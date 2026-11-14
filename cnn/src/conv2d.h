#ifndef CONV2D_H
#define CONV2D_H

#include <stdint.h>
#include <hls_stream.h>
#include <ap_int.h>

// Dedicated layer sizes. Activation layout: [H][W][C] (HWC).
// Weights: [3][3][IN_C][OUT_C] (HWIO).
// All six convolutions: 3x3, stride 1, SAME zero padding.
#define CONV_K                3
#define CONV1_1_H           400
#define CONV1_1_W            64
#define CONV1_1_IN_C          1
#define CONV1_1_OUT_C        16
#define CONV1_2_H           400
#define CONV1_2_W            64
#define CONV1_2_IN_C         16
#define CONV1_2_OUT_C        16

#define CONV1_1_INPUT_SIZE  (CONV1_1_H * CONV1_1_W * CONV1_1_IN_C)
#define CONV1_1_OUTPUT_SIZE (CONV1_1_H * CONV1_1_W * CONV1_1_OUT_C)
#define CONV1_1_WEIGHT_SIZE (CONV_K * CONV_K * CONV1_1_IN_C * CONV1_1_OUT_C)

#define CONV1_2_INPUT_SIZE  (CONV1_2_H * CONV1_2_W * CONV1_2_IN_C)
#define CONV1_2_OUTPUT_SIZE (CONV1_2_H * CONV1_2_W * CONV1_2_OUT_C)
#define CONV1_2_WEIGHT_SIZE (CONV_K * CONV_K * CONV1_2_IN_C * CONV1_2_OUT_C)

#define POOL1_H            (CONV1_2_H / 2)
#define POOL1_W            (CONV1_2_W / 2)
#define BLOCK1_OUTPUT_SIZE (POOL1_H * POOL1_W * CONV1_2_OUT_C)

// Each convolution engine is independently implemented in its own .cpp.
// Weight buffers are preloaded and 3x3-tap banked by each block TOP or cnn TOP.
// shift must be 0..24; ReLU + rounding right-shift + saturation to [0,127].
// Each function consumes/produces its entire fixed-size feature map in HWC order.
void conv1_1(
    hls::stream<int8_t> &in_pixels,
    const int8_t weights[9][CONV1_1_IN_C * CONV1_1_OUT_C],
    const int32_t bias[CONV1_1_OUT_C],
    hls::stream<int8_t> &out_pixels,
    int shift);

void conv1_2(
    hls::stream<int8_t> &in_pixels,
    const int8_t weights[9][CONV1_2_IN_C * CONV1_2_OUT_C],
    const int32_t bias[CONV1_2_OUT_C],
    hls::stream<int8_t> &out_pixels,
    int shift);

// 2x2 MaxPool, stride 2, HWC input/output (16 channels).
void maxpool1(
    hls::stream<int8_t> &in_pixels,
    hls::stream<int8_t> &out_pixels);

// The synthesis TOP: reads/writes DDR over AXI, streams intermediate maps.
void conv_block1(
    const int8_t input[CONV1_1_INPUT_SIZE],
    const int8_t weight1[CONV1_1_WEIGHT_SIZE],
    const int32_t bias1[CONV1_1_OUT_C],
    const int8_t weight2[CONV1_2_WEIGHT_SIZE],
    const int32_t bias2[CONV1_2_OUT_C],
    int8_t output[BLOCK1_OUTPUT_SIZE],
    int shift1,
    int shift2);


// ================================================================
// Conv Block 2: input from Pool1; SAME Conv 3x3, then 2x2 MaxPool.
// Activation: HWC; Weights: HWIO. All activations INT8.
// ================================================================
#define CONV2_1_H           POOL1_H
#define CONV2_1_W           POOL1_W
#define CONV2_1_IN_C        CONV1_2_OUT_C
#define CONV2_1_OUT_C       32

#define CONV2_2_H           CONV2_1_H
#define CONV2_2_W           CONV2_1_W
#define CONV2_2_IN_C        CONV2_1_OUT_C
#define CONV2_2_OUT_C       32

#define CONV2_1_INPUT_SIZE  (CONV2_1_H * CONV2_1_W * CONV2_1_IN_C)
#define CONV2_1_OUTPUT_SIZE (CONV2_1_H * CONV2_1_W * CONV2_1_OUT_C)
#define CONV2_1_WEIGHT_SIZE (CONV_K * CONV_K * CONV2_1_IN_C * CONV2_1_OUT_C)

