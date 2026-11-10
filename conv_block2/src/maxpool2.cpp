#include "conv2d.h"

// Dedicated 2x2 max pool, stride 2, HWC layout.
// Reads every input once, retains one previous row and one previous column.
void maxpool2(hls::stream<int8_t> &in_pixels,
              hls::stream<int8_t> &out_pixels)
{
#pragma HLS INLINE off
    int8_t prev_row[CONV2_2_W * CONV2_2_OUT_C];
    int8_t prev_col[CONV2_2_OUT_C];

POOL2_ROWS:
    for (int r = 0; r < CONV2_2_H; ++r) {
    POOL2_COLS:
        for (int c = 0; c < CONV2_2_W; ++c) {
        POOL2_CHANNELS:
            for (int ch = 0; ch < CONV2_2_OUT_C; ++ch) {
#pragma HLS PIPELINE II=1
                const int8_t value = in_pixels.read();
                const int addr = c * CONV2_2_OUT_C + ch;
                if ((r & 1) == 0) {
                    prev_row[addr] = value;
                } else {
                    const int8_t top = prev_row[addr];
                    const int8_t vertical = (top > value) ? top : value;
                    if ((c & 1) == 0) {
                        prev_col[ch] = vertical;
                    } else {
                        const int8_t left = prev_col[ch];
                        out_pixels.write((left > vertical) ? left : vertical);
                    }
                }
            }
        }
    }
}
