#include "classification_head.h"

// (heewon) GAP of 50x8x64 activations (HWC). A 32-bit sum is sufficient
// even if all 400 samples in a channel have magnitude 128.
// Round nearest, half away from zero; the preceding ReLU normally makes x>=0.
void head_global_avg_pool(
    hls::stream<int8_t> &in_pixels,
    hls::stream<int8_t> &pooled)
{
#pragma HLS INLINE off
    int32_t sum[HEAD_IN_C];
#pragma HLS ARRAY_PARTITION variable=sum complete dim=1
HEAD_GAP_ZERO:
    for (int ic = 0; ic < HEAD_IN_C; ++ic) {
#pragma HLS UNROLL
        sum[ic] = 0;
    }
HEAD_GAP_READ:
    for (int idx = 0; idx < HEAD_INPUT_SIZE; ++idx) {
#pragma HLS PIPELINE II=1
        int ic = idx % HEAD_IN_C;
        sum[ic] += (int32_t)in_pixels.read();
    }
HEAD_GAP_WRITE:
    for (int ic = 0; ic < HEAD_IN_C; ++ic) {
#pragma HLS PIPELINE II=1
        int32_t s = sum[ic];
        int32_t a = (s >= 0) ? (s + HEAD_SPATIAL/2) / HEAD_SPATIAL
                             : -((-s + HEAD_SPATIAL/2) / HEAD_SPATIAL);
        if (a > 127) a = 127;
        if (a < -128) a = -128;
        pooled.write((int8_t)a);
    }
}

static int8_t head_quant_relu(int32_t acc, int shift) {
#pragma HLS INLINE
    if (acc <= 0) return 0;
    uint32_t x = (uint32_t)acc;
    if (x >= (127u << shift)) return 127;
    if (shift > 0) x = (x + (1u << (shift-1))) >> shift;
    return (int8_t)((x > 127u) ? 127u : x);
}

// (heewon) Weights are Input-major: weight[ic * 64 + oc].
// Top partitions the weight array into 64 BLOCK banks by input channel.
void head_dense64_relu(
    hls::stream<int8_t> &pooled,
    const int8_t w1[HEAD_FC1_WEIGHT_SIZE],
    const int32_t b1[HEAD_FC1_OUT_C],
    hls::stream<int8_t> &hidden,
    int shift_fc1)
{
#pragma HLS INLINE off
    int8_t x[HEAD_IN_C];
#pragma HLS ARRAY_PARTITION variable=x complete dim=1
HEAD_FC1_LOAD:
    for (int ic = 0; ic < HEAD_IN_C; ++ic) {
#pragma HLS PIPELINE II=1
        x[ic] = pooled.read();
    }
HEAD_FC1_OUTPUT:
    for (int oc = 0; oc < HEAD_FC1_OUT_C; ++oc) {
#pragma HLS PIPELINE II=1
        // Parallelize across 64 input channels, 1 output channel / cycle.
        int32_t partial[HEAD_IN_C];
#pragma HLS ARRAY_PARTITION variable=partial complete dim=1
HEAD_FC1_MAC:
        for (int ic = 0; ic < HEAD_IN_C; ++ic) {
#pragma HLS UNROLL
            partial[ic] = (int32_t)x[ic] *
                          (int32_t)w1[ic * HEAD_FC1_OUT_C + oc];
        }
        int32_t acc = b1[oc];
HEAD_FC1_SUM:
        for (int ic = 0; ic < HEAD_IN_C; ++ic) {
#pragma HLS UNROLL
            acc += partial[ic];
        }
        hidden.write(head_quant_relu(acc, shift_fc1));
    }
}

