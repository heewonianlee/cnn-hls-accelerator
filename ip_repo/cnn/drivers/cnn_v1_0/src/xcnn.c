// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2024.1 (64-bit)
// Tool Version Limit: 2024.05
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
/***************************** Include Files *********************************/
#include "xcnn.h"

/************************** Function Implementation *************************/
#ifndef __linux__
int XCnn_CfgInitialize(XCnn *InstancePtr, XCnn_Config *ConfigPtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(ConfigPtr != NULL);

    InstancePtr->Control_BaseAddress = ConfigPtr->Control_BaseAddress;
    InstancePtr->IsReady = XIL_COMPONENT_IS_READY;

    return XST_SUCCESS;
}
#endif

void XCnn_Start(XCnn *InstancePtr) {
    u32 Data;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XCnn_ReadReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_AP_CTRL) & 0x80;
    XCnn_WriteReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_AP_CTRL, Data | 0x01);
}

u32 XCnn_IsDone(XCnn *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XCnn_ReadReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_AP_CTRL);
    return (Data >> 1) & 0x1;
}

u32 XCnn_IsIdle(XCnn *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XCnn_ReadReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_AP_CTRL);
    return (Data >> 2) & 0x1;
}

u32 XCnn_IsReady(XCnn *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XCnn_ReadReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_AP_CTRL);
    // check ap_start to see if the pcore is ready for next input
    return !(Data & 0x1);
}

void XCnn_EnableAutoRestart(XCnn *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XCnn_WriteReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_AP_CTRL, 0x80);
}

void XCnn_DisableAutoRestart(XCnn *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XCnn_WriteReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_AP_CTRL, 0);
}

void XCnn_Set_input_r(XCnn *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XCnn_WriteReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_INPUT_R_DATA, (u32)(Data));
    XCnn_WriteReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_INPUT_R_DATA + 4, (u32)(Data >> 32));
}

u64 XCnn_Get_input_r(XCnn *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XCnn_ReadReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_INPUT_R_DATA);
    Data += (u64)XCnn_ReadReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_INPUT_R_DATA + 4) << 32;
    return Data;
}

void XCnn_Set_weight1_1(XCnn *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XCnn_WriteReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_WEIGHT1_1_DATA, (u32)(Data));
    XCnn_WriteReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_WEIGHT1_1_DATA + 4, (u32)(Data >> 32));
}

u64 XCnn_Get_weight1_1(XCnn *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XCnn_ReadReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_WEIGHT1_1_DATA);
    Data += (u64)XCnn_ReadReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_WEIGHT1_1_DATA + 4) << 32;
    return Data;
}

void XCnn_Set_bias1_1(XCnn *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XCnn_WriteReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_BIAS1_1_DATA, (u32)(Data));
    XCnn_WriteReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_BIAS1_1_DATA + 4, (u32)(Data >> 32));
}

u64 XCnn_Get_bias1_1(XCnn *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XCnn_ReadReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_BIAS1_1_DATA);
    Data += (u64)XCnn_ReadReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_BIAS1_1_DATA + 4) << 32;
    return Data;
}

void XCnn_Set_weight1_2(XCnn *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XCnn_WriteReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_WEIGHT1_2_DATA, (u32)(Data));
    XCnn_WriteReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_WEIGHT1_2_DATA + 4, (u32)(Data >> 32));
}

u64 XCnn_Get_weight1_2(XCnn *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XCnn_ReadReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_WEIGHT1_2_DATA);
    Data += (u64)XCnn_ReadReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_WEIGHT1_2_DATA + 4) << 32;
    return Data;
}

void XCnn_Set_bias1_2(XCnn *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XCnn_WriteReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_BIAS1_2_DATA, (u32)(Data));
    XCnn_WriteReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_BIAS1_2_DATA + 4, (u32)(Data >> 32));
}

u64 XCnn_Get_bias1_2(XCnn *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XCnn_ReadReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_BIAS1_2_DATA);
    Data += (u64)XCnn_ReadReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_BIAS1_2_DATA + 4) << 32;
    return Data;
}

void XCnn_Set_weight2_1(XCnn *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XCnn_WriteReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_WEIGHT2_1_DATA, (u32)(Data));
    XCnn_WriteReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_WEIGHT2_1_DATA + 4, (u32)(Data >> 32));
}

