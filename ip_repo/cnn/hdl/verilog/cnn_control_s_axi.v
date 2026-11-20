// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2024.1 (64-bit)
// Tool Version Limit: 2024.05
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
`timescale 1ns/1ps
module cnn_control_s_axi
#(parameter
    C_S_AXI_ADDR_WIDTH = 9,
    C_S_AXI_DATA_WIDTH = 32
)(
    input  wire                          ACLK,
    input  wire                          ARESET,
    input  wire                          ACLK_EN,
    input  wire [C_S_AXI_ADDR_WIDTH-1:0] AWADDR,
    input  wire                          AWVALID,
    output wire                          AWREADY,
    input  wire [C_S_AXI_DATA_WIDTH-1:0] WDATA,
    input  wire [C_S_AXI_DATA_WIDTH/8-1:0] WSTRB,
    input  wire                          WVALID,
    output wire                          WREADY,
    output wire [1:0]                    BRESP,
    output wire                          BVALID,
    input  wire                          BREADY,
    input  wire [C_S_AXI_ADDR_WIDTH-1:0] ARADDR,
    input  wire                          ARVALID,
    output wire                          ARREADY,
    output wire [C_S_AXI_DATA_WIDTH-1:0] RDATA,
    output wire [1:0]                    RRESP,
    output wire                          RVALID,
    input  wire                          RREADY,
    output wire                          interrupt,
    output wire [63:0]                   input_r,
    output wire [63:0]                   weight1_1,
    output wire [63:0]                   bias1_1,
    output wire [63:0]                   weight1_2,
    output wire [63:0]                   bias1_2,
    output wire [63:0]                   weight2_1,
    output wire [63:0]                   bias2_1,
    output wire [63:0]                   weight2_2,
    output wire [63:0]                   bias2_2,
    output wire [63:0]                   weight3_1,
    output wire [63:0]                   bias3_1,
    output wire [63:0]                   weight3_2,
    output wire [63:0]                   bias3_2,
    output wire [63:0]                   weight_fc1,
    output wire [63:0]                   bias_fc1,
    output wire [63:0]                   weight_fc2,
    output wire [63:0]                   bias_fc2,
    output wire [63:0]                   logits,
    output wire [31:0]                   shift1_1,
    output wire [31:0]                   shift1_2,
    output wire [31:0]                   shift2_1,
    output wire [31:0]                   shift2_2,
    output wire [31:0]                   shift3_1,
    output wire [31:0]                   shift3_2,
    output wire [31:0]                   shift_fc1,
    output wire                          ap_start,
    input  wire                          ap_done,
    input  wire                          ap_ready,
    input  wire                          ap_idle
);
//------------------------Address Info-------------------
// Protocol Used: ap_ctrl_hs
//
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

//------------------------Parameter----------------------
localparam
    ADDR_AP_CTRL           = 9'h000,
    ADDR_GIE               = 9'h004,
    ADDR_IER               = 9'h008,
    ADDR_ISR               = 9'h00c,
    ADDR_INPUT_R_DATA_0    = 9'h010,
    ADDR_INPUT_R_DATA_1    = 9'h014,
    ADDR_INPUT_R_CTRL      = 9'h018,
    ADDR_WEIGHT1_1_DATA_0  = 9'h01c,
    ADDR_WEIGHT1_1_DATA_1  = 9'h020,
    ADDR_WEIGHT1_1_CTRL    = 9'h024,
    ADDR_BIAS1_1_DATA_0    = 9'h028,
    ADDR_BIAS1_1_DATA_1    = 9'h02c,
    ADDR_BIAS1_1_CTRL      = 9'h030,
    ADDR_WEIGHT1_2_DATA_0  = 9'h034,
    ADDR_WEIGHT1_2_DATA_1  = 9'h038,
    ADDR_WEIGHT1_2_CTRL    = 9'h03c,
    ADDR_BIAS1_2_DATA_0    = 9'h040,
    ADDR_BIAS1_2_DATA_1    = 9'h044,
    ADDR_BIAS1_2_CTRL      = 9'h048,
    ADDR_WEIGHT2_1_DATA_0  = 9'h04c,
    ADDR_WEIGHT2_1_DATA_1  = 9'h050,
    ADDR_WEIGHT2_1_CTRL    = 9'h054,
    ADDR_BIAS2_1_DATA_0    = 9'h058,
    ADDR_BIAS2_1_DATA_1    = 9'h05c,
    ADDR_BIAS2_1_CTRL      = 9'h060,
    ADDR_WEIGHT2_2_DATA_0  = 9'h064,
    ADDR_WEIGHT2_2_DATA_1  = 9'h068,
    ADDR_WEIGHT2_2_CTRL    = 9'h06c,
    ADDR_BIAS2_2_DATA_0    = 9'h070,
    ADDR_BIAS2_2_DATA_1    = 9'h074,
    ADDR_BIAS2_2_CTRL      = 9'h078,
    ADDR_WEIGHT3_1_DATA_0  = 9'h07c,
    ADDR_WEIGHT3_1_DATA_1  = 9'h080,
    ADDR_WEIGHT3_1_CTRL    = 9'h084,
    ADDR_BIAS3_1_DATA_0    = 9'h088,
    ADDR_BIAS3_1_DATA_1    = 9'h08c,
    ADDR_BIAS3_1_CTRL      = 9'h090,
    ADDR_WEIGHT3_2_DATA_0  = 9'h094,
    ADDR_WEIGHT3_2_DATA_1  = 9'h098,
    ADDR_WEIGHT3_2_CTRL    = 9'h09c,
    ADDR_BIAS3_2_DATA_0    = 9'h0a0,
    ADDR_BIAS3_2_DATA_1    = 9'h0a4,
    ADDR_BIAS3_2_CTRL      = 9'h0a8,
    ADDR_WEIGHT_FC1_DATA_0 = 9'h0ac,
    ADDR_WEIGHT_FC1_DATA_1 = 9'h0b0,
    ADDR_WEIGHT_FC1_CTRL   = 9'h0b4,
    ADDR_BIAS_FC1_DATA_0   = 9'h0b8,
    ADDR_BIAS_FC1_DATA_1   = 9'h0bc,
    ADDR_BIAS_FC1_CTRL     = 9'h0c0,
    ADDR_WEIGHT_FC2_DATA_0 = 9'h0c4,
    ADDR_WEIGHT_FC2_DATA_1 = 9'h0c8,
    ADDR_WEIGHT_FC2_CTRL   = 9'h0cc,
    ADDR_BIAS_FC2_DATA_0   = 9'h0d0,
    ADDR_BIAS_FC2_DATA_1   = 9'h0d4,
    ADDR_BIAS_FC2_CTRL     = 9'h0d8,
    ADDR_LOGITS_DATA_0     = 9'h0dc,
    ADDR_LOGITS_DATA_1     = 9'h0e0,
    ADDR_LOGITS_CTRL       = 9'h0e4,
    ADDR_SHIFT1_1_DATA_0   = 9'h0e8,
    ADDR_SHIFT1_1_CTRL     = 9'h0ec,
    ADDR_SHIFT1_2_DATA_0   = 9'h0f0,
    ADDR_SHIFT1_2_CTRL     = 9'h0f4,
    ADDR_SHIFT2_1_DATA_0   = 9'h0f8,
    ADDR_SHIFT2_1_CTRL     = 9'h0fc,
    ADDR_SHIFT2_2_DATA_0   = 9'h100,
    ADDR_SHIFT2_2_CTRL     = 9'h104,
    ADDR_SHIFT3_1_DATA_0   = 9'h108,
    ADDR_SHIFT3_1_CTRL     = 9'h10c,
    ADDR_SHIFT3_2_DATA_0   = 9'h110,
    ADDR_SHIFT3_2_CTRL     = 9'h114,
    ADDR_SHIFT_FC1_DATA_0  = 9'h118,
    ADDR_SHIFT_FC1_CTRL    = 9'h11c,
    WRIDLE                 = 2'd0,
    WRDATA                 = 2'd1,
    WRRESP                 = 2'd2,
    WRRESET                = 2'd3,
    RDIDLE                 = 2'd0,
    RDDATA                 = 2'd1,
    RDRESET                = 2'd2,
    ADDR_BITS                = 9;

//------------------------Local signal-------------------
    reg  [1:0]                    wstate = WRRESET;
    reg  [1:0]                    wnext;
    reg  [ADDR_BITS-1:0]          waddr;
    wire [C_S_AXI_DATA_WIDTH-1:0] wmask;
    wire                          aw_hs;
    wire                          w_hs;
    reg  [1:0]                    rstate = RDRESET;
    reg  [1:0]                    rnext;
    reg  [C_S_AXI_DATA_WIDTH-1:0] rdata;
    wire                          ar_hs;
    wire [ADDR_BITS-1:0]          raddr;
    // internal registers
    reg                           int_ap_idle = 1'b0;
    reg                           int_ap_ready = 1'b0;
    wire                          task_ap_ready;
    reg                           int_ap_done = 1'b0;
    wire                          task_ap_done;
    reg                           int_task_ap_done = 1'b0;
    reg                           int_ap_start = 1'b0;
    reg                           int_interrupt = 1'b0;
    reg                           int_auto_restart = 1'b0;
    reg                           auto_restart_status = 1'b0;
    wire                          auto_restart_done;
    reg                           int_gie = 1'b0;
    reg  [1:0]                    int_ier = 2'b0;
    reg  [1:0]                    int_isr = 2'b0;
    reg  [63:0]                   int_input_r = 'b0;
    reg  [63:0]                   int_weight1_1 = 'b0;
    reg  [63:0]                   int_bias1_1 = 'b0;
    reg  [63:0]                   int_weight1_2 = 'b0;
    reg  [63:0]                   int_bias1_2 = 'b0;
    reg  [63:0]                   int_weight2_1 = 'b0;
    reg  [63:0]                   int_bias2_1 = 'b0;
    reg  [63:0]                   int_weight2_2 = 'b0;
    reg  [63:0]                   int_bias2_2 = 'b0;
    reg  [63:0]                   int_weight3_1 = 'b0;
    reg  [63:0]                   int_bias3_1 = 'b0;
    reg  [63:0]                   int_weight3_2 = 'b0;
    reg  [63:0]                   int_bias3_2 = 'b0;
    reg  [63:0]                   int_weight_fc1 = 'b0;
    reg  [63:0]                   int_bias_fc1 = 'b0;
    reg  [63:0]                   int_weight_fc2 = 'b0;
    reg  [63:0]                   int_bias_fc2 = 'b0;
    reg  [63:0]                   int_logits = 'b0;
    reg  [31:0]                   int_shift1_1 = 'b0;
    reg  [31:0]                   int_shift1_2 = 'b0;
    reg  [31:0]                   int_shift2_1 = 'b0;
    reg  [31:0]                   int_shift2_2 = 'b0;
    reg  [31:0]                   int_shift3_1 = 'b0;
    reg  [31:0]                   int_shift3_2 = 'b0;
    reg  [31:0]                   int_shift_fc1 = 'b0;

//------------------------Instantiation------------------


//------------------------AXI write fsm------------------
assign AWREADY = (wstate == WRIDLE);
assign WREADY  = (wstate == WRDATA);
assign BRESP   = 2'b00;  // OKAY
assign BVALID  = (wstate == WRRESP);
assign wmask   = { {8{WSTRB[3]}}, {8{WSTRB[2]}}, {8{WSTRB[1]}}, {8{WSTRB[0]}} };
assign aw_hs   = AWVALID & AWREADY;
assign w_hs    = WVALID & WREADY;

// wstate
always @(posedge ACLK) begin
    if (ARESET)
        wstate <= WRRESET;
    else if (ACLK_EN)
        wstate <= wnext;
end

// wnext
always @(*) begin
    case (wstate)
        WRIDLE:
            if (AWVALID)
                wnext = WRDATA;
            else
                wnext = WRIDLE;
        WRDATA:
            if (WVALID)
                wnext = WRRESP;
            else
                wnext = WRDATA;
        WRRESP:
            if (BREADY)
                wnext = WRIDLE;
            else
                wnext = WRRESP;
        default:
            wnext = WRIDLE;
    endcase
end

// waddr
always @(posedge ACLK) begin
    if (ACLK_EN) begin
        if (aw_hs)
            waddr <= {AWADDR[ADDR_BITS-1:2], {2{1'b0}}};
    end
end

//------------------------AXI read fsm-------------------
assign ARREADY = (rstate == RDIDLE);
assign RDATA   = rdata;
assign RRESP   = 2'b00;  // OKAY
assign RVALID  = (rstate == RDDATA);
assign ar_hs   = ARVALID & ARREADY;
assign raddr   = ARADDR[ADDR_BITS-1:0];

// rstate
always @(posedge ACLK) begin
    if (ARESET)
        rstate <= RDRESET;
    else if (ACLK_EN)
        rstate <= rnext;
end

// rnext
always @(*) begin
    case (rstate)
        RDIDLE:
            if (ARVALID)
                rnext = RDDATA;
            else
                rnext = RDIDLE;
        RDDATA:
            if (RREADY & RVALID)
                rnext = RDIDLE;
            else
                rnext = RDDATA;
        default:
            rnext = RDIDLE;
    endcase
end

// rdata
always @(posedge ACLK) begin
    if (ACLK_EN) begin
        if (ar_hs) begin
            rdata <= 'b0;
            case (raddr)
                ADDR_AP_CTRL: begin
                    rdata[0] <= int_ap_start;
                    rdata[1] <= int_task_ap_done;
                    rdata[2] <= int_ap_idle;
                    rdata[3] <= int_ap_ready;
                    rdata[7] <= int_auto_restart;
                    rdata[9] <= int_interrupt;
                end
                ADDR_GIE: begin
                    rdata <= int_gie;
                end
                ADDR_IER: begin
                    rdata <= int_ier;
                end
                ADDR_ISR: begin
                    rdata <= int_isr;
                end
                ADDR_INPUT_R_DATA_0: begin
                    rdata <= int_input_r[31:0];
                end
                ADDR_INPUT_R_DATA_1: begin
                    rdata <= int_input_r[63:32];
                end
                ADDR_WEIGHT1_1_DATA_0: begin
                    rdata <= int_weight1_1[31:0];
                end
                ADDR_WEIGHT1_1_DATA_1: begin
                    rdata <= int_weight1_1[63:32];
                end
                ADDR_BIAS1_1_DATA_0: begin
                    rdata <= int_bias1_1[31:0];
                end
                ADDR_BIAS1_1_DATA_1: begin
                    rdata <= int_bias1_1[63:32];
                end
                ADDR_WEIGHT1_2_DATA_0: begin
                    rdata <= int_weight1_2[31:0];
                end
                ADDR_WEIGHT1_2_DATA_1: begin
                    rdata <= int_weight1_2[63:32];
                end
                ADDR_BIAS1_2_DATA_0: begin
                    rdata <= int_bias1_2[31:0];
                end
                ADDR_BIAS1_2_DATA_1: begin
                    rdata <= int_bias1_2[63:32];
                end
                ADDR_WEIGHT2_1_DATA_0: begin
                    rdata <= int_weight2_1[31:0];
                end
                ADDR_WEIGHT2_1_DATA_1: begin
                    rdata <= int_weight2_1[63:32];
                end
                ADDR_BIAS2_1_DATA_0: begin
                    rdata <= int_bias2_1[31:0];
                end
                ADDR_BIAS2_1_DATA_1: begin
                    rdata <= int_bias2_1[63:32];
                end
                ADDR_WEIGHT2_2_DATA_0: begin
                    rdata <= int_weight2_2[31:0];
                end
                ADDR_WEIGHT2_2_DATA_1: begin
                    rdata <= int_weight2_2[63:32];
                end
                ADDR_BIAS2_2_DATA_0: begin
                    rdata <= int_bias2_2[31:0];
                end
                ADDR_BIAS2_2_DATA_1: begin
                    rdata <= int_bias2_2[63:32];
                end
                ADDR_WEIGHT3_1_DATA_0: begin
                    rdata <= int_weight3_1[31:0];
                end
                ADDR_WEIGHT3_1_DATA_1: begin
                    rdata <= int_weight3_1[63:32];
                end
                ADDR_BIAS3_1_DATA_0: begin
                    rdata <= int_bias3_1[31:0];
                end
                ADDR_BIAS3_1_DATA_1: begin
                    rdata <= int_bias3_1[63:32];
                end
                ADDR_WEIGHT3_2_DATA_0: begin
                    rdata <= int_weight3_2[31:0];
                end
                ADDR_WEIGHT3_2_DATA_1: begin
                    rdata <= int_weight3_2[63:32];
                end
                ADDR_BIAS3_2_DATA_0: begin
                    rdata <= int_bias3_2[31:0];
                end
                ADDR_BIAS3_2_DATA_1: begin
                    rdata <= int_bias3_2[63:32];
                end
                ADDR_WEIGHT_FC1_DATA_0: begin
                    rdata <= int_weight_fc1[31:0];
                end
                ADDR_WEIGHT_FC1_DATA_1: begin
                    rdata <= int_weight_fc1[63:32];
                end
                ADDR_BIAS_FC1_DATA_0: begin
                    rdata <= int_bias_fc1[31:0];
                end
                ADDR_BIAS_FC1_DATA_1: begin
                    rdata <= int_bias_fc1[63:32];
                end
                ADDR_WEIGHT_FC2_DATA_0: begin
                    rdata <= int_weight_fc2[31:0];
                end
                ADDR_WEIGHT_FC2_DATA_1: begin
                    rdata <= int_weight_fc2[63:32];
                end
                ADDR_BIAS_FC2_DATA_0: begin
                    rdata <= int_bias_fc2[31:0];
                end
                ADDR_BIAS_FC2_DATA_1: begin
                    rdata <= int_bias_fc2[63:32];
                end
                ADDR_LOGITS_DATA_0: begin
                    rdata <= int_logits[31:0];
                end
                ADDR_LOGITS_DATA_1: begin
                    rdata <= int_logits[63:32];
                end
                ADDR_SHIFT1_1_DATA_0: begin
                    rdata <= int_shift1_1[31:0];
                end
                ADDR_SHIFT1_2_DATA_0: begin
                    rdata <= int_shift1_2[31:0];
                end
                ADDR_SHIFT2_1_DATA_0: begin
                    rdata <= int_shift2_1[31:0];
                end
                ADDR_SHIFT2_2_DATA_0: begin
                    rdata <= int_shift2_2[31:0];
                end
                ADDR_SHIFT3_1_DATA_0: begin
                    rdata <= int_shift3_1[31:0];
                end
                ADDR_SHIFT3_2_DATA_0: begin
                    rdata <= int_shift3_2[31:0];
                end
                ADDR_SHIFT_FC1_DATA_0: begin
                    rdata <= int_shift_fc1[31:0];
                end
            endcase
        end
    end
end


//------------------------Register logic-----------------
assign interrupt         = int_interrupt;
assign ap_start          = int_ap_start;
assign task_ap_done      = (ap_done && !auto_restart_status) || auto_restart_done;
assign task_ap_ready     = ap_ready && !int_auto_restart;
assign auto_restart_done = auto_restart_status && (ap_idle && !int_ap_idle);
assign input_r           = int_input_r;
assign weight1_1         = int_weight1_1;
assign bias1_1           = int_bias1_1;
assign weight1_2         = int_weight1_2;
assign bias1_2           = int_bias1_2;
assign weight2_1         = int_weight2_1;
assign bias2_1           = int_bias2_1;
assign weight2_2         = int_weight2_2;
assign bias2_2           = int_bias2_2;
assign weight3_1         = int_weight3_1;
assign bias3_1           = int_bias3_1;
assign weight3_2         = int_weight3_2;
assign bias3_2           = int_bias3_2;
assign weight_fc1        = int_weight_fc1;
assign bias_fc1          = int_bias_fc1;
assign weight_fc2        = int_weight_fc2;
assign bias_fc2          = int_bias_fc2;
assign logits            = int_logits;
assign shift1_1          = int_shift1_1;
assign shift1_2          = int_shift1_2;
assign shift2_1          = int_shift2_1;
assign shift2_2          = int_shift2_2;
assign shift3_1          = int_shift3_1;
assign shift3_2          = int_shift3_2;
assign shift_fc1         = int_shift_fc1;
// int_interrupt
always @(posedge ACLK) begin
    if (ARESET)
        int_interrupt <= 1'b0;
    else if (ACLK_EN) begin
        if (int_gie && (|int_isr))
            int_interrupt <= 1'b1;
        else
            int_interrupt <= 1'b0;
    end
end

// int_ap_start
always @(posedge ACLK) begin
    if (ARESET)
        int_ap_start <= 1'b0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_AP_CTRL && WSTRB[0] && WDATA[0])
            int_ap_start <= 1'b1;
        else if (ap_ready)
            int_ap_start <= int_auto_restart; // clear on handshake/auto restart
    end
end

// int_ap_done
always @(posedge ACLK) begin
    if (ARESET)
        int_ap_done <= 1'b0;
    else if (ACLK_EN) begin
            int_ap_done <= ap_done;
    end
end

// int_task_ap_done
always @(posedge ACLK) begin
    if (ARESET)
        int_task_ap_done <= 1'b0;
    else if (ACLK_EN) begin
        if (task_ap_done)
            int_task_ap_done <= 1'b1;
        else if (ar_hs && raddr == ADDR_AP_CTRL)
            int_task_ap_done <= 1'b0; // clear on read
    end
end

// int_ap_idle
always @(posedge ACLK) begin
    if (ARESET)
        int_ap_idle <= 1'b0;
    else if (ACLK_EN) begin
            int_ap_idle <= ap_idle;
    end
end

// int_ap_ready
always @(posedge ACLK) begin
    if (ARESET)
        int_ap_ready <= 1'b0;
    else if (ACLK_EN) begin
        if (task_ap_ready)
            int_ap_ready <= 1'b1;
        else if (ar_hs && raddr == ADDR_AP_CTRL)
            int_ap_ready <= 1'b0;
    end
end

// int_auto_restart
always @(posedge ACLK) begin
    if (ARESET)
        int_auto_restart <= 1'b0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_AP_CTRL && WSTRB[0])
            int_auto_restart <= WDATA[7];
    end
end

// auto_restart_status
always @(posedge ACLK) begin
    if (ARESET)
        auto_restart_status <= 1'b0;
    else if (ACLK_EN) begin
        if (int_auto_restart)
            auto_restart_status <= 1'b1;
        else if (ap_idle)
            auto_restart_status <= 1'b0;
    end
end

// int_gie
always @(posedge ACLK) begin
    if (ARESET)
        int_gie <= 1'b0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_GIE && WSTRB[0])
            int_gie <= WDATA[0];
    end
end

// int_ier
always @(posedge ACLK) begin
    if (ARESET)
        int_ier <= 1'b0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_IER && WSTRB[0])
            int_ier <= WDATA[1:0];
    end
end

// int_isr[0]
always @(posedge ACLK) begin
    if (ARESET)
        int_isr[0] <= 1'b0;
    else if (ACLK_EN) begin
        if (int_ier[0] & ap_done)
            int_isr[0] <= 1'b1;
        else if (w_hs && waddr == ADDR_ISR && WSTRB[0])
            int_isr[0] <= int_isr[0] ^ WDATA[0]; // toggle on write
    end
end

// int_isr[1]
always @(posedge ACLK) begin
    if (ARESET)
        int_isr[1] <= 1'b0;
    else if (ACLK_EN) begin
        if (int_ier[1] & ap_ready)
            int_isr[1] <= 1'b1;
        else if (w_hs && waddr == ADDR_ISR && WSTRB[0])
            int_isr[1] <= int_isr[1] ^ WDATA[1]; // toggle on write
    end
end

// int_input_r[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_input_r[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_INPUT_R_DATA_0)
            int_input_r[31:0] <= (WDATA[31:0] & wmask) | (int_input_r[31:0] & ~wmask);
    end
end

// int_input_r[63:32]
always @(posedge ACLK) begin
    if (ARESET)
        int_input_r[63:32] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_INPUT_R_DATA_1)
            int_input_r[63:32] <= (WDATA[31:0] & wmask) | (int_input_r[63:32] & ~wmask);
    end
end

// int_weight1_1[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_weight1_1[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_WEIGHT1_1_DATA_0)
            int_weight1_1[31:0] <= (WDATA[31:0] & wmask) | (int_weight1_1[31:0] & ~wmask);
    end
end

// int_weight1_1[63:32]
always @(posedge ACLK) begin
    if (ARESET)
        int_weight1_1[63:32] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_WEIGHT1_1_DATA_1)
            int_weight1_1[63:32] <= (WDATA[31:0] & wmask) | (int_weight1_1[63:32] & ~wmask);
    end
end

// int_bias1_1[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_bias1_1[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_BIAS1_1_DATA_0)
            int_bias1_1[31:0] <= (WDATA[31:0] & wmask) | (int_bias1_1[31:0] & ~wmask);
    end
end

// int_bias1_1[63:32]
always @(posedge ACLK) begin
    if (ARESET)
        int_bias1_1[63:32] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_BIAS1_1_DATA_1)
            int_bias1_1[63:32] <= (WDATA[31:0] & wmask) | (int_bias1_1[63:32] & ~wmask);
    end
end

// int_weight1_2[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_weight1_2[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_WEIGHT1_2_DATA_0)
            int_weight1_2[31:0] <= (WDATA[31:0] & wmask) | (int_weight1_2[31:0] & ~wmask);
    end
end

// int_weight1_2[63:32]
always @(posedge ACLK) begin
    if (ARESET)
        int_weight1_2[63:32] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_WEIGHT1_2_DATA_1)
            int_weight1_2[63:32] <= (WDATA[31:0] & wmask) | (int_weight1_2[63:32] & ~wmask);
    end
end

// int_bias1_2[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_bias1_2[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_BIAS1_2_DATA_0)
            int_bias1_2[31:0] <= (WDATA[31:0] & wmask) | (int_bias1_2[31:0] & ~wmask);
    end
end

// int_bias1_2[63:32]
always @(posedge ACLK) begin
    if (ARESET)
        int_bias1_2[63:32] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_BIAS1_2_DATA_1)
            int_bias1_2[63:32] <= (WDATA[31:0] & wmask) | (int_bias1_2[63:32] & ~wmask);
    end
end

// int_weight2_1[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_weight2_1[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_WEIGHT2_1_DATA_0)
            int_weight2_1[31:0] <= (WDATA[31:0] & wmask) | (int_weight2_1[31:0] & ~wmask);
    end
end

// int_weight2_1[63:32]
always @(posedge ACLK) begin
    if (ARESET)
        int_weight2_1[63:32] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_WEIGHT2_1_DATA_1)
            int_weight2_1[63:32] <= (WDATA[31:0] & wmask) | (int_weight2_1[63:32] & ~wmask);
    end
end

// int_bias2_1[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_bias2_1[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_BIAS2_1_DATA_0)
            int_bias2_1[31:0] <= (WDATA[31:0] & wmask) | (int_bias2_1[31:0] & ~wmask);
    end
end

// int_bias2_1[63:32]
always @(posedge ACLK) begin
    if (ARESET)
        int_bias2_1[63:32] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_BIAS2_1_DATA_1)
            int_bias2_1[63:32] <= (WDATA[31:0] & wmask) | (int_bias2_1[63:32] & ~wmask);
    end
end

// int_weight2_2[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_weight2_2[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_WEIGHT2_2_DATA_0)
            int_weight2_2[31:0] <= (WDATA[31:0] & wmask) | (int_weight2_2[31:0] & ~wmask);
    end
end

// int_weight2_2[63:32]
always @(posedge ACLK) begin
    if (ARESET)
        int_weight2_2[63:32] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_WEIGHT2_2_DATA_1)
            int_weight2_2[63:32] <= (WDATA[31:0] & wmask) | (int_weight2_2[63:32] & ~wmask);
    end
end

// int_bias2_2[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_bias2_2[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_BIAS2_2_DATA_0)
            int_bias2_2[31:0] <= (WDATA[31:0] & wmask) | (int_bias2_2[31:0] & ~wmask);
    end
end

// int_bias2_2[63:32]
always @(posedge ACLK) begin
    if (ARESET)
        int_bias2_2[63:32] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_BIAS2_2_DATA_1)
            int_bias2_2[63:32] <= (WDATA[31:0] & wmask) | (int_bias2_2[63:32] & ~wmask);
    end
end

// int_weight3_1[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_weight3_1[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_WEIGHT3_1_DATA_0)
            int_weight3_1[31:0] <= (WDATA[31:0] & wmask) | (int_weight3_1[31:0] & ~wmask);
    end
end

// int_weight3_1[63:32]
always @(posedge ACLK) begin
    if (ARESET)
        int_weight3_1[63:32] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_WEIGHT3_1_DATA_1)
            int_weight3_1[63:32] <= (WDATA[31:0] & wmask) | (int_weight3_1[63:32] & ~wmask);
    end
end

// int_bias3_1[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_bias3_1[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_BIAS3_1_DATA_0)
            int_bias3_1[31:0] <= (WDATA[31:0] & wmask) | (int_bias3_1[31:0] & ~wmask);
    end
end

// int_bias3_1[63:32]
always @(posedge ACLK) begin
    if (ARESET)
        int_bias3_1[63:32] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_BIAS3_1_DATA_1)
            int_bias3_1[63:32] <= (WDATA[31:0] & wmask) | (int_bias3_1[63:32] & ~wmask);
    end
end

// int_weight3_2[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_weight3_2[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_WEIGHT3_2_DATA_0)
            int_weight3_2[31:0] <= (WDATA[31:0] & wmask) | (int_weight3_2[31:0] & ~wmask);
    end
end

// int_weight3_2[63:32]
always @(posedge ACLK) begin
    if (ARESET)
        int_weight3_2[63:32] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_WEIGHT3_2_DATA_1)
            int_weight3_2[63:32] <= (WDATA[31:0] & wmask) | (int_weight3_2[63:32] & ~wmask);
    end
end

// int_bias3_2[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_bias3_2[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_BIAS3_2_DATA_0)
            int_bias3_2[31:0] <= (WDATA[31:0] & wmask) | (int_bias3_2[31:0] & ~wmask);
    end
end

// int_bias3_2[63:32]
always @(posedge ACLK) begin
    if (ARESET)
        int_bias3_2[63:32] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_BIAS3_2_DATA_1)
            int_bias3_2[63:32] <= (WDATA[31:0] & wmask) | (int_bias3_2[63:32] & ~wmask);
    end
end

// int_weight_fc1[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_weight_fc1[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_WEIGHT_FC1_DATA_0)
            int_weight_fc1[31:0] <= (WDATA[31:0] & wmask) | (int_weight_fc1[31:0] & ~wmask);
    end
end

// int_weight_fc1[63:32]
always @(posedge ACLK) begin
    if (ARESET)
        int_weight_fc1[63:32] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_WEIGHT_FC1_DATA_1)
            int_weight_fc1[63:32] <= (WDATA[31:0] & wmask) | (int_weight_fc1[63:32] & ~wmask);
    end
end

// int_bias_fc1[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_bias_fc1[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_BIAS_FC1_DATA_0)
            int_bias_fc1[31:0] <= (WDATA[31:0] & wmask) | (int_bias_fc1[31:0] & ~wmask);
    end
end

// int_bias_fc1[63:32]
always @(posedge ACLK) begin
    if (ARESET)
        int_bias_fc1[63:32] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_BIAS_FC1_DATA_1)
            int_bias_fc1[63:32] <= (WDATA[31:0] & wmask) | (int_bias_fc1[63:32] & ~wmask);
    end
end

// int_weight_fc2[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_weight_fc2[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_WEIGHT_FC2_DATA_0)
            int_weight_fc2[31:0] <= (WDATA[31:0] & wmask) | (int_weight_fc2[31:0] & ~wmask);
    end
end

// int_weight_fc2[63:32]
always @(posedge ACLK) begin
    if (ARESET)
        int_weight_fc2[63:32] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_WEIGHT_FC2_DATA_1)
            int_weight_fc2[63:32] <= (WDATA[31:0] & wmask) | (int_weight_fc2[63:32] & ~wmask);
    end
end

// int_bias_fc2[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_bias_fc2[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_BIAS_FC2_DATA_0)
            int_bias_fc2[31:0] <= (WDATA[31:0] & wmask) | (int_bias_fc2[31:0] & ~wmask);
    end
end

// int_bias_fc2[63:32]
always @(posedge ACLK) begin
    if (ARESET)
        int_bias_fc2[63:32] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_BIAS_FC2_DATA_1)
            int_bias_fc2[63:32] <= (WDATA[31:0] & wmask) | (int_bias_fc2[63:32] & ~wmask);
    end
end

// int_logits[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_logits[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_LOGITS_DATA_0)
            int_logits[31:0] <= (WDATA[31:0] & wmask) | (int_logits[31:0] & ~wmask);
    end
end

// int_logits[63:32]
always @(posedge ACLK) begin
    if (ARESET)
        int_logits[63:32] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_LOGITS_DATA_1)
            int_logits[63:32] <= (WDATA[31:0] & wmask) | (int_logits[63:32] & ~wmask);
    end
end

// int_shift1_1[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_shift1_1[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_SHIFT1_1_DATA_0)
            int_shift1_1[31:0] <= (WDATA[31:0] & wmask) | (int_shift1_1[31:0] & ~wmask);
    end
end

// int_shift1_2[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_shift1_2[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_SHIFT1_2_DATA_0)
            int_shift1_2[31:0] <= (WDATA[31:0] & wmask) | (int_shift1_2[31:0] & ~wmask);
    end
end

// int_shift2_1[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_shift2_1[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_SHIFT2_1_DATA_0)
            int_shift2_1[31:0] <= (WDATA[31:0] & wmask) | (int_shift2_1[31:0] & ~wmask);
    end
end

// int_shift2_2[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_shift2_2[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_SHIFT2_2_DATA_0)
            int_shift2_2[31:0] <= (WDATA[31:0] & wmask) | (int_shift2_2[31:0] & ~wmask);
    end
end

// int_shift3_1[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_shift3_1[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_SHIFT3_1_DATA_0)
            int_shift3_1[31:0] <= (WDATA[31:0] & wmask) | (int_shift3_1[31:0] & ~wmask);
    end
end

// int_shift3_2[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_shift3_2[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_SHIFT3_2_DATA_0)
            int_shift3_2[31:0] <= (WDATA[31:0] & wmask) | (int_shift3_2[31:0] & ~wmask);
    end
end

// int_shift_fc1[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_shift_fc1[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_SHIFT_FC1_DATA_0)
            int_shift_fc1[31:0] <= (WDATA[31:0] & wmask) | (int_shift_fc1[31:0] & ~wmask);
    end
end

//synthesis translate_off
always @(posedge ACLK) begin
    if (ACLK_EN) begin
        if (int_gie & ~int_isr[0] & int_ier[0] & ap_done)
            $display ("// Interrupt Monitor : interrupt for ap_done detected @ \"%0t\"", $time);
        if (int_gie & ~int_isr[1] & int_ier[1] & ap_ready)
            $display ("// Interrupt Monitor : interrupt for ap_ready detected @ \"%0t\"", $time);
    end
end
//synthesis translate_on

//------------------------Memory logic-------------------

endmodule
