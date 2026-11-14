#ifndef CONV2D_H
#define CONV2D_H

#include <stdint.h>
#include <hls_stream.h>
#include <ap_int.h>

// Dedicated layer sizes. Activation layout: [H][W][C] (HWC).
// Weights: [3][3][IN_C][OUT_C] (HWIO).
// Both convolutions: 3x3, stride 1, SAME zero padding.
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

// The TWO conv engines below are independently implemented in their own .cpp.
// Weight buffers are preloaded and 3x3-tap banked by conv_block1.cpp.
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

// (heewon) Same packed-weight interface pattern used by optimized Conv3.
// One word contains all nine INT8 taps for one (input channel, output channel).
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

#endif
