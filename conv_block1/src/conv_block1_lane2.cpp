#include "conv1_lane2.h"

// (heewon) Alternate implementation of the EXISTING conv_block1() TOP.
// Use conv_block1.cpp OR conv_block1_lane2.cpp in Tcl, NEVER both.
// The external DDR interface is unchanged; streams inside Block 1 are packed.
static void conv_block1_lane2_read_input(
    const int8_t input[CONV1_1_INPUT_SIZE],
    hls::stream<int8_t> &pixels)
{
#pragma HLS INLINE off
READ_INPUT:
    for (int i = 0; i < CONV1_1_INPUT_SIZE; ++i) {
#pragma HLS PIPELINE II=1
        pixels.write(input[i]);
    }
}

static void conv_block1_lane2_write_output(
    hls::stream<conv1_lane2_t> &pixels,
    int8_t output[BLOCK1_OUTPUT_SIZE])
{
#pragma HLS INLINE off
WRITE_OUTPUT:
    for (int i = 0; i < BLOCK1_OUTPUT_SIZE / 2; ++i) {
#pragma HLS PIPELINE II=2
        const conv1_lane2_t v = pixels.read();
        output[2 * i]     = (int8_t)(ap_int<8>)v.range(7,0);
        output[2 * i + 1] = (int8_t)(ap_int<8>)v.range(15,8);
    }
}

static void conv_block1_lane2_load_w1_1(
    const int8_t src[CONV1_1_WEIGHT_SIZE],
    conv1_weight9_t dst[2][CONV1_1_GROUPS])
{
#pragma HLS INLINE off

    // External layout remains flat HWIO. Conv1-1 has one input channel,
    // so src is effectively [k][oc]. Pack nine taps for each output lane/group.
LOAD_W11_K:
    for (int k = 0; k < 9; ++k) {
    LOAD_W11_G:
        for (int g = 0; g < CONV1_1_GROUPS; ++g) {
        LOAD_W11_L:
            for (int lane = 0; lane < 2; ++lane) {
#pragma HLS PIPELINE II=1
                conv1_weight9_t packed = 0;
                if (k != 0) {
                    packed = dst[lane][g];
                }

                packed.range(8 * k + 7, 8 * k) =
                    (ap_uint<8>)((uint8_t)src[
                        k * CONV1_1_OUT_C + 2 * g + lane
                    ]);

                dst[lane][g] = packed;
            }
        }
    }
}

static void conv_block1_lane2_load_w1_2(
    const int8_t src[CONV1_2_WEIGHT_SIZE],
    conv1_weight9_t dst[CONV1_2_IN_C][2][CONV1_2_GROUPS])
{
#pragma HLS INLINE off

    // External layout remains flat HWIO [k][ic][oc].
    // Pack the nine taps into one 72-bit word for each (ic, output lane/group).
LOAD_W12_K:
    for (int k = 0; k < 9; ++k) {
    LOAD_W12_IC:
        for (int ic = 0; ic < CONV1_2_IN_C; ++ic) {
        LOAD_W12_G:
            for (int g = 0; g < CONV1_2_GROUPS; ++g) {
            LOAD_W12_L:
                for (int lane = 0; lane < 2; ++lane) {
#pragma HLS PIPELINE II=1
                    conv1_weight9_t packed = 0;
                    if (k != 0) {
                        packed = dst[ic][lane][g];
                    }

                    packed.range(8 * k + 7, 8 * k) =
                        (ap_uint<8>)((uint8_t)src[
                            (k * CONV1_2_IN_C + ic) * CONV1_2_OUT_C
                            + 2 * g + lane
                        ]);

                    dst[ic][lane][g] = packed;
                }
            }
        }
    }
}

static void conv_block1_lane2_load_b1_1(
    const int32_t src[CONV1_1_OUT_C],
    int32_t dst[CONV1_1_OUT_C])
{
#pragma HLS INLINE off
LOAD_B11:
    for (int oc = 0; oc < CONV1_1_OUT_C; ++oc) {
#pragma HLS PIPELINE II=1
        dst[oc] = src[oc];
    }
}

static void conv_block1_lane2_load_b1_2(
    const int32_t src[CONV1_2_OUT_C],
    int32_t dst[CONV1_2_OUT_C])
{
#pragma HLS INLINE off
LOAD_B12:
    for (int oc = 0; oc < CONV1_2_OUT_C; ++oc) {
#pragma HLS PIPELINE II=1
        dst[oc] = src[oc];
    }
}

