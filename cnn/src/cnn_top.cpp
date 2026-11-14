#include "cnn_top.h"
// (heewon) Full end-to-end CNN top for Vitis HLS 2024.1.
// Reuse the existing independent layer implementations (do not duplicate them).
// Input 400x64x1 -> Block 1 -> Block 2 -> Block 3 (50x8x64)
// -> Global Average Pool -> Dense64/ReLU -> Dense2 (INT32 logits).
// All intermediate feature maps are HLS streams; only weights/input/output
// use external AXI memory interfaces. The final softmax is host-side.

static void cnn_read_input(const int8_t input[CNN_INPUT_SIZE],
                            hls::stream<int8_t>& pixels) {
#pragma HLS INLINE off
CNN_READ:
    for(int i=0; i<CNN_INPUT_SIZE; ++i) {
#pragma HLS PIPELINE II=1
        pixels.write(input[i]);
    }
}
static void cnn_write_logits(hls::stream<int32_t>& scores,
                              int32_t out[CNN_OUTPUT_SIZE]) {
#pragma HLS INLINE off
CNN_WRITE:
    for(int i=0; i<CNN_OUTPUT_SIZE; ++i) {
#pragma HLS PIPELINE II=1
        out[i]=scores.read();
    }
}

// (heewon) Block1 lane2 + 72-bit tap packing.
// External DDR weights remain flat HWIO; only the on-chip representation changes.
static void cnn_load_w1_1(
    const int8_t src[CONV1_1_WEIGHT_SIZE],
    conv1_weight9_t dst[2][CONV1_1_GROUPS]) {
#pragma HLS INLINE off
CNN_LOAD_W1_1_K:
    for (int k=0; k<9; ++k) {
    CNN_LOAD_W1_1_G:
        for (int g=0; g<CONV1_1_GROUPS; ++g) {
        CNN_LOAD_W1_1_L:
            for (int lane=0; lane<2; ++lane) {
#pragma HLS PIPELINE II=1
                conv1_weight9_t packed = 0;
                if (k != 0) packed = dst[lane][g];
                packed.range(8*k+7, 8*k) =
                    (ap_uint<8>)((uint8_t)src[k*CONV1_1_OUT_C + 2*g + lane]);
                dst[lane][g] = packed;
            }
        }
    }
}

static void cnn_load_b1_1(const int32_t src[CONV1_1_OUT_C],
                                 int32_t dst[CONV1_1_OUT_C]) {
#pragma HLS INLINE off
CNN_LOAD_B1_1:
    for(int i=0;i<CONV1_1_OUT_C;++i) {
#pragma HLS PIPELINE II=1
        dst[i]=src[i];
    }
}

static void cnn_load_w1_2(
    const int8_t src[CONV1_2_WEIGHT_SIZE],
    conv1_weight9_t dst[CONV1_2_IN_C][2][CONV1_2_GROUPS]) {
#pragma HLS INLINE off
CNN_LOAD_W1_2_K:
    for (int k=0; k<9; ++k) {
    CNN_LOAD_W1_2_IC:
        for (int ic=0; ic<CONV1_2_IN_C; ++ic) {
        CNN_LOAD_W1_2_G:
            for (int g=0; g<CONV1_2_GROUPS; ++g) {
            CNN_LOAD_W1_2_L:
                for (int lane=0; lane<2; ++lane) {
#pragma HLS PIPELINE II=1
                    conv1_weight9_t packed = 0;
                    if (k != 0) packed = dst[ic][lane][g];
                    packed.range(8*k+7, 8*k) =
                        (ap_uint<8>)((uint8_t)src[
                            (k*CONV1_2_IN_C + ic)*CONV1_2_OUT_C + 2*g + lane]);
                    dst[ic][lane][g] = packed;
                }
            }
        }
    }
}

static void cnn_load_b1_2(const int32_t src[CONV1_2_OUT_C],
                                 int32_t dst[CONV1_2_OUT_C]) {
#pragma HLS INLINE off
CNN_LOAD_B1_2:
    for(int i=0;i<CONV1_2_OUT_C;++i) {
#pragma HLS PIPELINE II=1
        dst[i]=src[i];
    }
}

