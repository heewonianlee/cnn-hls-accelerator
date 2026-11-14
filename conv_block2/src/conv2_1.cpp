#define AP_INT_MAX_W 4096 // Needed for 1152-bit or 2304-bit packed windows

#include "conv2d.h"
#include <ap_int.h>

// Dedicated Conv Block 2 engine (16->32); cloned from validated conv1_2.
// Two 16-channel padded scan-line buffers; produces one 72-bit window
// for EACH channel, ordered [spatial position][input channel].
// Its MAC and memory banking can be optimized independently of conv1_1.
typedef ap_uint<72> conv2_1_window_t;
typedef ap_uint<72 * CONV2_1_IN_C> conv2_1_window_set_t; // Tie all input-channel windows into one packet

// (heewon) 9-tap signed INT8 MAC for one input channel.
// Each product is 16 bits; the sum of nine products safely fits in 19 signed bits.
static ap_int<19> conv2_1_mac9(
    conv2_1_window_t pkt,
    conv2_weight9_t wpack)
{
#pragma HLS INLINE

    ap_int<19> acc = 0;

CONV2_1_MAC9_NARROW:
    for (int k = 0; k < 9; ++k) {
#pragma HLS UNROLL
        const ap_int<8> x =
            (ap_int<8>)pkt.range(8 * k + 7, 8 * k);
        const ap_int<8> w =
            (ap_int<8>)wpack.range(8 * k + 7, 8 * k);

        const ap_int<16> product = x * w;
        acc += product;
    }

    return acc;
}

static int8_t conv2_1_quantize_relu(int32_t acc, int shift) {
#pragma HLS INLINE
    if (acc <= 0) return (int8_t)0;
    uint32_t value = (uint32_t)acc;
    if (value >= (127u << shift)) return (int8_t)127;
    if (shift != 0) value = (value + (1u << (shift - 1))) >> shift;
    if (value > 127u) value = 127u;
    return (int8_t)value;
}