static void conv_block1_lane2_pipeline(
    const int8_t input[CONV1_1_INPUT_SIZE],
    const conv1_weight9_t w1[2][CONV1_1_GROUPS],
    const int32_t b1[CONV1_1_OUT_C],
    const conv1_weight9_t w2[CONV1_2_IN_C][2][CONV1_2_GROUPS],
    const int32_t b2[CONV1_2_OUT_C],
    int8_t output[BLOCK1_OUTPUT_SIZE],
    int shift1,
    int shift2)
{
#pragma HLS INLINE off
#pragma HLS DATAFLOW
    hls::stream<int8_t> input_pixels("input_pixels");
    hls::stream<conv1_lane2_t> conv11_features("conv1_1_lane2_features_fifo");
    hls::stream<conv1_lane2_t> conv12_features("conv1_2_lane2_features_fifo");
    hls::stream<conv1_lane2_t> pooled("maxpool1_lane2_features_fifo");
#pragma HLS STREAM variable=input_pixels depth=64
#pragma HLS STREAM variable=conv11_features depth=64
#pragma HLS STREAM variable=conv12_features depth=64
#pragma HLS STREAM variable=pooled depth=64

    conv_block1_lane2_read_input(input, input_pixels);
    conv1_1_lane2(input_pixels, w1, b1, conv11_features, shift1);
    conv1_2_lane2(conv11_features, w2, b2, conv12_features, shift2);
    maxpool1_lane2(conv12_features, pooled);
    conv_block1_lane2_write_output(pooled, output);
}

void conv_block1_lane2(
    const int8_t input[CONV1_1_INPUT_SIZE],
    const int8_t weight1[CONV1_1_WEIGHT_SIZE],
    const int32_t bias1[CONV1_1_OUT_C],
    const int8_t weight2[CONV1_2_WEIGHT_SIZE],
    const int32_t bias2[CONV1_2_OUT_C],
    int8_t output[BLOCK1_OUTPUT_SIZE],
    int shift1,
    int shift2)
{
#pragma HLS INTERFACE m_axi port=input offset=slave bundle=gmem depth=CONV1_1_INPUT_SIZE
#pragma HLS INTERFACE m_axi port=weight1 offset=slave bundle=gmem depth=CONV1_1_WEIGHT_SIZE
#pragma HLS INTERFACE m_axi port=bias1 offset=slave bundle=gmem depth=CONV1_1_OUT_C
#pragma HLS INTERFACE m_axi port=weight2 offset=slave bundle=gmem depth=CONV1_2_WEIGHT_SIZE
#pragma HLS INTERFACE m_axi port=bias2 offset=slave bundle=gmem depth=CONV1_2_OUT_C
#pragma HLS INTERFACE m_axi port=output offset=slave bundle=gmem depth=BLOCK1_OUTPUT_SIZE
#pragma HLS INTERFACE s_axilite port=input bundle=control
#pragma HLS INTERFACE s_axilite port=weight1 bundle=control
#pragma HLS INTERFACE s_axilite port=bias1 bundle=control
#pragma HLS INTERFACE s_axilite port=weight2 bundle=control
#pragma HLS INTERFACE s_axilite port=bias2 bundle=control
#pragma HLS INTERFACE s_axilite port=output bundle=control
#pragma HLS INTERFACE s_axilite port=shift1 bundle=control
#pragma HLS INTERFACE s_axilite port=shift2 bundle=control
#pragma HLS INTERFACE s_axilite port=return bundle=control

    if (shift1 < 0 || shift1 > 24 || shift2 < 0 || shift2 > 24) return;

    // (heewon) Block2/3-style 9-tap packing.
    // Conv1-1: 18 logical tap/lane banks -> 2 packed banks.
    // Conv1-2: 288 logical tap/ic/lane banks -> 32 packed banks.
    // Keep output-group as memory depth so we do not recreate the old bank count.
    conv1_weight9_t w1[2][CONV1_1_GROUPS];
    conv1_weight9_t w2[CONV1_2_IN_C][2][CONV1_2_GROUPS];
#pragma HLS ARRAY_PARTITION variable=w1 complete dim=1
#pragma HLS ARRAY_PARTITION variable=w2 complete dim=1
#pragma HLS ARRAY_PARTITION variable=w2 complete dim=2

    // Keep Block1 weights in LUTRAM. The integrated CNN is already BRAM-heavy,
    // so this follows optimized Block2 rather than Block3's BRAM binding.
#pragma HLS BIND_STORAGE variable=w1 type=ram_s2p impl=lutram
#pragma HLS BIND_STORAGE variable=w2 type=ram_s2p impl=lutram

    int32_t b1[CONV1_1_OUT_C];
    int32_t b2[CONV1_2_OUT_C];
#pragma HLS ARRAY_PARTITION variable=b1 complete dim=1
#pragma HLS ARRAY_PARTITION variable=b2 complete dim=1

    conv_block1_lane2_load_w1_1(weight1, w1);
    conv_block1_lane2_load_b1_1(bias1, b1);
    conv_block1_lane2_load_w1_2(weight2, w2);
    conv_block1_lane2_load_b1_2(bias2, b2);
    conv_block1_lane2_pipeline(input, w1, b1, w2, b2, output, shift1, shift2);
}