// (heewon) Dense(2) has no ReLU or saturation. Output RAW INT32 LOGITS.
// Class argmax may run in software; softmax is deliberately NOT in RTL.
void head_dense2_logits(
    hls::stream<int8_t> &hidden,
    const int8_t w2[HEAD_FC2_WEIGHT_SIZE],
    const int32_t b2[HEAD_FC2_OUT_C],
    hls::stream<int32_t> &logits)
{
#pragma HLS INLINE off
    int8_t x[HEAD_FC1_OUT_C];
#pragma HLS ARRAY_PARTITION variable=x complete dim=1
HEAD_FC2_LOAD:
    for (int ic = 0; ic < HEAD_FC1_OUT_C; ++ic) {
#pragma HLS PIPELINE II=1
        x[ic] = hidden.read();
    }
HEAD_FC2_OUTPUT:
    for (int oc = 0; oc < HEAD_FC2_OUT_C; ++oc) {
#pragma HLS PIPELINE II=1
        int32_t partial[HEAD_FC1_OUT_C];
#pragma HLS ARRAY_PARTITION variable=partial complete dim=1
HEAD_FC2_MAC:
        for (int ic = 0; ic < HEAD_FC1_OUT_C; ++ic) {
#pragma HLS UNROLL
            partial[ic] = (int32_t)x[ic] *
                          (int32_t)w2[ic * HEAD_FC2_OUT_C + oc];
        }
        int32_t acc = b2[oc];
HEAD_FC2_SUM:
        for (int ic = 0; ic < HEAD_FC1_OUT_C; ++ic) {
#pragma HLS UNROLL
            acc += partial[ic];
        }
        logits.write(acc);
    }
}

void classification_head_stream(
    hls::stream<int8_t> &in_pixels,
    const int8_t w1[HEAD_FC1_WEIGHT_SIZE],
    const int32_t b1[HEAD_FC1_OUT_C],
    const int8_t w2[HEAD_FC2_WEIGHT_SIZE],
    const int32_t b2[HEAD_FC2_OUT_C],
    hls::stream<int32_t> &logits,
    int shift_fc1)
{
#pragma HLS INLINE off
#pragma HLS DATAFLOW
    hls::stream<int8_t> pooled("head_gap_to_fc1");
    hls::stream<int8_t> hidden("head_fc1_to_fc2");
#pragma HLS STREAM variable=pooled depth=64
#pragma HLS STREAM variable=hidden depth=64
    head_global_avg_pool(in_pixels, pooled);
    head_dense64_relu(pooled, w1, b1, hidden, shift_fc1);
    head_dense2_logits(hidden, w2, b2, logits);
}

static void head_read_input(
    const int8_t input[HEAD_INPUT_SIZE],
    hls::stream<int8_t> &pixels)
{
#pragma HLS INLINE off
HEAD_READ_PIXELS:
    for (int i = 0; i < HEAD_INPUT_SIZE; ++i) {
#pragma HLS PIPELINE II=1
        pixels.write(input[i]);
    }
}

static void head_write_logits(
    hls::stream<int32_t> &scores,
    int32_t logits[HEAD_FC2_OUT_C])
{
#pragma HLS INLINE off
HEAD_WRITE_LOGITS:
    for (int i = 0; i < HEAD_FC2_OUT_C; ++i) {
#pragma HLS PIPELINE II=1
        logits[i] = scores.read();
    }
}

