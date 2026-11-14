#define AP_INT_MAX_W 8192 // (heewon) 72*64 = 4608-bit Conv3-2 window set

#include "conv3_reuse.h"

// (heewon) Conv3-2 64->64, 32-lane MAC shared across two phases.
// Two 64-channel padded scan-line buffers; produces one 72-bit window
// for EACH channel, ordered [spatial position][input channel].
// Window generation and the scalar stream interface are unchanged.
typedef ap_uint<72> conv3_2_window_t;
typedef ap_uint<72 * CONV3_2_IN_C> conv3_2_window_set_t;

static int8_t conv3_2_reuse32_quantize_relu(int32_t acc, int shift) {
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
static ap_int<19> conv3_2_reuse32_mac9(
    conv3_2_window_t pkt,
    conv3_weight9_t wpack)
{
#pragma HLS INLINE

    ap_int<19> acc = 0;

CONV3_2_MAC9:
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


static void conv3_2_reuse32_windows(
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

                if (r > 0 && r <= CONV3_2_H &&
                    c > 0 && c <= CONV3_2_W) {
                    pixel = pixels.read();
                }

                const int addr = c * CONV3_2_IN_C + ic;

                const int8_t upper =
                    (r >= 2) ? line0[addr] : (int8_t)0;

                const int8_t middle =
                    (r >= 1) ? line1[addr] : (int8_t)0;

                line0[addr] = middle;
                line1[addr] = pixel;

            CONV3_2_SHIFT:
                for (int kh = 0; kh < 3; ++kh) {
#pragma HLS UNROLL
                    win[kh][0][ic] = win[kh][1][ic];
                    win[kh][1][ic] = win[kh][2][ic];
                    win[kh][2][ic] =
                        (kh == 0) ? upper :
                        ((kh == 1) ? middle : pixel);
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


static void conv3_2_reuse32_pack_windows(
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


static void conv3_2_reuse32_compute(
    hls::stream<conv3_2_window_set_t> &window_sets,
    const conv3_weight9_t weights[32][2 * CONV3_2_OUT_C],
    const int32_t bias[CONV3_2_OUT_C],
    hls::stream<int8_t> &out_pixels,
    int shift)
{
#pragma HLS INLINE off

    // (heewon) Share one 32-input-channel x 9-tap MAC engine
    // across two phases:
    //   phase 0 -> channels  0..31
    //   phase 1 -> channels 32..63
    const int LANES = CONV3_2_IN_C / 2;

    conv3_2_window_t cached0[32];
    conv3_2_window_t cached1[32];

#pragma HLS ARRAY_PARTITION variable=cached0 complete dim=1
#pragma HLS ARRAY_PARTITION variable=cached1 complete dim=1

    int32_t accumulated = 0;

CONV3_2_REUSE_PHASES:
    for (int step = 0;
         step < CONV3_2_H * CONV3_2_W * CONV3_2_OUT_C * 2;
         ++step) {
#pragma HLS PIPELINE II=1

        const int phase = step & 1;
        const int output_idx = step >> 1;
        const int oc = output_idx % CONV3_2_OUT_C;

        if (phase == 0 && oc == 0) {
            const conv3_2_window_set_t packed = window_sets.read();

        CONV3_2_REUSE_UNPACK:
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

        // (heewon) A 9-tap signed INT8 sum needs 19 bits.
        // The previous ap_int<24> partial was wider than necessary.
        ap_int<19> partial[32];
#pragma HLS ARRAY_PARTITION variable=partial complete dim=1

        const int waddr = phase * CONV3_2_OUT_C + oc;

    CONV3_2_REUSE_LANES:
        for (int lane = 0; lane < LANES; ++lane) {
#pragma HLS UNROLL

            const conv3_2_window_t pkt =
                (phase == 0) ? cached0[lane] : cached1[lane];

            // (heewon) One 72-bit read supplies all nine kernel taps.
            // Old: weights[9][32][128] -> 288 banks.
            // New: weights[32][128]    -> 32 wide banks.
            const conv3_weight9_t wpack =
                weights[lane][waddr];

            partial[lane] =
                conv3_2_reuse32_mac9(pkt, wpack);
        }

        // (heewon) IMPORTANT:
        // 32 * max(9-tap INT8 sum) needs 24 signed bits.
        // The old ap_int<19> phase_sum could overflow.
        ap_int<24> phase_sum = 0;

    CONV3_2_REUSE_REDUCE:
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
                conv3_2_reuse32_quantize_relu(final_acc, shift)
            );
        }
    }
}


void conv3_2_reuse32(
    hls::stream<int8_t> &in_pixels,
    const conv3_weight9_t weights[32][2 * CONV3_2_OUT_C],
    const int32_t bias[CONV3_2_OUT_C],
    hls::stream<int8_t> &out_pixels,
    int shift)
{
#pragma HLS INLINE off
#pragma HLS DATAFLOW

    hls::stream<conv3_2_window_t> windows(
        "conv3_2_reuse32_windows_fifo"
    );

    hls::stream<conv3_2_window_set_t> window_sets(
        "conv3_2_reuse32_window_sets_fifo"
    );

#pragma HLS STREAM variable=windows depth=32
#pragma HLS STREAM variable=window_sets depth=4
#pragma HLS BIND_STORAGE variable=window_sets type=fifo impl=lutram

    conv3_2_reuse32_windows(
        in_pixels,
        windows
    );

    conv3_2_reuse32_pack_windows(
        windows,
        window_sets
    );

    conv3_2_reuse32_compute(
        window_sets,
        weights,
        bias,
        out_pixels,
        shift
    );
}
