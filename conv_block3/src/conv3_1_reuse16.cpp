#define AP_INT_MAX_W 4096 // (heewon) 72*32 = 2304-bit Conv3-1 window set

#include "conv3_reuse.h"

// (heewon) Conv3-1 32->64, 16-lane MAC shared across two phases.
// Two 32-channel padded scan-line buffers; produces one 72-bit window
// for EACH channel, ordered [spatial position][input channel].
// Window generation and the scalar stream interface are unchanged.
typedef ap_uint<72> conv3_1_window_t;
typedef ap_uint<72 * CONV3_1_IN_C> conv3_1_window_set_t;

static int8_t conv3_1_reuse16_quantize_relu(int32_t acc, int shift) {
#pragma HLS INLINE
    if (acc <= 0) return (int8_t)0;

    uint32_t value = (uint32_t)acc;
    if (value >= (127u << shift)) return (int8_t)127;

    if (shift != 0) {
        value = (value + (1u << (shift - 1))) >> shift;
    }

    if (value > 127u) value = 127u;
    return (int8_t)value;
}


// (heewon) 9-tap INT8 MAC for one input-channel lane.
// Keep this helper inline so the unrolled lane datapath remains fully parallel.
// Each 8x8 multiply is explicitly bound to DSP; do not combine INLINE with
// expression_balance in Vitis HLS 2024.1 (HLS 214-272 pragma conflict).
// The accumulator remains 19-bit, sufficient for nine signed INT8 products.
static ap_int<19> conv3_1_reuse16_mac9(
    conv3_1_window_t pkt,
    conv3_weight9_t wpack)
{
#pragma HLS INLINE

    ap_int<19> acc = 0;

CONV3_1_MAC9:
    for (int k = 0; k < 9; ++k) {
#pragma HLS UNROLL

        const ap_int<8> x =
            (ap_int<8>)pkt.range(8 * k + 7, 8 * k);

        const ap_int<8> w =
            (ap_int<8>)wpack.range(8 * k + 7, 8 * k);

        ap_int<16> product;
#pragma HLS BIND_OP variable=product op=mul impl=dsp
        product = x * w;

        acc += product;
    }

    return acc;
}


