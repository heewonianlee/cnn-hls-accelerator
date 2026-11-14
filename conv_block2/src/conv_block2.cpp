#include "conv2d.h"

// Standalone Block2 TOP: same AXI + DATAFLOW pattern as Block1.
// Input 200x32x16 -> Conv 16->32 -> Conv 32->32 -> Pool 100x16x32.
static void read_block2_input(
    const int8_t input[CONV2_1_INPUT_SIZE],
    hls::stream<int8_t> &pixels)
{
#pragma HLS INLINE off
READ_INPUT:
    for (int i = 0; i < CONV2_1_INPUT_SIZE; ++i) {
#pragma HLS PIPELINE II=1
        pixels.write(input[i]);
    }
}

static void write_block2_output(
    hls::stream<int8_t> &pixels,
    int8_t output[BLOCK2_OUTPUT_SIZE])
{
#pragma HLS INLINE off
WRITE_OUTPUT:
    for (int i = 0; i < BLOCK2_OUTPUT_SIZE; ++i) {
#pragma HLS PIPELINE II=1
        output[i] = pixels.read();
    }
}

static void load_weights2_1(
    const int8_t weight1[CONV2_1_WEIGHT_SIZE],
    conv2_weight9_t w1[CONV2_1_IN_C][CONV2_1_OUT_C])
{
#pragma HLS INLINE off

    // External weights remain flat HWIO:
    // [k][ic][oc]. Pack the nine taps into one 72-bit on-chip word.
LOAD_W1_K:
    for (int k = 0; k < 9; ++k) {
    LOAD_W1_IC:
        for (int ic = 0; ic < CONV2_1_IN_C; ++ic) {
        LOAD_W1_OC:
            for (int oc = 0; oc < CONV2_1_OUT_C; ++oc) {
#pragma HLS PIPELINE II=1
                conv2_weight9_t packed = 0;
                if (k != 0) {
                    packed = w1[ic][oc];
                }

                packed.range(8 * k + 7, 8 * k) =
                    (ap_uint<8>)((uint8_t)weight1[
                        (k * CONV2_1_IN_C + ic) * CONV2_1_OUT_C + oc
                    ]);

                w1[ic][oc] = packed;
            }
        }
    }
}

static void load_weights2_2(
    const int8_t weight2[CONV2_2_WEIGHT_SIZE],
    conv2_weight9_t w2[CONV2_2_IN_C][CONV2_2_OUT_C])
{
#pragma HLS INLINE off

    // External weights remain flat HWIO:
    // [k][ic][oc]. Pack the nine taps into one 72-bit on-chip word.
LOAD_W2_K:
    for (int k = 0; k < 9; ++k) {
    LOAD_W2_IC:
        for (int ic = 0; ic < CONV2_2_IN_C; ++ic) {
        LOAD_W2_OC:
            for (int oc = 0; oc < CONV2_2_OUT_C; ++oc) {
#pragma HLS PIPELINE II=1
                conv2_weight9_t packed = 0;
                if (k != 0) {
                    packed = w2[ic][oc];
                }

                packed.range(8 * k + 7, 8 * k) =
                    (ap_uint<8>)((uint8_t)weight2[
                        (k * CONV2_2_IN_C + ic) * CONV2_2_OUT_C + oc
                    ]);

                w2[ic][oc] = packed;
            }
        }
    }
}

static void load_bias2_1(
    const int32_t bias1[CONV2_1_OUT_C],
    int32_t b1[CONV2_1_OUT_C])
{
#pragma HLS INLINE off
LOAD_B1:
    for (int i = 0; i < CONV2_1_OUT_C; ++i) {
#pragma HLS PIPELINE II=1
        b1[i] = bias1[i];
    }
}

static void load_bias2_2(
    const int32_t bias2[CONV2_2_OUT_C],
    int32_t b2[CONV2_2_OUT_C])
{
#pragma HLS INLINE off
LOAD_B2:
    for (int i = 0; i < CONV2_2_OUT_C; ++i) {
#pragma HLS PIPELINE II=1
        b2[i] = bias2[i];
    }
}

