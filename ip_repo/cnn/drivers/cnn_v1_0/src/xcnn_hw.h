// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2024.1 (64-bit)
// Tool Version Limit: 2024.05
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
// control
// 0x000 : Control signals
//         bit 0  - ap_start (Read/Write/COH)
//         bit 1  - ap_done (Read/COR)
//         bit 2  - ap_idle (Read)
//         bit 3  - ap_ready (Read/COR)
//         bit 7  - auto_restart (Read/Write)
//         bit 9  - interrupt (Read)
//         others - reserved
// 0x004 : Global Interrupt Enable Register
//         bit 0  - Global Interrupt Enable (Read/Write)
//         others - reserved
// 0x008 : IP Interrupt Enable Register (Read/Write)
//         bit 0 - enable ap_done interrupt (Read/Write)
//         bit 1 - enable ap_ready interrupt (Read/Write)
//         others - reserved
// 0x00c : IP Interrupt Status Register (Read/TOW)
//         bit 0 - ap_done (Read/TOW)
//         bit 1 - ap_ready (Read/TOW)
//         others - reserved
// 0x010 : Data signal of input_r
//         bit 31~0 - input_r[31:0] (Read/Write)
// 0x014 : Data signal of input_r
//         bit 31~0 - input_r[63:32] (Read/Write)
// 0x018 : reserved
// 0x01c : Data signal of weight1_1
//         bit 31~0 - weight1_1[31:0] (Read/Write)
// 0x020 : Data signal of weight1_1
//         bit 31~0 - weight1_1[63:32] (Read/Write)
// 0x024 : reserved
// 0x028 : Data signal of bias1_1
//         bit 31~0 - bias1_1[31:0] (Read/Write)
// 0x02c : Data signal of bias1_1
//         bit 31~0 - bias1_1[63:32] (Read/Write)
// 0x030 : reserved
// 0x034 : Data signal of weight1_2
//         bit 31~0 - weight1_2[31:0] (Read/Write)
// 0x038 : Data signal of weight1_2
//         bit 31~0 - weight1_2[63:32] (Read/Write)
// 0x03c : reserved
// 0x040 : Data signal of bias1_2
//         bit 31~0 - bias1_2[31:0] (Read/Write)
// 0x044 : Data signal of bias1_2
//         bit 31~0 - bias1_2[63:32] (Read/Write)
// 0x048 : reserved
// 0x04c : Data signal of weight2_1
//         bit 31~0 - weight2_1[31:0] (Read/Write)
// 0x050 : Data signal of weight2_1
//         bit 31~0 - weight2_1[63:32] (Read/Write)
// 0x054 : reserved
// 0x058 : Data signal of bias2_1
//         bit 31~0 - bias2_1[31:0] (Read/Write)
// 0x05c : Data signal of bias2_1
//         bit 31~0 - bias2_1[63:32] (Read/Write)
// 0x060 : reserved
// 0x064 : Data signal of weight2_2
//         bit 31~0 - weight2_2[31:0] (Read/Write)
// 0x068 : Data signal of weight2_2
//         bit 31~0 - weight2_2[63:32] (Read/Write)
// 0x06c : reserved
// 0x070 : Data signal of bias2_2
//         bit 31~0 - bias2_2[31:0] (Read/Write)
// 0x074 : Data signal of bias2_2
//         bit 31~0 - bias2_2[63:32] (Read/Write)
// 0x078 : reserved
// 0x07c : Data signal of weight3_1
//         bit 31~0 - weight3_1[31:0] (Read/Write)
// 0x080 : Data signal of weight3_1
//         bit 31~0 - weight3_1[63:32] (Read/Write)
// 0x084 : reserved
// 0x088 : Data signal of bias3_1
//         bit 31~0 - bias3_1[31:0] (Read/Write)
// 0x08c : Data signal of bias3_1
//         bit 31~0 - bias3_1[63:32] (Read/Write)
// 0x090 : reserved
// 0x094 : Data signal of weight3_2
//         bit 31~0 - weight3_2[31:0] (Read/Write)
// 0x098 : Data signal of weight3_2
//         bit 31~0 - weight3_2[63:32] (Read/Write)
// 0x09c : reserved
// 0x0a0 : Data signal of bias3_2
//         bit 31~0 - bias3_2[31:0] (Read/Write)
// 0x0a4 : Data signal of bias3_2
//         bit 31~0 - bias3_2[63:32] (Read/Write)
// 0x0a8 : reserved
// 0x0ac : Data signal of weight_fc1
//         bit 31~0 - weight_fc1[31:0] (Read/Write)
// 0x0b0 : Data signal of weight_fc1
//         bit 31~0 - weight_fc1[63:32] (Read/Write)
// 0x0b4 : reserved
// 0x0b8 : Data signal of bias_fc1
//         bit 31~0 - bias_fc1[31:0] (Read/Write)
// 0x0bc : Data signal of bias_fc1
//         bit 31~0 - bias_fc1[63:32] (Read/Write)
// 0x0c0 : reserved
// 0x0c4 : Data signal of weight_fc2
//         bit 31~0 - weight_fc2[31:0] (Read/Write)
// 0x0c8 : Data signal of weight_fc2
//         bit 31~0 - weight_fc2[63:32] (Read/Write)
// 0x0cc : reserved
// 0x0d0 : Data signal of bias_fc2
//         bit 31~0 - bias_fc2[31:0] (Read/Write)
// 0x0d4 : Data signal of bias_fc2
//         bit 31~0 - bias_fc2[63:32] (Read/Write)
// 0x0d8 : reserved
// 0x0dc : Data signal of logits
//         bit 31~0 - logits[31:0] (Read/Write)
// 0x0e0 : Data signal of logits
//         bit 31~0 - logits[63:32] (Read/Write)
// 0x0e4 : reserved
// 0x0e8 : Data signal of shift1_1
//         bit 31~0 - shift1_1[31:0] (Read/Write)
// 0x0ec : reserved
// 0x0f0 : Data signal of shift1_2
//         bit 31~0 - shift1_2[31:0] (Read/Write)
// 0x0f4 : reserved
// 0x0f8 : Data signal of shift2_1
//         bit 31~0 - shift2_1[31:0] (Read/Write)
// 0x0fc : reserved
// 0x100 : Data signal of shift2_2
//         bit 31~0 - shift2_2[31:0] (Read/Write)
// 0x104 : reserved
// 0x108 : Data signal of shift3_1
//         bit 31~0 - shift3_1[31:0] (Read/Write)
// 0x10c : reserved
// 0x110 : Data signal of shift3_2
//         bit 31~0 - shift3_2[31:0] (Read/Write)
// 0x114 : reserved
// 0x118 : Data signal of shift_fc1
//         bit 31~0 - shift_fc1[31:0] (Read/Write)
// 0x11c : reserved
// (SC = Self Clear, COR = Clear on Read, TOW = Toggle on Write, COH = Clear on Handshake)

