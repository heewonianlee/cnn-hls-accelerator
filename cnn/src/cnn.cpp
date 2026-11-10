#include "cnn_top.h"

// Integrated CNN: reuse the existing six layer functions unchanged.
// All intermediate activations are hls::stream<int8_t>, never DDR arrays.
// Layout: input 400x64x1 => block1 200x32x16 => block2 100x16x32.

static void cnn_read_input(
    const int8_t input[CNN_INPUT_SIZE],
    hls::stream<int8_t> &out)
{
#pragma HLS INLINE off
CNN_READ_INPUT:
    for (int i = 0; i < CNN_INPUT_SIZE; ++i) {
#pragma HLS PIPELINE II=1
        out.write(input[i]);
    }
}

static void cnn_write_output(
    hls::stream<int8_t> &in,
    int8_t output[CNN_OUTPUT_SIZE])
{
#pragma HLS INLINE off
CNN_WRITE_OUTPUT:
    for (int i = 0; i < CNN_OUTPUT_SIZE; ++i) {
#pragma HLS PIPELINE II=1
        output[i] = in.read();
    }
}

static void cnn_load_w11(
    const int8_t src[CONV1_1_WEIGHT_SIZE],
    int8_t dst[9][CONV1_1_IN_C * CONV1_1_OUT_C])
{
#pragma HLS INLINE off
CNN_LOAD_W11_TAPS:
    for (int k = 0; k < 9; ++k) {
    CNN_LOAD_W11_CHANNELS:
        for (int j = 0; j < CONV1_1_IN_C * CONV1_1_OUT_C; ++j) {
#pragma HLS PIPELINE II=1
            dst[k][j] = src[k * CONV1_1_IN_C * CONV1_1_OUT_C + j];
        }
    }
}

static void cnn_load_b11(
    const int32_t src[CONV1_1_OUT_C],
    int32_t dst[CONV1_1_OUT_C])
{
#pragma HLS INLINE off
CNN_LOAD_B11:
    for (int oc = 0; oc < CONV1_1_OUT_C; ++oc) {
#pragma HLS PIPELINE II=1
        dst[oc] = src[oc];
    }
}

static void cnn_load_w12(
    const int8_t src[CONV1_2_WEIGHT_SIZE],
    int8_t dst[9][CONV1_2_IN_C * CONV1_2_OUT_C])
{
#pragma HLS INLINE off
CNN_LOAD_W12_TAPS:
    for (int k = 0; k < 9; ++k) {
    CNN_LOAD_W12_CHANNELS:
        for (int j = 0; j < CONV1_2_IN_C * CONV1_2_OUT_C; ++j) {
#pragma HLS PIPELINE II=1
            dst[k][j] = src[k * CONV1_2_IN_C * CONV1_2_OUT_C + j];
        }
    }
}

static void cnn_load_b12(
    const int32_t src[CONV1_2_OUT_C],
    int32_t dst[CONV1_2_OUT_C])
{
#pragma HLS INLINE off
CNN_LOAD_B12:
    for (int oc = 0; oc < CONV1_2_OUT_C; ++oc) {
#pragma HLS PIPELINE II=1
        dst[oc] = src[oc];
    }
}

static void cnn_load_w21(
    const int8_t src[CONV2_1_WEIGHT_SIZE],
    int8_t dst[9][CONV2_1_IN_C * CONV2_1_OUT_C])
{
#pragma HLS INLINE off
CNN_LOAD_W21_TAPS:
    for (int k = 0; k < 9; ++k) {
    CNN_LOAD_W21_CHANNELS:
        for (int j = 0; j < CONV2_1_IN_C * CONV2_1_OUT_C; ++j) {
#pragma HLS PIPELINE II=1
            dst[k][j] = src[k * CONV2_1_IN_C * CONV2_1_OUT_C + j];
        }
    }
}

static void cnn_load_b21(
    const int32_t src[CONV2_1_OUT_C],
    int32_t dst[CONV2_1_OUT_C])
{
#pragma HLS INLINE off
CNN_LOAD_B21:
    for (int oc = 0; oc < CONV2_1_OUT_C; ++oc) {
#pragma HLS PIPELINE II=1
        dst[oc] = src[oc];
    }
}

