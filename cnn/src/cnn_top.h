#ifndef CNN_TOP_H
#define CNN_TOP_H

// (heewon) Full CNN:
// Block1 -> Block2 -> Block3 -> Classification Head
#include "C:/Users/heewon/vitis_hls/cnn/src/conv2d.h"

// (heewon) Require the complete Block3 + Head definitions.
#ifndef HEAD_FC2_OUT_C
#error "Update conv2d.h with Block3 and Head definitions first."
#endif

// (heewon) Input: 400x64x1 INT8
// Output: 2 signed INT32 logits
#ifndef CNN_INPUT_SIZE
#define CNN_INPUT_SIZE CONV1_1_INPUT_SIZE
#endif

#ifndef CNN_OUTPUT_SIZE
#define CNN_OUTPUT_SIZE HEAD_FC2_OUT_C
#endif

void cnn(
    const int8_t input[CNN_INPUT_SIZE],

    // Conv Block 1
    const int8_t weight1_1[CONV1_1_WEIGHT_SIZE],
    const int32_t bias1_1[CONV1_1_OUT_C],
    const int8_t weight1_2[CONV1_2_WEIGHT_SIZE],
    const int32_t bias1_2[CONV1_2_OUT_C],

    // Conv Block 2
    const int8_t weight2_1[CONV2_1_WEIGHT_SIZE],
    const int32_t bias2_1[CONV2_1_OUT_C],
    const int8_t weight2_2[CONV2_2_WEIGHT_SIZE],
    const int32_t bias2_2[CONV2_2_OUT_C],

    // Conv Block 3
    const int8_t weight3_1[CONV3_1_WEIGHT_SIZE],
    const int32_t bias3_1[CONV3_1_OUT_C],
    const int8_t weight3_2[CONV3_2_WEIGHT_SIZE],
    const int32_t bias3_2[CONV3_2_OUT_C],

    // Classification Head
    const int8_t weight_fc1[HEAD_FC1_WEIGHT_SIZE],
    const int32_t bias_fc1[HEAD_FC1_OUT_C],
    const int8_t weight_fc2[HEAD_FC2_WEIGHT_SIZE],
    const int32_t bias_fc2[HEAD_FC2_OUT_C],

    // Final output: raw logits
    int32_t logits[CNN_OUTPUT_SIZE],

    // Quantization shifts
    int shift1_1, int shift1_2,
    int shift2_1, int shift2_2,
    int shift3_1, int shift3_2,
    int shift_fc1
);

#endif // CNN_TOP_H
