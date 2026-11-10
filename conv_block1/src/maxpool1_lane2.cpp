#include "conv1_lane2.h"

// (heewon) Compare both channels in parallel, retaining HWC order.
static conv1_lane2_t maxpool1_lane2_max_pair(conv1_lane2_t a, conv1_lane2_t b) {
#pragma HLS INLINE
    ap_int<8> a0 = (ap_int<8>)a.range(7,0);
    ap_int<8> a1 = (ap_int<8>)a.range(15,8);
    ap_int<8> b0 = (ap_int<8>)b.range(7,0);
    ap_int<8> b1 = (ap_int<8>)b.range(15,8);
    conv1_lane2_t v = 0;
    v.range(7,0) = (ap_uint<8>)((a0 > b0) ? a0 : b0);
    v.range(15,8) = (ap_uint<8>)((a1 > b1) ? a1 : b1);
    return v;
}

void maxpool1_lane2(hls::stream<conv1_lane2_t> &in_pixels,
                    hls::stream<conv1_lane2_t> &out_pixels) {
#pragma HLS INLINE off
    const int G = CONV1_2_OUT_C/2;
    conv1_lane2_t prev_row[CONV1_2_W * G];
    conv1_lane2_t prev_col[G];
POOL_ROWS:
    for (int r = 0; r < CONV1_2_H; ++r) {
    POOL_COLS:
        for (int c = 0; c < CONV1_2_W; ++c) {
        POOL_GROUPS:
            for (int g = 0; g < G; ++g) {
#pragma HLS PIPELINE II=1
                const conv1_lane2_t v = in_pixels.read();
                const int addr = c*G + g;
                if ((r & 1) == 0) {
                    prev_row[addr] = v;
                } else {
                    const conv1_lane2_t vert = maxpool1_lane2_max_pair(prev_row[addr], v);
                    if ((c & 1) == 0) {
                        prev_col[g] = vert;
                    } else {
                        out_pixels.write(maxpool1_lane2_max_pair(prev_col[g], vert));
                    }
                }
            }
        }
    }
}
