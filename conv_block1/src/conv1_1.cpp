#include "conv2d.h"
#include <ap_int.h>

// Completely independent 1->16 dedicated convolution engine.
// Two single-channel scan-line buffers, one 3x3 shift register, nine tap MACs.
typedef ap_uint<72> conv1_1_window_t;

static int8_t conv1_1_quantize_relu(int32_t acc, int shift) {
#pragma HLS INLINE
    if (acc <= 0) return (int8_t)0;
    uint32_t value = (uint32_t)acc;
    // Avoid overflow in (value + rounding): any larger input saturates anyway.
    if (value >= (127u << shift)) return (int8_t)127;
    if (shift != 0) value = (value + (1u << (shift - 1))) >> shift;
    if (value > 127u) value = 127u;
    return (int8_t)value;
}

static void conv1_1_windows(
    hls::stream<int8_t> &pixels,
    hls::stream<conv1_1_window_t> &windows)
{
#pragma HLS INLINE off
    // Only 2 prior padded rows, not a 400*64 full-image buffer.
    int8_t line0[CONV1_1_W + 2];
    int8_t line1[CONV1_1_W + 2];
    int8_t win[3][3];
#pragma HLS ARRAY_PARTITION variable=win complete dim=0

CONV1_1_PAD_ROWS:
    for (int r = 0; r < CONV1_1_H + 2; ++r) {
    CONV1_1_PAD_COLS:
        for (int c = 0; c < CONV1_1_W + 2; ++c) {
#pragma HLS PIPELINE II=1
            int8_t pixel = 0;
            if (r > 0 && r <= CONV1_1_H && c > 0 && c <= CONV1_1_W) {
                pixel = pixels.read();
            }
            int8_t upper  = (r >= 2) ? line0[c] : (int8_t)0;
            int8_t middle = (r >= 1) ? line1[c] : (int8_t)0;
            line0[c] = middle;
            line1[c] = pixel;

        CONV1_1_SHIFT:
            for (int kh = 0; kh < 3; ++kh) {
#pragma HLS UNROLL
                win[kh][0] = win[kh][1];
                win[kh][1] = win[kh][2];
                win[kh][2] = (kh == 0) ? upper : ((kh == 1) ? middle : pixel);
            }

            if (r >= 2 && c >= 2) {
                conv1_1_window_t pkt = 0;
            CONV1_1_PACK_KH:
                for (int kh = 0; kh < 3; ++kh) {
#pragma HLS UNROLL
                CONV1_1_PACK_KW:
                    for (int kw = 0; kw < 3; ++kw) {
#pragma HLS UNROLL
                        const int bit = 8 * (3 * kh + kw);
                        pkt.range(bit + 7, bit) =
                            (ap_uint<8>)((uint8_t)win[kh][kw]);
                    }
                }
                windows.write(pkt);
            }
        }
    }
}

static void conv1_1_mac(
    hls::stream<conv1_1_window_t> &windows,
    const int8_t weights[9][CONV1_1_OUT_C],
    const int32_t bias[CONV1_1_OUT_C],
    hls::stream<int8_t> &out_pixels,
    int shift)
{
#pragma HLS INLINE off
#pragma HLS expression_balance off
    conv1_1_window_t current = 0;

    // 16 scalar output channels per spatial window.
CONV1_1_ALL_OUTPUTS:
    for (int i = 0; i < CONV1_1_OUTPUT_SIZE; ++i) {
#pragma HLS PIPELINE II=1
        const int oc = i % CONV1_1_OUT_C;
        if (oc == 0) current = windows.read();

        int32_t acc = bias[oc];
    CONV1_1_MAC_9:
        for (int k = 0; k < 9; ++k) {
#pragma HLS UNROLL
            ap_uint<8> raw = current.range(8 * k + 7, 8 * k);
            ap_int<8> x = (ap_int<8>)raw;
            const int32_t w = (int32_t)weights[k][oc];
            acc += (int32_t)x * w;
        }
        out_pixels.write(conv1_1_quantize_relu(acc, shift));
    }
}

void conv1_1(
    hls::stream<int8_t> &in_pixels,
    const int8_t weights[9][CONV1_1_IN_C * CONV1_1_OUT_C],
    const int32_t bias[CONV1_1_OUT_C],
    hls::stream<int8_t> &out_pixels,
    int shift)
{
#pragma HLS INLINE off
#pragma HLS DATAFLOW
    hls::stream<conv1_1_window_t> windows("conv1_1_windows_fifo");
#pragma HLS STREAM variable=windows depth=32
    conv1_1_windows(in_pixels, windows);
    conv1_1_mac(windows, weights, bias, out_pixels, shift);
}
