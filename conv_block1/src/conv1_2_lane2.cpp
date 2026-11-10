#include "conv1_lane2.h"

// (heewon) Two consecutive HWC channels are transported in one packet.
// Window pair: bits[71:0] = channel 2g, bits[143:72] = channel 2g+1.
typedef ap_uint<144> conv1_2_lane2_window_pair_t;
typedef ap_uint<72> conv1_2_lane2_window_t;
typedef ap_uint<72 * CONV1_2_IN_C> conv1_2_lane2_window_set_t;

static int8_t conv1_2_lane2_quantize_relu(int32_t acc, int shift) {
#pragma HLS INLINE
    if (acc <= 0) return 0;
    uint32_t v = (uint32_t)acc;
    if (v >= (127u << shift)) return 127;
    if (shift) v = (v + (1u << (shift - 1))) >> shift;
    return (int8_t)((v > 127u) ? 127u : v);
}

static void conv1_2_lane2_windows(
    hls::stream<conv1_lane2_t> &pixels,
    hls::stream<conv1_2_lane2_window_pair_t> &windows)
{
#pragma HLS INLINE off
    const int GROUPS = CONV1_2_IN_C / 2;
    conv1_lane2_t line0[(CONV1_2_W + 2) * GROUPS];
    conv1_lane2_t line1[(CONV1_2_W + 2) * GROUPS];
    conv1_lane2_t win[3][3][GROUPS];
#pragma HLS ARRAY_PARTITION variable=win complete dim=1
#pragma HLS ARRAY_PARTITION variable=win complete dim=2
WINDOW_ROWS:
    for (int r = 0; r < CONV1_2_H + 2; ++r) {
WINDOW_COLS:
        for (int c = 0; c < CONV1_2_W + 2; ++c) {
        WINDOW_GROUPS:
            for (int g = 0; g < GROUPS; ++g) {
#pragma HLS PIPELINE II=1
                conv1_lane2_t pixel = 0;
                if (r > 0 && r <= CONV1_2_H && c > 0 && c <= CONV1_2_W)
                    pixel = pixels.read();
                const int addr = c*GROUPS + g;
                const conv1_lane2_t upper = (r >= 2) ? line0[addr] : (conv1_lane2_t)0;
                const conv1_lane2_t middle = (r >= 1) ? line1[addr] : (conv1_lane2_t)0;
                line0[addr] = middle;
                line1[addr] = pixel;
                for (int kh = 0; kh < 3; ++kh) {
#pragma HLS UNROLL
                    win[kh][0][g] = win[kh][1][g];
                    win[kh][1][g] = win[kh][2][g];
                    win[kh][2][g] = (kh == 0) ? upper : (kh == 1 ? middle : pixel);
                }
                if (r >= 2 && c >= 2) {
                    conv1_2_lane2_window_pair_t pair = 0;
                    for (int kh = 0; kh < 3; ++kh) {
#pragma HLS UNROLL
                        for (int kw = 0; kw < 3; ++kw) {
#pragma HLS UNROLL
                            const int bit = (3*kh + kw)*8;
                            const conv1_lane2_t lanes = win[kh][kw][g];
                            pair.range(bit+7,bit) = lanes.range(7,0);
                            pair.range(72+bit+7,72+bit) = lanes.range(15,8);
                        }
                    }
                    windows.write(pair);
                }
            }
        }
    }
}

static void conv1_2_lane2_pack_windows(
    hls::stream<conv1_2_lane2_window_pair_t> &windows,
    hls::stream<conv1_2_lane2_window_set_t> &window_sets)
{
#pragma HLS INLINE off
PACK_SPATIAL:
    for (int pos = 0; pos < CONV1_2_H * CONV1_2_W; ++pos) {
        conv1_2_lane2_window_set_t packed = 0;
    PACK_GROUPS:
        for (int g = 0; g < CONV1_2_IN_C/2; ++g) {
#pragma HLS PIPELINE II=1
            packed >>= 144;
            packed.range(72*CONV1_2_IN_C-1,
                         72*(CONV1_2_IN_C-2)) = windows.read();
        }
        window_sets.write(packed);
    }
}

