#define AP_INT_MAX_W 8192 // (heewon) 72*64 = 4608-bit Conv3-2 window set

#include "conv2d.h"
#include <ap_int.h>

// Dedicated Conv Block 2 engine (64->64); cloned from validated conv1_2.
// Two 64-channel padded scan-line buffers; produces one 72-bit window
// for EACH channel, ordered [spatial position][input channel].
// Its MAC and memory banking can be optimized independently of conv1_1.
typedef ap_uint<72> conv3_2_window_t;
typedef ap_uint<72 * CONV3_2_IN_C> conv3_2_window_set_t; // Tie all input-channel windows into one packet

static int8_t conv3_2_quantize_relu(int32_t acc, int shift) {
#pragma HLS INLINE
    if (acc <= 0) return (int8_t)0;
    uint32_t value = (uint32_t)acc;
    if (value >= (127u << shift)) return (int8_t)127;
    if (shift != 0) value = (value + (1u << (shift - 1))) >> shift;
    if (value > 127u) value = 127u;
    return (int8_t)value;
}

static void conv3_2_windows(
    hls::stream<int8_t> &pixels,
    hls::stream<conv3_2_window_t> &windows)
{
#pragma HLS INLINE off
    int8_t line0[(CONV3_2_W + 2) * CONV3_2_IN_C];
    int8_t line1[(CONV3_2_W + 2) * CONV3_2_IN_C];
    int8_t win[3][3][CONV3_2_IN_C];
#pragma HLS ARRAY_PARTITION variable=win complete dim=0

CONV3_2_PAD_ROWS:
    for (int r = 0; r < CONV3_2_H + 2; ++r) {
    CONV3_2_PAD_COLS:
        for (int c = 0; c < CONV3_2_W + 2; ++c) {
        CONV3_2_PAD_CHANNELS:
            for (int ic = 0; ic < CONV3_2_IN_C; ++ic) {
#pragma HLS PIPELINE II=1
                int8_t pixel = 0;
                if (r > 0 && r <= CONV3_2_H && c > 0 && c <= CONV3_2_W) {
                    pixel = pixels.read();
                }
                const int addr = c * CONV3_2_IN_C + ic;
                const int8_t upper  = (r >= 2) ? line0[addr] : (int8_t)0;
                const int8_t middle = (r >= 1) ? line1[addr] : (int8_t)0;
                line0[addr] = middle;
                line1[addr] = pixel;

            CONV3_2_SHIFT:
                for (int kh = 0; kh < 3; ++kh) {
#pragma HLS UNROLL
                    win[kh][0][ic] = win[kh][1][ic];
                    win[kh][1][ic] = win[kh][2][ic];
                    win[kh][2][ic] =
                        (kh == 0) ? upper : ((kh == 1) ? middle : pixel);
                }

                if (r >= 2 && c >= 2) {
                    conv3_2_window_t pkt = 0;
                CONV3_2_PACK_KH:
                    for (int kh = 0; kh < 3; ++kh) {
#pragma HLS UNROLL
                CONV3_2_PACK_KW:
                        for (int kw = 0; kw < 3; ++kw) {
#pragma HLS UNROLL
                            const int bit = 8 * (3 * kh + kw);
                            pkt.range(bit + 7, bit) =
                                (ap_uint<8>)((uint8_t)win[kh][kw][ic]);
                        }
                    }
                    windows.write(pkt);
                }
            }
        }
    }
}


static void conv3_2_pack_windows(
    hls::stream<conv3_2_window_t> &windows,
    hls::stream<conv3_2_window_set_t> &window_sets)
{
#pragma HLS INLINE off

    conv3_2_window_set_t packed = 0;

CONV3_2_PACK_ALL:
    for (int idx = 0;
         idx < CONV3_2_H * CONV3_2_W * CONV3_2_IN_C;
         ++idx) {
#pragma HLS PIPELINE II=1

        packed >>= 72;

        packed.range(
            72 * CONV3_2_IN_C - 1,
            72 * (CONV3_2_IN_C - 1)
        ) = windows.read();

        if ((idx % CONV3_2_IN_C) == CONV3_2_IN_C - 1) {
            window_sets.write(packed);
        }
    }
}


