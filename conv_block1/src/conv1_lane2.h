
#ifndef CONV1_LANE2_H
#define CONV1_LANE2_H

#ifndef AP_INT_MAX_W
#define AP_INT_MAX_W 2048
#endif

#include <ap_int.h>
#include "conv2d.h"

// Two INT8 channels packed into 16 bits
typedef ap_uint<16> conv1_lane2_t;

#define CONV1_LANE_COUNT 2
#define CONV1_1_GROUPS (CONV1_1_OUT_C / CONV1_LANE_COUNT)
#define CONV1_2_GROUPS (CONV1_2_OUT_C / CONV1_LANE_COUNT)

#if (CONV1_1_OUT_C % CONV1_LANE_COUNT != 0) || \
    (CONV1_2_IN_C % CONV1_LANE_COUNT != 0) || \
    (CONV1_2_OUT_C % CONV1_LANE_COUNT != 0)
#error "Block 1 lane2 requires even channel counts."
#endif

void conv1_1_lane2(
    hls::stream<int8_t> &in_pixels,
    const int8_t weights[9][2][CONV1_1_GROUPS],
    const int32_t bias[CONV1_1_OUT_C],
    hls::stream<conv1_lane2_t> &out_pixels,
    int shift);

void conv1_2_lane2(
    hls::stream<conv1_lane2_t> &in_pixels,
    const int8_t weights[9][CONV1_2_IN_C][2][CONV1_2_GROUPS],
    const int32_t bias[CONV1_2_OUT_C],
    hls::stream<conv1_lane2_t> &out_pixels,
    int shift);

void maxpool1_lane2(
    hls::stream<conv1_lane2_t> &in_pixels,
    hls::stream<conv1_lane2_t> &out_pixels);

// ========================================
// Block 1 - 2-Lane Top
// ========================================

void conv_block1_lane2(
    const int8_t input[CONV1_1_INPUT_SIZE],
    const int8_t weight1[CONV1_1_WEIGHT_SIZE],
    const int32_t bias1[CONV1_1_OUT_C],
    const int8_t weight2[CONV1_2_WEIGHT_SIZE],
    const int32_t bias2[CONV1_2_OUT_C],
    int8_t output[BLOCK1_OUTPUT_SIZE],
    int shift1,
    int shift2
);

#endif // CONV1_LANE2_H