// (heewon) Block2 72-bit tap packing. One word stores all 9 INT8 taps for (ic, oc).
static void cnn_load_w2_1(
    const int8_t src[CONV2_1_WEIGHT_SIZE],
    conv2_weight9_t dst[CONV2_1_IN_C][CONV2_1_OUT_C]) {
#pragma HLS INLINE off
CNN_LOAD_W2_1_K:
    for (int k=0; k<9; ++k) {
    CNN_LOAD_W2_1_IC:
        for (int ic=0; ic<CONV2_1_IN_C; ++ic) {
        CNN_LOAD_W2_1_OC:
            for (int oc=0; oc<CONV2_1_OUT_C; ++oc) {
#pragma HLS PIPELINE II=1
                conv2_weight9_t packed = 0;
                if (k != 0) packed = dst[ic][oc];
                packed.range(8*k+7, 8*k) =
                    (ap_uint<8>)((uint8_t)src[
                        (k*CONV2_1_IN_C + ic)*CONV2_1_OUT_C + oc]);
                dst[ic][oc] = packed;
            }
        }
    }
}
static void cnn_load_b2_1(const int32_t src[CONV2_1_OUT_C],
                                 int32_t dst[CONV2_1_OUT_C]) {
#pragma HLS INLINE off
CNN_LOAD_B2_1:
    for(int i=0;i<CONV2_1_OUT_C;++i) {
#pragma HLS PIPELINE II=1
        dst[i]=src[i];
    }
}

static void cnn_load_w2_2(
    const int8_t src[CONV2_2_WEIGHT_SIZE],
    conv2_weight9_t dst[CONV2_2_IN_C][CONV2_2_OUT_C]) {
#pragma HLS INLINE off
CNN_LOAD_W2_2_K:
    for (int k=0; k<9; ++k) {
    CNN_LOAD_W2_2_IC:
        for (int ic=0; ic<CONV2_2_IN_C; ++ic) {
        CNN_LOAD_W2_2_OC:
            for (int oc=0; oc<CONV2_2_OUT_C; ++oc) {
#pragma HLS PIPELINE II=1
                conv2_weight9_t packed = 0;
                if (k != 0) packed = dst[ic][oc];
                packed.range(8*k+7, 8*k) =
                    (ap_uint<8>)((uint8_t)src[
                        (k*CONV2_2_IN_C + ic)*CONV2_2_OUT_C + oc]);
                dst[ic][oc] = packed;
            }
        }
    }
}
static void cnn_load_b2_2(const int32_t src[CONV2_2_OUT_C],
                                 int32_t dst[CONV2_2_OUT_C]) {
#pragma HLS INLINE off
CNN_LOAD_B2_2:
    for(int i=0;i<CONV2_2_OUT_C;++i) {
#pragma HLS PIPELINE II=1
        dst[i]=src[i];
    }
}


static void cnn_load_w3_1(
    const int8_t src[CONV3_1_WEIGHT_SIZE],
    conv3_weight9_t dst[16][2 * CONV3_1_OUT_C]) {
#pragma HLS INLINE off

// (heewon) Keep the external HWIO layout unchanged, but pack all nine
// 3x3 INT8 taps for one (lane, phase, output-channel) tuple into 72 bits.
CNN_LOAD_W3_1_K:
    for (int k = 0; k < 9; ++k) {
    CNN_LOAD_W3_1_IC:
        for (int ic = 0; ic < CONV3_1_IN_C; ++ic) {
        CNN_LOAD_W3_1_OC:
            for (int oc = 0; oc < CONV3_1_OUT_C; ++oc) {
#pragma HLS PIPELINE II=1
                const int lane = ic & 15;
                const int phase = ic >> 4;
                const int addr = phase * CONV3_1_OUT_C + oc;

                conv3_weight9_t packed = 0;
                if (k != 0) {
                    packed = dst[lane][addr];
                }

                packed.range(8 * k + 7, 8 * k) =
                    (ap_uint<8>)((uint8_t)
                        src[(k * CONV3_1_IN_C + ic) * CONV3_1_OUT_C + oc]);

                dst[lane][addr] = packed;
            }
        }
    }
}