static void conv3_2_compute(
    hls::stream<conv3_2_window_set_t> &window_sets,
    const int8_t weights[9][CONV3_2_IN_C * CONV3_2_OUT_C],
    const int32_t bias[CONV3_2_OUT_C],
    hls::stream<int8_t> &out_pixels,
    int shift)
{
#pragma HLS INLINE off

    conv3_2_window_t cached[CONV3_2_IN_C];
#pragma HLS ARRAY_PARTITION variable=cached complete dim=1

CONV3_2_COMPUTE_OUTPUTS:
    for (int idx = 0;
         idx < CONV3_2_H * CONV3_2_W * CONV3_2_OUT_C;
         ++idx) {
#pragma HLS PIPELINE II=1

        const int oc = idx % CONV3_2_OUT_C;

        // Read the next spatial window set.
        if (oc == 0) {
            const conv3_2_window_set_t packed =
                window_sets.read();

        CONV3_2_UNPACK:
            for (int ic = 0; ic < CONV3_2_IN_C; ++ic) {
#pragma HLS UNROLL
                cached[ic] = packed.range(
                    72 * (ic + 1) - 1,
                    72 * ic
                );
            }
        }

        // Parallel input-channel computation.
        int32_t partial[CONV3_2_IN_C];
#pragma HLS ARRAY_PARTITION variable=partial complete dim=1

    CONV3_2_INPUT_CHANNELS:
        for (int ic = 0; ic < CONV3_2_IN_C; ++ic) {
#pragma HLS UNROLL

            const conv3_2_window_t pkt = cached[ic];
            int32_t channel_sum = 0;

        CONV3_2_MAC_9:
            for (int k = 0; k < 9; ++k) {
#pragma HLS UNROLL

                const ap_uint<8> raw =
                    pkt.range(8 * k + 7, 8 * k);

                const ap_int<8> x = (ap_int<8>)raw;

                const int32_t w =
                    (int32_t)weights[k]
                    [ic * CONV3_2_OUT_C + oc];

                channel_sum += (int32_t)x * w;
            }

            partial[ic] = channel_sum;
        }

        // Accumulate all input-channel results.
        int32_t acc = bias[oc];

    CONV3_2_REDUCE:
        for (int ic = 0; ic < CONV3_2_IN_C; ++ic) {
#pragma HLS UNROLL
            acc += partial[ic];
        }

        out_pixels.write(
            conv3_2_quantize_relu(acc, shift)
        );
    }
}



void conv3_2(
    hls::stream<int8_t> &in_pixels,
    const int8_t weights[9][CONV3_2_IN_C * CONV3_2_OUT_C],
    const int32_t bias[CONV3_2_OUT_C],
    hls::stream<int8_t> &out_pixels,
    int shift)
{
#pragma HLS INLINE off
#pragma HLS DATAFLOW

    hls::stream<conv3_2_window_t> windows(
        "conv3_2_windows_fifo"
    );

    hls::stream<conv3_2_window_set_t> window_sets(
        "conv3_2_window_sets_fifo"
    );

#pragma HLS STREAM variable=windows depth=32
#pragma HLS STREAM variable=window_sets depth=4
#pragma HLS BIND_STORAGE variable=window_sets type=fifo impl=lutram // (heewon) 4608-bit packed FIFO

    // Stage 1: Sliding Window Generation
    conv3_2_windows(
        in_pixels,
        windows
    );

    // Stage 2: Window Packing
    conv3_2_pack_windows(
        windows,
        window_sets
    );

    // Stage 3: Parallel MAC Computation
    conv3_2_compute(
        window_sets,
        weights,
        bias,
        out_pixels,
        shift
    );
}