#define XCNN_CONTROL_ADDR_AP_CTRL         0x000
#define XCNN_CONTROL_ADDR_GIE             0x004
#define XCNN_CONTROL_ADDR_IER             0x008
#define XCNN_CONTROL_ADDR_ISR             0x00c
#define XCNN_CONTROL_ADDR_INPUT_R_DATA    0x010
#define XCNN_CONTROL_BITS_INPUT_R_DATA    64
#define XCNN_CONTROL_ADDR_WEIGHT1_1_DATA  0x01c
#define XCNN_CONTROL_BITS_WEIGHT1_1_DATA  64
#define XCNN_CONTROL_ADDR_BIAS1_1_DATA    0x028
#define XCNN_CONTROL_BITS_BIAS1_1_DATA    64
#define XCNN_CONTROL_ADDR_WEIGHT1_2_DATA  0x034
#define XCNN_CONTROL_BITS_WEIGHT1_2_DATA  64
#define XCNN_CONTROL_ADDR_BIAS1_2_DATA    0x040
#define XCNN_CONTROL_BITS_BIAS1_2_DATA    64
#define XCNN_CONTROL_ADDR_WEIGHT2_1_DATA  0x04c
#define XCNN_CONTROL_BITS_WEIGHT2_1_DATA  64
#define XCNN_CONTROL_ADDR_BIAS2_1_DATA    0x058
#define XCNN_CONTROL_BITS_BIAS2_1_DATA    64
#define XCNN_CONTROL_ADDR_WEIGHT2_2_DATA  0x064
#define XCNN_CONTROL_BITS_WEIGHT2_2_DATA  64
#define XCNN_CONTROL_ADDR_BIAS2_2_DATA    0x070
#define XCNN_CONTROL_BITS_BIAS2_2_DATA    64
#define XCNN_CONTROL_ADDR_WEIGHT3_1_DATA  0x07c
#define XCNN_CONTROL_BITS_WEIGHT3_1_DATA  64
#define XCNN_CONTROL_ADDR_BIAS3_1_DATA    0x088
#define XCNN_CONTROL_BITS_BIAS3_1_DATA    64
#define XCNN_CONTROL_ADDR_WEIGHT3_2_DATA  0x094
#define XCNN_CONTROL_BITS_WEIGHT3_2_DATA  64
#define XCNN_CONTROL_ADDR_BIAS3_2_DATA    0x0a0
#define XCNN_CONTROL_BITS_BIAS3_2_DATA    64
#define XCNN_CONTROL_ADDR_WEIGHT_FC1_DATA 0x0ac
#define XCNN_CONTROL_BITS_WEIGHT_FC1_DATA 64
#define XCNN_CONTROL_ADDR_BIAS_FC1_DATA   0x0b8
#define XCNN_CONTROL_BITS_BIAS_FC1_DATA   64
#define XCNN_CONTROL_ADDR_WEIGHT_FC2_DATA 0x0c4
#define XCNN_CONTROL_BITS_WEIGHT_FC2_DATA 64
#define XCNN_CONTROL_ADDR_BIAS_FC2_DATA   0x0d0
#define XCNN_CONTROL_BITS_BIAS_FC2_DATA   64
#define XCNN_CONTROL_ADDR_LOGITS_DATA     0x0dc
#define XCNN_CONTROL_BITS_LOGITS_DATA     64
#define XCNN_CONTROL_ADDR_SHIFT1_1_DATA   0x0e8
#define XCNN_CONTROL_BITS_SHIFT1_1_DATA   32
#define XCNN_CONTROL_ADDR_SHIFT1_2_DATA   0x0f0
#define XCNN_CONTROL_BITS_SHIFT1_2_DATA   32
#define XCNN_CONTROL_ADDR_SHIFT2_1_DATA   0x0f8
#define XCNN_CONTROL_BITS_SHIFT2_1_DATA   32
#define XCNN_CONTROL_ADDR_SHIFT2_2_DATA   0x100
#define XCNN_CONTROL_BITS_SHIFT2_2_DATA   32
#define XCNN_CONTROL_ADDR_SHIFT3_1_DATA   0x108
#define XCNN_CONTROL_BITS_SHIFT3_1_DATA   32
#define XCNN_CONTROL_ADDR_SHIFT3_2_DATA   0x110
#define XCNN_CONTROL_BITS_SHIFT3_2_DATA   32
#define XCNN_CONTROL_ADDR_SHIFT_FC1_DATA  0x118
#define XCNN_CONTROL_BITS_SHIFT_FC1_DATA  32

