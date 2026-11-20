// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2024.1 (64-bit)
// Tool Version Limit: 2024.05
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
#ifndef XCNN_H
#define XCNN_H

#ifdef __cplusplus
extern "C" {
#endif

/***************************** Include Files *********************************/
#ifndef __linux__
#include "xil_types.h"
#include "xil_assert.h"
#include "xstatus.h"
#include "xil_io.h"
#else
#include <stdint.h>
#include <assert.h>
#include <dirent.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
#include <stddef.h>
#endif
#include "xcnn_hw.h"

/**************************** Type Definitions ******************************/
#ifdef __linux__
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef uint64_t u64;
#else
typedef struct {
#ifdef SDT
    char *Name;
#else
    u16 DeviceId;
#endif
    u64 Control_BaseAddress;
} XCnn_Config;
#endif

typedef struct {
    u64 Control_BaseAddress;
    u32 IsReady;
} XCnn;

typedef u32 word_type;

/***************** Macros (Inline Functions) Definitions *********************/
#ifndef __linux__
#define XCnn_WriteReg(BaseAddress, RegOffset, Data) \
    Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))
#define XCnn_ReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))
#else
#define XCnn_WriteReg(BaseAddress, RegOffset, Data) \
    *(volatile u32*)((BaseAddress) + (RegOffset)) = (u32)(Data)
#define XCnn_ReadReg(BaseAddress, RegOffset) \
    *(volatile u32*)((BaseAddress) + (RegOffset))

#define Xil_AssertVoid(expr)    assert(expr)
#define Xil_AssertNonvoid(expr) assert(expr)

#define XST_SUCCESS             0
#define XST_DEVICE_NOT_FOUND    2
#define XST_OPEN_DEVICE_FAILED  3
#define XIL_COMPONENT_IS_READY  1
#endif

/************************** Function Prototypes *****************************/
#ifndef __linux__
#ifdef SDT
int XCnn_Initialize(XCnn *InstancePtr, UINTPTR BaseAddress);
XCnn_Config* XCnn_LookupConfig(UINTPTR BaseAddress);
#else
int XCnn_Initialize(XCnn *InstancePtr, u16 DeviceId);
XCnn_Config* XCnn_LookupConfig(u16 DeviceId);
#endif
int XCnn_CfgInitialize(XCnn *InstancePtr, XCnn_Config *ConfigPtr);
#else
int XCnn_Initialize(XCnn *InstancePtr, const char* InstanceName);
int XCnn_Release(XCnn *InstancePtr);
#endif

void XCnn_Start(XCnn *InstancePtr);
u32 XCnn_IsDone(XCnn *InstancePtr);
u32 XCnn_IsIdle(XCnn *InstancePtr);
u32 XCnn_IsReady(XCnn *InstancePtr);
void XCnn_EnableAutoRestart(XCnn *InstancePtr);
void XCnn_DisableAutoRestart(XCnn *InstancePtr);

void XCnn_Set_input_r(XCnn *InstancePtr, u64 Data);
u64 XCnn_Get_input_r(XCnn *InstancePtr);
void XCnn_Set_weight1_1(XCnn *InstancePtr, u64 Data);
u64 XCnn_Get_weight1_1(XCnn *InstancePtr);
void XCnn_Set_bias1_1(XCnn *InstancePtr, u64 Data);
u64 XCnn_Get_bias1_1(XCnn *InstancePtr);
void XCnn_Set_weight1_2(XCnn *InstancePtr, u64 Data);
u64 XCnn_Get_weight1_2(XCnn *InstancePtr);
void XCnn_Set_bias1_2(XCnn *InstancePtr, u64 Data);
u64 XCnn_Get_bias1_2(XCnn *InstancePtr);
void XCnn_Set_weight2_1(XCnn *InstancePtr, u64 Data);
u64 XCnn_Get_weight2_1(XCnn *InstancePtr);
void XCnn_Set_bias2_1(XCnn *InstancePtr, u64 Data);
u64 XCnn_Get_bias2_1(XCnn *InstancePtr);
void XCnn_Set_weight2_2(XCnn *InstancePtr, u64 Data);
u64 XCnn_Get_weight2_2(XCnn *InstancePtr);
void XCnn_Set_bias2_2(XCnn *InstancePtr, u64 Data);
u64 XCnn_Get_bias2_2(XCnn *InstancePtr);
void XCnn_Set_weight3_1(XCnn *InstancePtr, u64 Data);
u64 XCnn_Get_weight3_1(XCnn *InstancePtr);
void XCnn_Set_bias3_1(XCnn *InstancePtr, u64 Data);
u64 XCnn_Get_bias3_1(XCnn *InstancePtr);
void XCnn_Set_weight3_2(XCnn *InstancePtr, u64 Data);
u64 XCnn_Get_weight3_2(XCnn *InstancePtr);
void XCnn_Set_bias3_2(XCnn *InstancePtr, u64 Data);
u64 XCnn_Get_bias3_2(XCnn *InstancePtr);
void XCnn_Set_weight_fc1(XCnn *InstancePtr, u64 Data);
u64 XCnn_Get_weight_fc1(XCnn *InstancePtr);
void XCnn_Set_bias_fc1(XCnn *InstancePtr, u64 Data);
u64 XCnn_Get_bias_fc1(XCnn *InstancePtr);
void XCnn_Set_weight_fc2(XCnn *InstancePtr, u64 Data);
u64 XCnn_Get_weight_fc2(XCnn *InstancePtr);
void XCnn_Set_bias_fc2(XCnn *InstancePtr, u64 Data);
u64 XCnn_Get_bias_fc2(XCnn *InstancePtr);
void XCnn_Set_logits(XCnn *InstancePtr, u64 Data);
u64 XCnn_Get_logits(XCnn *InstancePtr);
void XCnn_Set_shift1_1(XCnn *InstancePtr, u32 Data);
u32 XCnn_Get_shift1_1(XCnn *InstancePtr);
void XCnn_Set_shift1_2(XCnn *InstancePtr, u32 Data);
u32 XCnn_Get_shift1_2(XCnn *InstancePtr);
void XCnn_Set_shift2_1(XCnn *InstancePtr, u32 Data);
u32 XCnn_Get_shift2_1(XCnn *InstancePtr);
void XCnn_Set_shift2_2(XCnn *InstancePtr, u32 Data);
u32 XCnn_Get_shift2_2(XCnn *InstancePtr);
void XCnn_Set_shift3_1(XCnn *InstancePtr, u32 Data);
u32 XCnn_Get_shift3_1(XCnn *InstancePtr);
void XCnn_Set_shift3_2(XCnn *InstancePtr, u32 Data);
u32 XCnn_Get_shift3_2(XCnn *InstancePtr);
void XCnn_Set_shift_fc1(XCnn *InstancePtr, u32 Data);
u32 XCnn_Get_shift_fc1(XCnn *InstancePtr);

void XCnn_InterruptGlobalEnable(XCnn *InstancePtr);
void XCnn_InterruptGlobalDisable(XCnn *InstancePtr);
void XCnn_InterruptEnable(XCnn *InstancePtr, u32 Mask);
void XCnn_InterruptDisable(XCnn *InstancePtr, u32 Mask);
void XCnn_InterruptClear(XCnn *InstancePtr, u32 Mask);
u32 XCnn_InterruptGetEnabled(XCnn *InstancePtr);
u32 XCnn_InterruptGetStatus(XCnn *InstancePtr);

#ifdef __cplusplus
}
#endif

#endif