static void cnn_load_w22(
    const int8_t src[CONV2_2_WEIGHT_SIZE],
    int8_t dst[9][CONV2_2_IN_C * CONV2_2_OUT_C])
{
#pragma HLS INLINE off
CNN_LOAD_W22_TAPS:
    for (int k = 0; k < 9; ++k) {
    CNN_LOAD_W22_CHANNELS:
        for (int j = 0; j < CONV2_2_IN_C * CONV2_2_OUT_C; ++j) {
#pragma HLS PIPELINE II=1
            dst[k][j] = src[k * CONV2_2_IN_C * CONV2_2_OUT_C + j];
        }
    }
}

static void cnn_load_b22(
    const int32_t src[CONV2_2_OUT_C],
    int32_t dst[CONV2_2_OUT_C])
{
#pragma HLS INLINE off
CNN_LOAD_B22:
    for (int oc = 0; oc < CONV2_2_OUT_C; ++oc) {
#pragma HLS PIPELINE II=1
        dst[oc] = src[oc];
    }
}

// One DATAFLOW region across BOTH convolution blocks.
// Especially: maxpool1 -> conv2_1 is a STREAM, not an intermediate AXI buffer.
static void cnn_run_pipeline(
    const int8_t input[CNN_INPUT_SIZE],
    const int8_t w11[9][CONV1_1_IN_C * CONV1_1_OUT_C],
    const int32_t b11[CONV1_1_OUT_C],
    const int8_t w12[9][CONV1_2_IN_C * CONV1_2_OUT_C],
    const int32_t b12[CONV1_2_OUT_C],
    const int8_t w21[9][CONV2_1_IN_C * CONV2_1_OUT_C],
    const int32_t b21[CONV2_1_OUT_C],
    const int8_t w22[9][CONV2_2_IN_C * CONV2_2_OUT_C],
    const int32_t b22[CONV2_2_OUT_C],
    int8_t output[CNN_OUTPUT_SIZE],
    int shift1_1, int shift1_2,
    int shift2_1, int shift2_2)
{
#pragma HLS INLINE off
#pragma HLS DATAFLOW

    hls::stream<int8_t> input_stream("cnn_input_stream");
    hls::stream<int8_t> conv11_out("cnn_conv11_out");
    hls::stream<int8_t> conv12_out("cnn_conv12_out");
    hls::stream<int8_t> pool1_out("cnn_pool1_to_conv21");
    hls::stream<int8_t> conv21_out("cnn_conv21_out");
    hls::stream<int8_t> conv22_out("cnn_conv22_out");
    hls::stream<int8_t> pool2_out("cnn_pool2_out");

#pragma HLS STREAM variable=input_stream depth=64
#pragma HLS STREAM variable=conv11_out depth=64
#pragma HLS STREAM variable=conv12_out depth=64
#pragma HLS STREAM variable=pool1_out depth=64
#pragma HLS STREAM variable=conv21_out depth=64
#pragma HLS STREAM variable=conv22_out depth=64
#pragma HLS STREAM variable=pool2_out depth=64

    cnn_read_input(input, input_stream);
    conv1_1(input_stream, w11, b11, conv11_out, shift1_1);
    conv1_2(conv11_out, w12, b12, conv12_out, shift1_2);
    maxpool1(conv12_out, pool1_out);
    conv2_1(pool1_out, w21, b21, conv21_out, shift2_1);
    conv2_2(conv21_out, w22, b22, conv22_out, shift2_2);
    maxpool2(conv22_out, pool2_out);
    cnn_write_output(pool2_out, output);
}

