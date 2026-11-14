#ifndef CONV3_REUSE_H
#define CONV3_REUSE_H

#include "conv2d.h"
#include <ap_int.h>

// (heewon) Pack all nine INT8 3x3 kernel taps for one
// (input-lane, phase, output-channel) tuple into one 72-bit word.
// This replaces 9 independent 8-bit weight banks with one wide bank.
typedef ap_uint<72> conv3_weight9_t;

// (heewon) Scalar stream format and original external HWC/HWIO layout are unchanged.
// Only the on-chip weight layout is packed.
void conv3_1_reuse16(
    hls::stream<int8_t> &in_pixels,
    const conv3_weight9_t weights[16][2 * CONV3_1_OUT_C],
    const int32_t bias[CONV3_1_OUT_C],
    hls::stream<int8_t> &out_pixels,
    int shift);

void conv3_2_reuse32(
    hls::stream<int8_t> &in_pixels,
    const conv3_weight9_t weights[32][2 * CONV3_2_OUT_C],
    const int32_t bias[CONV3_2_OUT_C],
    hls::stream<int8_t> &out_pixels,
    int shift);

void conv_block3_reuse(
    const int8_t input[CONV3_1_INPUT_SIZE],
    const int8_t weight1[CONV3_1_WEIGHT_SIZE],
    const int32_t bias1[CONV3_1_OUT_C],
    const int8_t weight2[CONV3_2_WEIGHT_SIZE],
    const int32_t bias2[CONV3_2_OUT_C],
    int8_t output[BLOCK3_OUTPUT_SIZE],
    int shift1, int shift2);

#endif
