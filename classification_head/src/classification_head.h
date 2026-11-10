#ifndef CLASSIFICATION_HEAD_H
#define CLASSIFICATION_HEAD_H
#include <stdint.h>
#include <hls_stream.h>
// (heewon) The original conv_block3/src/conv2d.h is referenced via -I.
// Do NOT copy it: this keeps the feature-map dimensions synchronized.
#include "C:/Users/heewon/vitis_hls/conv_block3/src/conv2d.h"

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
#endif