void cnn(
    const int8_t input[CNN_INPUT_SIZE],
    const int8_t weight1_1[CONV1_1_WEIGHT_SIZE],
    const int32_t bias1_1[CONV1_1_OUT_C],
    const int8_t weight1_2[CONV1_2_WEIGHT_SIZE],
    const int32_t bias1_2[CONV1_2_OUT_C],
    const int8_t weight2_1[CONV2_1_WEIGHT_SIZE],
    const int32_t bias2_1[CONV2_1_OUT_C],
    const int8_t weight2_2[CONV2_2_WEIGHT_SIZE],
    const int32_t bias2_2[CONV2_2_OUT_C],
    int8_t output[CNN_OUTPUT_SIZE],
    int shift1_1, int shift1_2,
    int shift2_1, int shift2_2)
{
#pragma HLS INTERFACE m_axi port=input     offset=slave bundle=gmem depth=CNN_INPUT_SIZE
#pragma HLS INTERFACE m_axi port=weight1_1 offset=slave bundle=gmem depth=CONV1_1_WEIGHT_SIZE
#pragma HLS INTERFACE m_axi port=bias1_1   offset=slave bundle=gmem depth=CONV1_1_OUT_C
#pragma HLS INTERFACE m_axi port=weight1_2 offset=slave bundle=gmem depth=CONV1_2_WEIGHT_SIZE
#pragma HLS INTERFACE m_axi port=bias1_2   offset=slave bundle=gmem depth=CONV1_2_OUT_C
#pragma HLS INTERFACE m_axi port=weight2_1 offset=slave bundle=gmem depth=CONV2_1_WEIGHT_SIZE
#pragma HLS INTERFACE m_axi port=bias2_1   offset=slave bundle=gmem depth=CONV2_1_OUT_C
#pragma HLS INTERFACE m_axi port=weight2_2 offset=slave bundle=gmem depth=CONV2_2_WEIGHT_SIZE
#pragma HLS INTERFACE m_axi port=bias2_2   offset=slave bundle=gmem depth=CONV2_2_OUT_C
#pragma HLS INTERFACE m_axi port=output    offset=slave bundle=gmem depth=CNN_OUTPUT_SIZE

#pragma HLS INTERFACE s_axilite port=input bundle=control
#pragma HLS INTERFACE s_axilite port=weight1_1 bundle=control
#pragma HLS INTERFACE s_axilite port=bias1_1 bundle=control
#pragma HLS INTERFACE s_axilite port=weight1_2 bundle=control
#pragma HLS INTERFACE s_axilite port=bias1_2 bundle=control
#pragma HLS INTERFACE s_axilite port=weight2_1 bundle=control
#pragma HLS INTERFACE s_axilite port=bias2_1 bundle=control
#pragma HLS INTERFACE s_axilite port=weight2_2 bundle=control
#pragma HLS INTERFACE s_axilite port=bias2_2 bundle=control
#pragma HLS INTERFACE s_axilite port=output bundle=control
#pragma HLS INTERFACE s_axilite port=shift1_1 bundle=control
#pragma HLS INTERFACE s_axilite port=shift1_2 bundle=control
#pragma HLS INTERFACE s_axilite port=shift2_1 bundle=control
#pragma HLS INTERFACE s_axilite port=shift2_2 bundle=control
#pragma HLS INTERFACE s_axilite port=return bundle=control

    if (shift1_1 < 0 || shift1_1 > 24 ||
        shift1_2 < 0 || shift1_2 > 24 ||
        shift2_1 < 0 || shift2_1 > 24 ||
        shift2_2 < 0 || shift2_2 > 24) return;

    // The four *dedicated* weight sets preserve the banking of both projects.
    int8_t w11[9][CONV1_1_IN_C * CONV1_1_OUT_C];
    int8_t w12[9][CONV1_2_IN_C * CONV1_2_OUT_C];
    int8_t w21[9][CONV2_1_IN_C * CONV2_1_OUT_C];
    int8_t w22[9][CONV2_2_IN_C * CONV2_2_OUT_C];

#pragma HLS ARRAY_PARTITION variable=w11 complete dim=1
#pragma HLS ARRAY_PARTITION variable=w12 complete dim=1
#pragma HLS ARRAY_PARTITION variable=w12 block factor=16 dim=2
#pragma HLS ARRAY_PARTITION variable=w21 complete dim=1
#pragma HLS ARRAY_PARTITION variable=w21 block factor=16 dim=2
#pragma HLS ARRAY_PARTITION variable=w22 complete dim=1
#pragma HLS ARRAY_PARTITION variable=w22 block factor=32 dim=2

    int32_t b11[CONV1_1_OUT_C];
    int32_t b12[CONV1_2_OUT_C];
    int32_t b21[CONV2_1_OUT_C];
    int32_t b22[CONV2_2_OUT_C];

    // Keep the original sequential preloading sequence: proven architecture.
    cnn_load_w11(weight1_1, w11);
    cnn_load_b11(bias1_1, b11);
    cnn_load_w12(weight1_2, w12);
    cnn_load_b12(bias1_2, b12);
    cnn_load_w21(weight2_1, w21);
    cnn_load_b21(bias2_1, b21);
    cnn_load_w22(weight2_2, w22);
    cnn_load_b22(bias2_2, b22);

    cnn_run_pipeline(input, w11, b11, w12, b12,
                     w21, b21, w22, b22, output,
                     shift1_1, shift1_2, shift2_1, shift2_2);
}