static void conv2_1_windows(
    hls::stream<int8_t> &pixels,
    hls::stream<conv2_1_window_t> &windows)
{
#pragma HLS INLINE off
    int8_t line0[(CONV2_1_W + 2) * CONV2_1_IN_C];
    int8_t line1[(CONV2_1_W + 2) * CONV2_1_IN_C];
    int8_t win[3][3][CONV2_1_IN_C];
#pragma HLS ARRAY_PARTITION variable=win complete dim=0

CONV2_1_PAD_ROWS:
    for (int r = 0; r < CONV2_1_H + 2; ++r) {
    CONV2_1_PAD_COLS:
        for (int c = 0; c < CONV2_1_W + 2; ++c) {
        CONV2_1_PAD_CHANNELS:
            for (int ic = 0; ic < CONV2_1_IN_C; ++ic) {
#pragma HLS PIPELINE II=1
                int8_t pixel = 0;
                if (r > 0 && r <= CONV2_1_H && c > 0 && c <= CONV2_1_W) {
                    pixel = pixels.read();
                }
                const int addr = c * CONV2_1_IN_C + ic;
                const int8_t upper  = (r >= 2) ? line0[addr] : (int8_t)0;
                const int8_t middle = (r >= 1) ? line1[addr] : (int8_t)0;
                line0[addr] = middle;
                line1[addr] = pixel;

            CONV2_1_SHIFT:
                for (int kh = 0; kh < 3; ++kh) {
#pragma HLS UNROLL
                    win[kh][0][ic] = win[kh][1][ic];
                    win[kh][1][ic] = win[kh][2][ic];
                    win[kh][2][ic] =
                        (kh == 0) ? upper : ((kh == 1) ? middle : pixel);
                }

                if (r >= 2 && c >= 2) {
                    conv2_1_window_t pkt = 0;
                CONV2_1_PACK_KH:
                    for (int kh = 0; kh < 3; ++kh) {
#pragma HLS UNROLL
                CONV2_1_PACK_KW:
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


static void conv2_1_pack_windows(
    hls::stream<conv2_1_window_t> &windows,
    hls::stream<conv2_1_window_set_t> &window_sets)
{
#pragma HLS INLINE off

    conv2_1_window_set_t packed = 0;

CONV2_1_PACK_ALL:
    for (int idx = 0;
         idx < CONV2_1_H * CONV2_1_W * CONV2_1_IN_C;
         ++idx) {
#pragma HLS PIPELINE II=1

        packed >>= 72;

        packed.range(
            72 * CONV2_1_IN_C - 1,
            72 * (CONV2_1_IN_C - 1)
        ) = windows.read();

        if ((idx % CONV2_1_IN_C) == CONV2_1_IN_C - 1) {
            window_sets.write(packed);
        }
    }
}


static void conv2_1_compute(
    hls::stream<conv2_1_window_set_t> &window_sets,
    const conv2_weight9_t weights[CONV2_1_IN_C][CONV2_1_OUT_C],
    const int32_t bias[CONV2_1_OUT_C],
    hls::stream<int8_t> &out_pixels,
    int shift)
{
#pragma HLS INLINE off

    conv2_1_window_t cached[CONV2_1_IN_C];
#pragma HLS ARRAY_PARTITION variable=cached complete dim=1

CONV2_1_COMPUTE_OUTPUTS:
    for (int idx = 0;
         idx < CONV2_1_H * CONV2_1_W * CONV2_1_OUT_C;
         ++idx) {
#pragma HLS PIPELINE II=1

        const int oc = idx % CONV2_1_OUT_C;

        // Read the next spatial window set.
        if (oc == 0) {
            const conv2_1_window_set_t packed =
                window_sets.read();

        CONV2_1_UNPACK:
            for (int ic = 0; ic < CONV2_1_IN_C; ++ic) {
#pragma HLS UNROLL
                cached[ic] = packed.range(
                    72 * (ic + 1) - 1,
                    72 * ic
                );
            }
        }

        // Parallel input-channel computation.
        // One 9-tap signed INT8 sum needs 19 signed bits.
        ap_int<19> partial[CONV2_1_IN_C];
#pragma HLS ARRAY_PARTITION variable=partial complete dim=1

    CONV2_1_INPUT_CHANNELS:
        for (int ic = 0; ic < CONV2_1_IN_C; ++ic) {
#pragma HLS UNROLL

            const conv2_1_window_t pkt = cached[ic];

            // One 72-bit read supplies all nine kernel taps.
            const conv2_weight9_t wpack = weights[ic][oc];

            partial[ic] = conv2_1_mac9(pkt, wpack);
        }

        // 16 input channels * max 9-tap INT8 sum safely fits in 23 signed bits.
        ap_int<23> channel_total = 0;

    CONV2_1_REDUCE:
        for (int ic = 0; ic < CONV2_1_IN_C; ++ic) {
#pragma HLS UNROLL
            channel_total += partial[ic];
        }

        // Bias remains INT32, so only the final addition is widened to 32 bits.
        const int32_t acc = bias[oc] + (int32_t)channel_total;

        out_pixels.write(
            conv2_1_quantize_relu(acc, shift)
        );
    }
}



void conv2_1(
    hls::stream<int8_t> &in_pixels,
    const conv2_weight9_t weights[CONV2_1_IN_C][CONV2_1_OUT_C],
    const int32_t bias[CONV2_1_OUT_C],
    hls::stream<int8_t> &out_pixels,
    int shift)
{
#pragma HLS INLINE off
#pragma HLS DATAFLOW

    hls::stream<conv2_1_window_t> windows(
        "conv2_1_windows_fifo"
    );

    hls::stream<conv2_1_window_set_t> window_sets(
        "conv2_1_window_sets_fifo"
    );

#pragma HLS STREAM variable=windows depth=32
#pragma HLS STREAM variable=window_sets depth=4

    // Stage 1: Sliding Window Generation
    conv2_1_windows(
        in_pixels,
        windows
    );

    // Stage 2: Window Packing
    conv2_1_pack_windows(
        windows,
        window_sets
    );

    // Stage 3: Parallel MAC Computation
    conv2_1_compute(
        window_sets,
        weights,
        bias,
        out_pixels,
        shift
    );
}