static void conv3_1_reuse16_windows(
    hls::stream<int8_t> &pixels,
    hls::stream<conv3_1_window_t> &windows)
{
#pragma HLS INLINE off

    int8_t line0[(CONV3_1_W + 2) * CONV3_1_IN_C];
    int8_t line1[(CONV3_1_W + 2) * CONV3_1_IN_C];
    int8_t win[3][3][CONV3_1_IN_C];

#pragma HLS ARRAY_PARTITION variable=win complete dim=0

CONV3_1_PAD_ROWS:
    for (int r = 0; r < CONV3_1_H + 2; ++r) {
    CONV3_1_PAD_COLS:
        for (int c = 0; c < CONV3_1_W + 2; ++c) {
        CONV3_1_PAD_CHANNELS:
            for (int ic = 0; ic < CONV3_1_IN_C; ++ic) {
#pragma HLS PIPELINE II=1

                int8_t pixel = 0;

                if (r > 0 && r <= CONV3_1_H &&
                    c > 0 && c <= CONV3_1_W) {
                    pixel = pixels.read();
                }

                const int addr = c * CONV3_1_IN_C + ic;

                const int8_t upper =
                    (r >= 2) ? line0[addr] : (int8_t)0;

                const int8_t middle =
                    (r >= 1) ? line1[addr] : (int8_t)0;

                line0[addr] = middle;
                line1[addr] = pixel;

            CONV3_1_SHIFT:
                for (int kh = 0; kh < 3; ++kh) {
#pragma HLS UNROLL
                    win[kh][0][ic] = win[kh][1][ic];
                    win[kh][1][ic] = win[kh][2][ic];
                    win[kh][2][ic] =
                        (kh == 0) ? upper :
                        ((kh == 1) ? middle : pixel);
                }

                if (r >= 2 && c >= 2) {
                    conv3_1_window_t pkt = 0;

                CONV3_1_PACK_KH:
                    for (int kh = 0; kh < 3; ++kh) {
#pragma HLS UNROLL
                    CONV3_1_PACK_KW:
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


static void conv3_1_reuse16_pack_windows(
    hls::stream<conv3_1_window_t> &windows,
    hls::stream<conv3_1_window_set_t> &window_sets)
{
#pragma HLS INLINE off

    conv3_1_window_set_t packed = 0;

CONV3_1_PACK_ALL:
    for (int idx = 0;
         idx < CONV3_1_H * CONV3_1_W * CONV3_1_IN_C;
         ++idx) {
#pragma HLS PIPELINE II=1

        packed >>= 72;

        packed.range(
            72 * CONV3_1_IN_C - 1,
            72 * (CONV3_1_IN_C - 1)
        ) = windows.read();

        if ((idx % CONV3_1_IN_C) == CONV3_1_IN_C - 1) {
            window_sets.write(packed);
        }
    }
}


static void conv3_1_reuse16_compute(
    hls::stream<conv3_1_window_set_t> &window_sets,
    const conv3_weight9_t weights[16][2 * CONV3_1_OUT_C],
    const int32_t bias[CONV3_1_OUT_C],
    hls::stream<int8_t> &out_pixels,
    int shift)
{
#pragma HLS INLINE off

    // (heewon) Share one 16-input-channel x 9-tap MAC engine
    // across two phases:
    //   phase 0 -> channels  0..15
    //   phase 1 -> channels 16..31
    const int LANES = CONV3_1_IN_C / 2;

    conv3_1_window_t cached0[16];
    conv3_1_window_t cached1[16];

#pragma HLS ARRAY_PARTITION variable=cached0 complete dim=1
#pragma HLS ARRAY_PARTITION variable=cached1 complete dim=1

    int32_t accumulated = 0;

CONV3_1_REUSE_PHASES:
    for (int step = 0;
         step < CONV3_1_H * CONV3_1_W * CONV3_1_OUT_C * 2;
         ++step) {
#pragma HLS PIPELINE II=1

        const int phase = step & 1;
        const int output_idx = step >> 1;
        const int oc = output_idx % CONV3_1_OUT_C;

        // One window set is reused by every output channel
        // at the same spatial location.
        if (phase == 0 && oc == 0) {
            const conv3_1_window_set_t packed = window_sets.read();

        CONV3_1_REUSE_UNPACK:
            for (int lane = 0; lane < LANES; ++lane) {
#pragma HLS UNROLL
                cached0[lane] =
                    packed.range(
                        72 * (lane + 1) - 1,
                        72 * lane
                    );

                cached1[lane] =
                    packed.range(
                        72 * (LANES + lane + 1) - 1,
                        72 * (LANES + lane)
                    );
            }
        }

        ap_int<19> partial[16];
#pragma HLS ARRAY_PARTITION variable=partial complete dim=1

        const int waddr = phase * CONV3_1_OUT_C + oc;

    CONV3_1_REUSE_LANES:
        for (int lane = 0; lane < LANES; ++lane) {
#pragma HLS UNROLL

            // The 2:1 phase MUX remains intentionally; this is what
            // allows 16 MAC lanes to serve all 32 input channels.
            const conv3_1_window_t pkt =
                (phase == 0) ? cached0[lane] : cached1[lane];

            // (heewon) One 72-bit read supplies all nine kernel taps.
            // Old: weights[9][16][128] -> 144 banks.
            // New: weights[16][128]    -> 16 wide banks.
            const conv3_weight9_t wpack =
                weights[lane][waddr];

            partial[lane] =
                conv3_1_reuse16_mac9(pkt, wpack);
        }

        // 16 * max(9-tap INT8 sum) needs 23 signed bits.
        ap_int<23> phase_sum = 0;

    CONV3_1_REUSE_REDUCE:
        for (int lane = 0; lane < LANES; ++lane) {
#pragma HLS UNROLL
            phase_sum += partial[lane];
        }

        if (phase == 0) {
            accumulated =
                bias[oc] + (int32_t)phase_sum;
        } else {
            const int32_t final_acc =
                accumulated + (int32_t)phase_sum;

            out_pixels.write(
                conv3_1_reuse16_quantize_relu(final_acc, shift)
            );
        }
    }
}


void conv3_1_reuse16(
    hls::stream<int8_t> &in_pixels,
    const conv3_weight9_t weights[16][2 * CONV3_1_OUT_C],
    const int32_t bias[CONV3_1_OUT_C],
    hls::stream<int8_t> &out_pixels,
    int shift)
{
#pragma HLS INLINE off
#pragma HLS DATAFLOW

    hls::stream<conv3_1_window_t> windows(
        "conv3_1_reuse16_windows_fifo"
    );

    hls::stream<conv3_1_window_set_t> window_sets(
        "conv3_1_reuse16_window_sets_fifo"
    );

#pragma HLS STREAM variable=windows depth=32
#pragma HLS STREAM variable=window_sets depth=4
#pragma HLS BIND_STORAGE variable=window_sets type=fifo impl=lutram

    conv3_1_reuse16_windows(
        in_pixels,
        windows
    );

    conv3_1_reuse16_pack_windows(
        windows,
        window_sets
    );

    conv3_1_reuse16_compute(
        window_sets,
        weights,
        bias,
        out_pixels,
        shift
    );
}
