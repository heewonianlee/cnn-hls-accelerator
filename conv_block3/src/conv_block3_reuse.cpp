#include "conv3_reuse.h"

// (heewon) Standalone 2-phase MAC reuse Block 3.
// Input 100x16x32 -> Conv 32->64 -> Conv 64->64 -> Pool 50x8x64.
//
// Optimization in this version:
//   1) Pack all 9 kernel taps into one 72-bit on-chip weight word.
//   2) Conv3-1 weight banks: 9*16 = 144 -> 16.
//   3) Conv3-2 weight banks: 9*32 = 288 -> 32.
//   4) Store packed weight banks in BRAM instead of LUTRAM.
// External HWIO weight layout is unchanged.

static void conv_block3_reuse_read_input(
    const int8_t input[CONV3_1_INPUT_SIZE],
    hls::stream<int8_t> &pixels)
{
#pragma HLS INLINE off

READ_INPUT:
    for (int i = 0; i < CONV3_1_INPUT_SIZE; ++i) {
#pragma HLS PIPELINE II=1
        pixels.write(input[i]);
    }
}


static void conv_block3_reuse_write_output(
    hls::stream<int8_t> &pixels,
    int8_t output[BLOCK3_OUTPUT_SIZE])
{
#pragma HLS INLINE off

WRITE_OUTPUT:
    for (int i = 0; i < BLOCK3_OUTPUT_SIZE; ++i) {
#pragma HLS PIPELINE II=1
        output[i] = pixels.read();
    }
}


// ----------------------------------------------------------------
// Conv3-1 weight loader
//
// External layout remains:
//   weight1[k][ic][oc] flattened in HWIO order.
//
// Internal layout becomes:
//   w1[lane][phase * OUT_C + oc]
//
// Each internal 72-bit word contains:
//   bits [ 7: 0] = k0
//   bits [15: 8] = k1
//   ...
//   bits [71:64] = k8
// ----------------------------------------------------------------

static void conv_block3_reuse_load_weights3_1(
    const int8_t weight1[CONV3_1_WEIGHT_SIZE],
    conv3_weight9_t w1[16][2 * CONV3_1_OUT_C])
{
#pragma HLS INLINE off

LOAD_W1_K:
    for (int k = 0; k < 9; ++k) {
    LOAD_W1_IC:
        for (int ic = 0; ic < CONV3_1_IN_C; ++ic) {
        LOAD_W1_OC:
            for (int oc = 0; oc < CONV3_1_OUT_C; ++oc) {
#pragma HLS PIPELINE II=1

                const int lane = ic % 16;
                const int phase = ic / 16;
                const int addr =
                    phase * CONV3_1_OUT_C + oc;

                conv3_weight9_t packed = 0;

                // For k>0, preserve the taps already loaded into
                // this packed word. The k-loop itself is sequential.
                if (k != 0) {
                    packed = w1[lane][addr];
                }

                const int src_idx =
                    (k * CONV3_1_IN_C + ic)
                    * CONV3_1_OUT_C + oc;

                packed.range(8 * k + 7, 8 * k) =
                    (ap_uint<8>)((uint8_t)weight1[src_idx]);

                w1[lane][addr] = packed;
            }
        }
    }
}


// ----------------------------------------------------------------
// Conv3-2 weight loader
// Same packing scheme, now with 32 lanes.
// ----------------------------------------------------------------

static void conv_block3_reuse_load_weights3_2(
    const int8_t weight2[CONV3_2_WEIGHT_SIZE],
    conv3_weight9_t w2[32][2 * CONV3_2_OUT_C])
{
#pragma HLS INLINE off

LOAD_W2_K:
    for (int k = 0; k < 9; ++k) {
    LOAD_W2_IC:
        for (int ic = 0; ic < CONV3_2_IN_C; ++ic) {
        LOAD_W2_OC:
            for (int oc = 0; oc < CONV3_2_OUT_C; ++oc) {
#pragma HLS PIPELINE II=1

                const int lane = ic % 32;
                const int phase = ic / 32;
                const int addr =
                    phase * CONV3_2_OUT_C + oc;

                conv3_weight9_t packed = 0;

                if (k != 0) {
                    packed = w2[lane][addr];
                }

                const int src_idx =
                    (k * CONV3_2_IN_C + ic)
                    * CONV3_2_OUT_C + oc;

                packed.range(8 * k + 7, 8 * k) =
                    (ap_uint<8>)((uint8_t)weight2[src_idx]);

                w2[lane][addr] = packed;
            }
        }
    }
}


static void conv_block3_reuse_load_bias3_1(
    const int32_t bias1[CONV3_1_OUT_C],
    int32_t b1[CONV3_1_OUT_C])
{
#pragma HLS INLINE off

LOAD_B1:
    for (int i = 0; i < CONV3_1_OUT_C; ++i) {
#pragma HLS PIPELINE II=1
        b1[i] = bias1[i];
    }
}


static void conv_block3_reuse_load_bias3_2(
    const int32_t bias2[CONV3_2_OUT_C],
    int32_t b2[CONV3_2_OUT_C])
{
#pragma HLS INLINE off

LOAD_B2:
    for (int i = 0; i < CONV3_2_OUT_C; ++i) {
#pragma HLS PIPELINE II=1
        b2[i] = bias2[i];
    }
}