static void cnn_load_b3_1(const int32_t src[CONV3_1_OUT_C],
                                 int32_t dst[CONV3_1_OUT_C]) {
#pragma HLS INLINE off
CNN_LOAD_B3_1:
    for(int i=0;i<CONV3_1_OUT_C;++i) {
#pragma HLS PIPELINE II=1
        dst[i]=src[i];
    }
}

// (heewon) Conv3-2: 32 lanes, 2 phases, external input remains flat HWIO.
static void cnn_load_w3_2(
    const int8_t src[CONV3_2_WEIGHT_SIZE],
    conv3_weight9_t dst[32][2 * CONV3_2_OUT_C]) {
#pragma HLS INLINE off

// (heewon) 32 lanes x 2 phases. External HWIO stays flat; only the
// on-chip representation changes to one 72-bit word per 3x3 kernel.
CNN_LOAD_W3_2_K:
    for (int k = 0; k < 9; ++k) {
    CNN_LOAD_W3_2_IC:
        for (int ic = 0; ic < CONV3_2_IN_C; ++ic) {
        CNN_LOAD_W3_2_OC:
            for (int oc = 0; oc < CONV3_2_OUT_C; ++oc) {
#pragma HLS PIPELINE II=1
                const int lane = ic & 31;
                const int phase = ic >> 5;
                const int addr = phase * CONV3_2_OUT_C + oc;

                conv3_weight9_t packed = 0;
                if (k != 0) {
                    packed = dst[lane][addr];
                }

                packed.range(8 * k + 7, 8 * k) =
                    (ap_uint<8>)((uint8_t)
                        src[(k * CONV3_2_IN_C + ic) * CONV3_2_OUT_C + oc]);

                dst[lane][addr] = packed;
            }
        }
    }
}

static void cnn_load_b3_2(const int32_t src[CONV3_2_OUT_C],
                                 int32_t dst[CONV3_2_OUT_C]) {
#pragma HLS INLINE off
CNN_LOAD_B3_2:
    for(int i=0;i<CONV3_2_OUT_C;++i) {
#pragma HLS PIPELINE II=1
        dst[i]=src[i];
    }
}

static void cnn_load_w_fc1(const int8_t src[HEAD_FC1_WEIGHT_SIZE], int8_t dst[HEAD_FC1_WEIGHT_SIZE]) {
#pragma HLS INLINE off
CNN_LOAD_W_fc1:
    for(int i=0;i<HEAD_FC1_WEIGHT_SIZE;++i) {
#pragma HLS PIPELINE II=1
        dst[i]=src[i];
    }
}

static void cnn_load_w_fc2(const int8_t src[HEAD_FC2_WEIGHT_SIZE], int8_t dst[HEAD_FC2_WEIGHT_SIZE]) {
#pragma HLS INLINE off
CNN_LOAD_W_fc2:
    for(int i=0;i<HEAD_FC2_WEIGHT_SIZE;++i) {
#pragma HLS PIPELINE II=1
        dst[i]=src[i];
    }
}

static void cnn_load_b_fc1(const int32_t src[HEAD_FC1_OUT_C], int32_t dst[HEAD_FC1_OUT_C]) {
#pragma HLS INLINE off
CNN_LOAD_B_fc1:
    for(int i=0;i<HEAD_FC1_OUT_C;++i) {
#pragma HLS PIPELINE II=1
        dst[i]=src[i];
    }
}

static void cnn_load_b_fc2(const int32_t src[HEAD_FC2_OUT_C], int32_t dst[HEAD_FC2_OUT_C]) {
#pragma HLS INLINE off
CNN_LOAD_B_fc2:
    for(int i=0;i<CNN_OUTPUT_SIZE;++i) {
#pragma HLS PIPELINE II=1
        dst[i]=src[i];
    }
}