#define CONV2_2_INPUT_SIZE  (CONV2_2_H * CONV2_2_W * CONV2_2_IN_C)
#define CONV2_2_OUTPUT_SIZE (CONV2_2_H * CONV2_2_W * CONV2_2_OUT_C)
#define CONV2_2_WEIGHT_SIZE (CONV_K * CONV_K * CONV2_2_IN_C * CONV2_2_OUT_C)

#define POOL2_H            (CONV2_2_H / 2)
#define POOL2_W            (CONV2_2_W / 2)
#define BLOCK2_INPUT_SIZE  CONV2_1_INPUT_SIZE
#define BLOCK2_OUTPUT_SIZE (POOL2_H * POOL2_W * CONV2_2_OUT_C)

// (heewon) Optimized Block2 packed-weight interface.
// One 72-bit word contains all nine signed INT8 taps for one (ic, oc).
typedef ap_uint<72> conv2_weight9_t;

void conv2_1(
    hls::stream<int8_t> &in_pixels,
    const conv2_weight9_t weights[CONV2_1_IN_C][CONV2_1_OUT_C],
    const int32_t bias[CONV2_1_OUT_C],
    hls::stream<int8_t> &out_pixels,
    int shift);

void conv2_2(
    hls::stream<int8_t> &in_pixels,
    const conv2_weight9_t weights[CONV2_2_IN_C][CONV2_2_OUT_C],
    const int32_t bias[CONV2_2_OUT_C],
    hls::stream<int8_t> &out_pixels,
    int shift);

void maxpool2(
    hls::stream<int8_t> &in_pixels,
    hls::stream<int8_t> &out_pixels);

void conv_block2(
    const int8_t input[BLOCK2_INPUT_SIZE],
    const int8_t weight1[CONV2_1_WEIGHT_SIZE],
    const int32_t bias1[CONV2_1_OUT_C],
    const int8_t weight2[CONV2_2_WEIGHT_SIZE],
    const int32_t bias2[CONV2_2_OUT_C],
    int8_t output[BLOCK2_OUTPUT_SIZE],
    int shift1, int shift2);



// ================================================================
// (heewon) Conv Block 3: input from Pool2, 3x3 SAME, then 2x2 Pool.
// 100x16x32 -> 100x16x64 -> 100x16x64 -> 50x8x64
// ================================================================
#define CONV3_1_H           POOL2_H
#define CONV3_1_W           POOL2_W
#define CONV3_1_IN_C        CONV2_2_OUT_C
#define CONV3_1_OUT_C       64

#define CONV3_2_H           CONV3_1_H
#define CONV3_2_W           CONV3_1_W
#define CONV3_2_IN_C        CONV3_1_OUT_C
#define CONV3_2_OUT_C       64

#define CONV3_1_INPUT_SIZE  (CONV3_1_H * CONV3_1_W * CONV3_1_IN_C)
#define CONV3_1_OUTPUT_SIZE (CONV3_1_H * CONV3_1_W * CONV3_1_OUT_C)
#define CONV3_1_WEIGHT_SIZE (CONV_K * CONV_K * CONV3_1_IN_C * CONV3_1_OUT_C)

#define CONV3_2_INPUT_SIZE  (CONV3_2_H * CONV3_2_W * CONV3_2_IN_C)
#define CONV3_2_OUTPUT_SIZE (CONV3_2_H * CONV3_2_W * CONV3_2_OUT_C)
#define CONV3_2_WEIGHT_SIZE (CONV_K * CONV_K * CONV3_2_IN_C * CONV3_2_OUT_C)

#define POOL3_H            (CONV3_2_H / 2)
#define POOL3_W            (CONV3_2_W / 2)
#define BLOCK3_INPUT_SIZE  CONV3_1_INPUT_SIZE
#define BLOCK3_OUTPUT_SIZE (POOL3_H * POOL3_W * CONV3_2_OUT_C)

void conv3_1(
    hls::stream<int8_t> &in_pixels,
    const int8_t weights[9][CONV3_1_IN_C * CONV3_1_OUT_C],
    const int32_t bias[CONV3_1_OUT_C],
    hls::stream<int8_t> &out_pixels,
    int shift);

void conv3_2(
    hls::stream<int8_t> &in_pixels,
    const int8_t weights[9][CONV3_2_IN_C * CONV3_2_OUT_C],
    const int32_t bias[CONV3_2_OUT_C],
    hls::stream<int8_t> &out_pixels,
    int shift);

void maxpool3(
    hls::stream<int8_t> &in_pixels,
    hls::stream<int8_t> &out_pixels);