static void head_load_w1(
    const int8_t src[HEAD_FC1_WEIGHT_SIZE],
    int8_t dst[HEAD_FC1_WEIGHT_SIZE])
{
#pragma HLS INLINE off
HEAD_LOAD_W1:
    for (int i = 0; i < HEAD_FC1_WEIGHT_SIZE; ++i) {
#pragma HLS PIPELINE II=1
        dst[i] = src[i];
    }
}
static void head_load_w2(
    const int8_t src[HEAD_FC2_WEIGHT_SIZE],
    int8_t dst[HEAD_FC2_WEIGHT_SIZE])
{
#pragma HLS INLINE off
HEAD_LOAD_W2:
    for (int i = 0; i < HEAD_FC2_WEIGHT_SIZE; ++i) {
#pragma HLS PIPELINE II=1
        dst[i] = src[i];
    }
}
static void head_load_b1(
    const int32_t src[HEAD_FC1_OUT_C],
    int32_t dst[HEAD_FC1_OUT_C])
{
#pragma HLS INLINE off
HEAD_LOAD_B1:
    for (int i = 0; i < HEAD_FC1_OUT_C; ++i) {
#pragma HLS PIPELINE II=1
        dst[i] = src[i];
    }
}
static void head_load_b2(
    const int32_t src[HEAD_FC2_OUT_C],
    int32_t dst[HEAD_FC2_OUT_C])
{
#pragma HLS INLINE off
HEAD_LOAD_B2:
    for (int i = 0; i < HEAD_FC2_OUT_C; ++i) {
#pragma HLS PIPELINE II=1
        dst[i] = src[i];
    }
}
static void head_pipeline(
    const int8_t input[HEAD_INPUT_SIZE],
    const int8_t w1[HEAD_FC1_WEIGHT_SIZE],
    const int32_t b1[HEAD_FC1_OUT_C],
    const int8_t w2[HEAD_FC2_WEIGHT_SIZE],
    const int32_t b2[HEAD_FC2_OUT_C],
    int32_t logits[HEAD_FC2_OUT_C],
    int shift_fc1)
{
#pragma HLS INLINE off
#pragma HLS DATAFLOW
    hls::stream<int8_t> pixels("head_input_fifo");
    hls::stream<int32_t> scores("head_logits_fifo");
#pragma HLS STREAM variable=pixels depth=64
#pragma HLS STREAM variable=scores depth=2
    head_read_input(input, pixels);
    classification_head_stream(pixels, w1, b1, w2, b2, scores, shift_fc1);
    head_write_logits(scores, logits);
}

void classification_head(
    const int8_t input[HEAD_INPUT_SIZE],
    const int8_t weight_fc1[HEAD_FC1_WEIGHT_SIZE],
    const int32_t bias_fc1[HEAD_FC1_OUT_C],
    const int8_t weight_fc2[HEAD_FC2_WEIGHT_SIZE],
    const int32_t bias_fc2[HEAD_FC2_OUT_C],
    int32_t logits[HEAD_FC2_OUT_C],
    int shift_fc1)
{
#pragma HLS INTERFACE m_axi port=input      offset=slave bundle=gmem depth=HEAD_INPUT_SIZE
#pragma HLS INTERFACE m_axi port=weight_fc1 offset=slave bundle=gmem depth=HEAD_FC1_WEIGHT_SIZE
#pragma HLS INTERFACE m_axi port=bias_fc1   offset=slave bundle=gmem depth=HEAD_FC1_OUT_C
#pragma HLS INTERFACE m_axi port=weight_fc2 offset=slave bundle=gmem depth=HEAD_FC2_WEIGHT_SIZE
#pragma HLS INTERFACE m_axi port=bias_fc2   offset=slave bundle=gmem depth=HEAD_FC2_OUT_C
#pragma HLS INTERFACE m_axi port=logits     offset=slave bundle=gmem depth=HEAD_FC2_OUT_C
#pragma HLS INTERFACE s_axilite port=input      bundle=control
#pragma HLS INTERFACE s_axilite port=weight_fc1 bundle=control
#pragma HLS INTERFACE s_axilite port=bias_fc1   bundle=control
#pragma HLS INTERFACE s_axilite port=weight_fc2 bundle=control
#pragma HLS INTERFACE s_axilite port=bias_fc2   bundle=control
#pragma HLS INTERFACE s_axilite port=logits     bundle=control
#pragma HLS INTERFACE s_axilite port=shift_fc1  bundle=control
#pragma HLS INTERFACE s_axilite port=return     bundle=control
    if (shift_fc1 < 0 || shift_fc1 > 24) return;
    int8_t w1[HEAD_FC1_WEIGHT_SIZE];
    int8_t w2[HEAD_FC2_WEIGHT_SIZE];
    int32_t b1[HEAD_FC1_OUT_C];
    int32_t b2[HEAD_FC2_OUT_C];
    // BANK by input channel: weight[ic * OC + oc].
#pragma HLS ARRAY_PARTITION variable=w1 block factor=64 dim=1
#pragma HLS ARRAY_PARTITION variable=w2 block factor=64 dim=1
    head_load_w1(weight_fc1, w1);
    head_load_b1(bias_fc1, b1);
    head_load_w2(weight_fc2, w2);
    head_load_b2(bias_fc2, b2);
    head_pipeline(input, w1, b1, w2, b2, logits, shift_fc1);
}
