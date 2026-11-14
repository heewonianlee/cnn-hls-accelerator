#include "conv1_lane2.h"

// (heewon) Reuse the existing one-pixel-per-cycle sliding window.
typedef ap_uint<72> conv1_1_lane2_window_t;

// (heewon) Narrow signed 9-tap INT8 MAC.
// One INT8xINT8 product is 16 bits; nine products safely fit in 19 signed bits.
static ap_int<19> conv1_1_lane2_mac9(
    conv1_1_lane2_window_t window,
    conv1_weight9_t wpack)
{
#pragma HLS INLINE

    ap_int<19> acc = 0;

CONV1_1_MAC9_NARROW:
    for (int k = 0; k < 9; ++k) {
#pragma HLS UNROLL
        const ap_int<8> x =
            (ap_int<8>)window.range(8 * k + 7, 8 * k);
        const ap_int<8> w =
            (ap_int<8>)wpack.range(8 * k + 7, 8 * k);

        const ap_int<16> product = x * w;
        acc += product;
    }

    return acc;
}

static int8_t conv1_1_lane2_quantize_relu(int32_t acc, int shift) {
#pragma HLS INLINE
    if (acc <= 0) return 0;
    uint32_t v = (uint32_t)acc;
    if (v >= (127u << shift)) return 127;
    if (shift) v = (v + (1u << (shift - 1))) >> shift;
    return (int8_t)((v > 127u) ? 127u : v);
}

static void conv1_1_lane2_windows(
    hls::stream<int8_t> &pixels,
    hls::stream<conv1_1_lane2_window_t> &windows)
{
#pragma HLS INLINE off
    int8_t line0[CONV1_1_W + 2];
    int8_t line1[CONV1_1_W + 2];
    int8_t win[3][3];
#pragma HLS ARRAY_PARTITION variable=win complete dim=0
WINDOW_ROWS:
    for (int r = 0; r < CONV1_1_H + 2; ++r) {
WINDOW_COLS:
        for (int c = 0; c < CONV1_1_W + 2; ++c) {
#pragma HLS PIPELINE II=1
            int8_t pixel = 0;
            if (r > 0 && r <= CONV1_1_H && c > 0 && c <= CONV1_1_W)
                pixel = pixels.read();
            const int8_t upper = (r >= 2) ? line0[c] : (int8_t)0;
            const int8_t middle = (r >= 1) ? line1[c] : (int8_t)0;
            line0[c] = middle;
            line1[c] = pixel;
            for (int kh = 0; kh < 3; ++kh) {
#pragma HLS UNROLL
                win[kh][0] = win[kh][1];
                win[kh][1] = win[kh][2];
                win[kh][2] = (kh == 0) ? upper : (kh == 1 ? middle : pixel);
            }
            if (r >= 2 && c >= 2) {
                conv1_1_lane2_window_t packet = 0;
                for (int kh = 0; kh < 3; ++kh) {
#pragma HLS UNROLL
                    for (int kw = 0; kw < 3; ++kw) {
#pragma HLS UNROLL
                        const int bit = 8 * (3 * kh + kw);
                        packet.range(bit + 7, bit) =
                            (ap_uint<8>)((uint8_t)win[kh][kw]);
                    }
                }
                windows.write(packet);
            }
        }
    }
}

static void conv1_1_lane2_mac(
    hls::stream<conv1_1_lane2_window_t> &windows,
    const conv1_weight9_t weights[2][CONV1_1_GROUPS],
    const int32_t bias[CONV1_1_OUT_C],
    hls::stream<conv1_lane2_t> &out_pixels,
    int shift)
{
#pragma HLS INLINE off
COMPUTE_SPATIAL:
    for (int pixel = 0; pixel < CONV1_1_H * CONV1_1_W; ++pixel) {
        const conv1_1_lane2_window_t window = windows.read();
    COMPUTE_GROUPS:
        for (int g = 0; g < CONV1_1_GROUPS; ++g) {
#pragma HLS PIPELINE II=1
            // One 72-bit read per output lane supplies all nine kernel taps.
            const conv1_weight9_t wpack0 = weights[0][g];
            const conv1_weight9_t wpack1 = weights[1][g];

            const ap_int<19> mac0 = conv1_1_lane2_mac9(window, wpack0);
            const ap_int<19> mac1 = conv1_1_lane2_mac9(window, wpack1);

            // Bias remains INT32; only the final addition is widened to 32 bits.
            const int32_t acc0 = bias[2 * g]     + (int32_t)mac0;
            const int32_t acc1 = bias[2 * g + 1] + (int32_t)mac1;

            conv1_lane2_t pair = 0;
            pair.range(7,0) =
                (ap_uint<8>)(uint8_t)conv1_1_lane2_quantize_relu(acc0, shift);
            pair.range(15,8) =
                (ap_uint<8>)(uint8_t)conv1_1_lane2_quantize_relu(acc1, shift);
            out_pixels.write(pair);
        }
    }
}

void conv1_1_lane2(
    hls::stream<int8_t> &in_pixels,
    const conv1_weight9_t weights[2][CONV1_1_GROUPS],
    const int32_t bias[CONV1_1_OUT_C],
    hls::stream<conv1_lane2_t> &out_pixels,
    int shift)
{
#pragma HLS INLINE off
#pragma HLS DATAFLOW
    hls::stream<conv1_1_lane2_window_t> windows("conv1_1_lane2_windows_fifo");
#pragma HLS STREAM variable=windows depth=32
    conv1_1_lane2_windows(in_pixels, windows);
    conv1_1_lane2_mac(windows, weights, bias, out_pixels, shift);
}