static void conv_block3_reuse_pipeline(
    const int8_t input[CONV3_1_INPUT_SIZE],
    const conv3_weight9_t w1[16][2 * CONV3_1_OUT_C],
    const int32_t b1[CONV3_1_OUT_C],
    const conv3_weight9_t w2[32][2 * CONV3_2_OUT_C],
    const int32_t b2[CONV3_2_OUT_C],
    int8_t output[BLOCK3_OUTPUT_SIZE],
    int shift1,
    int shift2)
{
#pragma HLS INLINE off
#pragma HLS DATAFLOW

    hls::stream<int8_t> input_pixels("input_pixels");
    hls::stream<int8_t> conv3_1_features("conv3_1_features");
    hls::stream<int8_t> conv3_2_features("conv3_2_features");
    hls::stream<int8_t> pooled("pooled");

#pragma HLS STREAM variable=input_pixels depth=64
#pragma HLS STREAM variable=conv3_1_features depth=64
#pragma HLS STREAM variable=conv3_2_features depth=64
#pragma HLS STREAM variable=pooled depth=64

    conv_block3_reuse_read_input(
        input,
        input_pixels
    );

    conv3_1_reuse16(
        input_pixels,
        w1,
        b1,
        conv3_1_features,
        shift1
    );

    conv3_2_reuse32(
        conv3_1_features,
        w2,
        b2,
        conv3_2_features,
        shift2
    );

    maxpool3(
        conv3_2_features,
        pooled
    );

    conv_block3_reuse_write_output(
        pooled,
        output
    );
}


void conv_block3_reuse(
    const int8_t input[CONV3_1_INPUT_SIZE],
    const int8_t weight1[CONV3_1_WEIGHT_SIZE],
    const int32_t bias1[CONV3_1_OUT_C],
    const int8_t weight2[CONV3_2_WEIGHT_SIZE],
    const int32_t bias2[CONV3_2_OUT_C],
    int8_t output[BLOCK3_OUTPUT_SIZE],
    int shift1,
    int shift2)
{
#pragma HLS INTERFACE m_axi port=input   offset=slave bundle=gmem depth=CONV3_1_INPUT_SIZE
#pragma HLS INTERFACE m_axi port=weight1 offset=slave bundle=gmem depth=CONV3_1_WEIGHT_SIZE
#pragma HLS INTERFACE m_axi port=bias1   offset=slave bundle=gmem depth=CONV3_1_OUT_C
#pragma HLS INTERFACE m_axi port=weight2 offset=slave bundle=gmem depth=CONV3_2_WEIGHT_SIZE
#pragma HLS INTERFACE m_axi port=bias2   offset=slave bundle=gmem depth=CONV3_2_OUT_C
#pragma HLS INTERFACE m_axi port=output  offset=slave bundle=gmem depth=BLOCK3_OUTPUT_SIZE

#pragma HLS INTERFACE s_axilite port=input   bundle=control
#pragma HLS INTERFACE s_axilite port=weight1 bundle=control
#pragma HLS INTERFACE s_axilite port=bias1   bundle=control
#pragma HLS INTERFACE s_axilite port=weight2 bundle=control
#pragma HLS INTERFACE s_axilite port=bias2   bundle=control
#pragma HLS INTERFACE s_axilite port=output  bundle=control
#pragma HLS INTERFACE s_axilite port=shift1  bundle=control
#pragma HLS INTERFACE s_axilite port=shift2  bundle=control
#pragma HLS INTERFACE s_axilite port=return  bundle=control

    if (shift1 < 0 || shift1 > 24 ||
        shift2 < 0 || shift2 > 24) {
        return;
    }

    // (heewon) Packed on-chip weights.
    //
    // Conv3-1:
    //   old = 9 x 16 x 128 independent 8-bit memories
    //   new = 16 x 128 memories, each 72 bits wide
    //
    // Conv3-2:
    //   old = 9 x 32 x 128 independent 8-bit memories
    //   new = 32 x 128 memories, each 72 bits wide
    conv3_weight9_t w1[16][2 * CONV3_1_OUT_C];
    conv3_weight9_t w2[32][2 * CONV3_2_OUT_C];

    // One independent wide memory per MAC lane.
#pragma HLS ARRAY_PARTITION variable=w1 complete dim=1
#pragma HLS ARRAY_PARTITION variable=w2 complete dim=1

    // Move weight storage out of LUTRAM.
    // 72-bit words map naturally to BRAM36-class storage.
#pragma HLS BIND_STORAGE variable=w1 type=ram_s2p impl=bram
#pragma HLS BIND_STORAGE variable=w2 type=ram_s2p impl=bram

    int32_t b1[CONV3_1_OUT_C];
    int32_t b2[CONV3_2_OUT_C];

    conv_block3_reuse_load_weights3_1(
        weight1,
        w1
    );

    conv_block3_reuse_load_bias3_1(
        bias1,
        b1
    );

    conv_block3_reuse_load_weights3_2(
        weight2,
        w2
    );

    conv_block3_reuse_load_bias3_2(
        bias2,
        b2
    );

    conv_block3_reuse_pipeline(
        input,
        w1,
        b1,
        w2,
        b2,
        output,
        shift1,
        shift2
    );
}