// (heewon) Conv1 packs two HWC channels into 16-bit beats; Conv2 expects
// one INT8 channel per beat. Preserve HWC order and release one INT8/cycle.
static void cnn_unpack_pool1_lane2(
    hls::stream<conv1_lane2_t> &in_packed,
    hls::stream<int8_t> &out_scalar) {
#pragma HLS INLINE off
    conv1_lane2_t word = 0;
CNN_UNPACK_POOL1:
    for (int i=0; i<BLOCK1_OUTPUT_SIZE; ++i) {
#pragma HLS PIPELINE II=1
        if ((i & 1) == 0) word = in_packed.read();
        const ap_int<8> v = ((i & 1) == 0)
            ? (ap_int<8>)word.range(7, 0)
            : (ap_int<8>)word.range(15, 8);
        out_scalar.write((int8_t)v);
    }
}

static void cnn_pipeline(
    const int8_t input[CNN_INPUT_SIZE],
    const conv1_weight9_t w1_1[2][CONV1_1_GROUPS],
    const int32_t b1_1[CONV1_1_OUT_C],
    const conv1_weight9_t w1_2[CONV1_2_IN_C][2][CONV1_2_GROUPS],
    const int32_t b1_2[CONV1_2_OUT_C],
    const conv2_weight9_t w2_1[CONV2_1_IN_C][CONV2_1_OUT_C],
    const int32_t b2_1[CONV2_1_OUT_C],
    const conv2_weight9_t w2_2[CONV2_2_IN_C][CONV2_2_OUT_C],
    const int32_t b2_2[CONV2_2_OUT_C],
    const conv3_weight9_t w3_1[16][2 * CONV3_1_OUT_C],
    const int32_t b3_1[CONV3_1_OUT_C],
    const conv3_weight9_t w3_2[32][2 * CONV3_2_OUT_C],
    const int32_t b3_2[CONV3_2_OUT_C],
    const int8_t w_fc1[HEAD_FC1_WEIGHT_SIZE],
    const int32_t b_fc1[HEAD_FC1_OUT_C],
    const int8_t w_fc2[HEAD_FC2_WEIGHT_SIZE],
    const int32_t b_fc2[HEAD_FC2_OUT_C],
    int32_t logits[CNN_OUTPUT_SIZE],
    int shift1_1,
    int shift1_2,
    int shift2_1,
    int shift2_2,
    int shift3_1,
    int shift3_2,
    int shift_fc1) {
#pragma HLS INLINE off
#pragma HLS DATAFLOW
    hls::stream<int8_t> in_stream("cnn_in");
    hls::stream<conv1_lane2_t> s_c11("cnn_c11_lane2");
    hls::stream<conv1_lane2_t> s_c12("cnn_c12_lane2");
    hls::stream<conv1_lane2_t> s_pool1_packed("cnn_pool1_lane2");
    hls::stream<int8_t> s_pool1("cnn_pool1_unpacked");
    hls::stream<int8_t> s_c21("cnn_c21");
    hls::stream<int8_t> s_c22("cnn_c22");
    hls::stream<int8_t> s_pool2("cnn_pool2");
    hls::stream<int8_t> s_c31("cnn_c31");
    hls::stream<int8_t> s_c32("cnn_c32");
    hls::stream<int8_t> s_pool3("cnn_pool3");
    hls::stream<int32_t> scores("cnn_logits");
#pragma HLS STREAM variable=in_stream depth=16
#pragma HLS STREAM variable=s_c11 depth=16
#pragma HLS STREAM variable=s_c12 depth=16
#pragma HLS STREAM variable=s_pool1_packed depth=16
#pragma HLS STREAM variable=s_pool1 depth=16
#pragma HLS STREAM variable=s_c21 depth=16
#pragma HLS STREAM variable=s_c22 depth=16
#pragma HLS STREAM variable=s_pool2 depth=16
#pragma HLS STREAM variable=s_c31 depth=16
#pragma HLS STREAM variable=s_c32 depth=16
#pragma HLS STREAM variable=s_pool3 depth=16
#pragma HLS STREAM variable=scores depth=2
    cnn_read_input(input, in_stream);
    conv1_1_lane2(in_stream, w1_1, b1_1, s_c11, shift1_1);
    conv1_2_lane2(s_c11, w1_2, b1_2, s_c12, shift1_2);
    maxpool1_lane2(s_c12, s_pool1_packed);
    cnn_unpack_pool1_lane2(s_pool1_packed, s_pool1);
    conv2_1(s_pool1, w2_1, b2_1, s_c21, shift2_1);
    conv2_2(s_c21, w2_2, b2_2, s_c22, shift2_2);
    maxpool2(s_c22, s_pool2);
    conv3_1_reuse16(s_pool2, w3_1, b3_1, s_c31, shift3_1);
    conv3_2_reuse32(s_c31, w3_2, b3_2, s_c32, shift3_2);
    maxpool3(s_c32, s_pool3);
    classification_head_stream(s_pool3, w_fc1, b_fc1, w_fc2, b_fc2,
                               scores, shift_fc1);
    cnn_write_logits(scores, logits);
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
    const int8_t weight3_1[CONV3_1_WEIGHT_SIZE],
    const int32_t bias3_1[CONV3_1_OUT_C],
    const int8_t weight3_2[CONV3_2_WEIGHT_SIZE],
    const int32_t bias3_2[CONV3_2_OUT_C],
    const int8_t weight_fc1[HEAD_FC1_WEIGHT_SIZE],
    const int32_t bias_fc1[HEAD_FC1_OUT_C],
    const int8_t weight_fc2[HEAD_FC2_WEIGHT_SIZE],
    const int32_t bias_fc2[HEAD_FC2_OUT_C],
    int32_t logits[CNN_OUTPUT_SIZE],
    int shift1_1, int shift1_2,
    int shift2_1, int shift2_2,
    int shift3_1, int shift3_2,
    int shift_fc1) {
#pragma HLS INTERFACE m_axi port=input offset=slave bundle=gmem depth=CNN_INPUT_SIZE
#pragma HLS INTERFACE m_axi port=weight1_1 offset=slave bundle=gmem depth=CONV1_1_WEIGHT_SIZE
#pragma HLS INTERFACE m_axi port=bias1_1 offset=slave bundle=gmem depth=CONV1_1_OUT_C
#pragma HLS INTERFACE m_axi port=weight1_2 offset=slave bundle=gmem depth=CONV1_2_WEIGHT_SIZE
#pragma HLS INTERFACE m_axi port=bias1_2 offset=slave bundle=gmem depth=CONV1_2_OUT_C
#pragma HLS INTERFACE m_axi port=weight2_1 offset=slave bundle=gmem depth=CONV2_1_WEIGHT_SIZE
#pragma HLS INTERFACE m_axi port=bias2_1 offset=slave bundle=gmem depth=CONV2_1_OUT_C
#pragma HLS INTERFACE m_axi port=weight2_2 offset=slave bundle=gmem depth=CONV2_2_WEIGHT_SIZE
#pragma HLS INTERFACE m_axi port=bias2_2 offset=slave bundle=gmem depth=CONV2_2_OUT_C
#pragma HLS INTERFACE m_axi port=weight3_1 offset=slave bundle=gmem depth=CONV3_1_WEIGHT_SIZE
#pragma HLS INTERFACE m_axi port=bias3_1 offset=slave bundle=gmem depth=CONV3_1_OUT_C
#pragma HLS INTERFACE m_axi port=weight3_2 offset=slave bundle=gmem depth=CONV3_2_WEIGHT_SIZE
#pragma HLS INTERFACE m_axi port=bias3_2 offset=slave bundle=gmem depth=CONV3_2_OUT_C
#pragma HLS INTERFACE m_axi port=weight_fc1 offset=slave bundle=gmem depth=HEAD_FC1_WEIGHT_SIZE
#pragma HLS INTERFACE m_axi port=bias_fc1 offset=slave bundle=gmem depth=HEAD_FC1_OUT_C
#pragma HLS INTERFACE m_axi port=weight_fc2 offset=slave bundle=gmem depth=HEAD_FC2_WEIGHT_SIZE
#pragma HLS INTERFACE m_axi port=bias_fc2 offset=slave bundle=gmem depth=CNN_OUTPUT_SIZE
#pragma HLS INTERFACE m_axi port=logits offset=slave bundle=gmem depth=CNN_OUTPUT_SIZE
#pragma HLS INTERFACE s_axilite port=input bundle=control
#pragma HLS INTERFACE s_axilite port=weight1_1 bundle=control
#pragma HLS INTERFACE s_axilite port=bias1_1 bundle=control
#pragma HLS INTERFACE s_axilite port=weight1_2 bundle=control
#pragma HLS INTERFACE s_axilite port=bias1_2 bundle=control
#pragma HLS INTERFACE s_axilite port=weight2_1 bundle=control
#pragma HLS INTERFACE s_axilite port=bias2_1 bundle=control
#pragma HLS INTERFACE s_axilite port=weight2_2 bundle=control
#pragma HLS INTERFACE s_axilite port=bias2_2 bundle=control
#pragma HLS INTERFACE s_axilite port=weight3_1 bundle=control
#pragma HLS INTERFACE s_axilite port=bias3_1 bundle=control
#pragma HLS INTERFACE s_axilite port=weight3_2 bundle=control
#pragma HLS INTERFACE s_axilite port=bias3_2 bundle=control
#pragma HLS INTERFACE s_axilite port=weight_fc1 bundle=control
#pragma HLS INTERFACE s_axilite port=bias_fc1 bundle=control
#pragma HLS INTERFACE s_axilite port=weight_fc2 bundle=control
#pragma HLS INTERFACE s_axilite port=bias_fc2 bundle=control
#pragma HLS INTERFACE s_axilite port=logits bundle=control
#pragma HLS INTERFACE s_axilite port=shift1_1 bundle=control
#pragma HLS INTERFACE s_axilite port=shift1_2 bundle=control
#pragma HLS INTERFACE s_axilite port=shift2_1 bundle=control
#pragma HLS INTERFACE s_axilite port=shift2_2 bundle=control
#pragma HLS INTERFACE s_axilite port=shift3_1 bundle=control
#pragma HLS INTERFACE s_axilite port=shift3_2 bundle=control
#pragma HLS INTERFACE s_axilite port=shift_fc1 bundle=control
#pragma HLS INTERFACE s_axilite port=return bundle=control
    // (heewon) Reject shifts before reading input or accessing output.
    if (shift1_1 < 0 || shift1_1 > 24 ||
        shift1_2 < 0 || shift1_2 > 24 ||
        shift2_1 < 0 || shift2_1 > 24 ||
        shift2_2 < 0 || shift2_2 > 24 ||
        shift3_1 < 0 || shift3_1 > 24 ||
        shift3_2 < 0 || shift3_2 > 24 ||
        shift_fc1 < 0 || shift_fc1 > 24) return;
    // (heewon) Block1 final: 72-bit packed 3x3 taps + lane2 parallelism.
    // Keep packed weights in LUTRAM to avoid increasing BRAM pressure.
    conv1_weight9_t w1_1[2][CONV1_1_GROUPS];
#pragma HLS ARRAY_PARTITION variable=w1_1 complete dim=1
#pragma HLS BIND_STORAGE variable=w1_1 type=ram_s2p impl=lutram
    int32_t b1_1[CONV1_1_OUT_C];
#pragma HLS ARRAY_PARTITION variable=b1_1 complete dim=1

    conv1_weight9_t w1_2[CONV1_2_IN_C][2][CONV1_2_GROUPS];
#pragma HLS ARRAY_PARTITION variable=w1_2 complete dim=1
#pragma HLS ARRAY_PARTITION variable=w1_2 complete dim=2
#pragma HLS BIND_STORAGE variable=w1_2 type=ram_s2p impl=lutram
    int32_t b1_2[CONV1_2_OUT_C];
#pragma HLS ARRAY_PARTITION variable=b1_2 complete dim=1

    // (heewon) Block2 final: 72-bit packed 3x3 taps. Input channels remain
    // fully banked for parallel MACs; output channels remain memory depth.
    conv2_weight9_t w2_1[CONV2_1_IN_C][CONV2_1_OUT_C];
#pragma HLS ARRAY_PARTITION variable=w2_1 complete dim=1
#pragma HLS BIND_STORAGE variable=w2_1 type=ram_s2p impl=lutram
    int32_t b2_1[CONV2_1_OUT_C];

    conv2_weight9_t w2_2[CONV2_2_IN_C][CONV2_2_OUT_C];
#pragma HLS ARRAY_PARTITION variable=w2_2 complete dim=1
#pragma HLS BIND_STORAGE variable=w2_2 type=ram_s2p impl=lutram
    int32_t b2_2[CONV2_2_OUT_C];

    // (heewon) Block3 final: 72-bit packed weights + reuse16/32, validated standalone.
    // Conv3-1: 9x16 tiny banks -> 16 x 72-bit BRAM banks.
    // Conv3-2: 9x32 tiny banks -> 32 x 72-bit BRAM banks.
    conv3_weight9_t w3_1[16][2 * CONV3_1_OUT_C];
#pragma HLS ARRAY_PARTITION variable=w3_1 complete dim=1
#pragma HLS BIND_STORAGE variable=w3_1 type=ram_s2p impl=bram

    int32_t b3_1[CONV3_1_OUT_C];

    conv3_weight9_t w3_2[32][2 * CONV3_2_OUT_C];
#pragma HLS ARRAY_PARTITION variable=w3_2 complete dim=1
#pragma HLS BIND_STORAGE variable=w3_2 type=ram_s2p impl=bram

    int32_t b3_2[CONV3_2_OUT_C];
    int8_t w_fc1[HEAD_FC1_WEIGHT_SIZE];
    int8_t w_fc2[HEAD_FC2_WEIGHT_SIZE];
#pragma HLS ARRAY_PARTITION variable=w_fc1 block factor=64 dim=1
#pragma HLS ARRAY_PARTITION variable=w_fc2 block factor=64 dim=1
    int32_t b_fc1[HEAD_FC1_OUT_C];
    int32_t b_fc2[HEAD_FC2_OUT_C];
    // (heewon) Preserve sequential preload strategy used in original top.
    cnn_load_w1_1(weight1_1, w1_1);
    cnn_load_b1_1(bias1_1, b1_1);
    cnn_load_w1_2(weight1_2, w1_2);
    cnn_load_b1_2(bias1_2, b1_2);
    cnn_load_w2_1(weight2_1, w2_1);
    cnn_load_b2_1(bias2_1, b2_1);
    cnn_load_w2_2(weight2_2, w2_2);
    cnn_load_b2_2(bias2_2, b2_2);
    cnn_load_w3_1(weight3_1, w3_1);
    cnn_load_b3_1(bias3_1, b3_1);
    cnn_load_w3_2(weight3_2, w3_2);
    cnn_load_b3_2(bias3_2, b3_2);
    cnn_load_w_fc1(weight_fc1, w_fc1);
    cnn_load_b_fc1(bias_fc1, b_fc1);
    cnn_load_w_fc2(weight_fc2, w_fc2);
    cnn_load_b_fc2(bias_fc2, b_fc2);
    // (heewon) One dataflow region covers all layers, no activation DDR.
    cnn_pipeline(
        input,
        w1_1, b1_1,
        w1_2, b1_2,
        w2_1, b2_1,
        w2_2, b2_2,
        w3_1, b3_1,
        w3_2, b3_2,
        w_fc1, b_fc1, w_fc2, b_fc2, logits,
        shift1_1, shift1_2, shift2_1, shift2_2, shift3_1, shift3_2, shift_fc1);
}