u64 XCnn_Get_weight2_1(XCnn *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XCnn_ReadReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_WEIGHT2_1_DATA);
    Data += (u64)XCnn_ReadReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_WEIGHT2_1_DATA + 4) << 32;
    return Data;
}

void XCnn_Set_bias2_1(XCnn *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XCnn_WriteReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_BIAS2_1_DATA, (u32)(Data));
    XCnn_WriteReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_BIAS2_1_DATA + 4, (u32)(Data >> 32));
}

u64 XCnn_Get_bias2_1(XCnn *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XCnn_ReadReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_BIAS2_1_DATA);
    Data += (u64)XCnn_ReadReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_BIAS2_1_DATA + 4) << 32;
    return Data;
}

void XCnn_Set_weight2_2(XCnn *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XCnn_WriteReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_WEIGHT2_2_DATA, (u32)(Data));
    XCnn_WriteReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_WEIGHT2_2_DATA + 4, (u32)(Data >> 32));
}

u64 XCnn_Get_weight2_2(XCnn *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XCnn_ReadReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_WEIGHT2_2_DATA);
    Data += (u64)XCnn_ReadReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_WEIGHT2_2_DATA + 4) << 32;
    return Data;
}

void XCnn_Set_bias2_2(XCnn *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XCnn_WriteReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_BIAS2_2_DATA, (u32)(Data));
    XCnn_WriteReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_BIAS2_2_DATA + 4, (u32)(Data >> 32));
}

u64 XCnn_Get_bias2_2(XCnn *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XCnn_ReadReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_BIAS2_2_DATA);
    Data += (u64)XCnn_ReadReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_BIAS2_2_DATA + 4) << 32;
    return Data;
}

void XCnn_Set_weight3_1(XCnn *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XCnn_WriteReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_WEIGHT3_1_DATA, (u32)(Data));
    XCnn_WriteReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_WEIGHT3_1_DATA + 4, (u32)(Data >> 32));
}

u64 XCnn_Get_weight3_1(XCnn *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XCnn_ReadReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_WEIGHT3_1_DATA);
    Data += (u64)XCnn_ReadReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_WEIGHT3_1_DATA + 4) << 32;
    return Data;
}

void XCnn_Set_bias3_1(XCnn *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XCnn_WriteReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_BIAS3_1_DATA, (u32)(Data));
    XCnn_WriteReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_BIAS3_1_DATA + 4, (u32)(Data >> 32));
}

u64 XCnn_Get_bias3_1(XCnn *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XCnn_ReadReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_BIAS3_1_DATA);
    Data += (u64)XCnn_ReadReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_BIAS3_1_DATA + 4) << 32;
    return Data;
}

void XCnn_Set_weight3_2(XCnn *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XCnn_WriteReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_WEIGHT3_2_DATA, (u32)(Data));
    XCnn_WriteReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_WEIGHT3_2_DATA + 4, (u32)(Data >> 32));
}

u64 XCnn_Get_weight3_2(XCnn *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XCnn_ReadReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_WEIGHT3_2_DATA);
    Data += (u64)XCnn_ReadReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_WEIGHT3_2_DATA + 4) << 32;
    return Data;
}

void XCnn_Set_bias3_2(XCnn *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XCnn_WriteReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_BIAS3_2_DATA, (u32)(Data));
    XCnn_WriteReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_BIAS3_2_DATA + 4, (u32)(Data >> 32));
}

u64 XCnn_Get_bias3_2(XCnn *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XCnn_ReadReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_BIAS3_2_DATA);
    Data += (u64)XCnn_ReadReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_BIAS3_2_DATA + 4) << 32;
    return Data;
}

void XCnn_Set_weight_fc1(XCnn *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XCnn_WriteReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_WEIGHT_FC1_DATA, (u32)(Data));
    XCnn_WriteReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_WEIGHT_FC1_DATA + 4, (u32)(Data >> 32));
}

u64 XCnn_Get_weight_fc1(XCnn *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XCnn_ReadReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_WEIGHT_FC1_DATA);
    Data += (u64)XCnn_ReadReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_WEIGHT_FC1_DATA + 4) << 32;
    return Data;
}

void XCnn_Set_bias_fc1(XCnn *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XCnn_WriteReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_BIAS_FC1_DATA, (u32)(Data));
    XCnn_WriteReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_BIAS_FC1_DATA + 4, (u32)(Data >> 32));
}

u64 XCnn_Get_bias_fc1(XCnn *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XCnn_ReadReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_BIAS_FC1_DATA);
    Data += (u64)XCnn_ReadReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_BIAS_FC1_DATA + 4) << 32;
    return Data;
}