void conv_block3(
    const int8_t input[BLOCK3_INPUT_SIZE],
    const int8_t weight1[CONV3_1_WEIGHT_SIZE],
    const int32_t bias1[CONV3_1_OUT_C],
    const int8_t weight2[CONV3_2_WEIGHT_SIZE],
    const int32_t bias2[CONV3_2_OUT_C],
    int8_t output[BLOCK3_OUTPUT_SIZE],
    int shift1, int shift2);

// ================================================================
// (heewon) Classification Head: Pool3 -> GAP -> FC64/ReLU -> FC2
// GAP input: 50x8x64 (INT8). Final output: two INT32 raw logits.
// Include all definitions here so cnn/src/conv2d.h is self-contained.
// ================================================================
#define HEAD_H              POOL3_H
#define HEAD_W              POOL3_W
#define HEAD_IN_C           CONV3_2_OUT_C
#define HEAD_SPATIAL        (HEAD_H * HEAD_W)
#define HEAD_INPUT_SIZE     (HEAD_SPATIAL * HEAD_IN_C)
#define HEAD_FC1_OUT_C      64
#define HEAD_FC2_OUT_C      2
#define HEAD_FC1_WEIGHT_SIZE (HEAD_IN_C * HEAD_FC1_OUT_C)
#define HEAD_FC2_WEIGHT_SIZE (HEAD_FC1_OUT_C * HEAD_FC2_OUT_C)

// Stage functions are exposed for independent HLS C simulation.
void head_global_avg_pool(
    hls::stream<int8_t> &in_pixels,
    hls::stream<int8_t> &pooled);
void head_dense64_relu(
    hls::stream<int8_t> &pooled,
    const int8_t w1[HEAD_FC1_WEIGHT_SIZE],
    const int32_t b1[HEAD_FC1_OUT_C],
    hls::stream<int8_t> &hidden,
    int shift_fc1);
void head_dense2_logits(
    hls::stream<int8_t> &hidden,
    const int8_t w2[HEAD_FC2_WEIGHT_SIZE],
    const int32_t b2[HEAD_FC2_OUT_C],
    hls::stream<int32_t> &logits);

// Reusable streaming head. Upstream = maxpool3, output = two raw INT32 logits.
void classification_head_stream(
    hls::stream<int8_t> &in_pixels,
    const int8_t w1[HEAD_FC1_WEIGHT_SIZE],
    const int32_t b1[HEAD_FC1_OUT_C],
    const int8_t w2[HEAD_FC2_WEIGHT_SIZE],
    const int32_t b2[HEAD_FC2_OUT_C],
    hls::stream<int32_t> &logits,
    int shift_fc1);

// Standalone AXI Top: 50x8x64 -> 2 signed INT32 logits, no softmax.
void classification_head(
    const int8_t input[HEAD_INPUT_SIZE],
    const int8_t weight_fc1[HEAD_FC1_WEIGHT_SIZE],
    const int32_t bias_fc1[HEAD_FC1_OUT_C],
    const int8_t weight_fc2[HEAD_FC2_WEIGHT_SIZE],
    const int32_t bias_fc2[HEAD_FC2_OUT_C],
    int32_t logits[HEAD_FC2_OUT_C],
    int shift_fc1);

// ================================================================
// (heewon) CNN TOP: Block 1 -> Block 2 -> Block 3 -> Head
// No intermediate DDR; stream between layers.
// ================================================================
#define CNN_INPUT_SIZE       CONV1_1_INPUT_SIZE
#define CNN_OUTPUT_SIZE      HEAD_FC2_OUT_C
// (heewon) Full streaming CNN, input 400x64x1, output 2 raw INT32 logits.
// Three convolution blocks + GAP + Dense64 ReLU + Dense2.
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
    const int8_t weight3_1[CONV3_1_WEIGHT_SIZE],
    const int32_t bias3_1[CONV3_1_OUT_C],
    const int8_t weight3_2[CONV3_2_WEIGHT_SIZE],
    const int32_t bias3_2[CONV3_2_OUT_C],
    const int8_t weight_fc1[HEAD_FC1_WEIGHT_SIZE],
    const int32_t bias_fc1[HEAD_FC1_OUT_C],
    const int8_t weight_fc2[HEAD_FC2_WEIGHT_SIZE],
    const int32_t bias_fc2[HEAD_FC2_OUT_C],
    int32_t logits[HEAD_FC2_OUT_C],
    int shift1_1, int shift1_2, int shift2_1, int shift2_2, int shift3_1, int shift3_2, int shift_fc1);

#endif // CONV2D_H