static void run_block2_pipeline(
    const int8_t input[CONV2_1_INPUT_SIZE],
    const conv2_weight9_t w1[CONV2_1_IN_C][CONV2_1_OUT_C],
    const int32_t b1[CONV2_1_OUT_C],
    const conv2_weight9_t w2[CONV2_2_IN_C][CONV2_2_OUT_C],
    const int32_t b2[CONV2_2_OUT_C],
    int8_t output[BLOCK2_OUTPUT_SIZE],
    int shift1, int shift2)
{
#pragma HLS INLINE off
#pragma HLS DATAFLOW
    hls::stream<int8_t> input_pixels("input_pixels");
    hls::stream<int8_t> conv2_1_features("conv2_1_features");
    hls::stream<int8_t> conv2_2_features("conv2_2_features");
    hls::stream<int8_t> pooled("pooled");
#pragma HLS STREAM variable=input_pixels depth=64
#pragma HLS STREAM variable=conv2_1_features depth=64
#pragma HLS STREAM variable=conv2_2_features depth=64
#pragma HLS STREAM variable=pooled depth=64

    read_block2_input(input, input_pixels);
    conv2_1(input_pixels, w1, b1, conv2_1_features, shift1);
    conv2_2(conv2_1_features, w2, b2, conv2_2_features, shift2);
    maxpool2(conv2_2_features, pooled);
    write_block2_output(pooled, output);
}

void conv_block2(
    const int8_t input[CONV2_1_INPUT_SIZE],
    const int8_t weight1[CONV2_1_WEIGHT_SIZE],
    const int32_t bias1[CONV2_1_OUT_C],
    const int8_t weight2[CONV2_2_WEIGHT_SIZE],
    const int32_t bias2[CONV2_2_OUT_C],
    int8_t output[BLOCK2_OUTPUT_SIZE],
    int shift1, int shift2)
{
#pragma HLS INTERFACE m_axi port=input   offset=slave bundle=gmem depth=CONV2_1_INPUT_SIZE
#pragma HLS INTERFACE m_axi port=weight1 offset=slave bundle=gmem depth=CONV2_1_WEIGHT_SIZE
#pragma HLS INTERFACE m_axi port=bias1   offset=slave bundle=gmem depth=CONV2_1_OUT_C
#pragma HLS INTERFACE m_axi port=weight2 offset=slave bundle=gmem depth=CONV2_2_WEIGHT_SIZE
#pragma HLS INTERFACE m_axi port=bias2   offset=slave bundle=gmem depth=CONV2_2_OUT_C
#pragma HLS INTERFACE m_axi port=output  offset=slave bundle=gmem depth=BLOCK2_OUTPUT_SIZE
#pragma HLS INTERFACE s_axilite port=input   bundle=control
#pragma HLS INTERFACE s_axilite port=weight1 bundle=control
#pragma HLS INTERFACE s_axilite port=bias1   bundle=control
#pragma HLS INTERFACE s_axilite port=weight2 bundle=control
#pragma HLS INTERFACE s_axilite port=bias2   bundle=control
#pragma HLS INTERFACE s_axilite port=output  bundle=control
#pragma HLS INTERFACE s_axilite port=shift1  bundle=control
#pragma HLS INTERFACE s_axilite port=shift2  bundle=control
#pragma HLS INTERFACE s_axilite port=return  bundle=control

    // For invalid shifts, do not read or write output.
    if (shift1 < 0 || shift1 > 24 || shift2 < 0 || shift2 > 24) return;

    // (heewon) Conv3-style 9-tap packing.
    // One 72-bit word stores all nine INT8 taps for one (ic, oc).
    // Partition only the input-channel dimension so every input channel
    // can still be read in parallel. Keep the oc dimension as memory depth.
    conv2_weight9_t w1[CONV2_1_IN_C][CONV2_1_OUT_C];
    conv2_weight9_t w2[CONV2_2_IN_C][CONV2_2_OUT_C];
#pragma HLS ARRAY_PARTITION variable=w1 complete dim=1
#pragma HLS ARRAY_PARTITION variable=w2 complete dim=1

    // Unlike optimized Conv3, keep Block2 weights in LUTRAM because the
    // integrated CNN is already BRAM-constrained. Packing reduces the
    // logical banks from 144/288 to 16/32 without consuming more BRAM.
#pragma HLS BIND_STORAGE variable=w1 type=ram_s2p impl=lutram
#pragma HLS BIND_STORAGE variable=w2 type=ram_s2p impl=lutram
    int32_t b1[CONV2_1_OUT_C];
    int32_t b2[CONV2_2_OUT_C];

    load_weights2_1(weight1, w1);
    load_bias2_1(bias1, b1);
    load_weights2_2(weight2, w2);
    load_bias2_2(bias2, b2);
    run_block2_pipeline(input, w1, b1, w2, b2, output, shift1, shift2);
}
