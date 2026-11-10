#define AP_INT_MAX_W 2048 // (heewon) maximum bitwidth length from 1024 to 2048

#include "conv2d.h"
#include <ap_int.h>

// Completely independent 16->16 dedicated convolution engine.
// Two 16-channel padded scan-line buffers; produces one 72-bit window
// for EACH channel, ordered [spatial position][input channel].
// Its MAC and memory banking can be optimized independently of conv1_1.
typedef ap_uint<72> conv1_2_window_t;
typedef ap_uint<72 * CONV1_2_IN_C> conv1_2_window_set_t; // (heewon) tie 16 input channels

static int8_t conv1_2_quantize_relu(int32_t acc, int shift) {
#pragma HLS INLINE
    if (acc <= 0) return (int8_t)0;
    uint32_t value = (uint32_t)acc;
    if (value >= (127u << shift)) return (int8_t)127;
    if (shift != 0) value = (value + (1u << (shift - 1))) >> shift;
    if (value > 127u) value = 127u;
    return (int8_t)value;
}

static void conv1_2_windows(
    hls::stream<int8_t> &pixels,
    hls::stream<conv1_2_window_t> &windows)
{
#pragma HLS INLINE off
    int8_t line0[(CONV1_2_W + 2) * CONV1_2_IN_C];
    int8_t line1[(CONV1_2_W + 2) * CONV1_2_IN_C];
    int8_t win[3][3][CONV1_2_IN_C];
#pragma HLS ARRAY_PARTITION variable=win complete dim=0

CONV1_2_PAD_ROWS:
    for (int r = 0; r < CONV1_2_H + 2; ++r) {
    CONV1_2_PAD_COLS:
        for (int c = 0; c < CONV1_2_W + 2; ++c) {
        CONV1_2_PAD_CHANNELS:
            for (int ic = 0; ic < CONV1_2_IN_C; ++ic) {
#pragma HLS PIPELINE II=1
                int8_t pixel = 0;
                if (r > 0 && r <= CONV1_2_H && c > 0 && c <= CONV1_2_W) {
                    pixel = pixels.read();
                }
                const int addr = c * CONV1_2_IN_C + ic;
                const int8_t upper  = (r >= 2) ? line0[addr] : (int8_t)0;
                const int8_t middle = (r >= 1) ? line1[addr] : (int8_t)0;
                line0[addr] = middle;
                line1[addr] = pixel;

            CONV1_2_SHIFT:
                for (int kh = 0; kh < 3; ++kh) {
#pragma HLS UNROLL
                    win[kh][0][ic] = win[kh][1][ic];
                    win[kh][1][ic] = win[kh][2][ic];
                    win[kh][2][ic] =
                        (kh == 0) ? upper : ((kh == 1) ? middle : pixel);
                }

                if (r >= 2 && c >= 2) {
                    conv1_2_window_t pkt = 0;
                CONV1_2_PACK_KH:
                    for (int kh = 0; kh < 3; ++kh) {
#pragma HLS UNROLL
                CONV1_2_PACK_KW:
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


static void conv1_2_pack_windows(
    hls::stream<conv1_2_window_t> &windows,
    hls::stream<conv1_2_window_set_t> &window_sets)
{
#pragma HLS INLINE off

    conv1_2_window_set_t packed = 0;

CONV1_2_PACK_ALL:
    for (int idx = 0;
         idx < CONV1_2_H * CONV1_2_W * CONV1_2_IN_C;
         ++idx) {
#pragma HLS PIPELINE II=1

        packed >>= 72;

        packed.range(
            72 * CONV1_2_IN_C - 1,
            72 * (CONV1_2_IN_C - 1)
        ) = windows.read();

        if ((idx % CONV1_2_IN_C) == CONV1_2_IN_C - 1) {
            window_sets.write(packed);
        }
    }
}


static void conv1_2_compute(
    hls::stream<conv1_2_window_set_t> &window_sets,
    const int8_t weights[9][CONV1_2_IN_C * CONV1_2_OUT_C],
    const int32_t bias[CONV1_2_OUT_C],
    hls::stream<int8_t> &out_pixels,
    int shift)
{
#pragma HLS INLINE off

    conv1_2_window_t cached[CONV1_2_IN_C];
#pragma HLS ARRAY_PARTITION variable=cached complete dim=1

CONV1_2_COMPUTE_OUTPUTS:
    for (int idx = 0;
         idx < CONV1_2_H * CONV1_2_W * CONV1_2_OUT_C;
         ++idx) {
#pragma HLS PIPELINE II=1

        const int oc = idx % CONV1_2_OUT_C;

        // Read the next spatial window set.
        if (oc == 0) {
            const conv1_2_window_set_t packed =
                window_sets.read();

        CONV1_2_UNPACK:
            for (int ic = 0; ic < CONV1_2_IN_C; ++ic) {
#pragma HLS UNROLL
                cached[ic] = packed.range(
                    72 * (ic + 1) - 1,
                    72 * ic
                );
            }
        }

        // Parallel input-channel computation.
        int32_t partial[CONV1_2_IN_C];
#pragma HLS ARRAY_PARTITION variable=partial complete dim=1

    CONV1_2_INPUT_CHANNELS:
        for (int ic = 0; ic < CONV1_2_IN_C; ++ic) {
#pragma HLS UNROLL

            const conv1_2_window_t pkt = cached[ic];
            int32_t channel_sum = 0;

        CONV1_2_MAC_9:
            for (int k = 0; k < 9; ++k) {
#pragma HLS UNROLL

                const ap_uint<8> raw =
                    pkt.range(8 * k + 7, 8 * k);

                const ap_int<8> x = (ap_int<8>)raw;

                const int32_t w =
                    (int32_t)weights[k]
                    [ic * CONV1_2_OUT_C + oc];

                channel_sum += (int32_t)x * w;
            }

            partial[ic] = channel_sum;
        }

        // Accumulate all input-channel results.
        int32_t acc = bias[oc];

    CONV1_2_REDUCE:
        for (int ic = 0; ic < CONV1_2_IN_C; ++ic) {
#pragma HLS UNROLL
            acc += partial[ic];
        }

        out_pixels.write(
            conv1_2_quantize_relu(acc, shift)
        );
    }
}



void conv1_2(
    hls::stream<int8_t> &in_pixels,
    const int8_t weights[9][CONV1_2_IN_C * CONV1_2_OUT_C],
    const int32_t bias[CONV1_2_OUT_C],
    hls::stream<int8_t> &out_pixels,
    int shift)
{
#pragma HLS INLINE off
#pragma HLS DATAFLOW

    hls::stream<conv1_2_window_t> windows(
        "conv1_2_windows_fifo"
    );

    hls::stream<conv1_2_window_set_t> window_sets(
        "conv1_2_window_sets_fifo"
    );

#pragma HLS STREAM variable=windows depth=32
#pragma HLS STREAM variable=window_sets depth=4

    // Stage 1: Sliding Window Generation
    conv1_2_windows(
        in_pixels,
        windows
    );

    // Stage 2: Window Packing
    conv1_2_pack_windows(
        windows,
        window_sets
    );

    // Stage 3: Parallel MAC Computation
    conv1_2_compute(
        window_sets,
        weights,
        bias,
        out_pixels,
        shift
    );
}