void XCnn_Set_weight_fc2(XCnn *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XCnn_WriteReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_WEIGHT_FC2_DATA, (u32)(Data));
    XCnn_WriteReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_WEIGHT_FC2_DATA + 4, (u32)(Data >> 32));
}

u64 XCnn_Get_weight_fc2(XCnn *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XCnn_ReadReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_WEIGHT_FC2_DATA);
    Data += (u64)XCnn_ReadReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_WEIGHT_FC2_DATA + 4) << 32;
    return Data;
}

void XCnn_Set_bias_fc2(XCnn *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XCnn_WriteReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_BIAS_FC2_DATA, (u32)(Data));
    XCnn_WriteReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_BIAS_FC2_DATA + 4, (u32)(Data >> 32));
}

u64 XCnn_Get_bias_fc2(XCnn *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XCnn_ReadReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_BIAS_FC2_DATA);
    Data += (u64)XCnn_ReadReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_BIAS_FC2_DATA + 4) << 32;
    return Data;
}

void XCnn_Set_logits(XCnn *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XCnn_WriteReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_LOGITS_DATA, (u32)(Data));
    XCnn_WriteReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_LOGITS_DATA + 4, (u32)(Data >> 32));
}

u64 XCnn_Get_logits(XCnn *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XCnn_ReadReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_LOGITS_DATA);
    Data += (u64)XCnn_ReadReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_LOGITS_DATA + 4) << 32;
    return Data;
}

void XCnn_Set_shift1_1(XCnn *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XCnn_WriteReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_SHIFT1_1_DATA, Data);
}

u32 XCnn_Get_shift1_1(XCnn *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XCnn_ReadReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_SHIFT1_1_DATA);
    return Data;
}

void XCnn_Set_shift1_2(XCnn *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XCnn_WriteReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_SHIFT1_2_DATA, Data);
}

u32 XCnn_Get_shift1_2(XCnn *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XCnn_ReadReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_SHIFT1_2_DATA);
    return Data;
}

void XCnn_Set_shift2_1(XCnn *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XCnn_WriteReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_SHIFT2_1_DATA, Data);
}

u32 XCnn_Get_shift2_1(XCnn *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XCnn_ReadReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_SHIFT2_1_DATA);
    return Data;
}

void XCnn_Set_shift2_2(XCnn *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XCnn_WriteReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_SHIFT2_2_DATA, Data);
}

u32 XCnn_Get_shift2_2(XCnn *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XCnn_ReadReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_SHIFT2_2_DATA);
    return Data;
}

void XCnn_Set_shift3_1(XCnn *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XCnn_WriteReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_SHIFT3_1_DATA, Data);
}

u32 XCnn_Get_shift3_1(XCnn *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XCnn_ReadReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_SHIFT3_1_DATA);
    return Data;
}

void XCnn_Set_shift3_2(XCnn *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XCnn_WriteReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_SHIFT3_2_DATA, Data);
}

u32 XCnn_Get_shift3_2(XCnn *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XCnn_ReadReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_SHIFT3_2_DATA);
    return Data;
}

void XCnn_Set_shift_fc1(XCnn *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XCnn_WriteReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_SHIFT_FC1_DATA, Data);
}

u32 XCnn_Get_shift_fc1(XCnn *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XCnn_ReadReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_SHIFT_FC1_DATA);
    return Data;
}

void XCnn_InterruptGlobalEnable(XCnn *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XCnn_WriteReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_GIE, 1);
}

void XCnn_InterruptGlobalDisable(XCnn *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XCnn_WriteReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_GIE, 0);
}

void XCnn_InterruptEnable(XCnn *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XCnn_ReadReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_IER);
    XCnn_WriteReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_IER, Register | Mask);
}

void XCnn_InterruptDisable(XCnn *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XCnn_ReadReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_IER);
    XCnn_WriteReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_IER, Register & (~Mask));
}

void XCnn_InterruptClear(XCnn *InstancePtr, u32 Mask) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XCnn_WriteReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_ISR, Mask);
}

u32 XCnn_InterruptGetEnabled(XCnn *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XCnn_ReadReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_IER);
}

u32 XCnn_InterruptGetStatus(XCnn *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XCnn_ReadReg(InstancePtr->Control_BaseAddress, XCNN_CONTROL_ADDR_ISR);
}

