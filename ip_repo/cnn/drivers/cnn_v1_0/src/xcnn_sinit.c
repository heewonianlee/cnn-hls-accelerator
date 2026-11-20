// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2024.1 (64-bit)
// Tool Version Limit: 2024.05
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
#ifndef __linux__

#include "xstatus.h"
#ifdef SDT
#include "xparameters.h"
#endif
#include "xcnn.h"

extern XCnn_Config XCnn_ConfigTable[];

#ifdef SDT
XCnn_Config *XCnn_LookupConfig(UINTPTR BaseAddress) {
	XCnn_Config *ConfigPtr = NULL;

	int Index;

	for (Index = (u32)0x0; XCnn_ConfigTable[Index].Name != NULL; Index++) {
		if (!BaseAddress || XCnn_ConfigTable[Index].Control_BaseAddress == BaseAddress) {
			ConfigPtr = &XCnn_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XCnn_Initialize(XCnn *InstancePtr, UINTPTR BaseAddress) {
	XCnn_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XCnn_LookupConfig(BaseAddress);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XCnn_CfgInitialize(InstancePtr, ConfigPtr);
}
#else
XCnn_Config *XCnn_LookupConfig(u16 DeviceId) {
	XCnn_Config *ConfigPtr = NULL;

	int Index;

	for (Index = 0; Index < XPAR_XCNN_NUM_INSTANCES; Index++) {
		if (XCnn_ConfigTable[Index].DeviceId == DeviceId) {
			ConfigPtr = &XCnn_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XCnn_Initialize(XCnn *InstancePtr, u16 DeviceId) {
	XCnn_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XCnn_LookupConfig(DeviceId);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XCnn_CfgInitialize(InstancePtr, ConfigPtr);
}
#endif

#endif