static void conv1_2_lane2_mac(
    hls::stream<conv1_2_lane2_window_set_t> &window_sets,
    const int8_t weights[9][CONV1_2_IN_C][2][CONV1_2_GROUPS],
    const int32_t bias[CONV1_2_OUT_C],
    hls::stream<conv1_lane2_t> &out_pixels,
    int shift)
{
#pragma HLS INLINE off
#pragma HLS expression_balance off
COMPUTE_SPATIAL:
    for (int pos = 0; pos < CONV1_2_H * CONV1_2_W; ++pos) {
        const conv1_2_lane2_window_set_t packed = window_sets.read();
    COMPUTE_GROUPS:
        for (int g = 0; g < CONV1_2_GROUPS; ++g) {
#pragma HLS PIPELINE II=1
            int32_t partial0[CONV1_2_IN_C];
            int32_t partial1[CONV1_2_IN_C];
#pragma HLS ARRAY_PARTITION variable=partial0 complete dim=1
#pragma HLS ARRAY_PARTITION variable=partial1 complete dim=1
        MAC_INPUT_CHANNELS:
            for (int ic = 0; ic < CONV1_2_IN_C; ++ic) {
#pragma HLS UNROLL
                const conv1_2_lane2_window_t pkt = packed.range(72*(ic+1)-1,72*ic);
                int32_t sum0 = 0, sum1 = 0;
            MAC9:
                for (int k = 0; k < 9; ++k) {
#pragma HLS UNROLL
                    ap_uint<8> raw = pkt.range(8*k+7,8*k);
                    ap_int<8> x = (ap_int<8>)raw;
                    ap_int<8> w0 = (ap_int<8>)weights[k][ic][0][g];
                    ap_int<8> w1 = (ap_int<8>)weights[k][ic][1][g];
                    ap_int<16> prod0 = x*w0;
                    ap_int<16> prod1 = x*w1;
                    sum0 += (int32_t)prod0;
                    sum1 += (int32_t)prod1;
                }
                partial0[ic] = sum0;
                partial1[ic] = sum1;
            }
            int32_t acc0 = bias[2*g], acc1 = bias[2*g+1];
        REDUCE:
            for (int ic = 0; ic < CONV1_2_IN_C; ++ic) {
#pragma HLS UNROLL
                acc0 += partial0[ic];
                acc1 += partial1[ic];
            }
            conv1_lane2_t out = 0;
            out.range(7,0) = (ap_uint<8>)(uint8_t)conv1_2_lane2_quantize_relu(acc0, shift);
            out.range(15,8) = (ap_uint<8>)(uint8_t)conv1_2_lane2_quantize_relu(acc1, shift);
            out_pixels.write(out);
        }
    }
}

void conv1_2_lane2(
    hls::stream<conv1_lane2_t> &in_pixels,
    const int8_t weights[9][CONV1_2_IN_C][2][CONV1_2_GROUPS],
    const int32_t bias[CONV1_2_OUT_C],
    hls::stream<conv1_lane2_t> &out_pixels,
    int shift)
{
#pragma HLS INLINE off
#pragma HLS DATAFLOW
    hls::stream<conv1_2_lane2_window_pair_t> windows("conv1_2_lane2_windows_fifo");
    hls::stream<conv1_2_lane2_window_set_t> window_sets("conv1_2_lane2_window_sets_fifo");
#pragma HLS STREAM variable=windows depth=32
#pragma HLS STREAM variable=window_sets depth=4
    conv1_2_lane2_windows(in_pixels, windows);
    conv1_2_lane2_pack_windows(windows, window_sets);
    conv1_2_lane2_mac(window_sets, weights, bias, out_pixels, shift);
}
