
    wire dl_reset;
    wire dl_clock;
    assign dl_reset = ap_rst_n;
    assign dl_clock = ap_clk;
    wire [8:0] proc_0_data_FIFO_blk;
    wire [8:0] proc_0_data_PIPO_blk;
    wire [8:0] proc_0_start_FIFO_blk;
    wire [8:0] proc_0_TLF_FIFO_blk;
    wire [8:0] proc_0_input_sync_blk;
    wire [8:0] proc_0_output_sync_blk;
    wire [8:0] proc_dep_vld_vec_0;
    reg [8:0] proc_dep_vld_vec_0_reg;
    wire [8:0] in_chan_dep_vld_vec_0;
    wire [305:0] in_chan_dep_data_vec_0;
    wire [8:0] token_in_vec_0;
    wire [8:0] out_chan_dep_vld_vec_0;
    wire [33:0] out_chan_dep_data_0;
    wire [8:0] token_out_vec_0;
    wire dl_detect_out_0;
    wire dep_chan_vld_1_0;
    wire [33:0] dep_chan_data_1_0;
    wire token_1_0;
    wire dep_chan_vld_2_0;
    wire [33:0] dep_chan_data_2_0;
    wire token_2_0;
    wire dep_chan_vld_5_0;
    wire [33:0] dep_chan_data_5_0;
    wire token_5_0;
    wire dep_chan_vld_11_0;
    wire [33:0] dep_chan_data_11_0;
    wire token_11_0;
    wire dep_chan_vld_15_0;
    wire [33:0] dep_chan_data_15_0;
    wire token_15_0;
    wire dep_chan_vld_20_0;
    wire [33:0] dep_chan_data_20_0;
    wire token_20_0;
    wire dep_chan_vld_24_0;
    wire [33:0] dep_chan_data_24_0;
    wire token_24_0;
    wire dep_chan_vld_29_0;
    wire [33:0] dep_chan_data_29_0;
    wire token_29_0;
    wire dep_chan_vld_33_0;
    wire [33:0] dep_chan_data_33_0;
    wire token_33_0;
    wire [8:0] proc_1_data_FIFO_blk;
    wire [8:0] proc_1_data_PIPO_blk;
    wire [8:0] proc_1_start_FIFO_blk;
    wire [8:0] proc_1_TLF_FIFO_blk;
    wire [8:0] proc_1_input_sync_blk;
    wire [8:0] proc_1_output_sync_blk;
    wire [8:0] proc_dep_vld_vec_1;
    reg [8:0] proc_dep_vld_vec_1_reg;
    wire [8:0] in_chan_dep_vld_vec_1;
    wire [305:0] in_chan_dep_data_vec_1;
    wire [8:0] token_in_vec_1;
    wire [8:0] out_chan_dep_vld_vec_1;
    wire [33:0] out_chan_dep_data_1;
    wire [8:0] token_out_vec_1;
    wire dl_detect_out_1;
    wire dep_chan_vld_0_1;
    wire [33:0] dep_chan_data_0_1;
    wire token_0_1;
    wire dep_chan_vld_2_1;
    wire [33:0] dep_chan_data_2_1;
    wire token_2_1;
    wire dep_chan_vld_3_1;
    wire [33:0] dep_chan_data_3_1;
    wire token_3_1;
    wire dep_chan_vld_5_1;
    wire [33:0] dep_chan_data_5_1;
    wire token_5_1;
    wire dep_chan_vld_11_1;
    wire [33:0] dep_chan_data_11_1;
    wire token_11_1;
    wire dep_chan_vld_15_1;
    wire [33:0] dep_chan_data_15_1;
    wire token_15_1;
    wire dep_chan_vld_20_1;
    wire [33:0] dep_chan_data_20_1;
    wire token_20_1;
    wire dep_chan_vld_24_1;
    wire [33:0] dep_chan_data_24_1;
    wire token_24_1;
    wire dep_chan_vld_29_1;
    wire [33:0] dep_chan_data_29_1;
    wire token_29_1;
    wire [8:0] proc_2_data_FIFO_blk;
    wire [8:0] proc_2_data_PIPO_blk;
    wire [8:0] proc_2_start_FIFO_blk;
    wire [8:0] proc_2_TLF_FIFO_blk;
    wire [8:0] proc_2_input_sync_blk;
    wire [8:0] proc_2_output_sync_blk;
    wire [8:0] proc_dep_vld_vec_2;
    reg [8:0] proc_dep_vld_vec_2_reg;
    wire [8:0] in_chan_dep_vld_vec_2;
    wire [305:0] in_chan_dep_data_vec_2;
    wire [8:0] token_in_vec_2;
    wire [8:0] out_chan_dep_vld_vec_2;
    wire [33:0] out_chan_dep_data_2;
    wire [8:0] token_out_vec_2;
    wire dl_detect_out_2;
    wire dep_chan_vld_0_2;
    wire [33:0] dep_chan_data_0_2;
    wire token_0_2;
    wire dep_chan_vld_1_2;
    wire [33:0] dep_chan_data_1_2;
    wire token_1_2;
    wire dep_chan_vld_5_2;
    wire [33:0] dep_chan_data_5_2;
    wire token_5_2;
    wire dep_chan_vld_6_2;
    wire [33:0] dep_chan_data_6_2;
    wire token_6_2;
    wire dep_chan_vld_11_2;
    wire [33:0] dep_chan_data_11_2;
    wire token_11_2;
    wire dep_chan_vld_15_2;
    wire [33:0] dep_chan_data_15_2;
    wire token_15_2;
    wire dep_chan_vld_20_2;
    wire [33:0] dep_chan_data_20_2;
    wire token_20_2;
    wire dep_chan_vld_24_2;
    wire [33:0] dep_chan_data_24_2;
    wire token_24_2;
    wire dep_chan_vld_29_2;
    wire [33:0] dep_chan_data_29_2;
    wire token_29_2;
    wire [1:0] proc_3_data_FIFO_blk;
    wire [1:0] proc_3_data_PIPO_blk;
    wire [1:0] proc_3_start_FIFO_blk;
    wire [1:0] proc_3_TLF_FIFO_blk;
    wire [1:0] proc_3_input_sync_blk;
    wire [1:0] proc_3_output_sync_blk;
    wire [1:0] proc_dep_vld_vec_3;
    reg [1:0] proc_dep_vld_vec_3_reg;
    wire [1:0] in_chan_dep_vld_vec_3;
    wire [67:0] in_chan_dep_data_vec_3;
    wire [1:0] token_in_vec_3;
    wire [1:0] out_chan_dep_vld_vec_3;
    wire [33:0] out_chan_dep_data_3;
    wire [1:0] token_out_vec_3;
    wire dl_detect_out_3;
    wire dep_chan_vld_1_3;
    wire [33:0] dep_chan_data_1_3;
    wire token_1_3;
    wire dep_chan_vld_4_3;
    wire [33:0] dep_chan_data_4_3;
    wire token_4_3;
    wire [2:0] proc_4_data_FIFO_blk;
    wire [2:0] proc_4_data_PIPO_blk;
    wire [2:0] proc_4_start_FIFO_blk;
    wire [2:0] proc_4_TLF_FIFO_blk;
    wire [2:0] proc_4_input_sync_blk;
    wire [2:0] proc_4_output_sync_blk;
    wire [2:0] proc_dep_vld_vec_4;
    reg [2:0] proc_dep_vld_vec_4_reg;
    wire [2:0] in_chan_dep_vld_vec_4;
    wire [101:0] in_chan_dep_data_vec_4;
    wire [2:0] token_in_vec_4;
    wire [2:0] out_chan_dep_vld_vec_4;
    wire [33:0] out_chan_dep_data_4;
    wire [2:0] token_out_vec_4;
    wire dl_detect_out_4;
    wire dep_chan_vld_3_4;
    wire [33:0] dep_chan_data_3_4;
    wire token_3_4;
    wire dep_chan_vld_5_4;
    wire [33:0] dep_chan_data_5_4;
    wire token_5_4;
    wire dep_chan_vld_6_4;
    wire [33:0] dep_chan_data_6_4;
    wire token_6_4;
    wire [9:0] proc_5_data_FIFO_blk;
    wire [9:0] proc_5_data_PIPO_blk;
    wire [9:0] proc_5_start_FIFO_blk;
    wire [9:0] proc_5_TLF_FIFO_blk;
    wire [9:0] proc_5_input_sync_blk;
    wire [9:0] proc_5_output_sync_blk;
    wire [9:0] proc_dep_vld_vec_5;
    reg [9:0] proc_dep_vld_vec_5_reg;
    wire [9:0] in_chan_dep_vld_vec_5;
    wire [339:0] in_chan_dep_data_vec_5;
    wire [9:0] token_in_vec_5;
    wire [9:0] out_chan_dep_vld_vec_5;
    wire [33:0] out_chan_dep_data_5;
    wire [9:0] token_out_vec_5;
    wire dl_detect_out_5;
    wire dep_chan_vld_0_5;
    wire [33:0] dep_chan_data_0_5;
    wire token_0_5;
    wire dep_chan_vld_1_5;
    wire [33:0] dep_chan_data_1_5;
    wire token_1_5;
    wire dep_chan_vld_2_5;
    wire [33:0] dep_chan_data_2_5;
    wire token_2_5;
    wire dep_chan_vld_4_5;
    wire [33:0] dep_chan_data_4_5;
    wire token_4_5;
    wire dep_chan_vld_9_5;
    wire [33:0] dep_chan_data_9_5;
    wire token_9_5;
    wire dep_chan_vld_11_5;
    wire [33:0] dep_chan_data_11_5;
    wire token_11_5;
    wire dep_chan_vld_15_5;
    wire [33:0] dep_chan_data_15_5;
    wire token_15_5;
    wire dep_chan_vld_20_5;
    wire [33:0] dep_chan_data_20_5;
    wire token_20_5;
    wire dep_chan_vld_24_5;
    wire [33:0] dep_chan_data_24_5;
    wire token_24_5;
    wire dep_chan_vld_29_5;
    wire [33:0] dep_chan_data_29_5;
    wire token_29_5;
    wire [3:0] proc_6_data_FIFO_blk;
    wire [3:0] proc_6_data_PIPO_blk;
    wire [3:0] proc_6_start_FIFO_blk;
    wire [3:0] proc_6_TLF_FIFO_blk;
    wire [3:0] proc_6_input_sync_blk;
    wire [3:0] proc_6_output_sync_blk;
    wire [3:0] proc_dep_vld_vec_6;
    reg [3:0] proc_dep_vld_vec_6_reg;
    wire [3:0] in_chan_dep_vld_vec_6;
    wire [135:0] in_chan_dep_data_vec_6;
    wire [3:0] token_in_vec_6;
    wire [3:0] out_chan_dep_vld_vec_6;
    wire [33:0] out_chan_dep_data_6;
    wire [3:0] token_out_vec_6;
    wire dl_detect_out_6;
    wire dep_chan_vld_2_6;
    wire [33:0] dep_chan_data_2_6;
    wire token_2_6;
    wire dep_chan_vld_4_6;
    wire [33:0] dep_chan_data_4_6;
    wire token_4_6;
    wire dep_chan_vld_7_6;
    wire [33:0] dep_chan_data_7_6;
    wire token_7_6;
    wire dep_chan_vld_8_6;
    wire [33:0] dep_chan_data_8_6;
    wire token_8_6;
    wire [1:0] proc_7_data_FIFO_blk;
    wire [1:0] proc_7_data_PIPO_blk;
    wire [1:0] proc_7_start_FIFO_blk;
    wire [1:0] proc_7_TLF_FIFO_blk;
    wire [1:0] proc_7_input_sync_blk;
    wire [1:0] proc_7_output_sync_blk;
    wire [1:0] proc_dep_vld_vec_7;
    reg [1:0] proc_dep_vld_vec_7_reg;
    wire [1:0] in_chan_dep_vld_vec_7;
    wire [67:0] in_chan_dep_data_vec_7;
    wire [1:0] token_in_vec_7;
    wire [1:0] out_chan_dep_vld_vec_7;
    wire [33:0] out_chan_dep_data_7;
    wire [1:0] token_out_vec_7;
    wire dl_detect_out_7;
    wire dep_chan_vld_6_7;
    wire [33:0] dep_chan_data_6_7;
    wire token_6_7;
    wire dep_chan_vld_8_7;
    wire [33:0] dep_chan_data_8_7;
    wire token_8_7;
    wire [2:0] proc_8_data_FIFO_blk;
    wire [2:0] proc_8_data_PIPO_blk;
    wire [2:0] proc_8_start_FIFO_blk;
    wire [2:0] proc_8_TLF_FIFO_blk;
    wire [2:0] proc_8_input_sync_blk;
    wire [2:0] proc_8_output_sync_blk;
    wire [2:0] proc_dep_vld_vec_8;
    reg [2:0] proc_dep_vld_vec_8_reg;
    wire [2:0] in_chan_dep_vld_vec_8;
    wire [101:0] in_chan_dep_data_vec_8;
    wire [2:0] token_in_vec_8;
    wire [2:0] out_chan_dep_vld_vec_8;
    wire [33:0] out_chan_dep_data_8;
    wire [2:0] token_out_vec_8;
    wire dl_detect_out_8;
    wire dep_chan_vld_6_8;
    wire [33:0] dep_chan_data_6_8;
    wire token_6_8;
    wire dep_chan_vld_7_8;
    wire [33:0] dep_chan_data_7_8;
    wire token_7_8;
    wire dep_chan_vld_9_8;
    wire [33:0] dep_chan_data_9_8;
    wire token_9_8;
    wire [2:0] proc_9_data_FIFO_blk;
    wire [2:0] proc_9_data_PIPO_blk;
    wire [2:0] proc_9_start_FIFO_blk;
    wire [2:0] proc_9_TLF_FIFO_blk;
    wire [2:0] proc_9_input_sync_blk;
    wire [2:0] proc_9_output_sync_blk;
    wire [2:0] proc_dep_vld_vec_9;
    reg [2:0] proc_dep_vld_vec_9_reg;
    wire [2:0] in_chan_dep_vld_vec_9;
    wire [101:0] in_chan_dep_data_vec_9;
    wire [2:0] token_in_vec_9;
    wire [2:0] out_chan_dep_vld_vec_9;
    wire [33:0] out_chan_dep_data_9;
    wire [2:0] token_out_vec_9;
    wire dl_detect_out_9;
    wire dep_chan_vld_5_9;
    wire [33:0] dep_chan_data_5_9;
    wire token_5_9;
    wire dep_chan_vld_8_9;
    wire [33:0] dep_chan_data_8_9;
    wire token_8_9;
    wire dep_chan_vld_10_9;
    wire [33:0] dep_chan_data_10_9;
    wire token_10_9;
    wire [2:0] proc_10_data_FIFO_blk;
    wire [2:0] proc_10_data_PIPO_blk;
    wire [2:0] proc_10_start_FIFO_blk;
    wire [2:0] proc_10_TLF_FIFO_blk;
    wire [2:0] proc_10_input_sync_blk;
    wire [2:0] proc_10_output_sync_blk;
    wire [2:0] proc_dep_vld_vec_10;
    reg [2:0] proc_dep_vld_vec_10_reg;
    wire [2:0] in_chan_dep_vld_vec_10;
    wire [101:0] in_chan_dep_data_vec_10;
    wire [2:0] token_in_vec_10;
    wire [2:0] out_chan_dep_vld_vec_10;
    wire [33:0] out_chan_dep_data_10;
    wire [2:0] token_out_vec_10;
    wire dl_detect_out_10;
    wire dep_chan_vld_9_10;
    wire [33:0] dep_chan_data_9_10;
    wire token_9_10;
    wire dep_chan_vld_11_10;
    wire [33:0] dep_chan_data_11_10;
    wire token_11_10;
    wire dep_chan_vld_12_10;
    wire [33:0] dep_chan_data_12_10;
    wire token_12_10;
    wire [9:0] proc_11_data_FIFO_blk;
    wire [9:0] proc_11_data_PIPO_blk;
    wire [9:0] proc_11_start_FIFO_blk;
    wire [9:0] proc_11_TLF_FIFO_blk;
    wire [9:0] proc_11_input_sync_blk;
    wire [9:0] proc_11_output_sync_blk;
    wire [9:0] proc_dep_vld_vec_11;
    reg [9:0] proc_dep_vld_vec_11_reg;
    wire [9:0] in_chan_dep_vld_vec_11;
    wire [339:0] in_chan_dep_data_vec_11;
    wire [9:0] token_in_vec_11;
    wire [9:0] out_chan_dep_vld_vec_11;
    wire [33:0] out_chan_dep_data_11;
    wire [9:0] token_out_vec_11;
    wire dl_detect_out_11;
    wire dep_chan_vld_0_11;
    wire [33:0] dep_chan_data_0_11;
    wire token_0_11;
    wire dep_chan_vld_1_11;
    wire [33:0] dep_chan_data_1_11;
    wire token_1_11;
    wire dep_chan_vld_2_11;
    wire [33:0] dep_chan_data_2_11;
    wire token_2_11;
    wire dep_chan_vld_5_11;
    wire [33:0] dep_chan_data_5_11;
    wire token_5_11;
    wire dep_chan_vld_10_11;
    wire [33:0] dep_chan_data_10_11;
    wire token_10_11;
    wire dep_chan_vld_15_11;
    wire [33:0] dep_chan_data_15_11;
    wire token_15_11;
    wire dep_chan_vld_16_11;
    wire [33:0] dep_chan_data_16_11;
    wire token_16_11;
    wire dep_chan_vld_20_11;
    wire [33:0] dep_chan_data_20_11;
    wire token_20_11;
    wire dep_chan_vld_24_11;
    wire [33:0] dep_chan_data_24_11;
    wire token_24_11;
    wire dep_chan_vld_29_11;
    wire [33:0] dep_chan_data_29_11;
    wire token_29_11;
    wire [2:0] proc_12_data_FIFO_blk;
    wire [2:0] proc_12_data_PIPO_blk;
    wire [2:0] proc_12_start_FIFO_blk;
    wire [2:0] proc_12_TLF_FIFO_blk;
    wire [2:0] proc_12_input_sync_blk;
    wire [2:0] proc_12_output_sync_blk;
    wire [2:0] proc_dep_vld_vec_12;
    reg [2:0] proc_dep_vld_vec_12_reg;
    wire [2:0] in_chan_dep_vld_vec_12;
    wire [101:0] in_chan_dep_data_vec_12;
    wire [2:0] token_in_vec_12;
    wire [2:0] out_chan_dep_vld_vec_12;
    wire [33:0] out_chan_dep_data_12;
    wire [2:0] token_out_vec_12;
    wire dl_detect_out_12;
    wire dep_chan_vld_10_12;
    wire [33:0] dep_chan_data_10_12;
    wire token_10_12;
    wire dep_chan_vld_13_12;
    wire [33:0] dep_chan_data_13_12;
    wire token_13_12;
    wire dep_chan_vld_14_12;
    wire [33:0] dep_chan_data_14_12;
    wire token_14_12;
    wire [1:0] proc_13_data_FIFO_blk;
    wire [1:0] proc_13_data_PIPO_blk;
    wire [1:0] proc_13_start_FIFO_blk;
    wire [1:0] proc_13_TLF_FIFO_blk;
    wire [1:0] proc_13_input_sync_blk;
    wire [1:0] proc_13_output_sync_blk;
    wire [1:0] proc_dep_vld_vec_13;
    reg [1:0] proc_dep_vld_vec_13_reg;
    wire [1:0] in_chan_dep_vld_vec_13;
    wire [67:0] in_chan_dep_data_vec_13;
    wire [1:0] token_in_vec_13;
    wire [1:0] out_chan_dep_vld_vec_13;
    wire [33:0] out_chan_dep_data_13;
    wire [1:0] token_out_vec_13;
    wire dl_detect_out_13;
    wire dep_chan_vld_12_13;
    wire [33:0] dep_chan_data_12_13;
    wire token_12_13;
    wire dep_chan_vld_14_13;
    wire [33:0] dep_chan_data_14_13;
    wire token_14_13;
    wire [3:0] proc_14_data_FIFO_blk;
    wire [3:0] proc_14_data_PIPO_blk;
    wire [3:0] proc_14_start_FIFO_blk;
    wire [3:0] proc_14_TLF_FIFO_blk;
    wire [3:0] proc_14_input_sync_blk;
    wire [3:0] proc_14_output_sync_blk;
    wire [3:0] proc_dep_vld_vec_14;
    reg [3:0] proc_dep_vld_vec_14_reg;
    wire [3:0] in_chan_dep_vld_vec_14;
    wire [135:0] in_chan_dep_data_vec_14;
    wire [3:0] token_in_vec_14;
    wire [3:0] out_chan_dep_vld_vec_14;
    wire [33:0] out_chan_dep_data_14;
    wire [3:0] token_out_vec_14;
    wire dl_detect_out_14;
    wire dep_chan_vld_12_14;
    wire [33:0] dep_chan_data_12_14;
    wire token_12_14;
    wire dep_chan_vld_13_14;
    wire [33:0] dep_chan_data_13_14;
    wire token_13_14;
    wire dep_chan_vld_15_14;
    wire [33:0] dep_chan_data_15_14;
    wire token_15_14;
    wire dep_chan_vld_16_14;
    wire [33:0] dep_chan_data_16_14;
    wire token_16_14;
    wire [9:0] proc_15_data_FIFO_blk;
    wire [9:0] proc_15_data_PIPO_blk;
    wire [9:0] proc_15_start_FIFO_blk;
    wire [9:0] proc_15_TLF_FIFO_blk;
    wire [9:0] proc_15_input_sync_blk;
    wire [9:0] proc_15_output_sync_blk;
    wire [9:0] proc_dep_vld_vec_15;
    reg [9:0] proc_dep_vld_vec_15_reg;
    wire [9:0] in_chan_dep_vld_vec_15;
    wire [339:0] in_chan_dep_data_vec_15;
    wire [9:0] token_in_vec_15;
    wire [9:0] out_chan_dep_vld_vec_15;
    wire [33:0] out_chan_dep_data_15;
    wire [9:0] token_out_vec_15;
    wire dl_detect_out_15;
    wire dep_chan_vld_0_15;
    wire [33:0] dep_chan_data_0_15;
    wire token_0_15;
    wire dep_chan_vld_1_15;
    wire [33:0] dep_chan_data_1_15;
    wire token_1_15;
    wire dep_chan_vld_2_15;
    wire [33:0] dep_chan_data_2_15;
    wire token_2_15;
    wire dep_chan_vld_5_15;
    wire [33:0] dep_chan_data_5_15;
    wire token_5_15;
    wire dep_chan_vld_11_15;
    wire [33:0] dep_chan_data_11_15;
    wire token_11_15;
    wire dep_chan_vld_14_15;
    wire [33:0] dep_chan_data_14_15;
    wire token_14_15;
    wire dep_chan_vld_19_15;
    wire [33:0] dep_chan_data_19_15;
    wire token_19_15;
    wire dep_chan_vld_20_15;
    wire [33:0] dep_chan_data_20_15;
    wire token_20_15;
    wire dep_chan_vld_24_15;
    wire [33:0] dep_chan_data_24_15;
    wire token_24_15;
    wire dep_chan_vld_29_15;
    wire [33:0] dep_chan_data_29_15;
    wire token_29_15;
    wire [3:0] proc_16_data_FIFO_blk;
    wire [3:0] proc_16_data_PIPO_blk;
    wire [3:0] proc_16_start_FIFO_blk;
    wire [3:0] proc_16_TLF_FIFO_blk;
    wire [3:0] proc_16_input_sync_blk;
    wire [3:0] proc_16_output_sync_blk;
    wire [3:0] proc_dep_vld_vec_16;
    reg [3:0] proc_dep_vld_vec_16_reg;
    wire [3:0] in_chan_dep_vld_vec_16;
    wire [135:0] in_chan_dep_data_vec_16;
    wire [3:0] token_in_vec_16;
    wire [3:0] out_chan_dep_vld_vec_16;
    wire [33:0] out_chan_dep_data_16;
    wire [3:0] token_out_vec_16;
    wire dl_detect_out_16;
    wire dep_chan_vld_11_16;
    wire [33:0] dep_chan_data_11_16;
    wire token_11_16;
    wire dep_chan_vld_14_16;
    wire [33:0] dep_chan_data_14_16;
    wire token_14_16;
    wire dep_chan_vld_17_16;
    wire [33:0] dep_chan_data_17_16;
    wire token_17_16;
    wire dep_chan_vld_18_16;
    wire [33:0] dep_chan_data_18_16;
    wire token_18_16;
    wire [1:0] proc_17_data_FIFO_blk;
    wire [1:0] proc_17_data_PIPO_blk;
    wire [1:0] proc_17_start_FIFO_blk;
    wire [1:0] proc_17_TLF_FIFO_blk;
    wire [1:0] proc_17_input_sync_blk;
    wire [1:0] proc_17_output_sync_blk;
    wire [1:0] proc_dep_vld_vec_17;
    reg [1:0] proc_dep_vld_vec_17_reg;
    wire [1:0] in_chan_dep_vld_vec_17;
    wire [67:0] in_chan_dep_data_vec_17;
    wire [1:0] token_in_vec_17;
    wire [1:0] out_chan_dep_vld_vec_17;
    wire [33:0] out_chan_dep_data_17;
    wire [1:0] token_out_vec_17;
    wire dl_detect_out_17;
    wire dep_chan_vld_16_17;
    wire [33:0] dep_chan_data_16_17;
    wire token_16_17;
    wire dep_chan_vld_18_17;
    wire [33:0] dep_chan_data_18_17;
    wire token_18_17;
    wire [2:0] proc_18_data_FIFO_blk;
    wire [2:0] proc_18_data_PIPO_blk;
    wire [2:0] proc_18_start_FIFO_blk;
    wire [2:0] proc_18_TLF_FIFO_blk;
    wire [2:0] proc_18_input_sync_blk;
    wire [2:0] proc_18_output_sync_blk;
    wire [2:0] proc_dep_vld_vec_18;
    reg [2:0] proc_dep_vld_vec_18_reg;
    wire [2:0] in_chan_dep_vld_vec_18;
    wire [101:0] in_chan_dep_data_vec_18;
    wire [2:0] token_in_vec_18;
    wire [2:0] out_chan_dep_vld_vec_18;
    wire [33:0] out_chan_dep_data_18;
    wire [2:0] token_out_vec_18;
    wire dl_detect_out_18;
    wire dep_chan_vld_16_18;
    wire [33:0] dep_chan_data_16_18;
    wire token_16_18;
    wire dep_chan_vld_17_18;
    wire [33:0] dep_chan_data_17_18;
    wire token_17_18;
    wire dep_chan_vld_19_18;
    wire [33:0] dep_chan_data_19_18;
    wire token_19_18;
    wire [3:0] proc_19_data_FIFO_blk;
    wire [3:0] proc_19_data_PIPO_blk;
    wire [3:0] proc_19_start_FIFO_blk;
    wire [3:0] proc_19_TLF_FIFO_blk;
    wire [3:0] proc_19_input_sync_blk;
    wire [3:0] proc_19_output_sync_blk;
    wire [3:0] proc_dep_vld_vec_19;
    reg [3:0] proc_dep_vld_vec_19_reg;
    wire [3:0] in_chan_dep_vld_vec_19;
    wire [135:0] in_chan_dep_data_vec_19;
    wire [3:0] token_in_vec_19;
    wire [3:0] out_chan_dep_vld_vec_19;
    wire [33:0] out_chan_dep_data_19;
    wire [3:0] token_out_vec_19;
    wire dl_detect_out_19;
    wire dep_chan_vld_15_19;
    wire [33:0] dep_chan_data_15_19;
    wire token_15_19;
    wire dep_chan_vld_18_19;
    wire [33:0] dep_chan_data_18_19;
    wire token_18_19;
    wire dep_chan_vld_20_19;
    wire [33:0] dep_chan_data_20_19;
    wire token_20_19;
    wire dep_chan_vld_21_19;
    wire [33:0] dep_chan_data_21_19;
    wire token_21_19;
    wire [9:0] proc_20_data_FIFO_blk;
    wire [9:0] proc_20_data_PIPO_blk;
    wire [9:0] proc_20_start_FIFO_blk;
    wire [9:0] proc_20_TLF_FIFO_blk;
    wire [9:0] proc_20_input_sync_blk;
    wire [9:0] proc_20_output_sync_blk;
    wire [9:0] proc_dep_vld_vec_20;
    reg [9:0] proc_dep_vld_vec_20_reg;
    wire [9:0] in_chan_dep_vld_vec_20;
    wire [339:0] in_chan_dep_data_vec_20;
    wire [9:0] token_in_vec_20;
    wire [9:0] out_chan_dep_vld_vec_20;
    wire [33:0] out_chan_dep_data_20;
    wire [9:0] token_out_vec_20;
    wire dl_detect_out_20;
    wire dep_chan_vld_0_20;
    wire [33:0] dep_chan_data_0_20;
    wire token_0_20;
    wire dep_chan_vld_1_20;
    wire [33:0] dep_chan_data_1_20;
    wire token_1_20;
    wire dep_chan_vld_2_20;
    wire [33:0] dep_chan_data_2_20;
    wire token_2_20;
    wire dep_chan_vld_5_20;
    wire [33:0] dep_chan_data_5_20;
    wire token_5_20;
    wire dep_chan_vld_11_20;
    wire [33:0] dep_chan_data_11_20;
    wire token_11_20;
    wire dep_chan_vld_15_20;
    wire [33:0] dep_chan_data_15_20;
    wire token_15_20;
    wire dep_chan_vld_19_20;
    wire [33:0] dep_chan_data_19_20;
    wire token_19_20;
    wire dep_chan_vld_24_20;
    wire [33:0] dep_chan_data_24_20;
    wire token_24_20;
    wire dep_chan_vld_25_20;
    wire [33:0] dep_chan_data_25_20;
    wire token_25_20;
    wire dep_chan_vld_29_20;
    wire [33:0] dep_chan_data_29_20;
    wire token_29_20;
    wire [2:0] proc_21_data_FIFO_blk;
    wire [2:0] proc_21_data_PIPO_blk;
    wire [2:0] proc_21_start_FIFO_blk;
    wire [2:0] proc_21_TLF_FIFO_blk;
    wire [2:0] proc_21_input_sync_blk;
    wire [2:0] proc_21_output_sync_blk;
    wire [2:0] proc_dep_vld_vec_21;
    reg [2:0] proc_dep_vld_vec_21_reg;
    wire [2:0] in_chan_dep_vld_vec_21;
    wire [101:0] in_chan_dep_data_vec_21;
    wire [2:0] token_in_vec_21;
    wire [2:0] out_chan_dep_vld_vec_21;
    wire [33:0] out_chan_dep_data_21;
    wire [2:0] token_out_vec_21;
    wire dl_detect_out_21;
    wire dep_chan_vld_19_21;
    wire [33:0] dep_chan_data_19_21;
    wire token_19_21;
    wire dep_chan_vld_22_21;
    wire [33:0] dep_chan_data_22_21;
    wire token_22_21;
    wire dep_chan_vld_23_21;
    wire [33:0] dep_chan_data_23_21;
    wire token_23_21;
    wire [1:0] proc_22_data_FIFO_blk;
    wire [1:0] proc_22_data_PIPO_blk;
    wire [1:0] proc_22_start_FIFO_blk;
    wire [1:0] proc_22_TLF_FIFO_blk;
    wire [1:0] proc_22_input_sync_blk;
    wire [1:0] proc_22_output_sync_blk;
    wire [1:0] proc_dep_vld_vec_22;
    reg [1:0] proc_dep_vld_vec_22_reg;
    wire [1:0] in_chan_dep_vld_vec_22;
    wire [67:0] in_chan_dep_data_vec_22;
    wire [1:0] token_in_vec_22;
    wire [1:0] out_chan_dep_vld_vec_22;
    wire [33:0] out_chan_dep_data_22;
    wire [1:0] token_out_vec_22;
    wire dl_detect_out_22;
    wire dep_chan_vld_21_22;
    wire [33:0] dep_chan_data_21_22;
    wire token_21_22;
    wire dep_chan_vld_23_22;
    wire [33:0] dep_chan_data_23_22;
    wire token_23_22;
    wire [3:0] proc_23_data_FIFO_blk;
    wire [3:0] proc_23_data_PIPO_blk;
    wire [3:0] proc_23_start_FIFO_blk;
    wire [3:0] proc_23_TLF_FIFO_blk;
    wire [3:0] proc_23_input_sync_blk;
    wire [3:0] proc_23_output_sync_blk;
    wire [3:0] proc_dep_vld_vec_23;
    reg [3:0] proc_dep_vld_vec_23_reg;
    wire [3:0] in_chan_dep_vld_vec_23;
    wire [135:0] in_chan_dep_data_vec_23;
    wire [3:0] token_in_vec_23;
    wire [3:0] out_chan_dep_vld_vec_23;
    wire [33:0] out_chan_dep_data_23;
    wire [3:0] token_out_vec_23;
    wire dl_detect_out_23;
    wire dep_chan_vld_21_23;
    wire [33:0] dep_chan_data_21_23;
    wire token_21_23;
    wire dep_chan_vld_22_23;
    wire [33:0] dep_chan_data_22_23;
    wire token_22_23;
    wire dep_chan_vld_24_23;
    wire [33:0] dep_chan_data_24_23;
    wire token_24_23;
    wire dep_chan_vld_25_23;
    wire [33:0] dep_chan_data_25_23;
    wire token_25_23;
    wire [9:0] proc_24_data_FIFO_blk;
    wire [9:0] proc_24_data_PIPO_blk;
    wire [9:0] proc_24_start_FIFO_blk;
    wire [9:0] proc_24_TLF_FIFO_blk;
    wire [9:0] proc_24_input_sync_blk;
    wire [9:0] proc_24_output_sync_blk;
    wire [9:0] proc_dep_vld_vec_24;
    reg [9:0] proc_dep_vld_vec_24_reg;
    wire [9:0] in_chan_dep_vld_vec_24;
    wire [339:0] in_chan_dep_data_vec_24;
    wire [9:0] token_in_vec_24;
    wire [9:0] out_chan_dep_vld_vec_24;
    wire [33:0] out_chan_dep_data_24;
    wire [9:0] token_out_vec_24;
    wire dl_detect_out_24;
    wire dep_chan_vld_0_24;
    wire [33:0] dep_chan_data_0_24;
    wire token_0_24;
    wire dep_chan_vld_1_24;
    wire [33:0] dep_chan_data_1_24;
    wire token_1_24;
    wire dep_chan_vld_2_24;
    wire [33:0] dep_chan_data_2_24;
    wire token_2_24;
    wire dep_chan_vld_5_24;
    wire [33:0] dep_chan_data_5_24;
    wire token_5_24;
    wire dep_chan_vld_11_24;
    wire [33:0] dep_chan_data_11_24;
    wire token_11_24;
    wire dep_chan_vld_15_24;
    wire [33:0] dep_chan_data_15_24;
    wire token_15_24;
    wire dep_chan_vld_20_24;
    wire [33:0] dep_chan_data_20_24;
    wire token_20_24;
    wire dep_chan_vld_23_24;
    wire [33:0] dep_chan_data_23_24;
    wire token_23_24;
    wire dep_chan_vld_28_24;
    wire [33:0] dep_chan_data_28_24;
    wire token_28_24;
    wire dep_chan_vld_29_24;
    wire [33:0] dep_chan_data_29_24;
    wire token_29_24;
    wire [3:0] proc_25_data_FIFO_blk;
    wire [3:0] proc_25_data_PIPO_blk;
    wire [3:0] proc_25_start_FIFO_blk;
    wire [3:0] proc_25_TLF_FIFO_blk;
    wire [3:0] proc_25_input_sync_blk;
    wire [3:0] proc_25_output_sync_blk;
    wire [3:0] proc_dep_vld_vec_25;
    reg [3:0] proc_dep_vld_vec_25_reg;
    wire [3:0] in_chan_dep_vld_vec_25;
    wire [135:0] in_chan_dep_data_vec_25;
    wire [3:0] token_in_vec_25;
    wire [3:0] out_chan_dep_vld_vec_25;
    wire [33:0] out_chan_dep_data_25;
    wire [3:0] token_out_vec_25;
    wire dl_detect_out_25;
    wire dep_chan_vld_20_25;
    wire [33:0] dep_chan_data_20_25;
    wire token_20_25;
    wire dep_chan_vld_23_25;
    wire [33:0] dep_chan_data_23_25;
    wire token_23_25;
    wire dep_chan_vld_26_25;
    wire [33:0] dep_chan_data_26_25;
    wire token_26_25;
    wire dep_chan_vld_27_25;
    wire [33:0] dep_chan_data_27_25;
    wire token_27_25;
    wire [1:0] proc_26_data_FIFO_blk;
    wire [1:0] proc_26_data_PIPO_blk;
    wire [1:0] proc_26_start_FIFO_blk;
    wire [1:0] proc_26_TLF_FIFO_blk;
    wire [1:0] proc_26_input_sync_blk;
    wire [1:0] proc_26_output_sync_blk;
    wire [1:0] proc_dep_vld_vec_26;
    reg [1:0] proc_dep_vld_vec_26_reg;
    wire [1:0] in_chan_dep_vld_vec_26;
    wire [67:0] in_chan_dep_data_vec_26;
    wire [1:0] token_in_vec_26;
    wire [1:0] out_chan_dep_vld_vec_26;
    wire [33:0] out_chan_dep_data_26;
    wire [1:0] token_out_vec_26;
    wire dl_detect_out_26;
    wire dep_chan_vld_25_26;
    wire [33:0] dep_chan_data_25_26;
    wire token_25_26;
    wire dep_chan_vld_27_26;
    wire [33:0] dep_chan_data_27_26;
    wire token_27_26;
    wire [2:0] proc_27_data_FIFO_blk;
    wire [2:0] proc_27_data_PIPO_blk;
    wire [2:0] proc_27_start_FIFO_blk;
    wire [2:0] proc_27_TLF_FIFO_blk;
    wire [2:0] proc_27_input_sync_blk;
    wire [2:0] proc_27_output_sync_blk;
    wire [2:0] proc_dep_vld_vec_27;
    reg [2:0] proc_dep_vld_vec_27_reg;
    wire [2:0] in_chan_dep_vld_vec_27;
    wire [101:0] in_chan_dep_data_vec_27;
    wire [2:0] token_in_vec_27;
    wire [2:0] out_chan_dep_vld_vec_27;
    wire [33:0] out_chan_dep_data_27;
    wire [2:0] token_out_vec_27;
    wire dl_detect_out_27;
    wire dep_chan_vld_25_27;
    wire [33:0] dep_chan_data_25_27;
    wire token_25_27;
    wire dep_chan_vld_26_27;
    wire [33:0] dep_chan_data_26_27;
    wire token_26_27;
    wire dep_chan_vld_28_27;
    wire [33:0] dep_chan_data_28_27;
    wire token_28_27;
    wire [3:0] proc_28_data_FIFO_blk;
    wire [3:0] proc_28_data_PIPO_blk;
    wire [3:0] proc_28_start_FIFO_blk;
    wire [3:0] proc_28_TLF_FIFO_blk;
    wire [3:0] proc_28_input_sync_blk;
    wire [3:0] proc_28_output_sync_blk;
    wire [3:0] proc_dep_vld_vec_28;
    reg [3:0] proc_dep_vld_vec_28_reg;
    wire [3:0] in_chan_dep_vld_vec_28;
    wire [135:0] in_chan_dep_data_vec_28;
    wire [3:0] token_in_vec_28;
    wire [3:0] out_chan_dep_vld_vec_28;
    wire [33:0] out_chan_dep_data_28;
    wire [3:0] token_out_vec_28;
    wire dl_detect_out_28;
    wire dep_chan_vld_24_28;
    wire [33:0] dep_chan_data_24_28;
    wire token_24_28;
    wire dep_chan_vld_27_28;
    wire [33:0] dep_chan_data_27_28;
    wire token_27_28;
    wire dep_chan_vld_29_28;
    wire [33:0] dep_chan_data_29_28;
    wire token_29_28;
    wire dep_chan_vld_30_28;
    wire [33:0] dep_chan_data_30_28;
    wire token_30_28;
    wire [9:0] proc_29_data_FIFO_blk;
    wire [9:0] proc_29_data_PIPO_blk;
    wire [9:0] proc_29_start_FIFO_blk;
    wire [9:0] proc_29_TLF_FIFO_blk;
    wire [9:0] proc_29_input_sync_blk;
    wire [9:0] proc_29_output_sync_blk;
    wire [9:0] proc_dep_vld_vec_29;
    reg [9:0] proc_dep_vld_vec_29_reg;
    wire [9:0] in_chan_dep_vld_vec_29;
    wire [339:0] in_chan_dep_data_vec_29;
    wire [9:0] token_in_vec_29;
    wire [9:0] out_chan_dep_vld_vec_29;
    wire [33:0] out_chan_dep_data_29;
    wire [9:0] token_out_vec_29;
    wire dl_detect_out_29;
    wire dep_chan_vld_0_29;
    wire [33:0] dep_chan_data_0_29;
    wire token_0_29;
    wire dep_chan_vld_1_29;
    wire [33:0] dep_chan_data_1_29;
    wire token_1_29;
    wire dep_chan_vld_2_29;
    wire [33:0] dep_chan_data_2_29;
    wire token_2_29;
    wire dep_chan_vld_5_29;
    wire [33:0] dep_chan_data_5_29;
    wire token_5_29;
    wire dep_chan_vld_11_29;
    wire [33:0] dep_chan_data_11_29;
    wire token_11_29;
    wire dep_chan_vld_15_29;
    wire [33:0] dep_chan_data_15_29;
    wire token_15_29;
    wire dep_chan_vld_20_29;
    wire [33:0] dep_chan_data_20_29;
    wire token_20_29;
    wire dep_chan_vld_24_29;
    wire [33:0] dep_chan_data_24_29;
    wire token_24_29;
    wire dep_chan_vld_28_29;
    wire [33:0] dep_chan_data_28_29;
    wire token_28_29;
    wire dep_chan_vld_33_29;
    wire [33:0] dep_chan_data_33_29;
    wire token_33_29;
    wire [2:0] proc_30_data_FIFO_blk;
    wire [2:0] proc_30_data_PIPO_blk;
    wire [2:0] proc_30_start_FIFO_blk;
    wire [2:0] proc_30_TLF_FIFO_blk;
    wire [2:0] proc_30_input_sync_blk;
    wire [2:0] proc_30_output_sync_blk;
    wire [2:0] proc_dep_vld_vec_30;
    reg [2:0] proc_dep_vld_vec_30_reg;
    wire [2:0] in_chan_dep_vld_vec_30;
    wire [101:0] in_chan_dep_data_vec_30;
    wire [2:0] token_in_vec_30;
    wire [2:0] out_chan_dep_vld_vec_30;
    wire [33:0] out_chan_dep_data_30;
    wire [2:0] token_out_vec_30;
    wire dl_detect_out_30;
    wire dep_chan_vld_28_30;
    wire [33:0] dep_chan_data_28_30;
    wire token_28_30;
    wire dep_chan_vld_31_30;
    wire [33:0] dep_chan_data_31_30;
    wire token_31_30;
    wire dep_chan_vld_32_30;
    wire [33:0] dep_chan_data_32_30;
    wire token_32_30;
    wire [1:0] proc_31_data_FIFO_blk;
    wire [1:0] proc_31_data_PIPO_blk;
    wire [1:0] proc_31_start_FIFO_blk;
    wire [1:0] proc_31_TLF_FIFO_blk;
    wire [1:0] proc_31_input_sync_blk;
    wire [1:0] proc_31_output_sync_blk;
    wire [1:0] proc_dep_vld_vec_31;
    reg [1:0] proc_dep_vld_vec_31_reg;
    wire [1:0] in_chan_dep_vld_vec_31;
    wire [67:0] in_chan_dep_data_vec_31;
    wire [1:0] token_in_vec_31;
    wire [1:0] out_chan_dep_vld_vec_31;
    wire [33:0] out_chan_dep_data_31;
    wire [1:0] token_out_vec_31;
    wire dl_detect_out_31;
    wire dep_chan_vld_30_31;
    wire [33:0] dep_chan_data_30_31;
    wire token_30_31;
    wire dep_chan_vld_32_31;
    wire [33:0] dep_chan_data_32_31;
    wire token_32_31;
    wire [2:0] proc_32_data_FIFO_blk;
    wire [2:0] proc_32_data_PIPO_blk;
    wire [2:0] proc_32_start_FIFO_blk;
    wire [2:0] proc_32_TLF_FIFO_blk;
    wire [2:0] proc_32_input_sync_blk;
    wire [2:0] proc_32_output_sync_blk;
    wire [2:0] proc_dep_vld_vec_32;
    reg [2:0] proc_dep_vld_vec_32_reg;
    wire [2:0] in_chan_dep_vld_vec_32;
    wire [101:0] in_chan_dep_data_vec_32;
    wire [2:0] token_in_vec_32;
    wire [2:0] out_chan_dep_vld_vec_32;
    wire [33:0] out_chan_dep_data_32;
    wire [2:0] token_out_vec_32;
    wire dl_detect_out_32;
    wire dep_chan_vld_30_32;
    wire [33:0] dep_chan_data_30_32;
    wire token_30_32;
    wire dep_chan_vld_31_32;
    wire [33:0] dep_chan_data_31_32;
    wire token_31_32;
    wire dep_chan_vld_33_32;
    wire [33:0] dep_chan_data_33_32;
    wire token_33_32;
    wire [2:0] proc_33_data_FIFO_blk;
    wire [2:0] proc_33_data_PIPO_blk;
    wire [2:0] proc_33_start_FIFO_blk;
    wire [2:0] proc_33_TLF_FIFO_blk;
    wire [2:0] proc_33_input_sync_blk;
    wire [2:0] proc_33_output_sync_blk;
    wire [2:0] proc_dep_vld_vec_33;
    reg [2:0] proc_dep_vld_vec_33_reg;
    wire [2:0] in_chan_dep_vld_vec_33;
    wire [101:0] in_chan_dep_data_vec_33;
    wire [2:0] token_in_vec_33;
    wire [2:0] out_chan_dep_vld_vec_33;
    wire [33:0] out_chan_dep_data_33;
    wire [2:0] token_out_vec_33;
    wire dl_detect_out_33;
    wire dep_chan_vld_0_33;
    wire [33:0] dep_chan_data_0_33;
    wire token_0_33;
    wire dep_chan_vld_29_33;
    wire [33:0] dep_chan_data_29_33;
    wire token_29_33;
    wire dep_chan_vld_32_33;
    wire [33:0] dep_chan_data_32_33;
    wire token_32_33;
    wire [33:0] dl_in_vec;
    wire dl_detect_out;
    wire token_clear;
    reg [33:0] origin;

reg [15:0] trans_in_cnt_0;// for process grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_windows_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_0 <= 16'h0;
    end
    else if (grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_windows_U0.start_write == 1'b1) begin
        trans_in_cnt_0 <= trans_in_cnt_0 + 16'h1;
    end
    else begin
        trans_in_cnt_0 <= trans_in_cnt_0;
    end
end

reg [15:0] trans_out_cnt_0;// for process grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_windows_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_0 <= 16'h0;
    end
    else if (grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_windows_U0.ap_done == 1'b1 && grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_windows_U0.ap_continue == 1'b1) begin
        trans_out_cnt_0 <= trans_out_cnt_0 + 16'h1;
    end
    else begin
        trans_out_cnt_0 <= trans_out_cnt_0;
    end
end

reg [15:0] trans_in_cnt_1;// for process grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_1 <= 16'h0;
    end
    else if (grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.start_write == 1'b1) begin
        trans_in_cnt_1 <= trans_in_cnt_1 + 16'h1;
    end
    else begin
        trans_in_cnt_1 <= trans_in_cnt_1;
    end
end

reg [15:0] trans_out_cnt_1;// for process grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_1 <= 16'h0;
    end
    else if (grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.ap_done == 1'b1 && grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.ap_continue == 1'b1) begin
        trans_out_cnt_1 <= trans_out_cnt_1 + 16'h1;
    end
    else begin
        trans_out_cnt_1 <= trans_out_cnt_1;
    end
end

reg [15:0] trans_in_cnt_2;// for process grp_cnn_pipeline_fu_1933.maxpool1_lane2_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_2 <= 16'h0;
    end
    else if (grp_cnn_pipeline_fu_1933.maxpool1_lane2_U0.start_write == 1'b1) begin
        trans_in_cnt_2 <= trans_in_cnt_2 + 16'h1;
    end
    else begin
        trans_in_cnt_2 <= trans_in_cnt_2;
    end
end

reg [15:0] trans_out_cnt_2;// for process grp_cnn_pipeline_fu_1933.maxpool1_lane2_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_2 <= 16'h0;
    end
    else if (grp_cnn_pipeline_fu_1933.maxpool1_lane2_U0.ap_done == 1'b1 && grp_cnn_pipeline_fu_1933.maxpool1_lane2_U0.ap_continue == 1'b1) begin
        trans_out_cnt_2 <= trans_out_cnt_2 + 16'h1;
    end
    else begin
        trans_out_cnt_2 <= trans_out_cnt_2;
    end
end

reg [15:0] trans_in_cnt_3;// for process grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_windows_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_3 <= 16'h0;
    end
    else if (grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_windows_U0.start_write == 1'b1) begin
        trans_in_cnt_3 <= trans_in_cnt_3 + 16'h1;
    end
    else begin
        trans_in_cnt_3 <= trans_in_cnt_3;
    end
end

reg [15:0] trans_out_cnt_3;// for process grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_windows_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_3 <= 16'h0;
    end
    else if (grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_windows_U0.ap_done == 1'b1 && grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_windows_U0.ap_continue == 1'b1) begin
        trans_out_cnt_3 <= trans_out_cnt_3 + 16'h1;
    end
    else begin
        trans_out_cnt_3 <= trans_out_cnt_3;
    end
end

reg [15:0] trans_in_cnt_4;// for process grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_windows_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_4 <= 16'h0;
    end
    else if (grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_windows_U0.start_write == 1'b1) begin
        trans_in_cnt_4 <= trans_in_cnt_4 + 16'h1;
    end
    else begin
        trans_in_cnt_4 <= trans_in_cnt_4;
    end
end

reg [15:0] trans_out_cnt_4;// for process grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_windows_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_4 <= 16'h0;
    end
    else if (grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_windows_U0.ap_done == 1'b1 && grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_windows_U0.ap_continue == 1'b1) begin
        trans_out_cnt_4 <= trans_out_cnt_4 + 16'h1;
    end
    else begin
        trans_out_cnt_4 <= trans_out_cnt_4;
    end
end

reg [15:0] trans_in_cnt_5;// for process grp_cnn_pipeline_fu_1933.conv2_2_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_5 <= 16'h0;
    end
    else if (grp_cnn_pipeline_fu_1933.conv2_2_U0.start_write == 1'b1) begin
        trans_in_cnt_5 <= trans_in_cnt_5 + 16'h1;
    end
    else begin
        trans_in_cnt_5 <= trans_in_cnt_5;
    end
end

reg [15:0] trans_out_cnt_5;// for process grp_cnn_pipeline_fu_1933.conv2_2_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_5 <= 16'h0;
    end
    else if (grp_cnn_pipeline_fu_1933.conv2_2_U0.ap_done == 1'b1 && grp_cnn_pipeline_fu_1933.conv2_2_U0.ap_continue == 1'b1) begin
        trans_out_cnt_5 <= trans_out_cnt_5 + 16'h1;
    end
    else begin
        trans_out_cnt_5 <= trans_out_cnt_5;
    end
end

reg [15:0] trans_in_cnt_6;// for process grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_windows_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_6 <= 16'h0;
    end
    else if (grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_windows_U0.start_write == 1'b1) begin
        trans_in_cnt_6 <= trans_in_cnt_6 + 16'h1;
    end
    else begin
        trans_in_cnt_6 <= trans_in_cnt_6;
    end
end

reg [15:0] trans_out_cnt_6;// for process grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_windows_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_6 <= 16'h0;
    end
    else if (grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_windows_U0.ap_done == 1'b1 && grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_windows_U0.ap_continue == 1'b1) begin
        trans_out_cnt_6 <= trans_out_cnt_6 + 16'h1;
    end
    else begin
        trans_out_cnt_6 <= trans_out_cnt_6;
    end
end

reg [15:0] trans_in_cnt_7;// for process grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_windows_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_7 <= 16'h0;
    end
    else if (grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_windows_U0.start_write == 1'b1) begin
        trans_in_cnt_7 <= trans_in_cnt_7 + 16'h1;
    end
    else begin
        trans_in_cnt_7 <= trans_in_cnt_7;
    end
end

reg [15:0] trans_out_cnt_7;// for process grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_windows_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_7 <= 16'h0;
    end
    else if (grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_windows_U0.ap_done == 1'b1 && grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_windows_U0.ap_continue == 1'b1) begin
        trans_out_cnt_7 <= trans_out_cnt_7 + 16'h1;
    end
    else begin
        trans_out_cnt_7 <= trans_out_cnt_7;
    end
end

reg [15:0] trans_in_cnt_8;// for process grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_8 <= 16'h0;
    end
    else if (grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.start_write == 1'b1) begin
        trans_in_cnt_8 <= trans_in_cnt_8 + 16'h1;
    end
    else begin
        trans_in_cnt_8 <= trans_in_cnt_8;
    end
end

reg [15:0] trans_out_cnt_8;// for process grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_8 <= 16'h0;
    end
    else if (grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.ap_done == 1'b1 && grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.ap_continue == 1'b1) begin
        trans_out_cnt_8 <= trans_out_cnt_8 + 16'h1;
    end
    else begin
        trans_out_cnt_8 <= trans_out_cnt_8;
    end
end

reg [15:0] trans_in_cnt_9;// for process grp_cnn_pipeline_fu_1933.entry_proc_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_9 <= 16'h0;
    end
    else if (grp_cnn_pipeline_fu_1933.entry_proc_U0.start_write == 1'b1) begin
        trans_in_cnt_9 <= trans_in_cnt_9 + 16'h1;
    end
    else begin
        trans_in_cnt_9 <= trans_in_cnt_9;
    end
end

reg [15:0] trans_out_cnt_9;// for process grp_cnn_pipeline_fu_1933.entry_proc_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_9 <= 16'h0;
    end
    else if (grp_cnn_pipeline_fu_1933.entry_proc_U0.ap_done == 1'b1 && grp_cnn_pipeline_fu_1933.entry_proc_U0.ap_continue == 1'b1) begin
        trans_out_cnt_9 <= trans_out_cnt_9 + 16'h1;
    end
    else begin
        trans_out_cnt_9 <= trans_out_cnt_9;
    end
end

    // Process: grp_cnn_pipeline_fu_1933.entry_proc_U0
    cnn_hls_deadlock_detect_unit #(34, 0, 9, 9) cnn_hls_deadlock_detect_unit_0 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_0),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_0),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_0),
        .token_in_vec(token_in_vec_0),
        .dl_detect_in(dl_detect_out),
        .origin(origin[0]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_0),
        .out_chan_dep_data(out_chan_dep_data_0),
        .token_out_vec(token_out_vec_0),
        .dl_detect_out(dl_in_vec[0]));

    assign proc_0_data_FIFO_blk[0] = 1'b0 | (~grp_cnn_pipeline_fu_1933.entry_proc_U0.logits_c_blk_n);
    assign proc_0_data_PIPO_blk[0] = 1'b0;
    assign proc_0_start_FIFO_blk[0] = 1'b0 | (~grp_cnn_pipeline_fu_1933.start_for_cnn_write_logits_U0_U.if_full_n & grp_cnn_pipeline_fu_1933.entry_proc_U0.ap_start & ~grp_cnn_pipeline_fu_1933.entry_proc_U0.real_start & (trans_in_cnt_9 == trans_out_cnt_9) & ~grp_cnn_pipeline_fu_1933.start_for_cnn_write_logits_U0_U.if_read);
    assign proc_0_TLF_FIFO_blk[0] = 1'b0;
    assign proc_0_input_sync_blk[0] = 1'b0;
    assign proc_0_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_0[0] = dl_detect_out ? proc_dep_vld_vec_0_reg[0] : (proc_0_data_FIFO_blk[0] | proc_0_data_PIPO_blk[0] | proc_0_start_FIFO_blk[0] | proc_0_TLF_FIFO_blk[0] | proc_0_input_sync_blk[0] | proc_0_output_sync_blk[0]);
    assign proc_0_data_FIFO_blk[1] = 1'b0;
    assign proc_0_data_PIPO_blk[1] = 1'b0;
    assign proc_0_start_FIFO_blk[1] = 1'b0;
    assign proc_0_TLF_FIFO_blk[1] = 1'b0;
    assign proc_0_input_sync_blk[1] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_entry_proc_U0_ap_ready & grp_cnn_pipeline_fu_1933.entry_proc_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_cnn_read_input_U0_ap_ready);
    assign proc_0_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_0[1] = dl_detect_out ? proc_dep_vld_vec_0_reg[1] : (proc_0_data_FIFO_blk[1] | proc_0_data_PIPO_blk[1] | proc_0_start_FIFO_blk[1] | proc_0_TLF_FIFO_blk[1] | proc_0_input_sync_blk[1] | proc_0_output_sync_blk[1]);
    assign proc_0_data_FIFO_blk[2] = 1'b0;
    assign proc_0_data_PIPO_blk[2] = 1'b0;
    assign proc_0_start_FIFO_blk[2] = 1'b0;
    assign proc_0_TLF_FIFO_blk[2] = 1'b0;
    assign proc_0_input_sync_blk[2] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_entry_proc_U0_ap_ready & grp_cnn_pipeline_fu_1933.entry_proc_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv1_1_lane2_U0_ap_ready);
    assign proc_0_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_0[2] = dl_detect_out ? proc_dep_vld_vec_0_reg[2] : (proc_0_data_FIFO_blk[2] | proc_0_data_PIPO_blk[2] | proc_0_start_FIFO_blk[2] | proc_0_TLF_FIFO_blk[2] | proc_0_input_sync_blk[2] | proc_0_output_sync_blk[2]);
    assign proc_0_data_FIFO_blk[3] = 1'b0;
    assign proc_0_data_PIPO_blk[3] = 1'b0;
    assign proc_0_start_FIFO_blk[3] = 1'b0;
    assign proc_0_TLF_FIFO_blk[3] = 1'b0;
    assign proc_0_input_sync_blk[3] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_entry_proc_U0_ap_ready & grp_cnn_pipeline_fu_1933.entry_proc_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv1_2_lane2_U0_ap_ready);
    assign proc_0_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_0[3] = dl_detect_out ? proc_dep_vld_vec_0_reg[3] : (proc_0_data_FIFO_blk[3] | proc_0_data_PIPO_blk[3] | proc_0_start_FIFO_blk[3] | proc_0_TLF_FIFO_blk[3] | proc_0_input_sync_blk[3] | proc_0_output_sync_blk[3]);
    assign proc_0_data_FIFO_blk[4] = 1'b0;
    assign proc_0_data_PIPO_blk[4] = 1'b0;
    assign proc_0_start_FIFO_blk[4] = 1'b0;
    assign proc_0_TLF_FIFO_blk[4] = 1'b0;
    assign proc_0_input_sync_blk[4] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_entry_proc_U0_ap_ready & grp_cnn_pipeline_fu_1933.entry_proc_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv2_1_U0_ap_ready);
    assign proc_0_output_sync_blk[4] = 1'b0;
    assign proc_dep_vld_vec_0[4] = dl_detect_out ? proc_dep_vld_vec_0_reg[4] : (proc_0_data_FIFO_blk[4] | proc_0_data_PIPO_blk[4] | proc_0_start_FIFO_blk[4] | proc_0_TLF_FIFO_blk[4] | proc_0_input_sync_blk[4] | proc_0_output_sync_blk[4]);
    assign proc_0_data_FIFO_blk[5] = 1'b0;
    assign proc_0_data_PIPO_blk[5] = 1'b0;
    assign proc_0_start_FIFO_blk[5] = 1'b0;
    assign proc_0_TLF_FIFO_blk[5] = 1'b0;
    assign proc_0_input_sync_blk[5] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_entry_proc_U0_ap_ready & grp_cnn_pipeline_fu_1933.entry_proc_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv2_2_U0_ap_ready);
    assign proc_0_output_sync_blk[5] = 1'b0;
    assign proc_dep_vld_vec_0[5] = dl_detect_out ? proc_dep_vld_vec_0_reg[5] : (proc_0_data_FIFO_blk[5] | proc_0_data_PIPO_blk[5] | proc_0_start_FIFO_blk[5] | proc_0_TLF_FIFO_blk[5] | proc_0_input_sync_blk[5] | proc_0_output_sync_blk[5]);
    assign proc_0_data_FIFO_blk[6] = 1'b0;
    assign proc_0_data_PIPO_blk[6] = 1'b0;
    assign proc_0_start_FIFO_blk[6] = 1'b0;
    assign proc_0_TLF_FIFO_blk[6] = 1'b0;
    assign proc_0_input_sync_blk[6] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_entry_proc_U0_ap_ready & grp_cnn_pipeline_fu_1933.entry_proc_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv3_1_reuse16_U0_ap_ready);
    assign proc_0_output_sync_blk[6] = 1'b0;
    assign proc_dep_vld_vec_0[6] = dl_detect_out ? proc_dep_vld_vec_0_reg[6] : (proc_0_data_FIFO_blk[6] | proc_0_data_PIPO_blk[6] | proc_0_start_FIFO_blk[6] | proc_0_TLF_FIFO_blk[6] | proc_0_input_sync_blk[6] | proc_0_output_sync_blk[6]);
    assign proc_0_data_FIFO_blk[7] = 1'b0;
    assign proc_0_data_PIPO_blk[7] = 1'b0;
    assign proc_0_start_FIFO_blk[7] = 1'b0;
    assign proc_0_TLF_FIFO_blk[7] = 1'b0;
    assign proc_0_input_sync_blk[7] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_entry_proc_U0_ap_ready & grp_cnn_pipeline_fu_1933.entry_proc_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv3_2_reuse32_U0_ap_ready);
    assign proc_0_output_sync_blk[7] = 1'b0;
    assign proc_dep_vld_vec_0[7] = dl_detect_out ? proc_dep_vld_vec_0_reg[7] : (proc_0_data_FIFO_blk[7] | proc_0_data_PIPO_blk[7] | proc_0_start_FIFO_blk[7] | proc_0_TLF_FIFO_blk[7] | proc_0_input_sync_blk[7] | proc_0_output_sync_blk[7]);
    assign proc_0_data_FIFO_blk[8] = 1'b0;
    assign proc_0_data_PIPO_blk[8] = 1'b0;
    assign proc_0_start_FIFO_blk[8] = 1'b0;
    assign proc_0_TLF_FIFO_blk[8] = 1'b0;
    assign proc_0_input_sync_blk[8] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_entry_proc_U0_ap_ready & grp_cnn_pipeline_fu_1933.entry_proc_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_classification_head_stream_U0_ap_ready);
    assign proc_0_output_sync_blk[8] = 1'b0;
    assign proc_dep_vld_vec_0[8] = dl_detect_out ? proc_dep_vld_vec_0_reg[8] : (proc_0_data_FIFO_blk[8] | proc_0_data_PIPO_blk[8] | proc_0_start_FIFO_blk[8] | proc_0_TLF_FIFO_blk[8] | proc_0_input_sync_blk[8] | proc_0_output_sync_blk[8]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_0_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_0_reg <= proc_dep_vld_vec_0;
        end
    end
    assign in_chan_dep_vld_vec_0[0] = dep_chan_vld_1_0;
    assign in_chan_dep_data_vec_0[33 : 0] = dep_chan_data_1_0;
    assign token_in_vec_0[0] = token_1_0;
    assign in_chan_dep_vld_vec_0[1] = dep_chan_vld_2_0;
    assign in_chan_dep_data_vec_0[67 : 34] = dep_chan_data_2_0;
    assign token_in_vec_0[1] = token_2_0;
    assign in_chan_dep_vld_vec_0[2] = dep_chan_vld_5_0;
    assign in_chan_dep_data_vec_0[101 : 68] = dep_chan_data_5_0;
    assign token_in_vec_0[2] = token_5_0;
    assign in_chan_dep_vld_vec_0[3] = dep_chan_vld_11_0;
    assign in_chan_dep_data_vec_0[135 : 102] = dep_chan_data_11_0;
    assign token_in_vec_0[3] = token_11_0;
    assign in_chan_dep_vld_vec_0[4] = dep_chan_vld_15_0;
    assign in_chan_dep_data_vec_0[169 : 136] = dep_chan_data_15_0;
    assign token_in_vec_0[4] = token_15_0;
    assign in_chan_dep_vld_vec_0[5] = dep_chan_vld_20_0;
    assign in_chan_dep_data_vec_0[203 : 170] = dep_chan_data_20_0;
    assign token_in_vec_0[5] = token_20_0;
    assign in_chan_dep_vld_vec_0[6] = dep_chan_vld_24_0;
    assign in_chan_dep_data_vec_0[237 : 204] = dep_chan_data_24_0;
    assign token_in_vec_0[6] = token_24_0;
    assign in_chan_dep_vld_vec_0[7] = dep_chan_vld_29_0;
    assign in_chan_dep_data_vec_0[271 : 238] = dep_chan_data_29_0;
    assign token_in_vec_0[7] = token_29_0;
    assign in_chan_dep_vld_vec_0[8] = dep_chan_vld_33_0;
    assign in_chan_dep_data_vec_0[305 : 272] = dep_chan_data_33_0;
    assign token_in_vec_0[8] = token_33_0;
    assign dep_chan_vld_0_33 = out_chan_dep_vld_vec_0[0];
    assign dep_chan_data_0_33 = out_chan_dep_data_0;
    assign token_0_33 = token_out_vec_0[0];
    assign dep_chan_vld_0_1 = out_chan_dep_vld_vec_0[1];
    assign dep_chan_data_0_1 = out_chan_dep_data_0;
    assign token_0_1 = token_out_vec_0[1];
    assign dep_chan_vld_0_2 = out_chan_dep_vld_vec_0[2];
    assign dep_chan_data_0_2 = out_chan_dep_data_0;
    assign token_0_2 = token_out_vec_0[2];
    assign dep_chan_vld_0_5 = out_chan_dep_vld_vec_0[3];
    assign dep_chan_data_0_5 = out_chan_dep_data_0;
    assign token_0_5 = token_out_vec_0[3];
    assign dep_chan_vld_0_11 = out_chan_dep_vld_vec_0[4];
    assign dep_chan_data_0_11 = out_chan_dep_data_0;
    assign token_0_11 = token_out_vec_0[4];
    assign dep_chan_vld_0_15 = out_chan_dep_vld_vec_0[5];
    assign dep_chan_data_0_15 = out_chan_dep_data_0;
    assign token_0_15 = token_out_vec_0[5];
    assign dep_chan_vld_0_20 = out_chan_dep_vld_vec_0[6];
    assign dep_chan_data_0_20 = out_chan_dep_data_0;
    assign token_0_20 = token_out_vec_0[6];
    assign dep_chan_vld_0_24 = out_chan_dep_vld_vec_0[7];
    assign dep_chan_data_0_24 = out_chan_dep_data_0;
    assign token_0_24 = token_out_vec_0[7];
    assign dep_chan_vld_0_29 = out_chan_dep_vld_vec_0[8];
    assign dep_chan_data_0_29 = out_chan_dep_data_0;
    assign token_0_29 = token_out_vec_0[8];

    // Process: grp_cnn_pipeline_fu_1933.cnn_read_input_U0
    cnn_hls_deadlock_detect_unit #(34, 1, 9, 9) cnn_hls_deadlock_detect_unit_1 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_1),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_1),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_1),
        .token_in_vec(token_in_vec_1),
        .dl_detect_in(dl_detect_out),
        .origin(origin[1]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_1),
        .out_chan_dep_data(out_chan_dep_data_1),
        .token_out_vec(token_out_vec_1),
        .dl_detect_out(dl_in_vec[1]));

    assign proc_1_data_FIFO_blk[0] = 1'b0 | (~grp_cnn_pipeline_fu_1933.cnn_read_input_U0.in_stream_blk_n);
    assign proc_1_data_PIPO_blk[0] = 1'b0;
    assign proc_1_start_FIFO_blk[0] = 1'b0;
    assign proc_1_TLF_FIFO_blk[0] = 1'b0;
    assign proc_1_input_sync_blk[0] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_cnn_read_input_U0_ap_ready & grp_cnn_pipeline_fu_1933.cnn_read_input_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv1_1_lane2_U0_ap_ready);
    assign proc_1_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_1[0] = dl_detect_out ? proc_dep_vld_vec_1_reg[0] : (proc_1_data_FIFO_blk[0] | proc_1_data_PIPO_blk[0] | proc_1_start_FIFO_blk[0] | proc_1_TLF_FIFO_blk[0] | proc_1_input_sync_blk[0] | proc_1_output_sync_blk[0]);
    assign proc_1_data_FIFO_blk[1] = 1'b0 | (~grp_cnn_pipeline_fu_1933.cnn_read_input_U0.in_stream_blk_n);
    assign proc_1_data_PIPO_blk[1] = 1'b0;
    assign proc_1_start_FIFO_blk[1] = 1'b0;
    assign proc_1_TLF_FIFO_blk[1] = 1'b0;
    assign proc_1_input_sync_blk[1] = 1'b0;
    assign proc_1_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_1[1] = dl_detect_out ? proc_dep_vld_vec_1_reg[1] : (proc_1_data_FIFO_blk[1] | proc_1_data_PIPO_blk[1] | proc_1_start_FIFO_blk[1] | proc_1_TLF_FIFO_blk[1] | proc_1_input_sync_blk[1] | proc_1_output_sync_blk[1]);
    assign proc_1_data_FIFO_blk[2] = 1'b0;
    assign proc_1_data_PIPO_blk[2] = 1'b0;
    assign proc_1_start_FIFO_blk[2] = 1'b0;
    assign proc_1_TLF_FIFO_blk[2] = 1'b0;
    assign proc_1_input_sync_blk[2] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_cnn_read_input_U0_ap_ready & grp_cnn_pipeline_fu_1933.cnn_read_input_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_entry_proc_U0_ap_ready);
    assign proc_1_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_1[2] = dl_detect_out ? proc_dep_vld_vec_1_reg[2] : (proc_1_data_FIFO_blk[2] | proc_1_data_PIPO_blk[2] | proc_1_start_FIFO_blk[2] | proc_1_TLF_FIFO_blk[2] | proc_1_input_sync_blk[2] | proc_1_output_sync_blk[2]);
    assign proc_1_data_FIFO_blk[3] = 1'b0;
    assign proc_1_data_PIPO_blk[3] = 1'b0;
    assign proc_1_start_FIFO_blk[3] = 1'b0;
    assign proc_1_TLF_FIFO_blk[3] = 1'b0;
    assign proc_1_input_sync_blk[3] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_cnn_read_input_U0_ap_ready & grp_cnn_pipeline_fu_1933.cnn_read_input_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv1_2_lane2_U0_ap_ready);
    assign proc_1_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_1[3] = dl_detect_out ? proc_dep_vld_vec_1_reg[3] : (proc_1_data_FIFO_blk[3] | proc_1_data_PIPO_blk[3] | proc_1_start_FIFO_blk[3] | proc_1_TLF_FIFO_blk[3] | proc_1_input_sync_blk[3] | proc_1_output_sync_blk[3]);
    assign proc_1_data_FIFO_blk[4] = 1'b0;
    assign proc_1_data_PIPO_blk[4] = 1'b0;
    assign proc_1_start_FIFO_blk[4] = 1'b0;
    assign proc_1_TLF_FIFO_blk[4] = 1'b0;
    assign proc_1_input_sync_blk[4] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_cnn_read_input_U0_ap_ready & grp_cnn_pipeline_fu_1933.cnn_read_input_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv2_1_U0_ap_ready);
    assign proc_1_output_sync_blk[4] = 1'b0;
    assign proc_dep_vld_vec_1[4] = dl_detect_out ? proc_dep_vld_vec_1_reg[4] : (proc_1_data_FIFO_blk[4] | proc_1_data_PIPO_blk[4] | proc_1_start_FIFO_blk[4] | proc_1_TLF_FIFO_blk[4] | proc_1_input_sync_blk[4] | proc_1_output_sync_blk[4]);
    assign proc_1_data_FIFO_blk[5] = 1'b0;
    assign proc_1_data_PIPO_blk[5] = 1'b0;
    assign proc_1_start_FIFO_blk[5] = 1'b0;
    assign proc_1_TLF_FIFO_blk[5] = 1'b0;
    assign proc_1_input_sync_blk[5] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_cnn_read_input_U0_ap_ready & grp_cnn_pipeline_fu_1933.cnn_read_input_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv2_2_U0_ap_ready);
    assign proc_1_output_sync_blk[5] = 1'b0;
    assign proc_dep_vld_vec_1[5] = dl_detect_out ? proc_dep_vld_vec_1_reg[5] : (proc_1_data_FIFO_blk[5] | proc_1_data_PIPO_blk[5] | proc_1_start_FIFO_blk[5] | proc_1_TLF_FIFO_blk[5] | proc_1_input_sync_blk[5] | proc_1_output_sync_blk[5]);
    assign proc_1_data_FIFO_blk[6] = 1'b0;
    assign proc_1_data_PIPO_blk[6] = 1'b0;
    assign proc_1_start_FIFO_blk[6] = 1'b0;
    assign proc_1_TLF_FIFO_blk[6] = 1'b0;
    assign proc_1_input_sync_blk[6] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_cnn_read_input_U0_ap_ready & grp_cnn_pipeline_fu_1933.cnn_read_input_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv3_1_reuse16_U0_ap_ready);
    assign proc_1_output_sync_blk[6] = 1'b0;
    assign proc_dep_vld_vec_1[6] = dl_detect_out ? proc_dep_vld_vec_1_reg[6] : (proc_1_data_FIFO_blk[6] | proc_1_data_PIPO_blk[6] | proc_1_start_FIFO_blk[6] | proc_1_TLF_FIFO_blk[6] | proc_1_input_sync_blk[6] | proc_1_output_sync_blk[6]);
    assign proc_1_data_FIFO_blk[7] = 1'b0;
    assign proc_1_data_PIPO_blk[7] = 1'b0;
    assign proc_1_start_FIFO_blk[7] = 1'b0;
    assign proc_1_TLF_FIFO_blk[7] = 1'b0;
    assign proc_1_input_sync_blk[7] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_cnn_read_input_U0_ap_ready & grp_cnn_pipeline_fu_1933.cnn_read_input_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv3_2_reuse32_U0_ap_ready);
    assign proc_1_output_sync_blk[7] = 1'b0;
    assign proc_dep_vld_vec_1[7] = dl_detect_out ? proc_dep_vld_vec_1_reg[7] : (proc_1_data_FIFO_blk[7] | proc_1_data_PIPO_blk[7] | proc_1_start_FIFO_blk[7] | proc_1_TLF_FIFO_blk[7] | proc_1_input_sync_blk[7] | proc_1_output_sync_blk[7]);
    assign proc_1_data_FIFO_blk[8] = 1'b0;
    assign proc_1_data_PIPO_blk[8] = 1'b0;
    assign proc_1_start_FIFO_blk[8] = 1'b0;
    assign proc_1_TLF_FIFO_blk[8] = 1'b0;
    assign proc_1_input_sync_blk[8] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_cnn_read_input_U0_ap_ready & grp_cnn_pipeline_fu_1933.cnn_read_input_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_classification_head_stream_U0_ap_ready);
    assign proc_1_output_sync_blk[8] = 1'b0;
    assign proc_dep_vld_vec_1[8] = dl_detect_out ? proc_dep_vld_vec_1_reg[8] : (proc_1_data_FIFO_blk[8] | proc_1_data_PIPO_blk[8] | proc_1_start_FIFO_blk[8] | proc_1_TLF_FIFO_blk[8] | proc_1_input_sync_blk[8] | proc_1_output_sync_blk[8]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_1_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_1_reg <= proc_dep_vld_vec_1;
        end
    end
    assign in_chan_dep_vld_vec_1[0] = dep_chan_vld_0_1;
    assign in_chan_dep_data_vec_1[33 : 0] = dep_chan_data_0_1;
    assign token_in_vec_1[0] = token_0_1;
    assign in_chan_dep_vld_vec_1[1] = dep_chan_vld_2_1;
    assign in_chan_dep_data_vec_1[67 : 34] = dep_chan_data_2_1;
    assign token_in_vec_1[1] = token_2_1;
    assign in_chan_dep_vld_vec_1[2] = dep_chan_vld_3_1;
    assign in_chan_dep_data_vec_1[101 : 68] = dep_chan_data_3_1;
    assign token_in_vec_1[2] = token_3_1;
    assign in_chan_dep_vld_vec_1[3] = dep_chan_vld_5_1;
    assign in_chan_dep_data_vec_1[135 : 102] = dep_chan_data_5_1;
    assign token_in_vec_1[3] = token_5_1;
    assign in_chan_dep_vld_vec_1[4] = dep_chan_vld_11_1;
    assign in_chan_dep_data_vec_1[169 : 136] = dep_chan_data_11_1;
    assign token_in_vec_1[4] = token_11_1;
    assign in_chan_dep_vld_vec_1[5] = dep_chan_vld_15_1;
    assign in_chan_dep_data_vec_1[203 : 170] = dep_chan_data_15_1;
    assign token_in_vec_1[5] = token_15_1;
    assign in_chan_dep_vld_vec_1[6] = dep_chan_vld_20_1;
    assign in_chan_dep_data_vec_1[237 : 204] = dep_chan_data_20_1;
    assign token_in_vec_1[6] = token_20_1;
    assign in_chan_dep_vld_vec_1[7] = dep_chan_vld_24_1;
    assign in_chan_dep_data_vec_1[271 : 238] = dep_chan_data_24_1;
    assign token_in_vec_1[7] = token_24_1;
    assign in_chan_dep_vld_vec_1[8] = dep_chan_vld_29_1;
    assign in_chan_dep_data_vec_1[305 : 272] = dep_chan_data_29_1;
    assign token_in_vec_1[8] = token_29_1;
    assign dep_chan_vld_1_2 = out_chan_dep_vld_vec_1[0];
    assign dep_chan_data_1_2 = out_chan_dep_data_1;
    assign token_1_2 = token_out_vec_1[0];
    assign dep_chan_vld_1_3 = out_chan_dep_vld_vec_1[1];
    assign dep_chan_data_1_3 = out_chan_dep_data_1;
    assign token_1_3 = token_out_vec_1[1];
    assign dep_chan_vld_1_0 = out_chan_dep_vld_vec_1[2];
    assign dep_chan_data_1_0 = out_chan_dep_data_1;
    assign token_1_0 = token_out_vec_1[2];
    assign dep_chan_vld_1_5 = out_chan_dep_vld_vec_1[3];
    assign dep_chan_data_1_5 = out_chan_dep_data_1;
    assign token_1_5 = token_out_vec_1[3];
    assign dep_chan_vld_1_11 = out_chan_dep_vld_vec_1[4];
    assign dep_chan_data_1_11 = out_chan_dep_data_1;
    assign token_1_11 = token_out_vec_1[4];
    assign dep_chan_vld_1_15 = out_chan_dep_vld_vec_1[5];
    assign dep_chan_data_1_15 = out_chan_dep_data_1;
    assign token_1_15 = token_out_vec_1[5];
    assign dep_chan_vld_1_20 = out_chan_dep_vld_vec_1[6];
    assign dep_chan_data_1_20 = out_chan_dep_data_1;
    assign token_1_20 = token_out_vec_1[6];
    assign dep_chan_vld_1_24 = out_chan_dep_vld_vec_1[7];
    assign dep_chan_data_1_24 = out_chan_dep_data_1;
    assign token_1_24 = token_out_vec_1[7];
    assign dep_chan_vld_1_29 = out_chan_dep_vld_vec_1[8];
    assign dep_chan_data_1_29 = out_chan_dep_data_1;
    assign token_1_29 = token_out_vec_1[8];

    // Process: grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0
    cnn_hls_deadlock_detect_unit #(34, 2, 9, 9) cnn_hls_deadlock_detect_unit_2 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_2),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_2),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_2),
        .token_in_vec(token_in_vec_2),
        .dl_detect_in(dl_detect_out),
        .origin(origin[2]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_2),
        .out_chan_dep_data(out_chan_dep_data_2),
        .token_out_vec(token_out_vec_2),
        .dl_detect_out(dl_in_vec[2]));

    assign proc_2_data_FIFO_blk[0] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.conv1_1_lane2_windows_U0.in_stream_blk_n);
    assign proc_2_data_PIPO_blk[0] = 1'b0;
    assign proc_2_start_FIFO_blk[0] = 1'b0;
    assign proc_2_TLF_FIFO_blk[0] = 1'b0;
    assign proc_2_input_sync_blk[0] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_conv1_1_lane2_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_cnn_read_input_U0_ap_ready);
    assign proc_2_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_2[0] = dl_detect_out ? proc_dep_vld_vec_2_reg[0] : (proc_2_data_FIFO_blk[0] | proc_2_data_PIPO_blk[0] | proc_2_start_FIFO_blk[0] | proc_2_TLF_FIFO_blk[0] | proc_2_input_sync_blk[0] | proc_2_output_sync_blk[0]);
    assign proc_2_data_FIFO_blk[1] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.conv1_1_lane2_mac_U0.grp_conv1_1_lane2_mac_Pipeline_COMPUTE_SPATIAL_COMPUTE_GROUPS_fu_178.s_c11_blk_n);
    assign proc_2_data_PIPO_blk[1] = 1'b0;
    assign proc_2_start_FIFO_blk[1] = 1'b0;
    assign proc_2_TLF_FIFO_blk[1] = 1'b0;
    assign proc_2_input_sync_blk[1] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_conv1_1_lane2_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv1_2_lane2_U0_ap_ready);
    assign proc_2_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_2[1] = dl_detect_out ? proc_dep_vld_vec_2_reg[1] : (proc_2_data_FIFO_blk[1] | proc_2_data_PIPO_blk[1] | proc_2_start_FIFO_blk[1] | proc_2_TLF_FIFO_blk[1] | proc_2_input_sync_blk[1] | proc_2_output_sync_blk[1]);
    assign proc_2_data_FIFO_blk[2] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.conv1_1_lane2_mac_U0.grp_conv1_1_lane2_mac_Pipeline_COMPUTE_SPATIAL_COMPUTE_GROUPS_fu_178.s_c11_blk_n);
    assign proc_2_data_PIPO_blk[2] = 1'b0;
    assign proc_2_start_FIFO_blk[2] = 1'b0;
    assign proc_2_TLF_FIFO_blk[2] = 1'b0;
    assign proc_2_input_sync_blk[2] = 1'b0;
    assign proc_2_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_2[2] = dl_detect_out ? proc_dep_vld_vec_2_reg[2] : (proc_2_data_FIFO_blk[2] | proc_2_data_PIPO_blk[2] | proc_2_start_FIFO_blk[2] | proc_2_TLF_FIFO_blk[2] | proc_2_input_sync_blk[2] | proc_2_output_sync_blk[2]);
    assign proc_2_data_FIFO_blk[3] = 1'b0;
    assign proc_2_data_PIPO_blk[3] = 1'b0;
    assign proc_2_start_FIFO_blk[3] = 1'b0;
    assign proc_2_TLF_FIFO_blk[3] = 1'b0;
    assign proc_2_input_sync_blk[3] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_conv1_1_lane2_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_entry_proc_U0_ap_ready);
    assign proc_2_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_2[3] = dl_detect_out ? proc_dep_vld_vec_2_reg[3] : (proc_2_data_FIFO_blk[3] | proc_2_data_PIPO_blk[3] | proc_2_start_FIFO_blk[3] | proc_2_TLF_FIFO_blk[3] | proc_2_input_sync_blk[3] | proc_2_output_sync_blk[3]);
    assign proc_2_data_FIFO_blk[4] = 1'b0;
    assign proc_2_data_PIPO_blk[4] = 1'b0;
    assign proc_2_start_FIFO_blk[4] = 1'b0;
    assign proc_2_TLF_FIFO_blk[4] = 1'b0;
    assign proc_2_input_sync_blk[4] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_conv1_1_lane2_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv2_1_U0_ap_ready);
    assign proc_2_output_sync_blk[4] = 1'b0;
    assign proc_dep_vld_vec_2[4] = dl_detect_out ? proc_dep_vld_vec_2_reg[4] : (proc_2_data_FIFO_blk[4] | proc_2_data_PIPO_blk[4] | proc_2_start_FIFO_blk[4] | proc_2_TLF_FIFO_blk[4] | proc_2_input_sync_blk[4] | proc_2_output_sync_blk[4]);
    assign proc_2_data_FIFO_blk[5] = 1'b0;
    assign proc_2_data_PIPO_blk[5] = 1'b0;
    assign proc_2_start_FIFO_blk[5] = 1'b0;
    assign proc_2_TLF_FIFO_blk[5] = 1'b0;
    assign proc_2_input_sync_blk[5] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_conv1_1_lane2_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv2_2_U0_ap_ready);
    assign proc_2_output_sync_blk[5] = 1'b0;
    assign proc_dep_vld_vec_2[5] = dl_detect_out ? proc_dep_vld_vec_2_reg[5] : (proc_2_data_FIFO_blk[5] | proc_2_data_PIPO_blk[5] | proc_2_start_FIFO_blk[5] | proc_2_TLF_FIFO_blk[5] | proc_2_input_sync_blk[5] | proc_2_output_sync_blk[5]);
    assign proc_2_data_FIFO_blk[6] = 1'b0;
    assign proc_2_data_PIPO_blk[6] = 1'b0;
    assign proc_2_start_FIFO_blk[6] = 1'b0;
    assign proc_2_TLF_FIFO_blk[6] = 1'b0;
    assign proc_2_input_sync_blk[6] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_conv1_1_lane2_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv3_1_reuse16_U0_ap_ready);
    assign proc_2_output_sync_blk[6] = 1'b0;
    assign proc_dep_vld_vec_2[6] = dl_detect_out ? proc_dep_vld_vec_2_reg[6] : (proc_2_data_FIFO_blk[6] | proc_2_data_PIPO_blk[6] | proc_2_start_FIFO_blk[6] | proc_2_TLF_FIFO_blk[6] | proc_2_input_sync_blk[6] | proc_2_output_sync_blk[6]);
    assign proc_2_data_FIFO_blk[7] = 1'b0;
    assign proc_2_data_PIPO_blk[7] = 1'b0;
    assign proc_2_start_FIFO_blk[7] = 1'b0;
    assign proc_2_TLF_FIFO_blk[7] = 1'b0;
    assign proc_2_input_sync_blk[7] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_conv1_1_lane2_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv3_2_reuse32_U0_ap_ready);
    assign proc_2_output_sync_blk[7] = 1'b0;
    assign proc_dep_vld_vec_2[7] = dl_detect_out ? proc_dep_vld_vec_2_reg[7] : (proc_2_data_FIFO_blk[7] | proc_2_data_PIPO_blk[7] | proc_2_start_FIFO_blk[7] | proc_2_TLF_FIFO_blk[7] | proc_2_input_sync_blk[7] | proc_2_output_sync_blk[7]);
    assign proc_2_data_FIFO_blk[8] = 1'b0;
    assign proc_2_data_PIPO_blk[8] = 1'b0;
    assign proc_2_start_FIFO_blk[8] = 1'b0;
    assign proc_2_TLF_FIFO_blk[8] = 1'b0;
    assign proc_2_input_sync_blk[8] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_conv1_1_lane2_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_classification_head_stream_U0_ap_ready);
    assign proc_2_output_sync_blk[8] = 1'b0;
    assign proc_dep_vld_vec_2[8] = dl_detect_out ? proc_dep_vld_vec_2_reg[8] : (proc_2_data_FIFO_blk[8] | proc_2_data_PIPO_blk[8] | proc_2_start_FIFO_blk[8] | proc_2_TLF_FIFO_blk[8] | proc_2_input_sync_blk[8] | proc_2_output_sync_blk[8]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_2_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_2_reg <= proc_dep_vld_vec_2;
        end
    end
    assign in_chan_dep_vld_vec_2[0] = dep_chan_vld_0_2;
    assign in_chan_dep_data_vec_2[33 : 0] = dep_chan_data_0_2;
    assign token_in_vec_2[0] = token_0_2;
    assign in_chan_dep_vld_vec_2[1] = dep_chan_vld_1_2;
    assign in_chan_dep_data_vec_2[67 : 34] = dep_chan_data_1_2;
    assign token_in_vec_2[1] = token_1_2;
    assign in_chan_dep_vld_vec_2[2] = dep_chan_vld_5_2;
    assign in_chan_dep_data_vec_2[101 : 68] = dep_chan_data_5_2;
    assign token_in_vec_2[2] = token_5_2;
    assign in_chan_dep_vld_vec_2[3] = dep_chan_vld_6_2;
    assign in_chan_dep_data_vec_2[135 : 102] = dep_chan_data_6_2;
    assign token_in_vec_2[3] = token_6_2;
    assign in_chan_dep_vld_vec_2[4] = dep_chan_vld_11_2;
    assign in_chan_dep_data_vec_2[169 : 136] = dep_chan_data_11_2;
    assign token_in_vec_2[4] = token_11_2;
    assign in_chan_dep_vld_vec_2[5] = dep_chan_vld_15_2;
    assign in_chan_dep_data_vec_2[203 : 170] = dep_chan_data_15_2;
    assign token_in_vec_2[5] = token_15_2;
    assign in_chan_dep_vld_vec_2[6] = dep_chan_vld_20_2;
    assign in_chan_dep_data_vec_2[237 : 204] = dep_chan_data_20_2;
    assign token_in_vec_2[6] = token_20_2;
    assign in_chan_dep_vld_vec_2[7] = dep_chan_vld_24_2;
    assign in_chan_dep_data_vec_2[271 : 238] = dep_chan_data_24_2;
    assign token_in_vec_2[7] = token_24_2;
    assign in_chan_dep_vld_vec_2[8] = dep_chan_vld_29_2;
    assign in_chan_dep_data_vec_2[305 : 272] = dep_chan_data_29_2;
    assign token_in_vec_2[8] = token_29_2;
    assign dep_chan_vld_2_1 = out_chan_dep_vld_vec_2[0];
    assign dep_chan_data_2_1 = out_chan_dep_data_2;
    assign token_2_1 = token_out_vec_2[0];
    assign dep_chan_vld_2_5 = out_chan_dep_vld_vec_2[1];
    assign dep_chan_data_2_5 = out_chan_dep_data_2;
    assign token_2_5 = token_out_vec_2[1];
    assign dep_chan_vld_2_6 = out_chan_dep_vld_vec_2[2];
    assign dep_chan_data_2_6 = out_chan_dep_data_2;
    assign token_2_6 = token_out_vec_2[2];
    assign dep_chan_vld_2_0 = out_chan_dep_vld_vec_2[3];
    assign dep_chan_data_2_0 = out_chan_dep_data_2;
    assign token_2_0 = token_out_vec_2[3];
    assign dep_chan_vld_2_11 = out_chan_dep_vld_vec_2[4];
    assign dep_chan_data_2_11 = out_chan_dep_data_2;
    assign token_2_11 = token_out_vec_2[4];
    assign dep_chan_vld_2_15 = out_chan_dep_vld_vec_2[5];
    assign dep_chan_data_2_15 = out_chan_dep_data_2;
    assign token_2_15 = token_out_vec_2[5];
    assign dep_chan_vld_2_20 = out_chan_dep_vld_vec_2[6];
    assign dep_chan_data_2_20 = out_chan_dep_data_2;
    assign token_2_20 = token_out_vec_2[6];
    assign dep_chan_vld_2_24 = out_chan_dep_vld_vec_2[7];
    assign dep_chan_data_2_24 = out_chan_dep_data_2;
    assign token_2_24 = token_out_vec_2[7];
    assign dep_chan_vld_2_29 = out_chan_dep_vld_vec_2[8];
    assign dep_chan_data_2_29 = out_chan_dep_data_2;
    assign token_2_29 = token_out_vec_2[8];

    // Process: grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.conv1_1_lane2_windows_U0
    cnn_hls_deadlock_detect_unit #(34, 3, 2, 2) cnn_hls_deadlock_detect_unit_3 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_3),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_3),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_3),
        .token_in_vec(token_in_vec_3),
        .dl_detect_in(dl_detect_out),
        .origin(origin[3]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_3),
        .out_chan_dep_data(out_chan_dep_data_3),
        .token_out_vec(token_out_vec_3),
        .dl_detect_out(dl_in_vec[3]));

    assign proc_3_data_FIFO_blk[0] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.conv1_1_lane2_windows_U0.in_stream_blk_n);
    assign proc_3_data_PIPO_blk[0] = 1'b0;
    assign proc_3_start_FIFO_blk[0] = 1'b0;
    assign proc_3_TLF_FIFO_blk[0] = 1'b0;
    assign proc_3_input_sync_blk[0] = 1'b0;
    assign proc_3_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_3[0] = dl_detect_out ? proc_dep_vld_vec_3_reg[0] : (proc_3_data_FIFO_blk[0] | proc_3_data_PIPO_blk[0] | proc_3_start_FIFO_blk[0] | proc_3_TLF_FIFO_blk[0] | proc_3_input_sync_blk[0] | proc_3_output_sync_blk[0]);
    assign proc_3_data_FIFO_blk[1] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.conv1_1_lane2_windows_U0.windows_blk_n);
    assign proc_3_data_PIPO_blk[1] = 1'b0;
    assign proc_3_start_FIFO_blk[1] = 1'b0;
    assign proc_3_TLF_FIFO_blk[1] = 1'b0;
    assign proc_3_input_sync_blk[1] = 1'b0 | (grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.ap_sync_conv1_1_lane2_windows_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.conv1_1_lane2_windows_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.ap_sync_conv1_1_lane2_mac_U0_ap_ready);
    assign proc_3_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_3[1] = dl_detect_out ? proc_dep_vld_vec_3_reg[1] : (proc_3_data_FIFO_blk[1] | proc_3_data_PIPO_blk[1] | proc_3_start_FIFO_blk[1] | proc_3_TLF_FIFO_blk[1] | proc_3_input_sync_blk[1] | proc_3_output_sync_blk[1]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_3_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_3_reg <= proc_dep_vld_vec_3;
        end
    end
    assign in_chan_dep_vld_vec_3[0] = dep_chan_vld_1_3;
    assign in_chan_dep_data_vec_3[33 : 0] = dep_chan_data_1_3;
    assign token_in_vec_3[0] = token_1_3;
    assign in_chan_dep_vld_vec_3[1] = dep_chan_vld_4_3;
    assign in_chan_dep_data_vec_3[67 : 34] = dep_chan_data_4_3;
    assign token_in_vec_3[1] = token_4_3;
    assign dep_chan_vld_3_1 = out_chan_dep_vld_vec_3[0];
    assign dep_chan_data_3_1 = out_chan_dep_data_3;
    assign token_3_1 = token_out_vec_3[0];
    assign dep_chan_vld_3_4 = out_chan_dep_vld_vec_3[1];
    assign dep_chan_data_3_4 = out_chan_dep_data_3;
    assign token_3_4 = token_out_vec_3[1];

    // Process: grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.conv1_1_lane2_mac_U0
    cnn_hls_deadlock_detect_unit #(34, 4, 3, 3) cnn_hls_deadlock_detect_unit_4 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_4),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_4),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_4),
        .token_in_vec(token_in_vec_4),
        .dl_detect_in(dl_detect_out),
        .origin(origin[4]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_4),
        .out_chan_dep_data(out_chan_dep_data_4),
        .token_out_vec(token_out_vec_4),
        .dl_detect_out(dl_in_vec[4]));

    assign proc_4_data_FIFO_blk[0] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.conv1_1_lane2_mac_U0.grp_conv1_1_lane2_mac_Pipeline_COMPUTE_SPATIAL_COMPUTE_GROUPS_fu_178.windows_blk_n);
    assign proc_4_data_PIPO_blk[0] = 1'b0;
    assign proc_4_start_FIFO_blk[0] = 1'b0;
    assign proc_4_TLF_FIFO_blk[0] = 1'b0;
    assign proc_4_input_sync_blk[0] = 1'b0 | (grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.ap_sync_conv1_1_lane2_mac_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.conv1_1_lane2_mac_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.ap_sync_conv1_1_lane2_windows_U0_ap_ready);
    assign proc_4_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_4[0] = dl_detect_out ? proc_dep_vld_vec_4_reg[0] : (proc_4_data_FIFO_blk[0] | proc_4_data_PIPO_blk[0] | proc_4_start_FIFO_blk[0] | proc_4_TLF_FIFO_blk[0] | proc_4_input_sync_blk[0] | proc_4_output_sync_blk[0]);
    assign proc_4_data_FIFO_blk[1] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.conv1_1_lane2_mac_U0.grp_conv1_1_lane2_mac_Pipeline_COMPUTE_SPATIAL_COMPUTE_GROUPS_fu_178.s_c11_blk_n);
    assign proc_4_data_PIPO_blk[1] = 1'b0;
    assign proc_4_start_FIFO_blk[1] = 1'b0;
    assign proc_4_TLF_FIFO_blk[1] = 1'b0;
    assign proc_4_input_sync_blk[1] = 1'b0;
    assign proc_4_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_4[1] = dl_detect_out ? proc_dep_vld_vec_4_reg[1] : (proc_4_data_FIFO_blk[1] | proc_4_data_PIPO_blk[1] | proc_4_start_FIFO_blk[1] | proc_4_TLF_FIFO_blk[1] | proc_4_input_sync_blk[1] | proc_4_output_sync_blk[1]);
    assign proc_4_data_FIFO_blk[2] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.conv1_1_lane2_mac_U0.grp_conv1_1_lane2_mac_Pipeline_COMPUTE_SPATIAL_COMPUTE_GROUPS_fu_178.s_c11_blk_n);
    assign proc_4_data_PIPO_blk[2] = 1'b0;
    assign proc_4_start_FIFO_blk[2] = 1'b0;
    assign proc_4_TLF_FIFO_blk[2] = 1'b0;
    assign proc_4_input_sync_blk[2] = 1'b0;
    assign proc_4_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_4[2] = dl_detect_out ? proc_dep_vld_vec_4_reg[2] : (proc_4_data_FIFO_blk[2] | proc_4_data_PIPO_blk[2] | proc_4_start_FIFO_blk[2] | proc_4_TLF_FIFO_blk[2] | proc_4_input_sync_blk[2] | proc_4_output_sync_blk[2]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_4_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_4_reg <= proc_dep_vld_vec_4;
        end
    end
    assign in_chan_dep_vld_vec_4[0] = dep_chan_vld_3_4;
    assign in_chan_dep_data_vec_4[33 : 0] = dep_chan_data_3_4;
    assign token_in_vec_4[0] = token_3_4;
    assign in_chan_dep_vld_vec_4[1] = dep_chan_vld_5_4;
    assign in_chan_dep_data_vec_4[67 : 34] = dep_chan_data_5_4;
    assign token_in_vec_4[1] = token_5_4;
    assign in_chan_dep_vld_vec_4[2] = dep_chan_vld_6_4;
    assign in_chan_dep_data_vec_4[101 : 68] = dep_chan_data_6_4;
    assign token_in_vec_4[2] = token_6_4;
    assign dep_chan_vld_4_3 = out_chan_dep_vld_vec_4[0];
    assign dep_chan_data_4_3 = out_chan_dep_data_4;
    assign token_4_3 = token_out_vec_4[0];
    assign dep_chan_vld_4_5 = out_chan_dep_vld_vec_4[1];
    assign dep_chan_data_4_5 = out_chan_dep_data_4;
    assign token_4_5 = token_out_vec_4[1];
    assign dep_chan_vld_4_6 = out_chan_dep_vld_vec_4[2];
    assign dep_chan_data_4_6 = out_chan_dep_data_4;
    assign token_4_6 = token_out_vec_4[2];

    // Process: grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0
    cnn_hls_deadlock_detect_unit #(34, 5, 10, 10) cnn_hls_deadlock_detect_unit_5 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_5),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_5),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_5),
        .token_in_vec(token_in_vec_5),
        .dl_detect_in(dl_detect_out),
        .origin(origin[5]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_5),
        .out_chan_dep_data(out_chan_dep_data_5),
        .token_out_vec(token_out_vec_5),
        .dl_detect_out(dl_in_vec[5]));

    assign proc_5_data_FIFO_blk[0] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_windows_U0.s_c11_blk_n);
    assign proc_5_data_PIPO_blk[0] = 1'b0;
    assign proc_5_start_FIFO_blk[0] = 1'b0;
    assign proc_5_TLF_FIFO_blk[0] = 1'b0;
    assign proc_5_input_sync_blk[0] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_conv1_2_lane2_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv1_1_lane2_U0_ap_ready);
    assign proc_5_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_5[0] = dl_detect_out ? proc_dep_vld_vec_5_reg[0] : (proc_5_data_FIFO_blk[0] | proc_5_data_PIPO_blk[0] | proc_5_start_FIFO_blk[0] | proc_5_TLF_FIFO_blk[0] | proc_5_input_sync_blk[0] | proc_5_output_sync_blk[0]);
    assign proc_5_data_FIFO_blk[1] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_windows_U0.s_c11_blk_n);
    assign proc_5_data_PIPO_blk[1] = 1'b0;
    assign proc_5_start_FIFO_blk[1] = 1'b0;
    assign proc_5_TLF_FIFO_blk[1] = 1'b0;
    assign proc_5_input_sync_blk[1] = 1'b0;
    assign proc_5_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_5[1] = dl_detect_out ? proc_dep_vld_vec_5_reg[1] : (proc_5_data_FIFO_blk[1] | proc_5_data_PIPO_blk[1] | proc_5_start_FIFO_blk[1] | proc_5_TLF_FIFO_blk[1] | proc_5_input_sync_blk[1] | proc_5_output_sync_blk[1]);
    assign proc_5_data_FIFO_blk[2] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_mac_U0.grp_conv1_2_lane2_mac_Pipeline_COMPUTE_SPATIAL_COMPUTE_GROUPS_fu_238.s_c12_blk_n);
    assign proc_5_data_PIPO_blk[2] = 1'b0;
    assign proc_5_start_FIFO_blk[2] = 1'b0 | (~grp_cnn_pipeline_fu_1933.start_for_maxpool1_lane2_U0_U.if_full_n & grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.ap_start & ~grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.real_start & (trans_in_cnt_1 == trans_out_cnt_1) & ~grp_cnn_pipeline_fu_1933.start_for_maxpool1_lane2_U0_U.if_read);
    assign proc_5_TLF_FIFO_blk[2] = 1'b0;
    assign proc_5_input_sync_blk[2] = 1'b0;
    assign proc_5_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_5[2] = dl_detect_out ? proc_dep_vld_vec_5_reg[2] : (proc_5_data_FIFO_blk[2] | proc_5_data_PIPO_blk[2] | proc_5_start_FIFO_blk[2] | proc_5_TLF_FIFO_blk[2] | proc_5_input_sync_blk[2] | proc_5_output_sync_blk[2]);
    assign proc_5_data_FIFO_blk[3] = 1'b0;
    assign proc_5_data_PIPO_blk[3] = 1'b0;
    assign proc_5_start_FIFO_blk[3] = 1'b0;
    assign proc_5_TLF_FIFO_blk[3] = 1'b0;
    assign proc_5_input_sync_blk[3] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_conv1_2_lane2_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_entry_proc_U0_ap_ready);
    assign proc_5_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_5[3] = dl_detect_out ? proc_dep_vld_vec_5_reg[3] : (proc_5_data_FIFO_blk[3] | proc_5_data_PIPO_blk[3] | proc_5_start_FIFO_blk[3] | proc_5_TLF_FIFO_blk[3] | proc_5_input_sync_blk[3] | proc_5_output_sync_blk[3]);
    assign proc_5_data_FIFO_blk[4] = 1'b0;
    assign proc_5_data_PIPO_blk[4] = 1'b0;
    assign proc_5_start_FIFO_blk[4] = 1'b0;
    assign proc_5_TLF_FIFO_blk[4] = 1'b0;
    assign proc_5_input_sync_blk[4] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_conv1_2_lane2_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_cnn_read_input_U0_ap_ready);
    assign proc_5_output_sync_blk[4] = 1'b0;
    assign proc_dep_vld_vec_5[4] = dl_detect_out ? proc_dep_vld_vec_5_reg[4] : (proc_5_data_FIFO_blk[4] | proc_5_data_PIPO_blk[4] | proc_5_start_FIFO_blk[4] | proc_5_TLF_FIFO_blk[4] | proc_5_input_sync_blk[4] | proc_5_output_sync_blk[4]);
    assign proc_5_data_FIFO_blk[5] = 1'b0;
    assign proc_5_data_PIPO_blk[5] = 1'b0;
    assign proc_5_start_FIFO_blk[5] = 1'b0;
    assign proc_5_TLF_FIFO_blk[5] = 1'b0;
    assign proc_5_input_sync_blk[5] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_conv1_2_lane2_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv2_1_U0_ap_ready);
    assign proc_5_output_sync_blk[5] = 1'b0;
    assign proc_dep_vld_vec_5[5] = dl_detect_out ? proc_dep_vld_vec_5_reg[5] : (proc_5_data_FIFO_blk[5] | proc_5_data_PIPO_blk[5] | proc_5_start_FIFO_blk[5] | proc_5_TLF_FIFO_blk[5] | proc_5_input_sync_blk[5] | proc_5_output_sync_blk[5]);
    assign proc_5_data_FIFO_blk[6] = 1'b0;
    assign proc_5_data_PIPO_blk[6] = 1'b0;
    assign proc_5_start_FIFO_blk[6] = 1'b0;
    assign proc_5_TLF_FIFO_blk[6] = 1'b0;
    assign proc_5_input_sync_blk[6] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_conv1_2_lane2_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv2_2_U0_ap_ready);
    assign proc_5_output_sync_blk[6] = 1'b0;
    assign proc_dep_vld_vec_5[6] = dl_detect_out ? proc_dep_vld_vec_5_reg[6] : (proc_5_data_FIFO_blk[6] | proc_5_data_PIPO_blk[6] | proc_5_start_FIFO_blk[6] | proc_5_TLF_FIFO_blk[6] | proc_5_input_sync_blk[6] | proc_5_output_sync_blk[6]);
    assign proc_5_data_FIFO_blk[7] = 1'b0;
    assign proc_5_data_PIPO_blk[7] = 1'b0;
    assign proc_5_start_FIFO_blk[7] = 1'b0;
    assign proc_5_TLF_FIFO_blk[7] = 1'b0;
    assign proc_5_input_sync_blk[7] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_conv1_2_lane2_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv3_1_reuse16_U0_ap_ready);
    assign proc_5_output_sync_blk[7] = 1'b0;
    assign proc_dep_vld_vec_5[7] = dl_detect_out ? proc_dep_vld_vec_5_reg[7] : (proc_5_data_FIFO_blk[7] | proc_5_data_PIPO_blk[7] | proc_5_start_FIFO_blk[7] | proc_5_TLF_FIFO_blk[7] | proc_5_input_sync_blk[7] | proc_5_output_sync_blk[7]);
    assign proc_5_data_FIFO_blk[8] = 1'b0;
    assign proc_5_data_PIPO_blk[8] = 1'b0;
    assign proc_5_start_FIFO_blk[8] = 1'b0;
    assign proc_5_TLF_FIFO_blk[8] = 1'b0;
    assign proc_5_input_sync_blk[8] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_conv1_2_lane2_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv3_2_reuse32_U0_ap_ready);
    assign proc_5_output_sync_blk[8] = 1'b0;
    assign proc_dep_vld_vec_5[8] = dl_detect_out ? proc_dep_vld_vec_5_reg[8] : (proc_5_data_FIFO_blk[8] | proc_5_data_PIPO_blk[8] | proc_5_start_FIFO_blk[8] | proc_5_TLF_FIFO_blk[8] | proc_5_input_sync_blk[8] | proc_5_output_sync_blk[8]);
    assign proc_5_data_FIFO_blk[9] = 1'b0;
    assign proc_5_data_PIPO_blk[9] = 1'b0;
    assign proc_5_start_FIFO_blk[9] = 1'b0;
    assign proc_5_TLF_FIFO_blk[9] = 1'b0;
    assign proc_5_input_sync_blk[9] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_conv1_2_lane2_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_classification_head_stream_U0_ap_ready);
    assign proc_5_output_sync_blk[9] = 1'b0;
    assign proc_dep_vld_vec_5[9] = dl_detect_out ? proc_dep_vld_vec_5_reg[9] : (proc_5_data_FIFO_blk[9] | proc_5_data_PIPO_blk[9] | proc_5_start_FIFO_blk[9] | proc_5_TLF_FIFO_blk[9] | proc_5_input_sync_blk[9] | proc_5_output_sync_blk[9]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_5_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_5_reg <= proc_dep_vld_vec_5;
        end
    end
    assign in_chan_dep_vld_vec_5[0] = dep_chan_vld_0_5;
    assign in_chan_dep_data_vec_5[33 : 0] = dep_chan_data_0_5;
    assign token_in_vec_5[0] = token_0_5;
    assign in_chan_dep_vld_vec_5[1] = dep_chan_vld_1_5;
    assign in_chan_dep_data_vec_5[67 : 34] = dep_chan_data_1_5;
    assign token_in_vec_5[1] = token_1_5;
    assign in_chan_dep_vld_vec_5[2] = dep_chan_vld_2_5;
    assign in_chan_dep_data_vec_5[101 : 68] = dep_chan_data_2_5;
    assign token_in_vec_5[2] = token_2_5;
    assign in_chan_dep_vld_vec_5[3] = dep_chan_vld_4_5;
    assign in_chan_dep_data_vec_5[135 : 102] = dep_chan_data_4_5;
    assign token_in_vec_5[3] = token_4_5;
    assign in_chan_dep_vld_vec_5[4] = dep_chan_vld_9_5;
    assign in_chan_dep_data_vec_5[169 : 136] = dep_chan_data_9_5;
    assign token_in_vec_5[4] = token_9_5;
    assign in_chan_dep_vld_vec_5[5] = dep_chan_vld_11_5;
    assign in_chan_dep_data_vec_5[203 : 170] = dep_chan_data_11_5;
    assign token_in_vec_5[5] = token_11_5;
    assign in_chan_dep_vld_vec_5[6] = dep_chan_vld_15_5;
    assign in_chan_dep_data_vec_5[237 : 204] = dep_chan_data_15_5;
    assign token_in_vec_5[6] = token_15_5;
    assign in_chan_dep_vld_vec_5[7] = dep_chan_vld_20_5;
    assign in_chan_dep_data_vec_5[271 : 238] = dep_chan_data_20_5;
    assign token_in_vec_5[7] = token_20_5;
    assign in_chan_dep_vld_vec_5[8] = dep_chan_vld_24_5;
    assign in_chan_dep_data_vec_5[305 : 272] = dep_chan_data_24_5;
    assign token_in_vec_5[8] = token_24_5;
    assign in_chan_dep_vld_vec_5[9] = dep_chan_vld_29_5;
    assign in_chan_dep_data_vec_5[339 : 306] = dep_chan_data_29_5;
    assign token_in_vec_5[9] = token_29_5;
    assign dep_chan_vld_5_2 = out_chan_dep_vld_vec_5[0];
    assign dep_chan_data_5_2 = out_chan_dep_data_5;
    assign token_5_2 = token_out_vec_5[0];
    assign dep_chan_vld_5_4 = out_chan_dep_vld_vec_5[1];
    assign dep_chan_data_5_4 = out_chan_dep_data_5;
    assign token_5_4 = token_out_vec_5[1];
    assign dep_chan_vld_5_9 = out_chan_dep_vld_vec_5[2];
    assign dep_chan_data_5_9 = out_chan_dep_data_5;
    assign token_5_9 = token_out_vec_5[2];
    assign dep_chan_vld_5_0 = out_chan_dep_vld_vec_5[3];
    assign dep_chan_data_5_0 = out_chan_dep_data_5;
    assign token_5_0 = token_out_vec_5[3];
    assign dep_chan_vld_5_1 = out_chan_dep_vld_vec_5[4];
    assign dep_chan_data_5_1 = out_chan_dep_data_5;
    assign token_5_1 = token_out_vec_5[4];
    assign dep_chan_vld_5_11 = out_chan_dep_vld_vec_5[5];
    assign dep_chan_data_5_11 = out_chan_dep_data_5;
    assign token_5_11 = token_out_vec_5[5];
    assign dep_chan_vld_5_15 = out_chan_dep_vld_vec_5[6];
    assign dep_chan_data_5_15 = out_chan_dep_data_5;
    assign token_5_15 = token_out_vec_5[6];
    assign dep_chan_vld_5_20 = out_chan_dep_vld_vec_5[7];
    assign dep_chan_data_5_20 = out_chan_dep_data_5;
    assign token_5_20 = token_out_vec_5[7];
    assign dep_chan_vld_5_24 = out_chan_dep_vld_vec_5[8];
    assign dep_chan_data_5_24 = out_chan_dep_data_5;
    assign token_5_24 = token_out_vec_5[8];
    assign dep_chan_vld_5_29 = out_chan_dep_vld_vec_5[9];
    assign dep_chan_data_5_29 = out_chan_dep_data_5;
    assign token_5_29 = token_out_vec_5[9];

    // Process: grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_windows_U0
    cnn_hls_deadlock_detect_unit #(34, 6, 4, 4) cnn_hls_deadlock_detect_unit_6 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_6),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_6),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_6),
        .token_in_vec(token_in_vec_6),
        .dl_detect_in(dl_detect_out),
        .origin(origin[6]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_6),
        .out_chan_dep_data(out_chan_dep_data_6),
        .token_out_vec(token_out_vec_6),
        .dl_detect_out(dl_in_vec[6]));

    assign proc_6_data_FIFO_blk[0] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_windows_U0.s_c11_blk_n);
    assign proc_6_data_PIPO_blk[0] = 1'b0;
    assign proc_6_start_FIFO_blk[0] = 1'b0;
    assign proc_6_TLF_FIFO_blk[0] = 1'b0;
    assign proc_6_input_sync_blk[0] = 1'b0;
    assign proc_6_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_6[0] = dl_detect_out ? proc_dep_vld_vec_6_reg[0] : (proc_6_data_FIFO_blk[0] | proc_6_data_PIPO_blk[0] | proc_6_start_FIFO_blk[0] | proc_6_TLF_FIFO_blk[0] | proc_6_input_sync_blk[0] | proc_6_output_sync_blk[0]);
    assign proc_6_data_FIFO_blk[1] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_windows_U0.s_c11_blk_n);
    assign proc_6_data_PIPO_blk[1] = 1'b0;
    assign proc_6_start_FIFO_blk[1] = 1'b0;
    assign proc_6_TLF_FIFO_blk[1] = 1'b0;
    assign proc_6_input_sync_blk[1] = 1'b0;
    assign proc_6_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_6[1] = dl_detect_out ? proc_dep_vld_vec_6_reg[1] : (proc_6_data_FIFO_blk[1] | proc_6_data_PIPO_blk[1] | proc_6_start_FIFO_blk[1] | proc_6_TLF_FIFO_blk[1] | proc_6_input_sync_blk[1] | proc_6_output_sync_blk[1]);
    assign proc_6_data_FIFO_blk[2] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_windows_U0.windows_blk_n);
    assign proc_6_data_PIPO_blk[2] = 1'b0;
    assign proc_6_start_FIFO_blk[2] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.start_for_conv1_2_lane2_pack_windows_U0_U.if_full_n & grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_windows_U0.ap_start & ~grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_windows_U0.real_start & (trans_in_cnt_0 == trans_out_cnt_0) & ~grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.start_for_conv1_2_lane2_pack_windows_U0_U.if_read);
    assign proc_6_TLF_FIFO_blk[2] = 1'b0;
    assign proc_6_input_sync_blk[2] = 1'b0;
    assign proc_6_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_6[2] = dl_detect_out ? proc_dep_vld_vec_6_reg[2] : (proc_6_data_FIFO_blk[2] | proc_6_data_PIPO_blk[2] | proc_6_start_FIFO_blk[2] | proc_6_TLF_FIFO_blk[2] | proc_6_input_sync_blk[2] | proc_6_output_sync_blk[2]);
    assign proc_6_data_FIFO_blk[3] = 1'b0;
    assign proc_6_data_PIPO_blk[3] = 1'b0;
    assign proc_6_start_FIFO_blk[3] = 1'b0;
    assign proc_6_TLF_FIFO_blk[3] = 1'b0;
    assign proc_6_input_sync_blk[3] = 1'b0 | (grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.ap_sync_conv1_2_lane2_windows_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_windows_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.ap_sync_conv1_2_lane2_mac_U0_ap_ready);
    assign proc_6_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_6[3] = dl_detect_out ? proc_dep_vld_vec_6_reg[3] : (proc_6_data_FIFO_blk[3] | proc_6_data_PIPO_blk[3] | proc_6_start_FIFO_blk[3] | proc_6_TLF_FIFO_blk[3] | proc_6_input_sync_blk[3] | proc_6_output_sync_blk[3]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_6_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_6_reg <= proc_dep_vld_vec_6;
        end
    end
    assign in_chan_dep_vld_vec_6[0] = dep_chan_vld_2_6;
    assign in_chan_dep_data_vec_6[33 : 0] = dep_chan_data_2_6;
    assign token_in_vec_6[0] = token_2_6;
    assign in_chan_dep_vld_vec_6[1] = dep_chan_vld_4_6;
    assign in_chan_dep_data_vec_6[67 : 34] = dep_chan_data_4_6;
    assign token_in_vec_6[1] = token_4_6;
    assign in_chan_dep_vld_vec_6[2] = dep_chan_vld_7_6;
    assign in_chan_dep_data_vec_6[101 : 68] = dep_chan_data_7_6;
    assign token_in_vec_6[2] = token_7_6;
    assign in_chan_dep_vld_vec_6[3] = dep_chan_vld_8_6;
    assign in_chan_dep_data_vec_6[135 : 102] = dep_chan_data_8_6;
    assign token_in_vec_6[3] = token_8_6;
    assign dep_chan_vld_6_2 = out_chan_dep_vld_vec_6[0];
    assign dep_chan_data_6_2 = out_chan_dep_data_6;
    assign token_6_2 = token_out_vec_6[0];
    assign dep_chan_vld_6_4 = out_chan_dep_vld_vec_6[1];
    assign dep_chan_data_6_4 = out_chan_dep_data_6;
    assign token_6_4 = token_out_vec_6[1];
    assign dep_chan_vld_6_7 = out_chan_dep_vld_vec_6[2];
    assign dep_chan_data_6_7 = out_chan_dep_data_6;
    assign token_6_7 = token_out_vec_6[2];
    assign dep_chan_vld_6_8 = out_chan_dep_vld_vec_6[3];
    assign dep_chan_data_6_8 = out_chan_dep_data_6;
    assign token_6_8 = token_out_vec_6[3];

    // Process: grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_pack_windows_U0
    cnn_hls_deadlock_detect_unit #(34, 7, 2, 2) cnn_hls_deadlock_detect_unit_7 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_7),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_7),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_7),
        .token_in_vec(token_in_vec_7),
        .dl_detect_in(dl_detect_out),
        .origin(origin[7]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_7),
        .out_chan_dep_data(out_chan_dep_data_7),
        .token_out_vec(token_out_vec_7),
        .dl_detect_out(dl_in_vec[7]));

    assign proc_7_data_FIFO_blk[0] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_pack_windows_U0.windows_blk_n);
    assign proc_7_data_PIPO_blk[0] = 1'b0;
    assign proc_7_start_FIFO_blk[0] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.start_for_conv1_2_lane2_pack_windows_U0_U.if_empty_n & grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_pack_windows_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.start_for_conv1_2_lane2_pack_windows_U0_U.if_write);
    assign proc_7_TLF_FIFO_blk[0] = 1'b0;
    assign proc_7_input_sync_blk[0] = 1'b0;
    assign proc_7_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_7[0] = dl_detect_out ? proc_dep_vld_vec_7_reg[0] : (proc_7_data_FIFO_blk[0] | proc_7_data_PIPO_blk[0] | proc_7_start_FIFO_blk[0] | proc_7_TLF_FIFO_blk[0] | proc_7_input_sync_blk[0] | proc_7_output_sync_blk[0]);
    assign proc_7_data_FIFO_blk[1] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_pack_windows_U0.window_sets_blk_n);
    assign proc_7_data_PIPO_blk[1] = 1'b0;
    assign proc_7_start_FIFO_blk[1] = 1'b0;
    assign proc_7_TLF_FIFO_blk[1] = 1'b0;
    assign proc_7_input_sync_blk[1] = 1'b0;
    assign proc_7_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_7[1] = dl_detect_out ? proc_dep_vld_vec_7_reg[1] : (proc_7_data_FIFO_blk[1] | proc_7_data_PIPO_blk[1] | proc_7_start_FIFO_blk[1] | proc_7_TLF_FIFO_blk[1] | proc_7_input_sync_blk[1] | proc_7_output_sync_blk[1]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_7_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_7_reg <= proc_dep_vld_vec_7;
        end
    end
    assign in_chan_dep_vld_vec_7[0] = dep_chan_vld_6_7;
    assign in_chan_dep_data_vec_7[33 : 0] = dep_chan_data_6_7;
    assign token_in_vec_7[0] = token_6_7;
    assign in_chan_dep_vld_vec_7[1] = dep_chan_vld_8_7;
    assign in_chan_dep_data_vec_7[67 : 34] = dep_chan_data_8_7;
    assign token_in_vec_7[1] = token_8_7;
    assign dep_chan_vld_7_6 = out_chan_dep_vld_vec_7[0];
    assign dep_chan_data_7_6 = out_chan_dep_data_7;
    assign token_7_6 = token_out_vec_7[0];
    assign dep_chan_vld_7_8 = out_chan_dep_vld_vec_7[1];
    assign dep_chan_data_7_8 = out_chan_dep_data_7;
    assign token_7_8 = token_out_vec_7[1];

    // Process: grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_mac_U0
    cnn_hls_deadlock_detect_unit #(34, 8, 3, 3) cnn_hls_deadlock_detect_unit_8 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_8),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_8),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_8),
        .token_in_vec(token_in_vec_8),
        .dl_detect_in(dl_detect_out),
        .origin(origin[8]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_8),
        .out_chan_dep_data(out_chan_dep_data_8),
        .token_out_vec(token_out_vec_8),
        .dl_detect_out(dl_in_vec[8]));

    assign proc_8_data_FIFO_blk[0] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_mac_U0.grp_conv1_2_lane2_mac_Pipeline_COMPUTE_SPATIAL_COMPUTE_GROUPS_fu_238.window_sets_blk_n);
    assign proc_8_data_PIPO_blk[0] = 1'b0;
    assign proc_8_start_FIFO_blk[0] = 1'b0;
    assign proc_8_TLF_FIFO_blk[0] = 1'b0;
    assign proc_8_input_sync_blk[0] = 1'b0;
    assign proc_8_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_8[0] = dl_detect_out ? proc_dep_vld_vec_8_reg[0] : (proc_8_data_FIFO_blk[0] | proc_8_data_PIPO_blk[0] | proc_8_start_FIFO_blk[0] | proc_8_TLF_FIFO_blk[0] | proc_8_input_sync_blk[0] | proc_8_output_sync_blk[0]);
    assign proc_8_data_FIFO_blk[1] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_mac_U0.grp_conv1_2_lane2_mac_Pipeline_COMPUTE_SPATIAL_COMPUTE_GROUPS_fu_238.s_c12_blk_n);
    assign proc_8_data_PIPO_blk[1] = 1'b0;
    assign proc_8_start_FIFO_blk[1] = 1'b0;
    assign proc_8_TLF_FIFO_blk[1] = 1'b0;
    assign proc_8_input_sync_blk[1] = 1'b0;
    assign proc_8_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_8[1] = dl_detect_out ? proc_dep_vld_vec_8_reg[1] : (proc_8_data_FIFO_blk[1] | proc_8_data_PIPO_blk[1] | proc_8_start_FIFO_blk[1] | proc_8_TLF_FIFO_blk[1] | proc_8_input_sync_blk[1] | proc_8_output_sync_blk[1]);
    assign proc_8_data_FIFO_blk[2] = 1'b0;
    assign proc_8_data_PIPO_blk[2] = 1'b0;
    assign proc_8_start_FIFO_blk[2] = 1'b0;
    assign proc_8_TLF_FIFO_blk[2] = 1'b0;
    assign proc_8_input_sync_blk[2] = 1'b0 | (grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.ap_sync_conv1_2_lane2_mac_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_mac_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.ap_sync_conv1_2_lane2_windows_U0_ap_ready);
    assign proc_8_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_8[2] = dl_detect_out ? proc_dep_vld_vec_8_reg[2] : (proc_8_data_FIFO_blk[2] | proc_8_data_PIPO_blk[2] | proc_8_start_FIFO_blk[2] | proc_8_TLF_FIFO_blk[2] | proc_8_input_sync_blk[2] | proc_8_output_sync_blk[2]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_8_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_8_reg <= proc_dep_vld_vec_8;
        end
    end
    assign in_chan_dep_vld_vec_8[0] = dep_chan_vld_6_8;
    assign in_chan_dep_data_vec_8[33 : 0] = dep_chan_data_6_8;
    assign token_in_vec_8[0] = token_6_8;
    assign in_chan_dep_vld_vec_8[1] = dep_chan_vld_7_8;
    assign in_chan_dep_data_vec_8[67 : 34] = dep_chan_data_7_8;
    assign token_in_vec_8[1] = token_7_8;
    assign in_chan_dep_vld_vec_8[2] = dep_chan_vld_9_8;
    assign in_chan_dep_data_vec_8[101 : 68] = dep_chan_data_9_8;
    assign token_in_vec_8[2] = token_9_8;
    assign dep_chan_vld_8_7 = out_chan_dep_vld_vec_8[0];
    assign dep_chan_data_8_7 = out_chan_dep_data_8;
    assign token_8_7 = token_out_vec_8[0];
    assign dep_chan_vld_8_9 = out_chan_dep_vld_vec_8[1];
    assign dep_chan_data_8_9 = out_chan_dep_data_8;
    assign token_8_9 = token_out_vec_8[1];
    assign dep_chan_vld_8_6 = out_chan_dep_vld_vec_8[2];
    assign dep_chan_data_8_6 = out_chan_dep_data_8;
    assign token_8_6 = token_out_vec_8[2];

    // Process: grp_cnn_pipeline_fu_1933.maxpool1_lane2_U0
    cnn_hls_deadlock_detect_unit #(34, 9, 3, 3) cnn_hls_deadlock_detect_unit_9 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_9),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_9),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_9),
        .token_in_vec(token_in_vec_9),
        .dl_detect_in(dl_detect_out),
        .origin(origin[9]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_9),
        .out_chan_dep_data(out_chan_dep_data_9),
        .token_out_vec(token_out_vec_9),
        .dl_detect_out(dl_in_vec[9]));

    assign proc_9_data_FIFO_blk[0] = 1'b0 | (~grp_cnn_pipeline_fu_1933.maxpool1_lane2_U0.s_c12_blk_n);
    assign proc_9_data_PIPO_blk[0] = 1'b0;
    assign proc_9_start_FIFO_blk[0] = 1'b0 | (~grp_cnn_pipeline_fu_1933.start_for_maxpool1_lane2_U0_U.if_empty_n & grp_cnn_pipeline_fu_1933.maxpool1_lane2_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.start_for_maxpool1_lane2_U0_U.if_write);
    assign proc_9_TLF_FIFO_blk[0] = 1'b0;
    assign proc_9_input_sync_blk[0] = 1'b0;
    assign proc_9_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_9[0] = dl_detect_out ? proc_dep_vld_vec_9_reg[0] : (proc_9_data_FIFO_blk[0] | proc_9_data_PIPO_blk[0] | proc_9_start_FIFO_blk[0] | proc_9_TLF_FIFO_blk[0] | proc_9_input_sync_blk[0] | proc_9_output_sync_blk[0]);
    assign proc_9_data_FIFO_blk[1] = 1'b0 | (~grp_cnn_pipeline_fu_1933.maxpool1_lane2_U0.s_c12_blk_n);
    assign proc_9_data_PIPO_blk[1] = 1'b0;
    assign proc_9_start_FIFO_blk[1] = 1'b0;
    assign proc_9_TLF_FIFO_blk[1] = 1'b0;
    assign proc_9_input_sync_blk[1] = 1'b0;
    assign proc_9_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_9[1] = dl_detect_out ? proc_dep_vld_vec_9_reg[1] : (proc_9_data_FIFO_blk[1] | proc_9_data_PIPO_blk[1] | proc_9_start_FIFO_blk[1] | proc_9_TLF_FIFO_blk[1] | proc_9_input_sync_blk[1] | proc_9_output_sync_blk[1]);
    assign proc_9_data_FIFO_blk[2] = 1'b0 | (~grp_cnn_pipeline_fu_1933.maxpool1_lane2_U0.s_pool1_packed_blk_n);
    assign proc_9_data_PIPO_blk[2] = 1'b0;
    assign proc_9_start_FIFO_blk[2] = 1'b0 | (~grp_cnn_pipeline_fu_1933.start_for_cnn_unpack_pool1_lane2_U0_U.if_full_n & grp_cnn_pipeline_fu_1933.maxpool1_lane2_U0.ap_start & ~grp_cnn_pipeline_fu_1933.maxpool1_lane2_U0.real_start & (trans_in_cnt_2 == trans_out_cnt_2) & ~grp_cnn_pipeline_fu_1933.start_for_cnn_unpack_pool1_lane2_U0_U.if_read);
    assign proc_9_TLF_FIFO_blk[2] = 1'b0;
    assign proc_9_input_sync_blk[2] = 1'b0;
    assign proc_9_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_9[2] = dl_detect_out ? proc_dep_vld_vec_9_reg[2] : (proc_9_data_FIFO_blk[2] | proc_9_data_PIPO_blk[2] | proc_9_start_FIFO_blk[2] | proc_9_TLF_FIFO_blk[2] | proc_9_input_sync_blk[2] | proc_9_output_sync_blk[2]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_9_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_9_reg <= proc_dep_vld_vec_9;
        end
    end
    assign in_chan_dep_vld_vec_9[0] = dep_chan_vld_5_9;
    assign in_chan_dep_data_vec_9[33 : 0] = dep_chan_data_5_9;
    assign token_in_vec_9[0] = token_5_9;
    assign in_chan_dep_vld_vec_9[1] = dep_chan_vld_8_9;
    assign in_chan_dep_data_vec_9[67 : 34] = dep_chan_data_8_9;
    assign token_in_vec_9[1] = token_8_9;
    assign in_chan_dep_vld_vec_9[2] = dep_chan_vld_10_9;
    assign in_chan_dep_data_vec_9[101 : 68] = dep_chan_data_10_9;
    assign token_in_vec_9[2] = token_10_9;
    assign dep_chan_vld_9_5 = out_chan_dep_vld_vec_9[0];
    assign dep_chan_data_9_5 = out_chan_dep_data_9;
    assign token_9_5 = token_out_vec_9[0];
    assign dep_chan_vld_9_8 = out_chan_dep_vld_vec_9[1];
    assign dep_chan_data_9_8 = out_chan_dep_data_9;
    assign token_9_8 = token_out_vec_9[1];
    assign dep_chan_vld_9_10 = out_chan_dep_vld_vec_9[2];
    assign dep_chan_data_9_10 = out_chan_dep_data_9;
    assign token_9_10 = token_out_vec_9[2];

    // Process: grp_cnn_pipeline_fu_1933.cnn_unpack_pool1_lane2_U0
    cnn_hls_deadlock_detect_unit #(34, 10, 3, 3) cnn_hls_deadlock_detect_unit_10 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_10),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_10),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_10),
        .token_in_vec(token_in_vec_10),
        .dl_detect_in(dl_detect_out),
        .origin(origin[10]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_10),
        .out_chan_dep_data(out_chan_dep_data_10),
        .token_out_vec(token_out_vec_10),
        .dl_detect_out(dl_in_vec[10]));

    assign proc_10_data_FIFO_blk[0] = 1'b0 | (~grp_cnn_pipeline_fu_1933.cnn_unpack_pool1_lane2_U0.s_pool1_packed_blk_n);
    assign proc_10_data_PIPO_blk[0] = 1'b0;
    assign proc_10_start_FIFO_blk[0] = 1'b0 | (~grp_cnn_pipeline_fu_1933.start_for_cnn_unpack_pool1_lane2_U0_U.if_empty_n & grp_cnn_pipeline_fu_1933.cnn_unpack_pool1_lane2_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.start_for_cnn_unpack_pool1_lane2_U0_U.if_write);
    assign proc_10_TLF_FIFO_blk[0] = 1'b0;
    assign proc_10_input_sync_blk[0] = 1'b0;
    assign proc_10_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_10[0] = dl_detect_out ? proc_dep_vld_vec_10_reg[0] : (proc_10_data_FIFO_blk[0] | proc_10_data_PIPO_blk[0] | proc_10_start_FIFO_blk[0] | proc_10_TLF_FIFO_blk[0] | proc_10_input_sync_blk[0] | proc_10_output_sync_blk[0]);
    assign proc_10_data_FIFO_blk[1] = 1'b0 | (~grp_cnn_pipeline_fu_1933.cnn_unpack_pool1_lane2_U0.s_pool1_blk_n);
    assign proc_10_data_PIPO_blk[1] = 1'b0;
    assign proc_10_start_FIFO_blk[1] = 1'b0;
    assign proc_10_TLF_FIFO_blk[1] = 1'b0;
    assign proc_10_input_sync_blk[1] = 1'b0;
    assign proc_10_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_10[1] = dl_detect_out ? proc_dep_vld_vec_10_reg[1] : (proc_10_data_FIFO_blk[1] | proc_10_data_PIPO_blk[1] | proc_10_start_FIFO_blk[1] | proc_10_TLF_FIFO_blk[1] | proc_10_input_sync_blk[1] | proc_10_output_sync_blk[1]);
    assign proc_10_data_FIFO_blk[2] = 1'b0 | (~grp_cnn_pipeline_fu_1933.cnn_unpack_pool1_lane2_U0.s_pool1_blk_n);
    assign proc_10_data_PIPO_blk[2] = 1'b0;
    assign proc_10_start_FIFO_blk[2] = 1'b0;
    assign proc_10_TLF_FIFO_blk[2] = 1'b0;
    assign proc_10_input_sync_blk[2] = 1'b0;
    assign proc_10_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_10[2] = dl_detect_out ? proc_dep_vld_vec_10_reg[2] : (proc_10_data_FIFO_blk[2] | proc_10_data_PIPO_blk[2] | proc_10_start_FIFO_blk[2] | proc_10_TLF_FIFO_blk[2] | proc_10_input_sync_blk[2] | proc_10_output_sync_blk[2]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_10_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_10_reg <= proc_dep_vld_vec_10;
        end
    end
    assign in_chan_dep_vld_vec_10[0] = dep_chan_vld_9_10;
    assign in_chan_dep_data_vec_10[33 : 0] = dep_chan_data_9_10;
    assign token_in_vec_10[0] = token_9_10;
    assign in_chan_dep_vld_vec_10[1] = dep_chan_vld_11_10;
    assign in_chan_dep_data_vec_10[67 : 34] = dep_chan_data_11_10;
    assign token_in_vec_10[1] = token_11_10;
    assign in_chan_dep_vld_vec_10[2] = dep_chan_vld_12_10;
    assign in_chan_dep_data_vec_10[101 : 68] = dep_chan_data_12_10;
    assign token_in_vec_10[2] = token_12_10;
    assign dep_chan_vld_10_9 = out_chan_dep_vld_vec_10[0];
    assign dep_chan_data_10_9 = out_chan_dep_data_10;
    assign token_10_9 = token_out_vec_10[0];
    assign dep_chan_vld_10_11 = out_chan_dep_vld_vec_10[1];
    assign dep_chan_data_10_11 = out_chan_dep_data_10;
    assign token_10_11 = token_out_vec_10[1];
    assign dep_chan_vld_10_12 = out_chan_dep_vld_vec_10[2];
    assign dep_chan_data_10_12 = out_chan_dep_data_10;
    assign token_10_12 = token_out_vec_10[2];

    // Process: grp_cnn_pipeline_fu_1933.conv2_1_U0
    cnn_hls_deadlock_detect_unit #(34, 11, 10, 10) cnn_hls_deadlock_detect_unit_11 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_11),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_11),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_11),
        .token_in_vec(token_in_vec_11),
        .dl_detect_in(dl_detect_out),
        .origin(origin[11]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_11),
        .out_chan_dep_data(out_chan_dep_data_11),
        .token_out_vec(token_out_vec_11),
        .dl_detect_out(dl_in_vec[11]));

    assign proc_11_data_FIFO_blk[0] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_windows_U0.s_pool1_blk_n);
    assign proc_11_data_PIPO_blk[0] = 1'b0;
    assign proc_11_start_FIFO_blk[0] = 1'b0;
    assign proc_11_TLF_FIFO_blk[0] = 1'b0;
    assign proc_11_input_sync_blk[0] = 1'b0;
    assign proc_11_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_11[0] = dl_detect_out ? proc_dep_vld_vec_11_reg[0] : (proc_11_data_FIFO_blk[0] | proc_11_data_PIPO_blk[0] | proc_11_start_FIFO_blk[0] | proc_11_TLF_FIFO_blk[0] | proc_11_input_sync_blk[0] | proc_11_output_sync_blk[0]);
    assign proc_11_data_FIFO_blk[1] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_compute_U0.grp_conv2_1_compute_Pipeline_CONV2_1_COMPUTE_OUTPUTS_fu_78.s_c21_blk_n);
    assign proc_11_data_PIPO_blk[1] = 1'b0;
    assign proc_11_start_FIFO_blk[1] = 1'b0;
    assign proc_11_TLF_FIFO_blk[1] = 1'b0;
    assign proc_11_input_sync_blk[1] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_conv2_1_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv2_1_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv2_2_U0_ap_ready);
    assign proc_11_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_11[1] = dl_detect_out ? proc_dep_vld_vec_11_reg[1] : (proc_11_data_FIFO_blk[1] | proc_11_data_PIPO_blk[1] | proc_11_start_FIFO_blk[1] | proc_11_TLF_FIFO_blk[1] | proc_11_input_sync_blk[1] | proc_11_output_sync_blk[1]);
    assign proc_11_data_FIFO_blk[2] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_compute_U0.grp_conv2_1_compute_Pipeline_CONV2_1_COMPUTE_OUTPUTS_fu_78.s_c21_blk_n);
    assign proc_11_data_PIPO_blk[2] = 1'b0;
    assign proc_11_start_FIFO_blk[2] = 1'b0;
    assign proc_11_TLF_FIFO_blk[2] = 1'b0;
    assign proc_11_input_sync_blk[2] = 1'b0;
    assign proc_11_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_11[2] = dl_detect_out ? proc_dep_vld_vec_11_reg[2] : (proc_11_data_FIFO_blk[2] | proc_11_data_PIPO_blk[2] | proc_11_start_FIFO_blk[2] | proc_11_TLF_FIFO_blk[2] | proc_11_input_sync_blk[2] | proc_11_output_sync_blk[2]);
    assign proc_11_data_FIFO_blk[3] = 1'b0;
    assign proc_11_data_PIPO_blk[3] = 1'b0;
    assign proc_11_start_FIFO_blk[3] = 1'b0;
    assign proc_11_TLF_FIFO_blk[3] = 1'b0;
    assign proc_11_input_sync_blk[3] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_conv2_1_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv2_1_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_entry_proc_U0_ap_ready);
    assign proc_11_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_11[3] = dl_detect_out ? proc_dep_vld_vec_11_reg[3] : (proc_11_data_FIFO_blk[3] | proc_11_data_PIPO_blk[3] | proc_11_start_FIFO_blk[3] | proc_11_TLF_FIFO_blk[3] | proc_11_input_sync_blk[3] | proc_11_output_sync_blk[3]);
    assign proc_11_data_FIFO_blk[4] = 1'b0;
    assign proc_11_data_PIPO_blk[4] = 1'b0;
    assign proc_11_start_FIFO_blk[4] = 1'b0;
    assign proc_11_TLF_FIFO_blk[4] = 1'b0;
    assign proc_11_input_sync_blk[4] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_conv2_1_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv2_1_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_cnn_read_input_U0_ap_ready);
    assign proc_11_output_sync_blk[4] = 1'b0;
    assign proc_dep_vld_vec_11[4] = dl_detect_out ? proc_dep_vld_vec_11_reg[4] : (proc_11_data_FIFO_blk[4] | proc_11_data_PIPO_blk[4] | proc_11_start_FIFO_blk[4] | proc_11_TLF_FIFO_blk[4] | proc_11_input_sync_blk[4] | proc_11_output_sync_blk[4]);
    assign proc_11_data_FIFO_blk[5] = 1'b0;
    assign proc_11_data_PIPO_blk[5] = 1'b0;
    assign proc_11_start_FIFO_blk[5] = 1'b0;
    assign proc_11_TLF_FIFO_blk[5] = 1'b0;
    assign proc_11_input_sync_blk[5] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_conv2_1_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv2_1_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv1_1_lane2_U0_ap_ready);
    assign proc_11_output_sync_blk[5] = 1'b0;
    assign proc_dep_vld_vec_11[5] = dl_detect_out ? proc_dep_vld_vec_11_reg[5] : (proc_11_data_FIFO_blk[5] | proc_11_data_PIPO_blk[5] | proc_11_start_FIFO_blk[5] | proc_11_TLF_FIFO_blk[5] | proc_11_input_sync_blk[5] | proc_11_output_sync_blk[5]);
    assign proc_11_data_FIFO_blk[6] = 1'b0;
    assign proc_11_data_PIPO_blk[6] = 1'b0;
    assign proc_11_start_FIFO_blk[6] = 1'b0;
    assign proc_11_TLF_FIFO_blk[6] = 1'b0;
    assign proc_11_input_sync_blk[6] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_conv2_1_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv2_1_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv1_2_lane2_U0_ap_ready);
    assign proc_11_output_sync_blk[6] = 1'b0;
    assign proc_dep_vld_vec_11[6] = dl_detect_out ? proc_dep_vld_vec_11_reg[6] : (proc_11_data_FIFO_blk[6] | proc_11_data_PIPO_blk[6] | proc_11_start_FIFO_blk[6] | proc_11_TLF_FIFO_blk[6] | proc_11_input_sync_blk[6] | proc_11_output_sync_blk[6]);
    assign proc_11_data_FIFO_blk[7] = 1'b0;
    assign proc_11_data_PIPO_blk[7] = 1'b0;
    assign proc_11_start_FIFO_blk[7] = 1'b0;
    assign proc_11_TLF_FIFO_blk[7] = 1'b0;
    assign proc_11_input_sync_blk[7] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_conv2_1_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv2_1_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv3_1_reuse16_U0_ap_ready);
    assign proc_11_output_sync_blk[7] = 1'b0;
    assign proc_dep_vld_vec_11[7] = dl_detect_out ? proc_dep_vld_vec_11_reg[7] : (proc_11_data_FIFO_blk[7] | proc_11_data_PIPO_blk[7] | proc_11_start_FIFO_blk[7] | proc_11_TLF_FIFO_blk[7] | proc_11_input_sync_blk[7] | proc_11_output_sync_blk[7]);
    assign proc_11_data_FIFO_blk[8] = 1'b0;
    assign proc_11_data_PIPO_blk[8] = 1'b0;
    assign proc_11_start_FIFO_blk[8] = 1'b0;
    assign proc_11_TLF_FIFO_blk[8] = 1'b0;
    assign proc_11_input_sync_blk[8] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_conv2_1_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv2_1_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv3_2_reuse32_U0_ap_ready);
    assign proc_11_output_sync_blk[8] = 1'b0;
    assign proc_dep_vld_vec_11[8] = dl_detect_out ? proc_dep_vld_vec_11_reg[8] : (proc_11_data_FIFO_blk[8] | proc_11_data_PIPO_blk[8] | proc_11_start_FIFO_blk[8] | proc_11_TLF_FIFO_blk[8] | proc_11_input_sync_blk[8] | proc_11_output_sync_blk[8]);
    assign proc_11_data_FIFO_blk[9] = 1'b0;
    assign proc_11_data_PIPO_blk[9] = 1'b0;
    assign proc_11_start_FIFO_blk[9] = 1'b0;
    assign proc_11_TLF_FIFO_blk[9] = 1'b0;
    assign proc_11_input_sync_blk[9] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_conv2_1_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv2_1_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_classification_head_stream_U0_ap_ready);
    assign proc_11_output_sync_blk[9] = 1'b0;
    assign proc_dep_vld_vec_11[9] = dl_detect_out ? proc_dep_vld_vec_11_reg[9] : (proc_11_data_FIFO_blk[9] | proc_11_data_PIPO_blk[9] | proc_11_start_FIFO_blk[9] | proc_11_TLF_FIFO_blk[9] | proc_11_input_sync_blk[9] | proc_11_output_sync_blk[9]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_11_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_11_reg <= proc_dep_vld_vec_11;
        end
    end
    assign in_chan_dep_vld_vec_11[0] = dep_chan_vld_0_11;
    assign in_chan_dep_data_vec_11[33 : 0] = dep_chan_data_0_11;
    assign token_in_vec_11[0] = token_0_11;
    assign in_chan_dep_vld_vec_11[1] = dep_chan_vld_1_11;
    assign in_chan_dep_data_vec_11[67 : 34] = dep_chan_data_1_11;
    assign token_in_vec_11[1] = token_1_11;
    assign in_chan_dep_vld_vec_11[2] = dep_chan_vld_2_11;
    assign in_chan_dep_data_vec_11[101 : 68] = dep_chan_data_2_11;
    assign token_in_vec_11[2] = token_2_11;
    assign in_chan_dep_vld_vec_11[3] = dep_chan_vld_5_11;
    assign in_chan_dep_data_vec_11[135 : 102] = dep_chan_data_5_11;
    assign token_in_vec_11[3] = token_5_11;
    assign in_chan_dep_vld_vec_11[4] = dep_chan_vld_10_11;
    assign in_chan_dep_data_vec_11[169 : 136] = dep_chan_data_10_11;
    assign token_in_vec_11[4] = token_10_11;
    assign in_chan_dep_vld_vec_11[5] = dep_chan_vld_15_11;
    assign in_chan_dep_data_vec_11[203 : 170] = dep_chan_data_15_11;
    assign token_in_vec_11[5] = token_15_11;
    assign in_chan_dep_vld_vec_11[6] = dep_chan_vld_16_11;
    assign in_chan_dep_data_vec_11[237 : 204] = dep_chan_data_16_11;
    assign token_in_vec_11[6] = token_16_11;
    assign in_chan_dep_vld_vec_11[7] = dep_chan_vld_20_11;
    assign in_chan_dep_data_vec_11[271 : 238] = dep_chan_data_20_11;
    assign token_in_vec_11[7] = token_20_11;
    assign in_chan_dep_vld_vec_11[8] = dep_chan_vld_24_11;
    assign in_chan_dep_data_vec_11[305 : 272] = dep_chan_data_24_11;
    assign token_in_vec_11[8] = token_24_11;
    assign in_chan_dep_vld_vec_11[9] = dep_chan_vld_29_11;
    assign in_chan_dep_data_vec_11[339 : 306] = dep_chan_data_29_11;
    assign token_in_vec_11[9] = token_29_11;
    assign dep_chan_vld_11_10 = out_chan_dep_vld_vec_11[0];
    assign dep_chan_data_11_10 = out_chan_dep_data_11;
    assign token_11_10 = token_out_vec_11[0];
    assign dep_chan_vld_11_15 = out_chan_dep_vld_vec_11[1];
    assign dep_chan_data_11_15 = out_chan_dep_data_11;
    assign token_11_15 = token_out_vec_11[1];
    assign dep_chan_vld_11_16 = out_chan_dep_vld_vec_11[2];
    assign dep_chan_data_11_16 = out_chan_dep_data_11;
    assign token_11_16 = token_out_vec_11[2];
    assign dep_chan_vld_11_0 = out_chan_dep_vld_vec_11[3];
    assign dep_chan_data_11_0 = out_chan_dep_data_11;
    assign token_11_0 = token_out_vec_11[3];
    assign dep_chan_vld_11_1 = out_chan_dep_vld_vec_11[4];
    assign dep_chan_data_11_1 = out_chan_dep_data_11;
    assign token_11_1 = token_out_vec_11[4];
    assign dep_chan_vld_11_2 = out_chan_dep_vld_vec_11[5];
    assign dep_chan_data_11_2 = out_chan_dep_data_11;
    assign token_11_2 = token_out_vec_11[5];
    assign dep_chan_vld_11_5 = out_chan_dep_vld_vec_11[6];
    assign dep_chan_data_11_5 = out_chan_dep_data_11;
    assign token_11_5 = token_out_vec_11[6];
    assign dep_chan_vld_11_20 = out_chan_dep_vld_vec_11[7];
    assign dep_chan_data_11_20 = out_chan_dep_data_11;
    assign token_11_20 = token_out_vec_11[7];
    assign dep_chan_vld_11_24 = out_chan_dep_vld_vec_11[8];
    assign dep_chan_data_11_24 = out_chan_dep_data_11;
    assign token_11_24 = token_out_vec_11[8];
    assign dep_chan_vld_11_29 = out_chan_dep_vld_vec_11[9];
    assign dep_chan_data_11_29 = out_chan_dep_data_11;
    assign token_11_29 = token_out_vec_11[9];

    // Process: grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_windows_U0
    cnn_hls_deadlock_detect_unit #(34, 12, 3, 3) cnn_hls_deadlock_detect_unit_12 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_12),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_12),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_12),
        .token_in_vec(token_in_vec_12),
        .dl_detect_in(dl_detect_out),
        .origin(origin[12]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_12),
        .out_chan_dep_data(out_chan_dep_data_12),
        .token_out_vec(token_out_vec_12),
        .dl_detect_out(dl_in_vec[12]));

    assign proc_12_data_FIFO_blk[0] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_windows_U0.s_pool1_blk_n);
    assign proc_12_data_PIPO_blk[0] = 1'b0;
    assign proc_12_start_FIFO_blk[0] = 1'b0;
    assign proc_12_TLF_FIFO_blk[0] = 1'b0;
    assign proc_12_input_sync_blk[0] = 1'b0;
    assign proc_12_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_12[0] = dl_detect_out ? proc_dep_vld_vec_12_reg[0] : (proc_12_data_FIFO_blk[0] | proc_12_data_PIPO_blk[0] | proc_12_start_FIFO_blk[0] | proc_12_TLF_FIFO_blk[0] | proc_12_input_sync_blk[0] | proc_12_output_sync_blk[0]);
    assign proc_12_data_FIFO_blk[1] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_windows_U0.windows_blk_n);
    assign proc_12_data_PIPO_blk[1] = 1'b0;
    assign proc_12_start_FIFO_blk[1] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv2_1_U0.start_for_conv2_1_pack_windows_U0_U.if_full_n & grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_windows_U0.ap_start & ~grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_windows_U0.real_start & (trans_in_cnt_3 == trans_out_cnt_3) & ~grp_cnn_pipeline_fu_1933.conv2_1_U0.start_for_conv2_1_pack_windows_U0_U.if_read);
    assign proc_12_TLF_FIFO_blk[1] = 1'b0;
    assign proc_12_input_sync_blk[1] = 1'b0;
    assign proc_12_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_12[1] = dl_detect_out ? proc_dep_vld_vec_12_reg[1] : (proc_12_data_FIFO_blk[1] | proc_12_data_PIPO_blk[1] | proc_12_start_FIFO_blk[1] | proc_12_TLF_FIFO_blk[1] | proc_12_input_sync_blk[1] | proc_12_output_sync_blk[1]);
    assign proc_12_data_FIFO_blk[2] = 1'b0;
    assign proc_12_data_PIPO_blk[2] = 1'b0;
    assign proc_12_start_FIFO_blk[2] = 1'b0;
    assign proc_12_TLF_FIFO_blk[2] = 1'b0;
    assign proc_12_input_sync_blk[2] = 1'b0 | (grp_cnn_pipeline_fu_1933.conv2_1_U0.ap_sync_conv2_1_windows_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_windows_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.conv2_1_U0.ap_sync_conv2_1_compute_U0_ap_ready);
    assign proc_12_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_12[2] = dl_detect_out ? proc_dep_vld_vec_12_reg[2] : (proc_12_data_FIFO_blk[2] | proc_12_data_PIPO_blk[2] | proc_12_start_FIFO_blk[2] | proc_12_TLF_FIFO_blk[2] | proc_12_input_sync_blk[2] | proc_12_output_sync_blk[2]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_12_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_12_reg <= proc_dep_vld_vec_12;
        end
    end
    assign in_chan_dep_vld_vec_12[0] = dep_chan_vld_10_12;
    assign in_chan_dep_data_vec_12[33 : 0] = dep_chan_data_10_12;
    assign token_in_vec_12[0] = token_10_12;
    assign in_chan_dep_vld_vec_12[1] = dep_chan_vld_13_12;
    assign in_chan_dep_data_vec_12[67 : 34] = dep_chan_data_13_12;
    assign token_in_vec_12[1] = token_13_12;
    assign in_chan_dep_vld_vec_12[2] = dep_chan_vld_14_12;
    assign in_chan_dep_data_vec_12[101 : 68] = dep_chan_data_14_12;
    assign token_in_vec_12[2] = token_14_12;
    assign dep_chan_vld_12_10 = out_chan_dep_vld_vec_12[0];
    assign dep_chan_data_12_10 = out_chan_dep_data_12;
    assign token_12_10 = token_out_vec_12[0];
    assign dep_chan_vld_12_13 = out_chan_dep_vld_vec_12[1];
    assign dep_chan_data_12_13 = out_chan_dep_data_12;
    assign token_12_13 = token_out_vec_12[1];
    assign dep_chan_vld_12_14 = out_chan_dep_vld_vec_12[2];
    assign dep_chan_data_12_14 = out_chan_dep_data_12;
    assign token_12_14 = token_out_vec_12[2];

    // Process: grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_pack_windows_U0
    cnn_hls_deadlock_detect_unit #(34, 13, 2, 2) cnn_hls_deadlock_detect_unit_13 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_13),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_13),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_13),
        .token_in_vec(token_in_vec_13),
        .dl_detect_in(dl_detect_out),
        .origin(origin[13]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_13),
        .out_chan_dep_data(out_chan_dep_data_13),
        .token_out_vec(token_out_vec_13),
        .dl_detect_out(dl_in_vec[13]));

    assign proc_13_data_FIFO_blk[0] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_pack_windows_U0.windows_blk_n);
    assign proc_13_data_PIPO_blk[0] = 1'b0;
    assign proc_13_start_FIFO_blk[0] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv2_1_U0.start_for_conv2_1_pack_windows_U0_U.if_empty_n & grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_pack_windows_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.conv2_1_U0.start_for_conv2_1_pack_windows_U0_U.if_write);
    assign proc_13_TLF_FIFO_blk[0] = 1'b0;
    assign proc_13_input_sync_blk[0] = 1'b0;
    assign proc_13_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_13[0] = dl_detect_out ? proc_dep_vld_vec_13_reg[0] : (proc_13_data_FIFO_blk[0] | proc_13_data_PIPO_blk[0] | proc_13_start_FIFO_blk[0] | proc_13_TLF_FIFO_blk[0] | proc_13_input_sync_blk[0] | proc_13_output_sync_blk[0]);
    assign proc_13_data_FIFO_blk[1] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_pack_windows_U0.window_sets_blk_n);
    assign proc_13_data_PIPO_blk[1] = 1'b0;
    assign proc_13_start_FIFO_blk[1] = 1'b0;
    assign proc_13_TLF_FIFO_blk[1] = 1'b0;
    assign proc_13_input_sync_blk[1] = 1'b0;
    assign proc_13_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_13[1] = dl_detect_out ? proc_dep_vld_vec_13_reg[1] : (proc_13_data_FIFO_blk[1] | proc_13_data_PIPO_blk[1] | proc_13_start_FIFO_blk[1] | proc_13_TLF_FIFO_blk[1] | proc_13_input_sync_blk[1] | proc_13_output_sync_blk[1]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_13_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_13_reg <= proc_dep_vld_vec_13;
        end
    end
    assign in_chan_dep_vld_vec_13[0] = dep_chan_vld_12_13;
    assign in_chan_dep_data_vec_13[33 : 0] = dep_chan_data_12_13;
    assign token_in_vec_13[0] = token_12_13;
    assign in_chan_dep_vld_vec_13[1] = dep_chan_vld_14_13;
    assign in_chan_dep_data_vec_13[67 : 34] = dep_chan_data_14_13;
    assign token_in_vec_13[1] = token_14_13;
    assign dep_chan_vld_13_12 = out_chan_dep_vld_vec_13[0];
    assign dep_chan_data_13_12 = out_chan_dep_data_13;
    assign token_13_12 = token_out_vec_13[0];
    assign dep_chan_vld_13_14 = out_chan_dep_vld_vec_13[1];
    assign dep_chan_data_13_14 = out_chan_dep_data_13;
    assign token_13_14 = token_out_vec_13[1];

    // Process: grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_compute_U0
    cnn_hls_deadlock_detect_unit #(34, 14, 4, 4) cnn_hls_deadlock_detect_unit_14 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_14),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_14),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_14),
        .token_in_vec(token_in_vec_14),
        .dl_detect_in(dl_detect_out),
        .origin(origin[14]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_14),
        .out_chan_dep_data(out_chan_dep_data_14),
        .token_out_vec(token_out_vec_14),
        .dl_detect_out(dl_in_vec[14]));

    assign proc_14_data_FIFO_blk[0] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_compute_U0.grp_conv2_1_compute_Pipeline_CONV2_1_COMPUTE_OUTPUTS_fu_78.window_sets_blk_n);
    assign proc_14_data_PIPO_blk[0] = 1'b0;
    assign proc_14_start_FIFO_blk[0] = 1'b0;
    assign proc_14_TLF_FIFO_blk[0] = 1'b0;
    assign proc_14_input_sync_blk[0] = 1'b0;
    assign proc_14_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_14[0] = dl_detect_out ? proc_dep_vld_vec_14_reg[0] : (proc_14_data_FIFO_blk[0] | proc_14_data_PIPO_blk[0] | proc_14_start_FIFO_blk[0] | proc_14_TLF_FIFO_blk[0] | proc_14_input_sync_blk[0] | proc_14_output_sync_blk[0]);
    assign proc_14_data_FIFO_blk[1] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_compute_U0.grp_conv2_1_compute_Pipeline_CONV2_1_COMPUTE_OUTPUTS_fu_78.s_c21_blk_n);
    assign proc_14_data_PIPO_blk[1] = 1'b0;
    assign proc_14_start_FIFO_blk[1] = 1'b0;
    assign proc_14_TLF_FIFO_blk[1] = 1'b0;
    assign proc_14_input_sync_blk[1] = 1'b0;
    assign proc_14_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_14[1] = dl_detect_out ? proc_dep_vld_vec_14_reg[1] : (proc_14_data_FIFO_blk[1] | proc_14_data_PIPO_blk[1] | proc_14_start_FIFO_blk[1] | proc_14_TLF_FIFO_blk[1] | proc_14_input_sync_blk[1] | proc_14_output_sync_blk[1]);
    assign proc_14_data_FIFO_blk[2] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_compute_U0.grp_conv2_1_compute_Pipeline_CONV2_1_COMPUTE_OUTPUTS_fu_78.s_c21_blk_n);
    assign proc_14_data_PIPO_blk[2] = 1'b0;
    assign proc_14_start_FIFO_blk[2] = 1'b0;
    assign proc_14_TLF_FIFO_blk[2] = 1'b0;
    assign proc_14_input_sync_blk[2] = 1'b0;
    assign proc_14_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_14[2] = dl_detect_out ? proc_dep_vld_vec_14_reg[2] : (proc_14_data_FIFO_blk[2] | proc_14_data_PIPO_blk[2] | proc_14_start_FIFO_blk[2] | proc_14_TLF_FIFO_blk[2] | proc_14_input_sync_blk[2] | proc_14_output_sync_blk[2]);
    assign proc_14_data_FIFO_blk[3] = 1'b0;
    assign proc_14_data_PIPO_blk[3] = 1'b0;
    assign proc_14_start_FIFO_blk[3] = 1'b0;
    assign proc_14_TLF_FIFO_blk[3] = 1'b0;
    assign proc_14_input_sync_blk[3] = 1'b0 | (grp_cnn_pipeline_fu_1933.conv2_1_U0.ap_sync_conv2_1_compute_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_compute_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.conv2_1_U0.ap_sync_conv2_1_windows_U0_ap_ready);
    assign proc_14_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_14[3] = dl_detect_out ? proc_dep_vld_vec_14_reg[3] : (proc_14_data_FIFO_blk[3] | proc_14_data_PIPO_blk[3] | proc_14_start_FIFO_blk[3] | proc_14_TLF_FIFO_blk[3] | proc_14_input_sync_blk[3] | proc_14_output_sync_blk[3]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_14_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_14_reg <= proc_dep_vld_vec_14;
        end
    end
    assign in_chan_dep_vld_vec_14[0] = dep_chan_vld_12_14;
    assign in_chan_dep_data_vec_14[33 : 0] = dep_chan_data_12_14;
    assign token_in_vec_14[0] = token_12_14;
    assign in_chan_dep_vld_vec_14[1] = dep_chan_vld_13_14;
    assign in_chan_dep_data_vec_14[67 : 34] = dep_chan_data_13_14;
    assign token_in_vec_14[1] = token_13_14;
    assign in_chan_dep_vld_vec_14[2] = dep_chan_vld_15_14;
    assign in_chan_dep_data_vec_14[101 : 68] = dep_chan_data_15_14;
    assign token_in_vec_14[2] = token_15_14;
    assign in_chan_dep_vld_vec_14[3] = dep_chan_vld_16_14;
    assign in_chan_dep_data_vec_14[135 : 102] = dep_chan_data_16_14;
    assign token_in_vec_14[3] = token_16_14;
    assign dep_chan_vld_14_13 = out_chan_dep_vld_vec_14[0];
    assign dep_chan_data_14_13 = out_chan_dep_data_14;
    assign token_14_13 = token_out_vec_14[0];
    assign dep_chan_vld_14_15 = out_chan_dep_vld_vec_14[1];
    assign dep_chan_data_14_15 = out_chan_dep_data_14;
    assign token_14_15 = token_out_vec_14[1];
    assign dep_chan_vld_14_16 = out_chan_dep_vld_vec_14[2];
    assign dep_chan_data_14_16 = out_chan_dep_data_14;
    assign token_14_16 = token_out_vec_14[2];
    assign dep_chan_vld_14_12 = out_chan_dep_vld_vec_14[3];
    assign dep_chan_data_14_12 = out_chan_dep_data_14;
    assign token_14_12 = token_out_vec_14[3];

    // Process: grp_cnn_pipeline_fu_1933.conv2_2_U0
    cnn_hls_deadlock_detect_unit #(34, 15, 10, 10) cnn_hls_deadlock_detect_unit_15 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_15),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_15),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_15),
        .token_in_vec(token_in_vec_15),
        .dl_detect_in(dl_detect_out),
        .origin(origin[15]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_15),
        .out_chan_dep_data(out_chan_dep_data_15),
        .token_out_vec(token_out_vec_15),
        .dl_detect_out(dl_in_vec[15]));

    assign proc_15_data_FIFO_blk[0] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_windows_U0.s_c21_blk_n);
    assign proc_15_data_PIPO_blk[0] = 1'b0;
    assign proc_15_start_FIFO_blk[0] = 1'b0;
    assign proc_15_TLF_FIFO_blk[0] = 1'b0;
    assign proc_15_input_sync_blk[0] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_conv2_2_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv2_2_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv2_1_U0_ap_ready);
    assign proc_15_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_15[0] = dl_detect_out ? proc_dep_vld_vec_15_reg[0] : (proc_15_data_FIFO_blk[0] | proc_15_data_PIPO_blk[0] | proc_15_start_FIFO_blk[0] | proc_15_TLF_FIFO_blk[0] | proc_15_input_sync_blk[0] | proc_15_output_sync_blk[0]);
    assign proc_15_data_FIFO_blk[1] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_windows_U0.s_c21_blk_n);
    assign proc_15_data_PIPO_blk[1] = 1'b0;
    assign proc_15_start_FIFO_blk[1] = 1'b0;
    assign proc_15_TLF_FIFO_blk[1] = 1'b0;
    assign proc_15_input_sync_blk[1] = 1'b0;
    assign proc_15_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_15[1] = dl_detect_out ? proc_dep_vld_vec_15_reg[1] : (proc_15_data_FIFO_blk[1] | proc_15_data_PIPO_blk[1] | proc_15_start_FIFO_blk[1] | proc_15_TLF_FIFO_blk[1] | proc_15_input_sync_blk[1] | proc_15_output_sync_blk[1]);
    assign proc_15_data_FIFO_blk[2] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_compute_U0.grp_conv2_2_compute_Pipeline_CONV2_2_COMPUTE_OUTPUTS_fu_112.s_c22_blk_n);
    assign proc_15_data_PIPO_blk[2] = 1'b0;
    assign proc_15_start_FIFO_blk[2] = 1'b0 | (~grp_cnn_pipeline_fu_1933.start_for_maxpool2_U0_U.if_full_n & grp_cnn_pipeline_fu_1933.conv2_2_U0.ap_start & ~grp_cnn_pipeline_fu_1933.conv2_2_U0.real_start & (trans_in_cnt_5 == trans_out_cnt_5) & ~grp_cnn_pipeline_fu_1933.start_for_maxpool2_U0_U.if_read);
    assign proc_15_TLF_FIFO_blk[2] = 1'b0;
    assign proc_15_input_sync_blk[2] = 1'b0;
    assign proc_15_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_15[2] = dl_detect_out ? proc_dep_vld_vec_15_reg[2] : (proc_15_data_FIFO_blk[2] | proc_15_data_PIPO_blk[2] | proc_15_start_FIFO_blk[2] | proc_15_TLF_FIFO_blk[2] | proc_15_input_sync_blk[2] | proc_15_output_sync_blk[2]);
    assign proc_15_data_FIFO_blk[3] = 1'b0;
    assign proc_15_data_PIPO_blk[3] = 1'b0;
    assign proc_15_start_FIFO_blk[3] = 1'b0;
    assign proc_15_TLF_FIFO_blk[3] = 1'b0;
    assign proc_15_input_sync_blk[3] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_conv2_2_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv2_2_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_entry_proc_U0_ap_ready);
    assign proc_15_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_15[3] = dl_detect_out ? proc_dep_vld_vec_15_reg[3] : (proc_15_data_FIFO_blk[3] | proc_15_data_PIPO_blk[3] | proc_15_start_FIFO_blk[3] | proc_15_TLF_FIFO_blk[3] | proc_15_input_sync_blk[3] | proc_15_output_sync_blk[3]);
    assign proc_15_data_FIFO_blk[4] = 1'b0;
    assign proc_15_data_PIPO_blk[4] = 1'b0;
    assign proc_15_start_FIFO_blk[4] = 1'b0;
    assign proc_15_TLF_FIFO_blk[4] = 1'b0;
    assign proc_15_input_sync_blk[4] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_conv2_2_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv2_2_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_cnn_read_input_U0_ap_ready);
    assign proc_15_output_sync_blk[4] = 1'b0;
    assign proc_dep_vld_vec_15[4] = dl_detect_out ? proc_dep_vld_vec_15_reg[4] : (proc_15_data_FIFO_blk[4] | proc_15_data_PIPO_blk[4] | proc_15_start_FIFO_blk[4] | proc_15_TLF_FIFO_blk[4] | proc_15_input_sync_blk[4] | proc_15_output_sync_blk[4]);
    assign proc_15_data_FIFO_blk[5] = 1'b0;
    assign proc_15_data_PIPO_blk[5] = 1'b0;
    assign proc_15_start_FIFO_blk[5] = 1'b0;
    assign proc_15_TLF_FIFO_blk[5] = 1'b0;
    assign proc_15_input_sync_blk[5] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_conv2_2_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv2_2_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv1_1_lane2_U0_ap_ready);
    assign proc_15_output_sync_blk[5] = 1'b0;
    assign proc_dep_vld_vec_15[5] = dl_detect_out ? proc_dep_vld_vec_15_reg[5] : (proc_15_data_FIFO_blk[5] | proc_15_data_PIPO_blk[5] | proc_15_start_FIFO_blk[5] | proc_15_TLF_FIFO_blk[5] | proc_15_input_sync_blk[5] | proc_15_output_sync_blk[5]);
    assign proc_15_data_FIFO_blk[6] = 1'b0;
    assign proc_15_data_PIPO_blk[6] = 1'b0;
    assign proc_15_start_FIFO_blk[6] = 1'b0;
    assign proc_15_TLF_FIFO_blk[6] = 1'b0;
    assign proc_15_input_sync_blk[6] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_conv2_2_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv2_2_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv1_2_lane2_U0_ap_ready);
    assign proc_15_output_sync_blk[6] = 1'b0;
    assign proc_dep_vld_vec_15[6] = dl_detect_out ? proc_dep_vld_vec_15_reg[6] : (proc_15_data_FIFO_blk[6] | proc_15_data_PIPO_blk[6] | proc_15_start_FIFO_blk[6] | proc_15_TLF_FIFO_blk[6] | proc_15_input_sync_blk[6] | proc_15_output_sync_blk[6]);
    assign proc_15_data_FIFO_blk[7] = 1'b0;
    assign proc_15_data_PIPO_blk[7] = 1'b0;
    assign proc_15_start_FIFO_blk[7] = 1'b0;
    assign proc_15_TLF_FIFO_blk[7] = 1'b0;
    assign proc_15_input_sync_blk[7] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_conv2_2_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv2_2_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv3_1_reuse16_U0_ap_ready);
    assign proc_15_output_sync_blk[7] = 1'b0;
    assign proc_dep_vld_vec_15[7] = dl_detect_out ? proc_dep_vld_vec_15_reg[7] : (proc_15_data_FIFO_blk[7] | proc_15_data_PIPO_blk[7] | proc_15_start_FIFO_blk[7] | proc_15_TLF_FIFO_blk[7] | proc_15_input_sync_blk[7] | proc_15_output_sync_blk[7]);
    assign proc_15_data_FIFO_blk[8] = 1'b0;
    assign proc_15_data_PIPO_blk[8] = 1'b0;
    assign proc_15_start_FIFO_blk[8] = 1'b0;
    assign proc_15_TLF_FIFO_blk[8] = 1'b0;
    assign proc_15_input_sync_blk[8] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_conv2_2_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv2_2_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv3_2_reuse32_U0_ap_ready);
    assign proc_15_output_sync_blk[8] = 1'b0;
    assign proc_dep_vld_vec_15[8] = dl_detect_out ? proc_dep_vld_vec_15_reg[8] : (proc_15_data_FIFO_blk[8] | proc_15_data_PIPO_blk[8] | proc_15_start_FIFO_blk[8] | proc_15_TLF_FIFO_blk[8] | proc_15_input_sync_blk[8] | proc_15_output_sync_blk[8]);
    assign proc_15_data_FIFO_blk[9] = 1'b0;
    assign proc_15_data_PIPO_blk[9] = 1'b0;
    assign proc_15_start_FIFO_blk[9] = 1'b0;
    assign proc_15_TLF_FIFO_blk[9] = 1'b0;
    assign proc_15_input_sync_blk[9] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_conv2_2_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv2_2_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_classification_head_stream_U0_ap_ready);
    assign proc_15_output_sync_blk[9] = 1'b0;
    assign proc_dep_vld_vec_15[9] = dl_detect_out ? proc_dep_vld_vec_15_reg[9] : (proc_15_data_FIFO_blk[9] | proc_15_data_PIPO_blk[9] | proc_15_start_FIFO_blk[9] | proc_15_TLF_FIFO_blk[9] | proc_15_input_sync_blk[9] | proc_15_output_sync_blk[9]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_15_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_15_reg <= proc_dep_vld_vec_15;
        end
    end
    assign in_chan_dep_vld_vec_15[0] = dep_chan_vld_0_15;
    assign in_chan_dep_data_vec_15[33 : 0] = dep_chan_data_0_15;
    assign token_in_vec_15[0] = token_0_15;
    assign in_chan_dep_vld_vec_15[1] = dep_chan_vld_1_15;
    assign in_chan_dep_data_vec_15[67 : 34] = dep_chan_data_1_15;
    assign token_in_vec_15[1] = token_1_15;
    assign in_chan_dep_vld_vec_15[2] = dep_chan_vld_2_15;
    assign in_chan_dep_data_vec_15[101 : 68] = dep_chan_data_2_15;
    assign token_in_vec_15[2] = token_2_15;
    assign in_chan_dep_vld_vec_15[3] = dep_chan_vld_5_15;
    assign in_chan_dep_data_vec_15[135 : 102] = dep_chan_data_5_15;
    assign token_in_vec_15[3] = token_5_15;
    assign in_chan_dep_vld_vec_15[4] = dep_chan_vld_11_15;
    assign in_chan_dep_data_vec_15[169 : 136] = dep_chan_data_11_15;
    assign token_in_vec_15[4] = token_11_15;
    assign in_chan_dep_vld_vec_15[5] = dep_chan_vld_14_15;
    assign in_chan_dep_data_vec_15[203 : 170] = dep_chan_data_14_15;
    assign token_in_vec_15[5] = token_14_15;
    assign in_chan_dep_vld_vec_15[6] = dep_chan_vld_19_15;
    assign in_chan_dep_data_vec_15[237 : 204] = dep_chan_data_19_15;
    assign token_in_vec_15[6] = token_19_15;
    assign in_chan_dep_vld_vec_15[7] = dep_chan_vld_20_15;
    assign in_chan_dep_data_vec_15[271 : 238] = dep_chan_data_20_15;
    assign token_in_vec_15[7] = token_20_15;
    assign in_chan_dep_vld_vec_15[8] = dep_chan_vld_24_15;
    assign in_chan_dep_data_vec_15[305 : 272] = dep_chan_data_24_15;
    assign token_in_vec_15[8] = token_24_15;
    assign in_chan_dep_vld_vec_15[9] = dep_chan_vld_29_15;
    assign in_chan_dep_data_vec_15[339 : 306] = dep_chan_data_29_15;
    assign token_in_vec_15[9] = token_29_15;
    assign dep_chan_vld_15_11 = out_chan_dep_vld_vec_15[0];
    assign dep_chan_data_15_11 = out_chan_dep_data_15;
    assign token_15_11 = token_out_vec_15[0];
    assign dep_chan_vld_15_14 = out_chan_dep_vld_vec_15[1];
    assign dep_chan_data_15_14 = out_chan_dep_data_15;
    assign token_15_14 = token_out_vec_15[1];
    assign dep_chan_vld_15_19 = out_chan_dep_vld_vec_15[2];
    assign dep_chan_data_15_19 = out_chan_dep_data_15;
    assign token_15_19 = token_out_vec_15[2];
    assign dep_chan_vld_15_0 = out_chan_dep_vld_vec_15[3];
    assign dep_chan_data_15_0 = out_chan_dep_data_15;
    assign token_15_0 = token_out_vec_15[3];
    assign dep_chan_vld_15_1 = out_chan_dep_vld_vec_15[4];
    assign dep_chan_data_15_1 = out_chan_dep_data_15;
    assign token_15_1 = token_out_vec_15[4];
    assign dep_chan_vld_15_2 = out_chan_dep_vld_vec_15[5];
    assign dep_chan_data_15_2 = out_chan_dep_data_15;
    assign token_15_2 = token_out_vec_15[5];
    assign dep_chan_vld_15_5 = out_chan_dep_vld_vec_15[6];
    assign dep_chan_data_15_5 = out_chan_dep_data_15;
    assign token_15_5 = token_out_vec_15[6];
    assign dep_chan_vld_15_20 = out_chan_dep_vld_vec_15[7];
    assign dep_chan_data_15_20 = out_chan_dep_data_15;
    assign token_15_20 = token_out_vec_15[7];
    assign dep_chan_vld_15_24 = out_chan_dep_vld_vec_15[8];
    assign dep_chan_data_15_24 = out_chan_dep_data_15;
    assign token_15_24 = token_out_vec_15[8];
    assign dep_chan_vld_15_29 = out_chan_dep_vld_vec_15[9];
    assign dep_chan_data_15_29 = out_chan_dep_data_15;
    assign token_15_29 = token_out_vec_15[9];

    // Process: grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_windows_U0
    cnn_hls_deadlock_detect_unit #(34, 16, 4, 4) cnn_hls_deadlock_detect_unit_16 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_16),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_16),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_16),
        .token_in_vec(token_in_vec_16),
        .dl_detect_in(dl_detect_out),
        .origin(origin[16]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_16),
        .out_chan_dep_data(out_chan_dep_data_16),
        .token_out_vec(token_out_vec_16),
        .dl_detect_out(dl_in_vec[16]));

    assign proc_16_data_FIFO_blk[0] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_windows_U0.s_c21_blk_n);
    assign proc_16_data_PIPO_blk[0] = 1'b0;
    assign proc_16_start_FIFO_blk[0] = 1'b0;
    assign proc_16_TLF_FIFO_blk[0] = 1'b0;
    assign proc_16_input_sync_blk[0] = 1'b0;
    assign proc_16_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_16[0] = dl_detect_out ? proc_dep_vld_vec_16_reg[0] : (proc_16_data_FIFO_blk[0] | proc_16_data_PIPO_blk[0] | proc_16_start_FIFO_blk[0] | proc_16_TLF_FIFO_blk[0] | proc_16_input_sync_blk[0] | proc_16_output_sync_blk[0]);
    assign proc_16_data_FIFO_blk[1] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_windows_U0.s_c21_blk_n);
    assign proc_16_data_PIPO_blk[1] = 1'b0;
    assign proc_16_start_FIFO_blk[1] = 1'b0;
    assign proc_16_TLF_FIFO_blk[1] = 1'b0;
    assign proc_16_input_sync_blk[1] = 1'b0;
    assign proc_16_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_16[1] = dl_detect_out ? proc_dep_vld_vec_16_reg[1] : (proc_16_data_FIFO_blk[1] | proc_16_data_PIPO_blk[1] | proc_16_start_FIFO_blk[1] | proc_16_TLF_FIFO_blk[1] | proc_16_input_sync_blk[1] | proc_16_output_sync_blk[1]);
    assign proc_16_data_FIFO_blk[2] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_windows_U0.windows_blk_n);
    assign proc_16_data_PIPO_blk[2] = 1'b0;
    assign proc_16_start_FIFO_blk[2] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv2_2_U0.start_for_conv2_2_pack_windows_U0_U.if_full_n & grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_windows_U0.ap_start & ~grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_windows_U0.real_start & (trans_in_cnt_4 == trans_out_cnt_4) & ~grp_cnn_pipeline_fu_1933.conv2_2_U0.start_for_conv2_2_pack_windows_U0_U.if_read);
    assign proc_16_TLF_FIFO_blk[2] = 1'b0;
    assign proc_16_input_sync_blk[2] = 1'b0;
    assign proc_16_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_16[2] = dl_detect_out ? proc_dep_vld_vec_16_reg[2] : (proc_16_data_FIFO_blk[2] | proc_16_data_PIPO_blk[2] | proc_16_start_FIFO_blk[2] | proc_16_TLF_FIFO_blk[2] | proc_16_input_sync_blk[2] | proc_16_output_sync_blk[2]);
    assign proc_16_data_FIFO_blk[3] = 1'b0;
    assign proc_16_data_PIPO_blk[3] = 1'b0;
    assign proc_16_start_FIFO_blk[3] = 1'b0;
    assign proc_16_TLF_FIFO_blk[3] = 1'b0;
    assign proc_16_input_sync_blk[3] = 1'b0 | (grp_cnn_pipeline_fu_1933.conv2_2_U0.ap_sync_conv2_2_windows_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_windows_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.conv2_2_U0.ap_sync_conv2_2_compute_U0_ap_ready);
    assign proc_16_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_16[3] = dl_detect_out ? proc_dep_vld_vec_16_reg[3] : (proc_16_data_FIFO_blk[3] | proc_16_data_PIPO_blk[3] | proc_16_start_FIFO_blk[3] | proc_16_TLF_FIFO_blk[3] | proc_16_input_sync_blk[3] | proc_16_output_sync_blk[3]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_16_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_16_reg <= proc_dep_vld_vec_16;
        end
    end
    assign in_chan_dep_vld_vec_16[0] = dep_chan_vld_11_16;
    assign in_chan_dep_data_vec_16[33 : 0] = dep_chan_data_11_16;
    assign token_in_vec_16[0] = token_11_16;
    assign in_chan_dep_vld_vec_16[1] = dep_chan_vld_14_16;
    assign in_chan_dep_data_vec_16[67 : 34] = dep_chan_data_14_16;
    assign token_in_vec_16[1] = token_14_16;
    assign in_chan_dep_vld_vec_16[2] = dep_chan_vld_17_16;
    assign in_chan_dep_data_vec_16[101 : 68] = dep_chan_data_17_16;
    assign token_in_vec_16[2] = token_17_16;
    assign in_chan_dep_vld_vec_16[3] = dep_chan_vld_18_16;
    assign in_chan_dep_data_vec_16[135 : 102] = dep_chan_data_18_16;
    assign token_in_vec_16[3] = token_18_16;
    assign dep_chan_vld_16_11 = out_chan_dep_vld_vec_16[0];
    assign dep_chan_data_16_11 = out_chan_dep_data_16;
    assign token_16_11 = token_out_vec_16[0];
    assign dep_chan_vld_16_14 = out_chan_dep_vld_vec_16[1];
    assign dep_chan_data_16_14 = out_chan_dep_data_16;
    assign token_16_14 = token_out_vec_16[1];
    assign dep_chan_vld_16_17 = out_chan_dep_vld_vec_16[2];
    assign dep_chan_data_16_17 = out_chan_dep_data_16;
    assign token_16_17 = token_out_vec_16[2];
    assign dep_chan_vld_16_18 = out_chan_dep_vld_vec_16[3];
    assign dep_chan_data_16_18 = out_chan_dep_data_16;
    assign token_16_18 = token_out_vec_16[3];

    // Process: grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_pack_windows_U0
    cnn_hls_deadlock_detect_unit #(34, 17, 2, 2) cnn_hls_deadlock_detect_unit_17 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_17),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_17),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_17),
        .token_in_vec(token_in_vec_17),
        .dl_detect_in(dl_detect_out),
        .origin(origin[17]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_17),
        .out_chan_dep_data(out_chan_dep_data_17),
        .token_out_vec(token_out_vec_17),
        .dl_detect_out(dl_in_vec[17]));

    assign proc_17_data_FIFO_blk[0] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_pack_windows_U0.windows_blk_n);
    assign proc_17_data_PIPO_blk[0] = 1'b0;
    assign proc_17_start_FIFO_blk[0] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv2_2_U0.start_for_conv2_2_pack_windows_U0_U.if_empty_n & grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_pack_windows_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.conv2_2_U0.start_for_conv2_2_pack_windows_U0_U.if_write);
    assign proc_17_TLF_FIFO_blk[0] = 1'b0;
    assign proc_17_input_sync_blk[0] = 1'b0;
    assign proc_17_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_17[0] = dl_detect_out ? proc_dep_vld_vec_17_reg[0] : (proc_17_data_FIFO_blk[0] | proc_17_data_PIPO_blk[0] | proc_17_start_FIFO_blk[0] | proc_17_TLF_FIFO_blk[0] | proc_17_input_sync_blk[0] | proc_17_output_sync_blk[0]);
    assign proc_17_data_FIFO_blk[1] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_pack_windows_U0.window_sets_blk_n);
    assign proc_17_data_PIPO_blk[1] = 1'b0;
    assign proc_17_start_FIFO_blk[1] = 1'b0;
    assign proc_17_TLF_FIFO_blk[1] = 1'b0;
    assign proc_17_input_sync_blk[1] = 1'b0;
    assign proc_17_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_17[1] = dl_detect_out ? proc_dep_vld_vec_17_reg[1] : (proc_17_data_FIFO_blk[1] | proc_17_data_PIPO_blk[1] | proc_17_start_FIFO_blk[1] | proc_17_TLF_FIFO_blk[1] | proc_17_input_sync_blk[1] | proc_17_output_sync_blk[1]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_17_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_17_reg <= proc_dep_vld_vec_17;
        end
    end
    assign in_chan_dep_vld_vec_17[0] = dep_chan_vld_16_17;
    assign in_chan_dep_data_vec_17[33 : 0] = dep_chan_data_16_17;
    assign token_in_vec_17[0] = token_16_17;
    assign in_chan_dep_vld_vec_17[1] = dep_chan_vld_18_17;
    assign in_chan_dep_data_vec_17[67 : 34] = dep_chan_data_18_17;
    assign token_in_vec_17[1] = token_18_17;
    assign dep_chan_vld_17_16 = out_chan_dep_vld_vec_17[0];
    assign dep_chan_data_17_16 = out_chan_dep_data_17;
    assign token_17_16 = token_out_vec_17[0];
    assign dep_chan_vld_17_18 = out_chan_dep_vld_vec_17[1];
    assign dep_chan_data_17_18 = out_chan_dep_data_17;
    assign token_17_18 = token_out_vec_17[1];

    // Process: grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_compute_U0
    cnn_hls_deadlock_detect_unit #(34, 18, 3, 3) cnn_hls_deadlock_detect_unit_18 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_18),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_18),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_18),
        .token_in_vec(token_in_vec_18),
        .dl_detect_in(dl_detect_out),
        .origin(origin[18]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_18),
        .out_chan_dep_data(out_chan_dep_data_18),
        .token_out_vec(token_out_vec_18),
        .dl_detect_out(dl_in_vec[18]));

    assign proc_18_data_FIFO_blk[0] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_compute_U0.grp_conv2_2_compute_Pipeline_CONV2_2_COMPUTE_OUTPUTS_fu_112.window_sets_blk_n);
    assign proc_18_data_PIPO_blk[0] = 1'b0;
    assign proc_18_start_FIFO_blk[0] = 1'b0;
    assign proc_18_TLF_FIFO_blk[0] = 1'b0;
    assign proc_18_input_sync_blk[0] = 1'b0;
    assign proc_18_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_18[0] = dl_detect_out ? proc_dep_vld_vec_18_reg[0] : (proc_18_data_FIFO_blk[0] | proc_18_data_PIPO_blk[0] | proc_18_start_FIFO_blk[0] | proc_18_TLF_FIFO_blk[0] | proc_18_input_sync_blk[0] | proc_18_output_sync_blk[0]);
    assign proc_18_data_FIFO_blk[1] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_compute_U0.grp_conv2_2_compute_Pipeline_CONV2_2_COMPUTE_OUTPUTS_fu_112.s_c22_blk_n);
    assign proc_18_data_PIPO_blk[1] = 1'b0;
    assign proc_18_start_FIFO_blk[1] = 1'b0;
    assign proc_18_TLF_FIFO_blk[1] = 1'b0;
    assign proc_18_input_sync_blk[1] = 1'b0;
    assign proc_18_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_18[1] = dl_detect_out ? proc_dep_vld_vec_18_reg[1] : (proc_18_data_FIFO_blk[1] | proc_18_data_PIPO_blk[1] | proc_18_start_FIFO_blk[1] | proc_18_TLF_FIFO_blk[1] | proc_18_input_sync_blk[1] | proc_18_output_sync_blk[1]);
    assign proc_18_data_FIFO_blk[2] = 1'b0;
    assign proc_18_data_PIPO_blk[2] = 1'b0;
    assign proc_18_start_FIFO_blk[2] = 1'b0;
    assign proc_18_TLF_FIFO_blk[2] = 1'b0;
    assign proc_18_input_sync_blk[2] = 1'b0 | (grp_cnn_pipeline_fu_1933.conv2_2_U0.ap_sync_conv2_2_compute_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_compute_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.conv2_2_U0.ap_sync_conv2_2_windows_U0_ap_ready);
    assign proc_18_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_18[2] = dl_detect_out ? proc_dep_vld_vec_18_reg[2] : (proc_18_data_FIFO_blk[2] | proc_18_data_PIPO_blk[2] | proc_18_start_FIFO_blk[2] | proc_18_TLF_FIFO_blk[2] | proc_18_input_sync_blk[2] | proc_18_output_sync_blk[2]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_18_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_18_reg <= proc_dep_vld_vec_18;
        end
    end
    assign in_chan_dep_vld_vec_18[0] = dep_chan_vld_16_18;
    assign in_chan_dep_data_vec_18[33 : 0] = dep_chan_data_16_18;
    assign token_in_vec_18[0] = token_16_18;
    assign in_chan_dep_vld_vec_18[1] = dep_chan_vld_17_18;
    assign in_chan_dep_data_vec_18[67 : 34] = dep_chan_data_17_18;
    assign token_in_vec_18[1] = token_17_18;
    assign in_chan_dep_vld_vec_18[2] = dep_chan_vld_19_18;
    assign in_chan_dep_data_vec_18[101 : 68] = dep_chan_data_19_18;
    assign token_in_vec_18[2] = token_19_18;
    assign dep_chan_vld_18_17 = out_chan_dep_vld_vec_18[0];
    assign dep_chan_data_18_17 = out_chan_dep_data_18;
    assign token_18_17 = token_out_vec_18[0];
    assign dep_chan_vld_18_19 = out_chan_dep_vld_vec_18[1];
    assign dep_chan_data_18_19 = out_chan_dep_data_18;
    assign token_18_19 = token_out_vec_18[1];
    assign dep_chan_vld_18_16 = out_chan_dep_vld_vec_18[2];
    assign dep_chan_data_18_16 = out_chan_dep_data_18;
    assign token_18_16 = token_out_vec_18[2];

    // Process: grp_cnn_pipeline_fu_1933.maxpool2_U0
    cnn_hls_deadlock_detect_unit #(34, 19, 4, 4) cnn_hls_deadlock_detect_unit_19 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_19),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_19),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_19),
        .token_in_vec(token_in_vec_19),
        .dl_detect_in(dl_detect_out),
        .origin(origin[19]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_19),
        .out_chan_dep_data(out_chan_dep_data_19),
        .token_out_vec(token_out_vec_19),
        .dl_detect_out(dl_in_vec[19]));

    assign proc_19_data_FIFO_blk[0] = 1'b0 | (~grp_cnn_pipeline_fu_1933.maxpool2_U0.s_c22_blk_n);
    assign proc_19_data_PIPO_blk[0] = 1'b0;
    assign proc_19_start_FIFO_blk[0] = 1'b0 | (~grp_cnn_pipeline_fu_1933.start_for_maxpool2_U0_U.if_empty_n & grp_cnn_pipeline_fu_1933.maxpool2_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.start_for_maxpool2_U0_U.if_write);
    assign proc_19_TLF_FIFO_blk[0] = 1'b0;
    assign proc_19_input_sync_blk[0] = 1'b0;
    assign proc_19_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_19[0] = dl_detect_out ? proc_dep_vld_vec_19_reg[0] : (proc_19_data_FIFO_blk[0] | proc_19_data_PIPO_blk[0] | proc_19_start_FIFO_blk[0] | proc_19_TLF_FIFO_blk[0] | proc_19_input_sync_blk[0] | proc_19_output_sync_blk[0]);
    assign proc_19_data_FIFO_blk[1] = 1'b0 | (~grp_cnn_pipeline_fu_1933.maxpool2_U0.s_c22_blk_n);
    assign proc_19_data_PIPO_blk[1] = 1'b0;
    assign proc_19_start_FIFO_blk[1] = 1'b0;
    assign proc_19_TLF_FIFO_blk[1] = 1'b0;
    assign proc_19_input_sync_blk[1] = 1'b0;
    assign proc_19_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_19[1] = dl_detect_out ? proc_dep_vld_vec_19_reg[1] : (proc_19_data_FIFO_blk[1] | proc_19_data_PIPO_blk[1] | proc_19_start_FIFO_blk[1] | proc_19_TLF_FIFO_blk[1] | proc_19_input_sync_blk[1] | proc_19_output_sync_blk[1]);
    assign proc_19_data_FIFO_blk[2] = 1'b0 | (~grp_cnn_pipeline_fu_1933.maxpool2_U0.s_pool2_blk_n);
    assign proc_19_data_PIPO_blk[2] = 1'b0;
    assign proc_19_start_FIFO_blk[2] = 1'b0;
    assign proc_19_TLF_FIFO_blk[2] = 1'b0;
    assign proc_19_input_sync_blk[2] = 1'b0;
    assign proc_19_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_19[2] = dl_detect_out ? proc_dep_vld_vec_19_reg[2] : (proc_19_data_FIFO_blk[2] | proc_19_data_PIPO_blk[2] | proc_19_start_FIFO_blk[2] | proc_19_TLF_FIFO_blk[2] | proc_19_input_sync_blk[2] | proc_19_output_sync_blk[2]);
    assign proc_19_data_FIFO_blk[3] = 1'b0 | (~grp_cnn_pipeline_fu_1933.maxpool2_U0.s_pool2_blk_n);
    assign proc_19_data_PIPO_blk[3] = 1'b0;
    assign proc_19_start_FIFO_blk[3] = 1'b0;
    assign proc_19_TLF_FIFO_blk[3] = 1'b0;
    assign proc_19_input_sync_blk[3] = 1'b0;
    assign proc_19_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_19[3] = dl_detect_out ? proc_dep_vld_vec_19_reg[3] : (proc_19_data_FIFO_blk[3] | proc_19_data_PIPO_blk[3] | proc_19_start_FIFO_blk[3] | proc_19_TLF_FIFO_blk[3] | proc_19_input_sync_blk[3] | proc_19_output_sync_blk[3]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_19_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_19_reg <= proc_dep_vld_vec_19;
        end
    end
    assign in_chan_dep_vld_vec_19[0] = dep_chan_vld_15_19;
    assign in_chan_dep_data_vec_19[33 : 0] = dep_chan_data_15_19;
    assign token_in_vec_19[0] = token_15_19;
    assign in_chan_dep_vld_vec_19[1] = dep_chan_vld_18_19;
    assign in_chan_dep_data_vec_19[67 : 34] = dep_chan_data_18_19;
    assign token_in_vec_19[1] = token_18_19;
    assign in_chan_dep_vld_vec_19[2] = dep_chan_vld_20_19;
    assign in_chan_dep_data_vec_19[101 : 68] = dep_chan_data_20_19;
    assign token_in_vec_19[2] = token_20_19;
    assign in_chan_dep_vld_vec_19[3] = dep_chan_vld_21_19;
    assign in_chan_dep_data_vec_19[135 : 102] = dep_chan_data_21_19;
    assign token_in_vec_19[3] = token_21_19;
    assign dep_chan_vld_19_15 = out_chan_dep_vld_vec_19[0];
    assign dep_chan_data_19_15 = out_chan_dep_data_19;
    assign token_19_15 = token_out_vec_19[0];
    assign dep_chan_vld_19_18 = out_chan_dep_vld_vec_19[1];
    assign dep_chan_data_19_18 = out_chan_dep_data_19;
    assign token_19_18 = token_out_vec_19[1];
    assign dep_chan_vld_19_20 = out_chan_dep_vld_vec_19[2];
    assign dep_chan_data_19_20 = out_chan_dep_data_19;
    assign token_19_20 = token_out_vec_19[2];
    assign dep_chan_vld_19_21 = out_chan_dep_vld_vec_19[3];
    assign dep_chan_data_19_21 = out_chan_dep_data_19;
    assign token_19_21 = token_out_vec_19[3];

    // Process: grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0
    cnn_hls_deadlock_detect_unit #(34, 20, 10, 10) cnn_hls_deadlock_detect_unit_20 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_20),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_20),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_20),
        .token_in_vec(token_in_vec_20),
        .dl_detect_in(dl_detect_out),
        .origin(origin[20]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_20),
        .out_chan_dep_data(out_chan_dep_data_20),
        .token_out_vec(token_out_vec_20),
        .dl_detect_out(dl_in_vec[20]));

    assign proc_20_data_FIFO_blk[0] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_windows_U0.s_pool2_blk_n);
    assign proc_20_data_PIPO_blk[0] = 1'b0;
    assign proc_20_start_FIFO_blk[0] = 1'b0;
    assign proc_20_TLF_FIFO_blk[0] = 1'b0;
    assign proc_20_input_sync_blk[0] = 1'b0;
    assign proc_20_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_20[0] = dl_detect_out ? proc_dep_vld_vec_20_reg[0] : (proc_20_data_FIFO_blk[0] | proc_20_data_PIPO_blk[0] | proc_20_start_FIFO_blk[0] | proc_20_TLF_FIFO_blk[0] | proc_20_input_sync_blk[0] | proc_20_output_sync_blk[0]);
    assign proc_20_data_FIFO_blk[1] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_compute_U0.grp_conv3_1_reuse16_compute_Pipeline_CONV3_1_REUSE_PHASES_fu_80.s_c31_blk_n);
    assign proc_20_data_PIPO_blk[1] = 1'b0;
    assign proc_20_start_FIFO_blk[1] = 1'b0;
    assign proc_20_TLF_FIFO_blk[1] = 1'b0;
    assign proc_20_input_sync_blk[1] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_conv3_1_reuse16_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv3_2_reuse32_U0_ap_ready);
    assign proc_20_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_20[1] = dl_detect_out ? proc_dep_vld_vec_20_reg[1] : (proc_20_data_FIFO_blk[1] | proc_20_data_PIPO_blk[1] | proc_20_start_FIFO_blk[1] | proc_20_TLF_FIFO_blk[1] | proc_20_input_sync_blk[1] | proc_20_output_sync_blk[1]);
    assign proc_20_data_FIFO_blk[2] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_compute_U0.grp_conv3_1_reuse16_compute_Pipeline_CONV3_1_REUSE_PHASES_fu_80.s_c31_blk_n);
    assign proc_20_data_PIPO_blk[2] = 1'b0;
    assign proc_20_start_FIFO_blk[2] = 1'b0;
    assign proc_20_TLF_FIFO_blk[2] = 1'b0;
    assign proc_20_input_sync_blk[2] = 1'b0;
    assign proc_20_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_20[2] = dl_detect_out ? proc_dep_vld_vec_20_reg[2] : (proc_20_data_FIFO_blk[2] | proc_20_data_PIPO_blk[2] | proc_20_start_FIFO_blk[2] | proc_20_TLF_FIFO_blk[2] | proc_20_input_sync_blk[2] | proc_20_output_sync_blk[2]);
    assign proc_20_data_FIFO_blk[3] = 1'b0;
    assign proc_20_data_PIPO_blk[3] = 1'b0;
    assign proc_20_start_FIFO_blk[3] = 1'b0;
    assign proc_20_TLF_FIFO_blk[3] = 1'b0;
    assign proc_20_input_sync_blk[3] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_conv3_1_reuse16_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_entry_proc_U0_ap_ready);
    assign proc_20_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_20[3] = dl_detect_out ? proc_dep_vld_vec_20_reg[3] : (proc_20_data_FIFO_blk[3] | proc_20_data_PIPO_blk[3] | proc_20_start_FIFO_blk[3] | proc_20_TLF_FIFO_blk[3] | proc_20_input_sync_blk[3] | proc_20_output_sync_blk[3]);
    assign proc_20_data_FIFO_blk[4] = 1'b0;
    assign proc_20_data_PIPO_blk[4] = 1'b0;
    assign proc_20_start_FIFO_blk[4] = 1'b0;
    assign proc_20_TLF_FIFO_blk[4] = 1'b0;
    assign proc_20_input_sync_blk[4] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_conv3_1_reuse16_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_cnn_read_input_U0_ap_ready);
    assign proc_20_output_sync_blk[4] = 1'b0;
    assign proc_dep_vld_vec_20[4] = dl_detect_out ? proc_dep_vld_vec_20_reg[4] : (proc_20_data_FIFO_blk[4] | proc_20_data_PIPO_blk[4] | proc_20_start_FIFO_blk[4] | proc_20_TLF_FIFO_blk[4] | proc_20_input_sync_blk[4] | proc_20_output_sync_blk[4]);
    assign proc_20_data_FIFO_blk[5] = 1'b0;
    assign proc_20_data_PIPO_blk[5] = 1'b0;
    assign proc_20_start_FIFO_blk[5] = 1'b0;
    assign proc_20_TLF_FIFO_blk[5] = 1'b0;
    assign proc_20_input_sync_blk[5] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_conv3_1_reuse16_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv1_1_lane2_U0_ap_ready);
    assign proc_20_output_sync_blk[5] = 1'b0;
    assign proc_dep_vld_vec_20[5] = dl_detect_out ? proc_dep_vld_vec_20_reg[5] : (proc_20_data_FIFO_blk[5] | proc_20_data_PIPO_blk[5] | proc_20_start_FIFO_blk[5] | proc_20_TLF_FIFO_blk[5] | proc_20_input_sync_blk[5] | proc_20_output_sync_blk[5]);
    assign proc_20_data_FIFO_blk[6] = 1'b0;
    assign proc_20_data_PIPO_blk[6] = 1'b0;
    assign proc_20_start_FIFO_blk[6] = 1'b0;
    assign proc_20_TLF_FIFO_blk[6] = 1'b0;
    assign proc_20_input_sync_blk[6] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_conv3_1_reuse16_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv1_2_lane2_U0_ap_ready);
    assign proc_20_output_sync_blk[6] = 1'b0;
    assign proc_dep_vld_vec_20[6] = dl_detect_out ? proc_dep_vld_vec_20_reg[6] : (proc_20_data_FIFO_blk[6] | proc_20_data_PIPO_blk[6] | proc_20_start_FIFO_blk[6] | proc_20_TLF_FIFO_blk[6] | proc_20_input_sync_blk[6] | proc_20_output_sync_blk[6]);
    assign proc_20_data_FIFO_blk[7] = 1'b0;
    assign proc_20_data_PIPO_blk[7] = 1'b0;
    assign proc_20_start_FIFO_blk[7] = 1'b0;
    assign proc_20_TLF_FIFO_blk[7] = 1'b0;
    assign proc_20_input_sync_blk[7] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_conv3_1_reuse16_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv2_1_U0_ap_ready);
    assign proc_20_output_sync_blk[7] = 1'b0;
    assign proc_dep_vld_vec_20[7] = dl_detect_out ? proc_dep_vld_vec_20_reg[7] : (proc_20_data_FIFO_blk[7] | proc_20_data_PIPO_blk[7] | proc_20_start_FIFO_blk[7] | proc_20_TLF_FIFO_blk[7] | proc_20_input_sync_blk[7] | proc_20_output_sync_blk[7]);
    assign proc_20_data_FIFO_blk[8] = 1'b0;
    assign proc_20_data_PIPO_blk[8] = 1'b0;
    assign proc_20_start_FIFO_blk[8] = 1'b0;
    assign proc_20_TLF_FIFO_blk[8] = 1'b0;
    assign proc_20_input_sync_blk[8] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_conv3_1_reuse16_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv2_2_U0_ap_ready);
    assign proc_20_output_sync_blk[8] = 1'b0;
    assign proc_dep_vld_vec_20[8] = dl_detect_out ? proc_dep_vld_vec_20_reg[8] : (proc_20_data_FIFO_blk[8] | proc_20_data_PIPO_blk[8] | proc_20_start_FIFO_blk[8] | proc_20_TLF_FIFO_blk[8] | proc_20_input_sync_blk[8] | proc_20_output_sync_blk[8]);
    assign proc_20_data_FIFO_blk[9] = 1'b0;
    assign proc_20_data_PIPO_blk[9] = 1'b0;
    assign proc_20_start_FIFO_blk[9] = 1'b0;
    assign proc_20_TLF_FIFO_blk[9] = 1'b0;
    assign proc_20_input_sync_blk[9] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_conv3_1_reuse16_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_classification_head_stream_U0_ap_ready);
    assign proc_20_output_sync_blk[9] = 1'b0;
    assign proc_dep_vld_vec_20[9] = dl_detect_out ? proc_dep_vld_vec_20_reg[9] : (proc_20_data_FIFO_blk[9] | proc_20_data_PIPO_blk[9] | proc_20_start_FIFO_blk[9] | proc_20_TLF_FIFO_blk[9] | proc_20_input_sync_blk[9] | proc_20_output_sync_blk[9]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_20_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_20_reg <= proc_dep_vld_vec_20;
        end
    end
    assign in_chan_dep_vld_vec_20[0] = dep_chan_vld_0_20;
    assign in_chan_dep_data_vec_20[33 : 0] = dep_chan_data_0_20;
    assign token_in_vec_20[0] = token_0_20;
    assign in_chan_dep_vld_vec_20[1] = dep_chan_vld_1_20;
    assign in_chan_dep_data_vec_20[67 : 34] = dep_chan_data_1_20;
    assign token_in_vec_20[1] = token_1_20;
    assign in_chan_dep_vld_vec_20[2] = dep_chan_vld_2_20;
    assign in_chan_dep_data_vec_20[101 : 68] = dep_chan_data_2_20;
    assign token_in_vec_20[2] = token_2_20;
    assign in_chan_dep_vld_vec_20[3] = dep_chan_vld_5_20;
    assign in_chan_dep_data_vec_20[135 : 102] = dep_chan_data_5_20;
    assign token_in_vec_20[3] = token_5_20;
    assign in_chan_dep_vld_vec_20[4] = dep_chan_vld_11_20;
    assign in_chan_dep_data_vec_20[169 : 136] = dep_chan_data_11_20;
    assign token_in_vec_20[4] = token_11_20;
    assign in_chan_dep_vld_vec_20[5] = dep_chan_vld_15_20;
    assign in_chan_dep_data_vec_20[203 : 170] = dep_chan_data_15_20;
    assign token_in_vec_20[5] = token_15_20;
    assign in_chan_dep_vld_vec_20[6] = dep_chan_vld_19_20;
    assign in_chan_dep_data_vec_20[237 : 204] = dep_chan_data_19_20;
    assign token_in_vec_20[6] = token_19_20;
    assign in_chan_dep_vld_vec_20[7] = dep_chan_vld_24_20;
    assign in_chan_dep_data_vec_20[271 : 238] = dep_chan_data_24_20;
    assign token_in_vec_20[7] = token_24_20;
    assign in_chan_dep_vld_vec_20[8] = dep_chan_vld_25_20;
    assign in_chan_dep_data_vec_20[305 : 272] = dep_chan_data_25_20;
    assign token_in_vec_20[8] = token_25_20;
    assign in_chan_dep_vld_vec_20[9] = dep_chan_vld_29_20;
    assign in_chan_dep_data_vec_20[339 : 306] = dep_chan_data_29_20;
    assign token_in_vec_20[9] = token_29_20;
    assign dep_chan_vld_20_19 = out_chan_dep_vld_vec_20[0];
    assign dep_chan_data_20_19 = out_chan_dep_data_20;
    assign token_20_19 = token_out_vec_20[0];
    assign dep_chan_vld_20_24 = out_chan_dep_vld_vec_20[1];
    assign dep_chan_data_20_24 = out_chan_dep_data_20;
    assign token_20_24 = token_out_vec_20[1];
    assign dep_chan_vld_20_25 = out_chan_dep_vld_vec_20[2];
    assign dep_chan_data_20_25 = out_chan_dep_data_20;
    assign token_20_25 = token_out_vec_20[2];
    assign dep_chan_vld_20_0 = out_chan_dep_vld_vec_20[3];
    assign dep_chan_data_20_0 = out_chan_dep_data_20;
    assign token_20_0 = token_out_vec_20[3];
    assign dep_chan_vld_20_1 = out_chan_dep_vld_vec_20[4];
    assign dep_chan_data_20_1 = out_chan_dep_data_20;
    assign token_20_1 = token_out_vec_20[4];
    assign dep_chan_vld_20_2 = out_chan_dep_vld_vec_20[5];
    assign dep_chan_data_20_2 = out_chan_dep_data_20;
    assign token_20_2 = token_out_vec_20[5];
    assign dep_chan_vld_20_5 = out_chan_dep_vld_vec_20[6];
    assign dep_chan_data_20_5 = out_chan_dep_data_20;
    assign token_20_5 = token_out_vec_20[6];
    assign dep_chan_vld_20_11 = out_chan_dep_vld_vec_20[7];
    assign dep_chan_data_20_11 = out_chan_dep_data_20;
    assign token_20_11 = token_out_vec_20[7];
    assign dep_chan_vld_20_15 = out_chan_dep_vld_vec_20[8];
    assign dep_chan_data_20_15 = out_chan_dep_data_20;
    assign token_20_15 = token_out_vec_20[8];
    assign dep_chan_vld_20_29 = out_chan_dep_vld_vec_20[9];
    assign dep_chan_data_20_29 = out_chan_dep_data_20;
    assign token_20_29 = token_out_vec_20[9];

    // Process: grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_windows_U0
    cnn_hls_deadlock_detect_unit #(34, 21, 3, 3) cnn_hls_deadlock_detect_unit_21 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_21),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_21),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_21),
        .token_in_vec(token_in_vec_21),
        .dl_detect_in(dl_detect_out),
        .origin(origin[21]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_21),
        .out_chan_dep_data(out_chan_dep_data_21),
        .token_out_vec(token_out_vec_21),
        .dl_detect_out(dl_in_vec[21]));

    assign proc_21_data_FIFO_blk[0] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_windows_U0.s_pool2_blk_n);
    assign proc_21_data_PIPO_blk[0] = 1'b0;
    assign proc_21_start_FIFO_blk[0] = 1'b0;
    assign proc_21_TLF_FIFO_blk[0] = 1'b0;
    assign proc_21_input_sync_blk[0] = 1'b0;
    assign proc_21_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_21[0] = dl_detect_out ? proc_dep_vld_vec_21_reg[0] : (proc_21_data_FIFO_blk[0] | proc_21_data_PIPO_blk[0] | proc_21_start_FIFO_blk[0] | proc_21_TLF_FIFO_blk[0] | proc_21_input_sync_blk[0] | proc_21_output_sync_blk[0]);
    assign proc_21_data_FIFO_blk[1] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_windows_U0.windows_blk_n);
    assign proc_21_data_PIPO_blk[1] = 1'b0;
    assign proc_21_start_FIFO_blk[1] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.start_for_conv3_1_reuse16_pack_windows_U0_U.if_full_n & grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_windows_U0.ap_start & ~grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_windows_U0.real_start & (trans_in_cnt_6 == trans_out_cnt_6) & ~grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.start_for_conv3_1_reuse16_pack_windows_U0_U.if_read);
    assign proc_21_TLF_FIFO_blk[1] = 1'b0;
    assign proc_21_input_sync_blk[1] = 1'b0;
    assign proc_21_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_21[1] = dl_detect_out ? proc_dep_vld_vec_21_reg[1] : (proc_21_data_FIFO_blk[1] | proc_21_data_PIPO_blk[1] | proc_21_start_FIFO_blk[1] | proc_21_TLF_FIFO_blk[1] | proc_21_input_sync_blk[1] | proc_21_output_sync_blk[1]);
    assign proc_21_data_FIFO_blk[2] = 1'b0;
    assign proc_21_data_PIPO_blk[2] = 1'b0;
    assign proc_21_start_FIFO_blk[2] = 1'b0;
    assign proc_21_TLF_FIFO_blk[2] = 1'b0;
    assign proc_21_input_sync_blk[2] = 1'b0 | (grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.ap_sync_conv3_1_reuse16_windows_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_windows_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.ap_sync_conv3_1_reuse16_compute_U0_ap_ready);
    assign proc_21_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_21[2] = dl_detect_out ? proc_dep_vld_vec_21_reg[2] : (proc_21_data_FIFO_blk[2] | proc_21_data_PIPO_blk[2] | proc_21_start_FIFO_blk[2] | proc_21_TLF_FIFO_blk[2] | proc_21_input_sync_blk[2] | proc_21_output_sync_blk[2]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_21_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_21_reg <= proc_dep_vld_vec_21;
        end
    end
    assign in_chan_dep_vld_vec_21[0] = dep_chan_vld_19_21;
    assign in_chan_dep_data_vec_21[33 : 0] = dep_chan_data_19_21;
    assign token_in_vec_21[0] = token_19_21;
    assign in_chan_dep_vld_vec_21[1] = dep_chan_vld_22_21;
    assign in_chan_dep_data_vec_21[67 : 34] = dep_chan_data_22_21;
    assign token_in_vec_21[1] = token_22_21;
    assign in_chan_dep_vld_vec_21[2] = dep_chan_vld_23_21;
    assign in_chan_dep_data_vec_21[101 : 68] = dep_chan_data_23_21;
    assign token_in_vec_21[2] = token_23_21;
    assign dep_chan_vld_21_19 = out_chan_dep_vld_vec_21[0];
    assign dep_chan_data_21_19 = out_chan_dep_data_21;
    assign token_21_19 = token_out_vec_21[0];
    assign dep_chan_vld_21_22 = out_chan_dep_vld_vec_21[1];
    assign dep_chan_data_21_22 = out_chan_dep_data_21;
    assign token_21_22 = token_out_vec_21[1];
    assign dep_chan_vld_21_23 = out_chan_dep_vld_vec_21[2];
    assign dep_chan_data_21_23 = out_chan_dep_data_21;
    assign token_21_23 = token_out_vec_21[2];

    // Process: grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_pack_windows_U0
    cnn_hls_deadlock_detect_unit #(34, 22, 2, 2) cnn_hls_deadlock_detect_unit_22 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_22),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_22),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_22),
        .token_in_vec(token_in_vec_22),
        .dl_detect_in(dl_detect_out),
        .origin(origin[22]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_22),
        .out_chan_dep_data(out_chan_dep_data_22),
        .token_out_vec(token_out_vec_22),
        .dl_detect_out(dl_in_vec[22]));

    assign proc_22_data_FIFO_blk[0] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_pack_windows_U0.windows_blk_n);
    assign proc_22_data_PIPO_blk[0] = 1'b0;
    assign proc_22_start_FIFO_blk[0] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.start_for_conv3_1_reuse16_pack_windows_U0_U.if_empty_n & grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_pack_windows_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.start_for_conv3_1_reuse16_pack_windows_U0_U.if_write);
    assign proc_22_TLF_FIFO_blk[0] = 1'b0;
    assign proc_22_input_sync_blk[0] = 1'b0;
    assign proc_22_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_22[0] = dl_detect_out ? proc_dep_vld_vec_22_reg[0] : (proc_22_data_FIFO_blk[0] | proc_22_data_PIPO_blk[0] | proc_22_start_FIFO_blk[0] | proc_22_TLF_FIFO_blk[0] | proc_22_input_sync_blk[0] | proc_22_output_sync_blk[0]);
    assign proc_22_data_FIFO_blk[1] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_pack_windows_U0.window_sets_blk_n);
    assign proc_22_data_PIPO_blk[1] = 1'b0;
    assign proc_22_start_FIFO_blk[1] = 1'b0;
    assign proc_22_TLF_FIFO_blk[1] = 1'b0;
    assign proc_22_input_sync_blk[1] = 1'b0;
    assign proc_22_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_22[1] = dl_detect_out ? proc_dep_vld_vec_22_reg[1] : (proc_22_data_FIFO_blk[1] | proc_22_data_PIPO_blk[1] | proc_22_start_FIFO_blk[1] | proc_22_TLF_FIFO_blk[1] | proc_22_input_sync_blk[1] | proc_22_output_sync_blk[1]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_22_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_22_reg <= proc_dep_vld_vec_22;
        end
    end
    assign in_chan_dep_vld_vec_22[0] = dep_chan_vld_21_22;
    assign in_chan_dep_data_vec_22[33 : 0] = dep_chan_data_21_22;
    assign token_in_vec_22[0] = token_21_22;
    assign in_chan_dep_vld_vec_22[1] = dep_chan_vld_23_22;
    assign in_chan_dep_data_vec_22[67 : 34] = dep_chan_data_23_22;
    assign token_in_vec_22[1] = token_23_22;
    assign dep_chan_vld_22_21 = out_chan_dep_vld_vec_22[0];
    assign dep_chan_data_22_21 = out_chan_dep_data_22;
    assign token_22_21 = token_out_vec_22[0];
    assign dep_chan_vld_22_23 = out_chan_dep_vld_vec_22[1];
    assign dep_chan_data_22_23 = out_chan_dep_data_22;
    assign token_22_23 = token_out_vec_22[1];

    // Process: grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_compute_U0
    cnn_hls_deadlock_detect_unit #(34, 23, 4, 4) cnn_hls_deadlock_detect_unit_23 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_23),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_23),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_23),
        .token_in_vec(token_in_vec_23),
        .dl_detect_in(dl_detect_out),
        .origin(origin[23]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_23),
        .out_chan_dep_data(out_chan_dep_data_23),
        .token_out_vec(token_out_vec_23),
        .dl_detect_out(dl_in_vec[23]));

    assign proc_23_data_FIFO_blk[0] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_compute_U0.grp_conv3_1_reuse16_compute_Pipeline_CONV3_1_REUSE_PHASES_fu_80.window_sets_blk_n);
    assign proc_23_data_PIPO_blk[0] = 1'b0;
    assign proc_23_start_FIFO_blk[0] = 1'b0;
    assign proc_23_TLF_FIFO_blk[0] = 1'b0;
    assign proc_23_input_sync_blk[0] = 1'b0;
    assign proc_23_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_23[0] = dl_detect_out ? proc_dep_vld_vec_23_reg[0] : (proc_23_data_FIFO_blk[0] | proc_23_data_PIPO_blk[0] | proc_23_start_FIFO_blk[0] | proc_23_TLF_FIFO_blk[0] | proc_23_input_sync_blk[0] | proc_23_output_sync_blk[0]);
    assign proc_23_data_FIFO_blk[1] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_compute_U0.grp_conv3_1_reuse16_compute_Pipeline_CONV3_1_REUSE_PHASES_fu_80.s_c31_blk_n);
    assign proc_23_data_PIPO_blk[1] = 1'b0;
    assign proc_23_start_FIFO_blk[1] = 1'b0;
    assign proc_23_TLF_FIFO_blk[1] = 1'b0;
    assign proc_23_input_sync_blk[1] = 1'b0;
    assign proc_23_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_23[1] = dl_detect_out ? proc_dep_vld_vec_23_reg[1] : (proc_23_data_FIFO_blk[1] | proc_23_data_PIPO_blk[1] | proc_23_start_FIFO_blk[1] | proc_23_TLF_FIFO_blk[1] | proc_23_input_sync_blk[1] | proc_23_output_sync_blk[1]);
    assign proc_23_data_FIFO_blk[2] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_compute_U0.grp_conv3_1_reuse16_compute_Pipeline_CONV3_1_REUSE_PHASES_fu_80.s_c31_blk_n);
    assign proc_23_data_PIPO_blk[2] = 1'b0;
    assign proc_23_start_FIFO_blk[2] = 1'b0;
    assign proc_23_TLF_FIFO_blk[2] = 1'b0;
    assign proc_23_input_sync_blk[2] = 1'b0;
    assign proc_23_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_23[2] = dl_detect_out ? proc_dep_vld_vec_23_reg[2] : (proc_23_data_FIFO_blk[2] | proc_23_data_PIPO_blk[2] | proc_23_start_FIFO_blk[2] | proc_23_TLF_FIFO_blk[2] | proc_23_input_sync_blk[2] | proc_23_output_sync_blk[2]);
    assign proc_23_data_FIFO_blk[3] = 1'b0;
    assign proc_23_data_PIPO_blk[3] = 1'b0;
    assign proc_23_start_FIFO_blk[3] = 1'b0;
    assign proc_23_TLF_FIFO_blk[3] = 1'b0;
    assign proc_23_input_sync_blk[3] = 1'b0 | (grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.ap_sync_conv3_1_reuse16_compute_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_compute_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.ap_sync_conv3_1_reuse16_windows_U0_ap_ready);
    assign proc_23_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_23[3] = dl_detect_out ? proc_dep_vld_vec_23_reg[3] : (proc_23_data_FIFO_blk[3] | proc_23_data_PIPO_blk[3] | proc_23_start_FIFO_blk[3] | proc_23_TLF_FIFO_blk[3] | proc_23_input_sync_blk[3] | proc_23_output_sync_blk[3]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_23_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_23_reg <= proc_dep_vld_vec_23;
        end
    end
    assign in_chan_dep_vld_vec_23[0] = dep_chan_vld_21_23;
    assign in_chan_dep_data_vec_23[33 : 0] = dep_chan_data_21_23;
    assign token_in_vec_23[0] = token_21_23;
    assign in_chan_dep_vld_vec_23[1] = dep_chan_vld_22_23;
    assign in_chan_dep_data_vec_23[67 : 34] = dep_chan_data_22_23;
    assign token_in_vec_23[1] = token_22_23;
    assign in_chan_dep_vld_vec_23[2] = dep_chan_vld_24_23;
    assign in_chan_dep_data_vec_23[101 : 68] = dep_chan_data_24_23;
    assign token_in_vec_23[2] = token_24_23;
    assign in_chan_dep_vld_vec_23[3] = dep_chan_vld_25_23;
    assign in_chan_dep_data_vec_23[135 : 102] = dep_chan_data_25_23;
    assign token_in_vec_23[3] = token_25_23;
    assign dep_chan_vld_23_22 = out_chan_dep_vld_vec_23[0];
    assign dep_chan_data_23_22 = out_chan_dep_data_23;
    assign token_23_22 = token_out_vec_23[0];
    assign dep_chan_vld_23_24 = out_chan_dep_vld_vec_23[1];
    assign dep_chan_data_23_24 = out_chan_dep_data_23;
    assign token_23_24 = token_out_vec_23[1];
    assign dep_chan_vld_23_25 = out_chan_dep_vld_vec_23[2];
    assign dep_chan_data_23_25 = out_chan_dep_data_23;
    assign token_23_25 = token_out_vec_23[2];
    assign dep_chan_vld_23_21 = out_chan_dep_vld_vec_23[3];
    assign dep_chan_data_23_21 = out_chan_dep_data_23;
    assign token_23_21 = token_out_vec_23[3];

    // Process: grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0
    cnn_hls_deadlock_detect_unit #(34, 24, 10, 10) cnn_hls_deadlock_detect_unit_24 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_24),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_24),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_24),
        .token_in_vec(token_in_vec_24),
        .dl_detect_in(dl_detect_out),
        .origin(origin[24]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_24),
        .out_chan_dep_data(out_chan_dep_data_24),
        .token_out_vec(token_out_vec_24),
        .dl_detect_out(dl_in_vec[24]));

    assign proc_24_data_FIFO_blk[0] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_windows_U0.s_c31_blk_n);
    assign proc_24_data_PIPO_blk[0] = 1'b0;
    assign proc_24_start_FIFO_blk[0] = 1'b0;
    assign proc_24_TLF_FIFO_blk[0] = 1'b0;
    assign proc_24_input_sync_blk[0] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_conv3_2_reuse32_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv3_1_reuse16_U0_ap_ready);
    assign proc_24_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_24[0] = dl_detect_out ? proc_dep_vld_vec_24_reg[0] : (proc_24_data_FIFO_blk[0] | proc_24_data_PIPO_blk[0] | proc_24_start_FIFO_blk[0] | proc_24_TLF_FIFO_blk[0] | proc_24_input_sync_blk[0] | proc_24_output_sync_blk[0]);
    assign proc_24_data_FIFO_blk[1] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_windows_U0.s_c31_blk_n);
    assign proc_24_data_PIPO_blk[1] = 1'b0;
    assign proc_24_start_FIFO_blk[1] = 1'b0;
    assign proc_24_TLF_FIFO_blk[1] = 1'b0;
    assign proc_24_input_sync_blk[1] = 1'b0;
    assign proc_24_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_24[1] = dl_detect_out ? proc_dep_vld_vec_24_reg[1] : (proc_24_data_FIFO_blk[1] | proc_24_data_PIPO_blk[1] | proc_24_start_FIFO_blk[1] | proc_24_TLF_FIFO_blk[1] | proc_24_input_sync_blk[1] | proc_24_output_sync_blk[1]);
    assign proc_24_data_FIFO_blk[2] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_compute_U0.grp_conv3_2_reuse32_compute_Pipeline_CONV3_2_REUSE_PHASES_fu_112.s_c32_blk_n);
    assign proc_24_data_PIPO_blk[2] = 1'b0;
    assign proc_24_start_FIFO_blk[2] = 1'b0 | (~grp_cnn_pipeline_fu_1933.start_for_maxpool3_U0_U.if_full_n & grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.ap_start & ~grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.real_start & (trans_in_cnt_8 == trans_out_cnt_8) & ~grp_cnn_pipeline_fu_1933.start_for_maxpool3_U0_U.if_read);
    assign proc_24_TLF_FIFO_blk[2] = 1'b0;
    assign proc_24_input_sync_blk[2] = 1'b0;
    assign proc_24_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_24[2] = dl_detect_out ? proc_dep_vld_vec_24_reg[2] : (proc_24_data_FIFO_blk[2] | proc_24_data_PIPO_blk[2] | proc_24_start_FIFO_blk[2] | proc_24_TLF_FIFO_blk[2] | proc_24_input_sync_blk[2] | proc_24_output_sync_blk[2]);
    assign proc_24_data_FIFO_blk[3] = 1'b0;
    assign proc_24_data_PIPO_blk[3] = 1'b0;
    assign proc_24_start_FIFO_blk[3] = 1'b0;
    assign proc_24_TLF_FIFO_blk[3] = 1'b0;
    assign proc_24_input_sync_blk[3] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_conv3_2_reuse32_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_entry_proc_U0_ap_ready);
    assign proc_24_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_24[3] = dl_detect_out ? proc_dep_vld_vec_24_reg[3] : (proc_24_data_FIFO_blk[3] | proc_24_data_PIPO_blk[3] | proc_24_start_FIFO_blk[3] | proc_24_TLF_FIFO_blk[3] | proc_24_input_sync_blk[3] | proc_24_output_sync_blk[3]);
    assign proc_24_data_FIFO_blk[4] = 1'b0;
    assign proc_24_data_PIPO_blk[4] = 1'b0;
    assign proc_24_start_FIFO_blk[4] = 1'b0;
    assign proc_24_TLF_FIFO_blk[4] = 1'b0;
    assign proc_24_input_sync_blk[4] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_conv3_2_reuse32_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_cnn_read_input_U0_ap_ready);
    assign proc_24_output_sync_blk[4] = 1'b0;
    assign proc_dep_vld_vec_24[4] = dl_detect_out ? proc_dep_vld_vec_24_reg[4] : (proc_24_data_FIFO_blk[4] | proc_24_data_PIPO_blk[4] | proc_24_start_FIFO_blk[4] | proc_24_TLF_FIFO_blk[4] | proc_24_input_sync_blk[4] | proc_24_output_sync_blk[4]);
    assign proc_24_data_FIFO_blk[5] = 1'b0;
    assign proc_24_data_PIPO_blk[5] = 1'b0;
    assign proc_24_start_FIFO_blk[5] = 1'b0;
    assign proc_24_TLF_FIFO_blk[5] = 1'b0;
    assign proc_24_input_sync_blk[5] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_conv3_2_reuse32_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv1_1_lane2_U0_ap_ready);
    assign proc_24_output_sync_blk[5] = 1'b0;
    assign proc_dep_vld_vec_24[5] = dl_detect_out ? proc_dep_vld_vec_24_reg[5] : (proc_24_data_FIFO_blk[5] | proc_24_data_PIPO_blk[5] | proc_24_start_FIFO_blk[5] | proc_24_TLF_FIFO_blk[5] | proc_24_input_sync_blk[5] | proc_24_output_sync_blk[5]);
    assign proc_24_data_FIFO_blk[6] = 1'b0;
    assign proc_24_data_PIPO_blk[6] = 1'b0;
    assign proc_24_start_FIFO_blk[6] = 1'b0;
    assign proc_24_TLF_FIFO_blk[6] = 1'b0;
    assign proc_24_input_sync_blk[6] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_conv3_2_reuse32_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv1_2_lane2_U0_ap_ready);
    assign proc_24_output_sync_blk[6] = 1'b0;
    assign proc_dep_vld_vec_24[6] = dl_detect_out ? proc_dep_vld_vec_24_reg[6] : (proc_24_data_FIFO_blk[6] | proc_24_data_PIPO_blk[6] | proc_24_start_FIFO_blk[6] | proc_24_TLF_FIFO_blk[6] | proc_24_input_sync_blk[6] | proc_24_output_sync_blk[6]);
    assign proc_24_data_FIFO_blk[7] = 1'b0;
    assign proc_24_data_PIPO_blk[7] = 1'b0;
    assign proc_24_start_FIFO_blk[7] = 1'b0;
    assign proc_24_TLF_FIFO_blk[7] = 1'b0;
    assign proc_24_input_sync_blk[7] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_conv3_2_reuse32_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv2_1_U0_ap_ready);
    assign proc_24_output_sync_blk[7] = 1'b0;
    assign proc_dep_vld_vec_24[7] = dl_detect_out ? proc_dep_vld_vec_24_reg[7] : (proc_24_data_FIFO_blk[7] | proc_24_data_PIPO_blk[7] | proc_24_start_FIFO_blk[7] | proc_24_TLF_FIFO_blk[7] | proc_24_input_sync_blk[7] | proc_24_output_sync_blk[7]);
    assign proc_24_data_FIFO_blk[8] = 1'b0;
    assign proc_24_data_PIPO_blk[8] = 1'b0;
    assign proc_24_start_FIFO_blk[8] = 1'b0;
    assign proc_24_TLF_FIFO_blk[8] = 1'b0;
    assign proc_24_input_sync_blk[8] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_conv3_2_reuse32_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv2_2_U0_ap_ready);
    assign proc_24_output_sync_blk[8] = 1'b0;
    assign proc_dep_vld_vec_24[8] = dl_detect_out ? proc_dep_vld_vec_24_reg[8] : (proc_24_data_FIFO_blk[8] | proc_24_data_PIPO_blk[8] | proc_24_start_FIFO_blk[8] | proc_24_TLF_FIFO_blk[8] | proc_24_input_sync_blk[8] | proc_24_output_sync_blk[8]);
    assign proc_24_data_FIFO_blk[9] = 1'b0;
    assign proc_24_data_PIPO_blk[9] = 1'b0;
    assign proc_24_start_FIFO_blk[9] = 1'b0;
    assign proc_24_TLF_FIFO_blk[9] = 1'b0;
    assign proc_24_input_sync_blk[9] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_conv3_2_reuse32_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_classification_head_stream_U0_ap_ready);
    assign proc_24_output_sync_blk[9] = 1'b0;
    assign proc_dep_vld_vec_24[9] = dl_detect_out ? proc_dep_vld_vec_24_reg[9] : (proc_24_data_FIFO_blk[9] | proc_24_data_PIPO_blk[9] | proc_24_start_FIFO_blk[9] | proc_24_TLF_FIFO_blk[9] | proc_24_input_sync_blk[9] | proc_24_output_sync_blk[9]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_24_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_24_reg <= proc_dep_vld_vec_24;
        end
    end
    assign in_chan_dep_vld_vec_24[0] = dep_chan_vld_0_24;
    assign in_chan_dep_data_vec_24[33 : 0] = dep_chan_data_0_24;
    assign token_in_vec_24[0] = token_0_24;
    assign in_chan_dep_vld_vec_24[1] = dep_chan_vld_1_24;
    assign in_chan_dep_data_vec_24[67 : 34] = dep_chan_data_1_24;
    assign token_in_vec_24[1] = token_1_24;
    assign in_chan_dep_vld_vec_24[2] = dep_chan_vld_2_24;
    assign in_chan_dep_data_vec_24[101 : 68] = dep_chan_data_2_24;
    assign token_in_vec_24[2] = token_2_24;
    assign in_chan_dep_vld_vec_24[3] = dep_chan_vld_5_24;
    assign in_chan_dep_data_vec_24[135 : 102] = dep_chan_data_5_24;
    assign token_in_vec_24[3] = token_5_24;
    assign in_chan_dep_vld_vec_24[4] = dep_chan_vld_11_24;
    assign in_chan_dep_data_vec_24[169 : 136] = dep_chan_data_11_24;
    assign token_in_vec_24[4] = token_11_24;
    assign in_chan_dep_vld_vec_24[5] = dep_chan_vld_15_24;
    assign in_chan_dep_data_vec_24[203 : 170] = dep_chan_data_15_24;
    assign token_in_vec_24[5] = token_15_24;
    assign in_chan_dep_vld_vec_24[6] = dep_chan_vld_20_24;
    assign in_chan_dep_data_vec_24[237 : 204] = dep_chan_data_20_24;
    assign token_in_vec_24[6] = token_20_24;
    assign in_chan_dep_vld_vec_24[7] = dep_chan_vld_23_24;
    assign in_chan_dep_data_vec_24[271 : 238] = dep_chan_data_23_24;
    assign token_in_vec_24[7] = token_23_24;
    assign in_chan_dep_vld_vec_24[8] = dep_chan_vld_28_24;
    assign in_chan_dep_data_vec_24[305 : 272] = dep_chan_data_28_24;
    assign token_in_vec_24[8] = token_28_24;
    assign in_chan_dep_vld_vec_24[9] = dep_chan_vld_29_24;
    assign in_chan_dep_data_vec_24[339 : 306] = dep_chan_data_29_24;
    assign token_in_vec_24[9] = token_29_24;
    assign dep_chan_vld_24_20 = out_chan_dep_vld_vec_24[0];
    assign dep_chan_data_24_20 = out_chan_dep_data_24;
    assign token_24_20 = token_out_vec_24[0];
    assign dep_chan_vld_24_23 = out_chan_dep_vld_vec_24[1];
    assign dep_chan_data_24_23 = out_chan_dep_data_24;
    assign token_24_23 = token_out_vec_24[1];
    assign dep_chan_vld_24_28 = out_chan_dep_vld_vec_24[2];
    assign dep_chan_data_24_28 = out_chan_dep_data_24;
    assign token_24_28 = token_out_vec_24[2];
    assign dep_chan_vld_24_0 = out_chan_dep_vld_vec_24[3];
    assign dep_chan_data_24_0 = out_chan_dep_data_24;
    assign token_24_0 = token_out_vec_24[3];
    assign dep_chan_vld_24_1 = out_chan_dep_vld_vec_24[4];
    assign dep_chan_data_24_1 = out_chan_dep_data_24;
    assign token_24_1 = token_out_vec_24[4];
    assign dep_chan_vld_24_2 = out_chan_dep_vld_vec_24[5];
    assign dep_chan_data_24_2 = out_chan_dep_data_24;
    assign token_24_2 = token_out_vec_24[5];
    assign dep_chan_vld_24_5 = out_chan_dep_vld_vec_24[6];
    assign dep_chan_data_24_5 = out_chan_dep_data_24;
    assign token_24_5 = token_out_vec_24[6];
    assign dep_chan_vld_24_11 = out_chan_dep_vld_vec_24[7];
    assign dep_chan_data_24_11 = out_chan_dep_data_24;
    assign token_24_11 = token_out_vec_24[7];
    assign dep_chan_vld_24_15 = out_chan_dep_vld_vec_24[8];
    assign dep_chan_data_24_15 = out_chan_dep_data_24;
    assign token_24_15 = token_out_vec_24[8];
    assign dep_chan_vld_24_29 = out_chan_dep_vld_vec_24[9];
    assign dep_chan_data_24_29 = out_chan_dep_data_24;
    assign token_24_29 = token_out_vec_24[9];

    // Process: grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_windows_U0
    cnn_hls_deadlock_detect_unit #(34, 25, 4, 4) cnn_hls_deadlock_detect_unit_25 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_25),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_25),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_25),
        .token_in_vec(token_in_vec_25),
        .dl_detect_in(dl_detect_out),
        .origin(origin[25]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_25),
        .out_chan_dep_data(out_chan_dep_data_25),
        .token_out_vec(token_out_vec_25),
        .dl_detect_out(dl_in_vec[25]));

    assign proc_25_data_FIFO_blk[0] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_windows_U0.s_c31_blk_n);
    assign proc_25_data_PIPO_blk[0] = 1'b0;
    assign proc_25_start_FIFO_blk[0] = 1'b0;
    assign proc_25_TLF_FIFO_blk[0] = 1'b0;
    assign proc_25_input_sync_blk[0] = 1'b0;
    assign proc_25_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_25[0] = dl_detect_out ? proc_dep_vld_vec_25_reg[0] : (proc_25_data_FIFO_blk[0] | proc_25_data_PIPO_blk[0] | proc_25_start_FIFO_blk[0] | proc_25_TLF_FIFO_blk[0] | proc_25_input_sync_blk[0] | proc_25_output_sync_blk[0]);
    assign proc_25_data_FIFO_blk[1] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_windows_U0.s_c31_blk_n);
    assign proc_25_data_PIPO_blk[1] = 1'b0;
    assign proc_25_start_FIFO_blk[1] = 1'b0;
    assign proc_25_TLF_FIFO_blk[1] = 1'b0;
    assign proc_25_input_sync_blk[1] = 1'b0;
    assign proc_25_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_25[1] = dl_detect_out ? proc_dep_vld_vec_25_reg[1] : (proc_25_data_FIFO_blk[1] | proc_25_data_PIPO_blk[1] | proc_25_start_FIFO_blk[1] | proc_25_TLF_FIFO_blk[1] | proc_25_input_sync_blk[1] | proc_25_output_sync_blk[1]);
    assign proc_25_data_FIFO_blk[2] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_windows_U0.windows_blk_n);
    assign proc_25_data_PIPO_blk[2] = 1'b0;
    assign proc_25_start_FIFO_blk[2] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.start_for_conv3_2_reuse32_pack_windows_U0_U.if_full_n & grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_windows_U0.ap_start & ~grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_windows_U0.real_start & (trans_in_cnt_7 == trans_out_cnt_7) & ~grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.start_for_conv3_2_reuse32_pack_windows_U0_U.if_read);
    assign proc_25_TLF_FIFO_blk[2] = 1'b0;
    assign proc_25_input_sync_blk[2] = 1'b0;
    assign proc_25_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_25[2] = dl_detect_out ? proc_dep_vld_vec_25_reg[2] : (proc_25_data_FIFO_blk[2] | proc_25_data_PIPO_blk[2] | proc_25_start_FIFO_blk[2] | proc_25_TLF_FIFO_blk[2] | proc_25_input_sync_blk[2] | proc_25_output_sync_blk[2]);
    assign proc_25_data_FIFO_blk[3] = 1'b0;
    assign proc_25_data_PIPO_blk[3] = 1'b0;
    assign proc_25_start_FIFO_blk[3] = 1'b0;
    assign proc_25_TLF_FIFO_blk[3] = 1'b0;
    assign proc_25_input_sync_blk[3] = 1'b0 | (grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.ap_sync_conv3_2_reuse32_windows_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_windows_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.ap_sync_conv3_2_reuse32_compute_U0_ap_ready);
    assign proc_25_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_25[3] = dl_detect_out ? proc_dep_vld_vec_25_reg[3] : (proc_25_data_FIFO_blk[3] | proc_25_data_PIPO_blk[3] | proc_25_start_FIFO_blk[3] | proc_25_TLF_FIFO_blk[3] | proc_25_input_sync_blk[3] | proc_25_output_sync_blk[3]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_25_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_25_reg <= proc_dep_vld_vec_25;
        end
    end
    assign in_chan_dep_vld_vec_25[0] = dep_chan_vld_20_25;
    assign in_chan_dep_data_vec_25[33 : 0] = dep_chan_data_20_25;
    assign token_in_vec_25[0] = token_20_25;
    assign in_chan_dep_vld_vec_25[1] = dep_chan_vld_23_25;
    assign in_chan_dep_data_vec_25[67 : 34] = dep_chan_data_23_25;
    assign token_in_vec_25[1] = token_23_25;
    assign in_chan_dep_vld_vec_25[2] = dep_chan_vld_26_25;
    assign in_chan_dep_data_vec_25[101 : 68] = dep_chan_data_26_25;
    assign token_in_vec_25[2] = token_26_25;
    assign in_chan_dep_vld_vec_25[3] = dep_chan_vld_27_25;
    assign in_chan_dep_data_vec_25[135 : 102] = dep_chan_data_27_25;
    assign token_in_vec_25[3] = token_27_25;
    assign dep_chan_vld_25_20 = out_chan_dep_vld_vec_25[0];
    assign dep_chan_data_25_20 = out_chan_dep_data_25;
    assign token_25_20 = token_out_vec_25[0];
    assign dep_chan_vld_25_23 = out_chan_dep_vld_vec_25[1];
    assign dep_chan_data_25_23 = out_chan_dep_data_25;
    assign token_25_23 = token_out_vec_25[1];
    assign dep_chan_vld_25_26 = out_chan_dep_vld_vec_25[2];
    assign dep_chan_data_25_26 = out_chan_dep_data_25;
    assign token_25_26 = token_out_vec_25[2];
    assign dep_chan_vld_25_27 = out_chan_dep_vld_vec_25[3];
    assign dep_chan_data_25_27 = out_chan_dep_data_25;
    assign token_25_27 = token_out_vec_25[3];

    // Process: grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_pack_windows_U0
    cnn_hls_deadlock_detect_unit #(34, 26, 2, 2) cnn_hls_deadlock_detect_unit_26 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_26),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_26),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_26),
        .token_in_vec(token_in_vec_26),
        .dl_detect_in(dl_detect_out),
        .origin(origin[26]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_26),
        .out_chan_dep_data(out_chan_dep_data_26),
        .token_out_vec(token_out_vec_26),
        .dl_detect_out(dl_in_vec[26]));

    assign proc_26_data_FIFO_blk[0] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_pack_windows_U0.windows_blk_n);
    assign proc_26_data_PIPO_blk[0] = 1'b0;
    assign proc_26_start_FIFO_blk[0] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.start_for_conv3_2_reuse32_pack_windows_U0_U.if_empty_n & grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_pack_windows_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.start_for_conv3_2_reuse32_pack_windows_U0_U.if_write);
    assign proc_26_TLF_FIFO_blk[0] = 1'b0;
    assign proc_26_input_sync_blk[0] = 1'b0;
    assign proc_26_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_26[0] = dl_detect_out ? proc_dep_vld_vec_26_reg[0] : (proc_26_data_FIFO_blk[0] | proc_26_data_PIPO_blk[0] | proc_26_start_FIFO_blk[0] | proc_26_TLF_FIFO_blk[0] | proc_26_input_sync_blk[0] | proc_26_output_sync_blk[0]);
    assign proc_26_data_FIFO_blk[1] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_pack_windows_U0.window_sets_blk_n);
    assign proc_26_data_PIPO_blk[1] = 1'b0;
    assign proc_26_start_FIFO_blk[1] = 1'b0;
    assign proc_26_TLF_FIFO_blk[1] = 1'b0;
    assign proc_26_input_sync_blk[1] = 1'b0;
    assign proc_26_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_26[1] = dl_detect_out ? proc_dep_vld_vec_26_reg[1] : (proc_26_data_FIFO_blk[1] | proc_26_data_PIPO_blk[1] | proc_26_start_FIFO_blk[1] | proc_26_TLF_FIFO_blk[1] | proc_26_input_sync_blk[1] | proc_26_output_sync_blk[1]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_26_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_26_reg <= proc_dep_vld_vec_26;
        end
    end
    assign in_chan_dep_vld_vec_26[0] = dep_chan_vld_25_26;
    assign in_chan_dep_data_vec_26[33 : 0] = dep_chan_data_25_26;
    assign token_in_vec_26[0] = token_25_26;
    assign in_chan_dep_vld_vec_26[1] = dep_chan_vld_27_26;
    assign in_chan_dep_data_vec_26[67 : 34] = dep_chan_data_27_26;
    assign token_in_vec_26[1] = token_27_26;
    assign dep_chan_vld_26_25 = out_chan_dep_vld_vec_26[0];
    assign dep_chan_data_26_25 = out_chan_dep_data_26;
    assign token_26_25 = token_out_vec_26[0];
    assign dep_chan_vld_26_27 = out_chan_dep_vld_vec_26[1];
    assign dep_chan_data_26_27 = out_chan_dep_data_26;
    assign token_26_27 = token_out_vec_26[1];

    // Process: grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_compute_U0
    cnn_hls_deadlock_detect_unit #(34, 27, 3, 3) cnn_hls_deadlock_detect_unit_27 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_27),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_27),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_27),
        .token_in_vec(token_in_vec_27),
        .dl_detect_in(dl_detect_out),
        .origin(origin[27]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_27),
        .out_chan_dep_data(out_chan_dep_data_27),
        .token_out_vec(token_out_vec_27),
        .dl_detect_out(dl_in_vec[27]));

    assign proc_27_data_FIFO_blk[0] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_compute_U0.grp_conv3_2_reuse32_compute_Pipeline_CONV3_2_REUSE_PHASES_fu_112.window_sets_blk_n);
    assign proc_27_data_PIPO_blk[0] = 1'b0;
    assign proc_27_start_FIFO_blk[0] = 1'b0;
    assign proc_27_TLF_FIFO_blk[0] = 1'b0;
    assign proc_27_input_sync_blk[0] = 1'b0;
    assign proc_27_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_27[0] = dl_detect_out ? proc_dep_vld_vec_27_reg[0] : (proc_27_data_FIFO_blk[0] | proc_27_data_PIPO_blk[0] | proc_27_start_FIFO_blk[0] | proc_27_TLF_FIFO_blk[0] | proc_27_input_sync_blk[0] | proc_27_output_sync_blk[0]);
    assign proc_27_data_FIFO_blk[1] = 1'b0 | (~grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_compute_U0.grp_conv3_2_reuse32_compute_Pipeline_CONV3_2_REUSE_PHASES_fu_112.s_c32_blk_n);
    assign proc_27_data_PIPO_blk[1] = 1'b0;
    assign proc_27_start_FIFO_blk[1] = 1'b0;
    assign proc_27_TLF_FIFO_blk[1] = 1'b0;
    assign proc_27_input_sync_blk[1] = 1'b0;
    assign proc_27_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_27[1] = dl_detect_out ? proc_dep_vld_vec_27_reg[1] : (proc_27_data_FIFO_blk[1] | proc_27_data_PIPO_blk[1] | proc_27_start_FIFO_blk[1] | proc_27_TLF_FIFO_blk[1] | proc_27_input_sync_blk[1] | proc_27_output_sync_blk[1]);
    assign proc_27_data_FIFO_blk[2] = 1'b0;
    assign proc_27_data_PIPO_blk[2] = 1'b0;
    assign proc_27_start_FIFO_blk[2] = 1'b0;
    assign proc_27_TLF_FIFO_blk[2] = 1'b0;
    assign proc_27_input_sync_blk[2] = 1'b0 | (grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.ap_sync_conv3_2_reuse32_compute_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_compute_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.ap_sync_conv3_2_reuse32_windows_U0_ap_ready);
    assign proc_27_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_27[2] = dl_detect_out ? proc_dep_vld_vec_27_reg[2] : (proc_27_data_FIFO_blk[2] | proc_27_data_PIPO_blk[2] | proc_27_start_FIFO_blk[2] | proc_27_TLF_FIFO_blk[2] | proc_27_input_sync_blk[2] | proc_27_output_sync_blk[2]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_27_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_27_reg <= proc_dep_vld_vec_27;
        end
    end
    assign in_chan_dep_vld_vec_27[0] = dep_chan_vld_25_27;
    assign in_chan_dep_data_vec_27[33 : 0] = dep_chan_data_25_27;
    assign token_in_vec_27[0] = token_25_27;
    assign in_chan_dep_vld_vec_27[1] = dep_chan_vld_26_27;
    assign in_chan_dep_data_vec_27[67 : 34] = dep_chan_data_26_27;
    assign token_in_vec_27[1] = token_26_27;
    assign in_chan_dep_vld_vec_27[2] = dep_chan_vld_28_27;
    assign in_chan_dep_data_vec_27[101 : 68] = dep_chan_data_28_27;
    assign token_in_vec_27[2] = token_28_27;
    assign dep_chan_vld_27_26 = out_chan_dep_vld_vec_27[0];
    assign dep_chan_data_27_26 = out_chan_dep_data_27;
    assign token_27_26 = token_out_vec_27[0];
    assign dep_chan_vld_27_28 = out_chan_dep_vld_vec_27[1];
    assign dep_chan_data_27_28 = out_chan_dep_data_27;
    assign token_27_28 = token_out_vec_27[1];
    assign dep_chan_vld_27_25 = out_chan_dep_vld_vec_27[2];
    assign dep_chan_data_27_25 = out_chan_dep_data_27;
    assign token_27_25 = token_out_vec_27[2];

    // Process: grp_cnn_pipeline_fu_1933.maxpool3_U0
    cnn_hls_deadlock_detect_unit #(34, 28, 4, 4) cnn_hls_deadlock_detect_unit_28 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_28),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_28),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_28),
        .token_in_vec(token_in_vec_28),
        .dl_detect_in(dl_detect_out),
        .origin(origin[28]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_28),
        .out_chan_dep_data(out_chan_dep_data_28),
        .token_out_vec(token_out_vec_28),
        .dl_detect_out(dl_in_vec[28]));

    assign proc_28_data_FIFO_blk[0] = 1'b0 | (~grp_cnn_pipeline_fu_1933.maxpool3_U0.s_c32_blk_n);
    assign proc_28_data_PIPO_blk[0] = 1'b0;
    assign proc_28_start_FIFO_blk[0] = 1'b0 | (~grp_cnn_pipeline_fu_1933.start_for_maxpool3_U0_U.if_empty_n & grp_cnn_pipeline_fu_1933.maxpool3_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.start_for_maxpool3_U0_U.if_write);
    assign proc_28_TLF_FIFO_blk[0] = 1'b0;
    assign proc_28_input_sync_blk[0] = 1'b0;
    assign proc_28_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_28[0] = dl_detect_out ? proc_dep_vld_vec_28_reg[0] : (proc_28_data_FIFO_blk[0] | proc_28_data_PIPO_blk[0] | proc_28_start_FIFO_blk[0] | proc_28_TLF_FIFO_blk[0] | proc_28_input_sync_blk[0] | proc_28_output_sync_blk[0]);
    assign proc_28_data_FIFO_blk[1] = 1'b0 | (~grp_cnn_pipeline_fu_1933.maxpool3_U0.s_c32_blk_n);
    assign proc_28_data_PIPO_blk[1] = 1'b0;
    assign proc_28_start_FIFO_blk[1] = 1'b0;
    assign proc_28_TLF_FIFO_blk[1] = 1'b0;
    assign proc_28_input_sync_blk[1] = 1'b0;
    assign proc_28_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_28[1] = dl_detect_out ? proc_dep_vld_vec_28_reg[1] : (proc_28_data_FIFO_blk[1] | proc_28_data_PIPO_blk[1] | proc_28_start_FIFO_blk[1] | proc_28_TLF_FIFO_blk[1] | proc_28_input_sync_blk[1] | proc_28_output_sync_blk[1]);
    assign proc_28_data_FIFO_blk[2] = 1'b0 | (~grp_cnn_pipeline_fu_1933.maxpool3_U0.s_pool3_blk_n);
    assign proc_28_data_PIPO_blk[2] = 1'b0;
    assign proc_28_start_FIFO_blk[2] = 1'b0;
    assign proc_28_TLF_FIFO_blk[2] = 1'b0;
    assign proc_28_input_sync_blk[2] = 1'b0;
    assign proc_28_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_28[2] = dl_detect_out ? proc_dep_vld_vec_28_reg[2] : (proc_28_data_FIFO_blk[2] | proc_28_data_PIPO_blk[2] | proc_28_start_FIFO_blk[2] | proc_28_TLF_FIFO_blk[2] | proc_28_input_sync_blk[2] | proc_28_output_sync_blk[2]);
    assign proc_28_data_FIFO_blk[3] = 1'b0 | (~grp_cnn_pipeline_fu_1933.maxpool3_U0.s_pool3_blk_n);
    assign proc_28_data_PIPO_blk[3] = 1'b0;
    assign proc_28_start_FIFO_blk[3] = 1'b0;
    assign proc_28_TLF_FIFO_blk[3] = 1'b0;
    assign proc_28_input_sync_blk[3] = 1'b0;
    assign proc_28_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_28[3] = dl_detect_out ? proc_dep_vld_vec_28_reg[3] : (proc_28_data_FIFO_blk[3] | proc_28_data_PIPO_blk[3] | proc_28_start_FIFO_blk[3] | proc_28_TLF_FIFO_blk[3] | proc_28_input_sync_blk[3] | proc_28_output_sync_blk[3]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_28_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_28_reg <= proc_dep_vld_vec_28;
        end
    end
    assign in_chan_dep_vld_vec_28[0] = dep_chan_vld_24_28;
    assign in_chan_dep_data_vec_28[33 : 0] = dep_chan_data_24_28;
    assign token_in_vec_28[0] = token_24_28;
    assign in_chan_dep_vld_vec_28[1] = dep_chan_vld_27_28;
    assign in_chan_dep_data_vec_28[67 : 34] = dep_chan_data_27_28;
    assign token_in_vec_28[1] = token_27_28;
    assign in_chan_dep_vld_vec_28[2] = dep_chan_vld_29_28;
    assign in_chan_dep_data_vec_28[101 : 68] = dep_chan_data_29_28;
    assign token_in_vec_28[2] = token_29_28;
    assign in_chan_dep_vld_vec_28[3] = dep_chan_vld_30_28;
    assign in_chan_dep_data_vec_28[135 : 102] = dep_chan_data_30_28;
    assign token_in_vec_28[3] = token_30_28;
    assign dep_chan_vld_28_24 = out_chan_dep_vld_vec_28[0];
    assign dep_chan_data_28_24 = out_chan_dep_data_28;
    assign token_28_24 = token_out_vec_28[0];
    assign dep_chan_vld_28_27 = out_chan_dep_vld_vec_28[1];
    assign dep_chan_data_28_27 = out_chan_dep_data_28;
    assign token_28_27 = token_out_vec_28[1];
    assign dep_chan_vld_28_29 = out_chan_dep_vld_vec_28[2];
    assign dep_chan_data_28_29 = out_chan_dep_data_28;
    assign token_28_29 = token_out_vec_28[2];
    assign dep_chan_vld_28_30 = out_chan_dep_vld_vec_28[3];
    assign dep_chan_data_28_30 = out_chan_dep_data_28;
    assign token_28_30 = token_out_vec_28[3];

    // Process: grp_cnn_pipeline_fu_1933.classification_head_stream_U0
    cnn_hls_deadlock_detect_unit #(34, 29, 10, 10) cnn_hls_deadlock_detect_unit_29 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_29),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_29),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_29),
        .token_in_vec(token_in_vec_29),
        .dl_detect_in(dl_detect_out),
        .origin(origin[29]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_29),
        .out_chan_dep_data(out_chan_dep_data_29),
        .token_out_vec(token_out_vec_29),
        .dl_detect_out(dl_in_vec[29]));

    assign proc_29_data_FIFO_blk[0] = 1'b0 | (~grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_global_avg_pool_U0.grp_head_global_avg_pool_Pipeline_HEAD_GAP_READ_fu_278.s_pool3_blk_n);
    assign proc_29_data_PIPO_blk[0] = 1'b0;
    assign proc_29_start_FIFO_blk[0] = 1'b0;
    assign proc_29_TLF_FIFO_blk[0] = 1'b0;
    assign proc_29_input_sync_blk[0] = 1'b0;
    assign proc_29_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_29[0] = dl_detect_out ? proc_dep_vld_vec_29_reg[0] : (proc_29_data_FIFO_blk[0] | proc_29_data_PIPO_blk[0] | proc_29_start_FIFO_blk[0] | proc_29_TLF_FIFO_blk[0] | proc_29_input_sync_blk[0] | proc_29_output_sync_blk[0]);
    assign proc_29_data_FIFO_blk[1] = 1'b0 | (~grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_dense2_logits_U0.grp_head_dense2_logits_Pipeline_HEAD_FC2_OUTPUT_fu_478.scores_blk_n);
    assign proc_29_data_PIPO_blk[1] = 1'b0;
    assign proc_29_start_FIFO_blk[1] = 1'b0;
    assign proc_29_TLF_FIFO_blk[1] = 1'b0;
    assign proc_29_input_sync_blk[1] = 1'b0;
    assign proc_29_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_29[1] = dl_detect_out ? proc_dep_vld_vec_29_reg[1] : (proc_29_data_FIFO_blk[1] | proc_29_data_PIPO_blk[1] | proc_29_start_FIFO_blk[1] | proc_29_TLF_FIFO_blk[1] | proc_29_input_sync_blk[1] | proc_29_output_sync_blk[1]);
    assign proc_29_data_FIFO_blk[2] = 1'b0;
    assign proc_29_data_PIPO_blk[2] = 1'b0;
    assign proc_29_start_FIFO_blk[2] = 1'b0;
    assign proc_29_TLF_FIFO_blk[2] = 1'b0;
    assign proc_29_input_sync_blk[2] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_classification_head_stream_U0_ap_ready & grp_cnn_pipeline_fu_1933.classification_head_stream_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_entry_proc_U0_ap_ready);
    assign proc_29_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_29[2] = dl_detect_out ? proc_dep_vld_vec_29_reg[2] : (proc_29_data_FIFO_blk[2] | proc_29_data_PIPO_blk[2] | proc_29_start_FIFO_blk[2] | proc_29_TLF_FIFO_blk[2] | proc_29_input_sync_blk[2] | proc_29_output_sync_blk[2]);
    assign proc_29_data_FIFO_blk[3] = 1'b0;
    assign proc_29_data_PIPO_blk[3] = 1'b0;
    assign proc_29_start_FIFO_blk[3] = 1'b0;
    assign proc_29_TLF_FIFO_blk[3] = 1'b0;
    assign proc_29_input_sync_blk[3] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_classification_head_stream_U0_ap_ready & grp_cnn_pipeline_fu_1933.classification_head_stream_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_cnn_read_input_U0_ap_ready);
    assign proc_29_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_29[3] = dl_detect_out ? proc_dep_vld_vec_29_reg[3] : (proc_29_data_FIFO_blk[3] | proc_29_data_PIPO_blk[3] | proc_29_start_FIFO_blk[3] | proc_29_TLF_FIFO_blk[3] | proc_29_input_sync_blk[3] | proc_29_output_sync_blk[3]);
    assign proc_29_data_FIFO_blk[4] = 1'b0;
    assign proc_29_data_PIPO_blk[4] = 1'b0;
    assign proc_29_start_FIFO_blk[4] = 1'b0;
    assign proc_29_TLF_FIFO_blk[4] = 1'b0;
    assign proc_29_input_sync_blk[4] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_classification_head_stream_U0_ap_ready & grp_cnn_pipeline_fu_1933.classification_head_stream_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv1_1_lane2_U0_ap_ready);
    assign proc_29_output_sync_blk[4] = 1'b0;
    assign proc_dep_vld_vec_29[4] = dl_detect_out ? proc_dep_vld_vec_29_reg[4] : (proc_29_data_FIFO_blk[4] | proc_29_data_PIPO_blk[4] | proc_29_start_FIFO_blk[4] | proc_29_TLF_FIFO_blk[4] | proc_29_input_sync_blk[4] | proc_29_output_sync_blk[4]);
    assign proc_29_data_FIFO_blk[5] = 1'b0;
    assign proc_29_data_PIPO_blk[5] = 1'b0;
    assign proc_29_start_FIFO_blk[5] = 1'b0;
    assign proc_29_TLF_FIFO_blk[5] = 1'b0;
    assign proc_29_input_sync_blk[5] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_classification_head_stream_U0_ap_ready & grp_cnn_pipeline_fu_1933.classification_head_stream_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv1_2_lane2_U0_ap_ready);
    assign proc_29_output_sync_blk[5] = 1'b0;
    assign proc_dep_vld_vec_29[5] = dl_detect_out ? proc_dep_vld_vec_29_reg[5] : (proc_29_data_FIFO_blk[5] | proc_29_data_PIPO_blk[5] | proc_29_start_FIFO_blk[5] | proc_29_TLF_FIFO_blk[5] | proc_29_input_sync_blk[5] | proc_29_output_sync_blk[5]);
    assign proc_29_data_FIFO_blk[6] = 1'b0;
    assign proc_29_data_PIPO_blk[6] = 1'b0;
    assign proc_29_start_FIFO_blk[6] = 1'b0;
    assign proc_29_TLF_FIFO_blk[6] = 1'b0;
    assign proc_29_input_sync_blk[6] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_classification_head_stream_U0_ap_ready & grp_cnn_pipeline_fu_1933.classification_head_stream_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv2_1_U0_ap_ready);
    assign proc_29_output_sync_blk[6] = 1'b0;
    assign proc_dep_vld_vec_29[6] = dl_detect_out ? proc_dep_vld_vec_29_reg[6] : (proc_29_data_FIFO_blk[6] | proc_29_data_PIPO_blk[6] | proc_29_start_FIFO_blk[6] | proc_29_TLF_FIFO_blk[6] | proc_29_input_sync_blk[6] | proc_29_output_sync_blk[6]);
    assign proc_29_data_FIFO_blk[7] = 1'b0;
    assign proc_29_data_PIPO_blk[7] = 1'b0;
    assign proc_29_start_FIFO_blk[7] = 1'b0;
    assign proc_29_TLF_FIFO_blk[7] = 1'b0;
    assign proc_29_input_sync_blk[7] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_classification_head_stream_U0_ap_ready & grp_cnn_pipeline_fu_1933.classification_head_stream_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv2_2_U0_ap_ready);
    assign proc_29_output_sync_blk[7] = 1'b0;
    assign proc_dep_vld_vec_29[7] = dl_detect_out ? proc_dep_vld_vec_29_reg[7] : (proc_29_data_FIFO_blk[7] | proc_29_data_PIPO_blk[7] | proc_29_start_FIFO_blk[7] | proc_29_TLF_FIFO_blk[7] | proc_29_input_sync_blk[7] | proc_29_output_sync_blk[7]);
    assign proc_29_data_FIFO_blk[8] = 1'b0;
    assign proc_29_data_PIPO_blk[8] = 1'b0;
    assign proc_29_start_FIFO_blk[8] = 1'b0;
    assign proc_29_TLF_FIFO_blk[8] = 1'b0;
    assign proc_29_input_sync_blk[8] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_classification_head_stream_U0_ap_ready & grp_cnn_pipeline_fu_1933.classification_head_stream_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv3_1_reuse16_U0_ap_ready);
    assign proc_29_output_sync_blk[8] = 1'b0;
    assign proc_dep_vld_vec_29[8] = dl_detect_out ? proc_dep_vld_vec_29_reg[8] : (proc_29_data_FIFO_blk[8] | proc_29_data_PIPO_blk[8] | proc_29_start_FIFO_blk[8] | proc_29_TLF_FIFO_blk[8] | proc_29_input_sync_blk[8] | proc_29_output_sync_blk[8]);
    assign proc_29_data_FIFO_blk[9] = 1'b0;
    assign proc_29_data_PIPO_blk[9] = 1'b0;
    assign proc_29_start_FIFO_blk[9] = 1'b0;
    assign proc_29_TLF_FIFO_blk[9] = 1'b0;
    assign proc_29_input_sync_blk[9] = 1'b0 | (grp_cnn_pipeline_fu_1933.ap_sync_classification_head_stream_U0_ap_ready & grp_cnn_pipeline_fu_1933.classification_head_stream_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv3_2_reuse32_U0_ap_ready);
    assign proc_29_output_sync_blk[9] = 1'b0;
    assign proc_dep_vld_vec_29[9] = dl_detect_out ? proc_dep_vld_vec_29_reg[9] : (proc_29_data_FIFO_blk[9] | proc_29_data_PIPO_blk[9] | proc_29_start_FIFO_blk[9] | proc_29_TLF_FIFO_blk[9] | proc_29_input_sync_blk[9] | proc_29_output_sync_blk[9]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_29_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_29_reg <= proc_dep_vld_vec_29;
        end
    end
    assign in_chan_dep_vld_vec_29[0] = dep_chan_vld_0_29;
    assign in_chan_dep_data_vec_29[33 : 0] = dep_chan_data_0_29;
    assign token_in_vec_29[0] = token_0_29;
    assign in_chan_dep_vld_vec_29[1] = dep_chan_vld_1_29;
    assign in_chan_dep_data_vec_29[67 : 34] = dep_chan_data_1_29;
    assign token_in_vec_29[1] = token_1_29;
    assign in_chan_dep_vld_vec_29[2] = dep_chan_vld_2_29;
    assign in_chan_dep_data_vec_29[101 : 68] = dep_chan_data_2_29;
    assign token_in_vec_29[2] = token_2_29;
    assign in_chan_dep_vld_vec_29[3] = dep_chan_vld_5_29;
    assign in_chan_dep_data_vec_29[135 : 102] = dep_chan_data_5_29;
    assign token_in_vec_29[3] = token_5_29;
    assign in_chan_dep_vld_vec_29[4] = dep_chan_vld_11_29;
    assign in_chan_dep_data_vec_29[169 : 136] = dep_chan_data_11_29;
    assign token_in_vec_29[4] = token_11_29;
    assign in_chan_dep_vld_vec_29[5] = dep_chan_vld_15_29;
    assign in_chan_dep_data_vec_29[203 : 170] = dep_chan_data_15_29;
    assign token_in_vec_29[5] = token_15_29;
    assign in_chan_dep_vld_vec_29[6] = dep_chan_vld_20_29;
    assign in_chan_dep_data_vec_29[237 : 204] = dep_chan_data_20_29;
    assign token_in_vec_29[6] = token_20_29;
    assign in_chan_dep_vld_vec_29[7] = dep_chan_vld_24_29;
    assign in_chan_dep_data_vec_29[271 : 238] = dep_chan_data_24_29;
    assign token_in_vec_29[7] = token_24_29;
    assign in_chan_dep_vld_vec_29[8] = dep_chan_vld_28_29;
    assign in_chan_dep_data_vec_29[305 : 272] = dep_chan_data_28_29;
    assign token_in_vec_29[8] = token_28_29;
    assign in_chan_dep_vld_vec_29[9] = dep_chan_vld_33_29;
    assign in_chan_dep_data_vec_29[339 : 306] = dep_chan_data_33_29;
    assign token_in_vec_29[9] = token_33_29;
    assign dep_chan_vld_29_28 = out_chan_dep_vld_vec_29[0];
    assign dep_chan_data_29_28 = out_chan_dep_data_29;
    assign token_29_28 = token_out_vec_29[0];
    assign dep_chan_vld_29_33 = out_chan_dep_vld_vec_29[1];
    assign dep_chan_data_29_33 = out_chan_dep_data_29;
    assign token_29_33 = token_out_vec_29[1];
    assign dep_chan_vld_29_0 = out_chan_dep_vld_vec_29[2];
    assign dep_chan_data_29_0 = out_chan_dep_data_29;
    assign token_29_0 = token_out_vec_29[2];
    assign dep_chan_vld_29_1 = out_chan_dep_vld_vec_29[3];
    assign dep_chan_data_29_1 = out_chan_dep_data_29;
    assign token_29_1 = token_out_vec_29[3];
    assign dep_chan_vld_29_2 = out_chan_dep_vld_vec_29[4];
    assign dep_chan_data_29_2 = out_chan_dep_data_29;
    assign token_29_2 = token_out_vec_29[4];
    assign dep_chan_vld_29_5 = out_chan_dep_vld_vec_29[5];
    assign dep_chan_data_29_5 = out_chan_dep_data_29;
    assign token_29_5 = token_out_vec_29[5];
    assign dep_chan_vld_29_11 = out_chan_dep_vld_vec_29[6];
    assign dep_chan_data_29_11 = out_chan_dep_data_29;
    assign token_29_11 = token_out_vec_29[6];
    assign dep_chan_vld_29_15 = out_chan_dep_vld_vec_29[7];
    assign dep_chan_data_29_15 = out_chan_dep_data_29;
    assign token_29_15 = token_out_vec_29[7];
    assign dep_chan_vld_29_20 = out_chan_dep_vld_vec_29[8];
    assign dep_chan_data_29_20 = out_chan_dep_data_29;
    assign token_29_20 = token_out_vec_29[8];
    assign dep_chan_vld_29_24 = out_chan_dep_vld_vec_29[9];
    assign dep_chan_data_29_24 = out_chan_dep_data_29;
    assign token_29_24 = token_out_vec_29[9];

    // Process: grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_global_avg_pool_U0
    cnn_hls_deadlock_detect_unit #(34, 30, 3, 3) cnn_hls_deadlock_detect_unit_30 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_30),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_30),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_30),
        .token_in_vec(token_in_vec_30),
        .dl_detect_in(dl_detect_out),
        .origin(origin[30]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_30),
        .out_chan_dep_data(out_chan_dep_data_30),
        .token_out_vec(token_out_vec_30),
        .dl_detect_out(dl_in_vec[30]));

    assign proc_30_data_FIFO_blk[0] = 1'b0 | (~grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_global_avg_pool_U0.grp_head_global_avg_pool_Pipeline_HEAD_GAP_READ_fu_278.s_pool3_blk_n);
    assign proc_30_data_PIPO_blk[0] = 1'b0;
    assign proc_30_start_FIFO_blk[0] = 1'b0;
    assign proc_30_TLF_FIFO_blk[0] = 1'b0;
    assign proc_30_input_sync_blk[0] = 1'b0;
    assign proc_30_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_30[0] = dl_detect_out ? proc_dep_vld_vec_30_reg[0] : (proc_30_data_FIFO_blk[0] | proc_30_data_PIPO_blk[0] | proc_30_start_FIFO_blk[0] | proc_30_TLF_FIFO_blk[0] | proc_30_input_sync_blk[0] | proc_30_output_sync_blk[0]);
    assign proc_30_data_FIFO_blk[1] = 1'b0 | (~grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_global_avg_pool_U0.grp_head_global_avg_pool_Pipeline_HEAD_GAP_WRITE_fu_348.pooled_blk_n);
    assign proc_30_data_PIPO_blk[1] = 1'b0;
    assign proc_30_start_FIFO_blk[1] = 1'b0;
    assign proc_30_TLF_FIFO_blk[1] = 1'b0;
    assign proc_30_input_sync_blk[1] = 1'b0 | (grp_cnn_pipeline_fu_1933.classification_head_stream_U0.ap_sync_head_global_avg_pool_U0_ap_ready & grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_global_avg_pool_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.classification_head_stream_U0.ap_sync_head_dense64_relu_U0_ap_ready);
    assign proc_30_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_30[1] = dl_detect_out ? proc_dep_vld_vec_30_reg[1] : (proc_30_data_FIFO_blk[1] | proc_30_data_PIPO_blk[1] | proc_30_start_FIFO_blk[1] | proc_30_TLF_FIFO_blk[1] | proc_30_input_sync_blk[1] | proc_30_output_sync_blk[1]);
    assign proc_30_data_FIFO_blk[2] = 1'b0;
    assign proc_30_data_PIPO_blk[2] = 1'b0;
    assign proc_30_start_FIFO_blk[2] = 1'b0;
    assign proc_30_TLF_FIFO_blk[2] = 1'b0;
    assign proc_30_input_sync_blk[2] = 1'b0 | (grp_cnn_pipeline_fu_1933.classification_head_stream_U0.ap_sync_head_global_avg_pool_U0_ap_ready & grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_global_avg_pool_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.classification_head_stream_U0.ap_sync_head_dense2_logits_U0_ap_ready);
    assign proc_30_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_30[2] = dl_detect_out ? proc_dep_vld_vec_30_reg[2] : (proc_30_data_FIFO_blk[2] | proc_30_data_PIPO_blk[2] | proc_30_start_FIFO_blk[2] | proc_30_TLF_FIFO_blk[2] | proc_30_input_sync_blk[2] | proc_30_output_sync_blk[2]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_30_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_30_reg <= proc_dep_vld_vec_30;
        end
    end
    assign in_chan_dep_vld_vec_30[0] = dep_chan_vld_28_30;
    assign in_chan_dep_data_vec_30[33 : 0] = dep_chan_data_28_30;
    assign token_in_vec_30[0] = token_28_30;
    assign in_chan_dep_vld_vec_30[1] = dep_chan_vld_31_30;
    assign in_chan_dep_data_vec_30[67 : 34] = dep_chan_data_31_30;
    assign token_in_vec_30[1] = token_31_30;
    assign in_chan_dep_vld_vec_30[2] = dep_chan_vld_32_30;
    assign in_chan_dep_data_vec_30[101 : 68] = dep_chan_data_32_30;
    assign token_in_vec_30[2] = token_32_30;
    assign dep_chan_vld_30_28 = out_chan_dep_vld_vec_30[0];
    assign dep_chan_data_30_28 = out_chan_dep_data_30;
    assign token_30_28 = token_out_vec_30[0];
    assign dep_chan_vld_30_31 = out_chan_dep_vld_vec_30[1];
    assign dep_chan_data_30_31 = out_chan_dep_data_30;
    assign token_30_31 = token_out_vec_30[1];
    assign dep_chan_vld_30_32 = out_chan_dep_vld_vec_30[2];
    assign dep_chan_data_30_32 = out_chan_dep_data_30;
    assign token_30_32 = token_out_vec_30[2];

    // Process: grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_dense64_relu_U0
    cnn_hls_deadlock_detect_unit #(34, 31, 2, 2) cnn_hls_deadlock_detect_unit_31 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_31),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_31),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_31),
        .token_in_vec(token_in_vec_31),
        .dl_detect_in(dl_detect_out),
        .origin(origin[31]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_31),
        .out_chan_dep_data(out_chan_dep_data_31),
        .token_out_vec(token_out_vec_31),
        .dl_detect_out(dl_in_vec[31]));

    assign proc_31_data_FIFO_blk[0] = 1'b0 | (~grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_dense64_relu_U0.grp_head_dense64_relu_Pipeline_HEAD_FC1_LOAD_fu_426.pooled_blk_n);
    assign proc_31_data_PIPO_blk[0] = 1'b0;
    assign proc_31_start_FIFO_blk[0] = 1'b0;
    assign proc_31_TLF_FIFO_blk[0] = 1'b0;
    assign proc_31_input_sync_blk[0] = 1'b0 | (grp_cnn_pipeline_fu_1933.classification_head_stream_U0.ap_sync_head_dense64_relu_U0_ap_ready & grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_dense64_relu_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.classification_head_stream_U0.ap_sync_head_global_avg_pool_U0_ap_ready);
    assign proc_31_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_31[0] = dl_detect_out ? proc_dep_vld_vec_31_reg[0] : (proc_31_data_FIFO_blk[0] | proc_31_data_PIPO_blk[0] | proc_31_start_FIFO_blk[0] | proc_31_TLF_FIFO_blk[0] | proc_31_input_sync_blk[0] | proc_31_output_sync_blk[0]);
    assign proc_31_data_FIFO_blk[1] = 1'b0 | (~grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_dense64_relu_U0.grp_head_dense64_relu_Pipeline_HEAD_FC1_OUTPUT_fu_496.hidden_blk_n);
    assign proc_31_data_PIPO_blk[1] = 1'b0;
    assign proc_31_start_FIFO_blk[1] = 1'b0;
    assign proc_31_TLF_FIFO_blk[1] = 1'b0;
    assign proc_31_input_sync_blk[1] = 1'b0 | (grp_cnn_pipeline_fu_1933.classification_head_stream_U0.ap_sync_head_dense64_relu_U0_ap_ready & grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_dense64_relu_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.classification_head_stream_U0.ap_sync_head_dense2_logits_U0_ap_ready);
    assign proc_31_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_31[1] = dl_detect_out ? proc_dep_vld_vec_31_reg[1] : (proc_31_data_FIFO_blk[1] | proc_31_data_PIPO_blk[1] | proc_31_start_FIFO_blk[1] | proc_31_TLF_FIFO_blk[1] | proc_31_input_sync_blk[1] | proc_31_output_sync_blk[1]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_31_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_31_reg <= proc_dep_vld_vec_31;
        end
    end
    assign in_chan_dep_vld_vec_31[0] = dep_chan_vld_30_31;
    assign in_chan_dep_data_vec_31[33 : 0] = dep_chan_data_30_31;
    assign token_in_vec_31[0] = token_30_31;
    assign in_chan_dep_vld_vec_31[1] = dep_chan_vld_32_31;
    assign in_chan_dep_data_vec_31[67 : 34] = dep_chan_data_32_31;
    assign token_in_vec_31[1] = token_32_31;
    assign dep_chan_vld_31_30 = out_chan_dep_vld_vec_31[0];
    assign dep_chan_data_31_30 = out_chan_dep_data_31;
    assign token_31_30 = token_out_vec_31[0];
    assign dep_chan_vld_31_32 = out_chan_dep_vld_vec_31[1];
    assign dep_chan_data_31_32 = out_chan_dep_data_31;
    assign token_31_32 = token_out_vec_31[1];

    // Process: grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_dense2_logits_U0
    cnn_hls_deadlock_detect_unit #(34, 32, 3, 3) cnn_hls_deadlock_detect_unit_32 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_32),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_32),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_32),
        .token_in_vec(token_in_vec_32),
        .dl_detect_in(dl_detect_out),
        .origin(origin[32]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_32),
        .out_chan_dep_data(out_chan_dep_data_32),
        .token_out_vec(token_out_vec_32),
        .dl_detect_out(dl_in_vec[32]));

    assign proc_32_data_FIFO_blk[0] = 1'b0 | (~grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_dense2_logits_U0.grp_head_dense2_logits_Pipeline_HEAD_FC2_LOAD_fu_408.hidden_blk_n);
    assign proc_32_data_PIPO_blk[0] = 1'b0;
    assign proc_32_start_FIFO_blk[0] = 1'b0;
    assign proc_32_TLF_FIFO_blk[0] = 1'b0;
    assign proc_32_input_sync_blk[0] = 1'b0 | (grp_cnn_pipeline_fu_1933.classification_head_stream_U0.ap_sync_head_dense2_logits_U0_ap_ready & grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_dense2_logits_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.classification_head_stream_U0.ap_sync_head_dense64_relu_U0_ap_ready);
    assign proc_32_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_32[0] = dl_detect_out ? proc_dep_vld_vec_32_reg[0] : (proc_32_data_FIFO_blk[0] | proc_32_data_PIPO_blk[0] | proc_32_start_FIFO_blk[0] | proc_32_TLF_FIFO_blk[0] | proc_32_input_sync_blk[0] | proc_32_output_sync_blk[0]);
    assign proc_32_data_FIFO_blk[1] = 1'b0 | (~grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_dense2_logits_U0.grp_head_dense2_logits_Pipeline_HEAD_FC2_OUTPUT_fu_478.scores_blk_n);
    assign proc_32_data_PIPO_blk[1] = 1'b0;
    assign proc_32_start_FIFO_blk[1] = 1'b0;
    assign proc_32_TLF_FIFO_blk[1] = 1'b0;
    assign proc_32_input_sync_blk[1] = 1'b0;
    assign proc_32_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_32[1] = dl_detect_out ? proc_dep_vld_vec_32_reg[1] : (proc_32_data_FIFO_blk[1] | proc_32_data_PIPO_blk[1] | proc_32_start_FIFO_blk[1] | proc_32_TLF_FIFO_blk[1] | proc_32_input_sync_blk[1] | proc_32_output_sync_blk[1]);
    assign proc_32_data_FIFO_blk[2] = 1'b0;
    assign proc_32_data_PIPO_blk[2] = 1'b0;
    assign proc_32_start_FIFO_blk[2] = 1'b0;
    assign proc_32_TLF_FIFO_blk[2] = 1'b0;
    assign proc_32_input_sync_blk[2] = 1'b0 | (grp_cnn_pipeline_fu_1933.classification_head_stream_U0.ap_sync_head_dense2_logits_U0_ap_ready & grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_dense2_logits_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.classification_head_stream_U0.ap_sync_head_global_avg_pool_U0_ap_ready);
    assign proc_32_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_32[2] = dl_detect_out ? proc_dep_vld_vec_32_reg[2] : (proc_32_data_FIFO_blk[2] | proc_32_data_PIPO_blk[2] | proc_32_start_FIFO_blk[2] | proc_32_TLF_FIFO_blk[2] | proc_32_input_sync_blk[2] | proc_32_output_sync_blk[2]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_32_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_32_reg <= proc_dep_vld_vec_32;
        end
    end
    assign in_chan_dep_vld_vec_32[0] = dep_chan_vld_30_32;
    assign in_chan_dep_data_vec_32[33 : 0] = dep_chan_data_30_32;
    assign token_in_vec_32[0] = token_30_32;
    assign in_chan_dep_vld_vec_32[1] = dep_chan_vld_31_32;
    assign in_chan_dep_data_vec_32[67 : 34] = dep_chan_data_31_32;
    assign token_in_vec_32[1] = token_31_32;
    assign in_chan_dep_vld_vec_32[2] = dep_chan_vld_33_32;
    assign in_chan_dep_data_vec_32[101 : 68] = dep_chan_data_33_32;
    assign token_in_vec_32[2] = token_33_32;
    assign dep_chan_vld_32_31 = out_chan_dep_vld_vec_32[0];
    assign dep_chan_data_32_31 = out_chan_dep_data_32;
    assign token_32_31 = token_out_vec_32[0];
    assign dep_chan_vld_32_33 = out_chan_dep_vld_vec_32[1];
    assign dep_chan_data_32_33 = out_chan_dep_data_32;
    assign token_32_33 = token_out_vec_32[1];
    assign dep_chan_vld_32_30 = out_chan_dep_vld_vec_32[2];
    assign dep_chan_data_32_30 = out_chan_dep_data_32;
    assign token_32_30 = token_out_vec_32[2];

    // Process: grp_cnn_pipeline_fu_1933.cnn_write_logits_U0
    cnn_hls_deadlock_detect_unit #(34, 33, 3, 3) cnn_hls_deadlock_detect_unit_33 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_33),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_33),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_33),
        .token_in_vec(token_in_vec_33),
        .dl_detect_in(dl_detect_out),
        .origin(origin[33]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_33),
        .out_chan_dep_data(out_chan_dep_data_33),
        .token_out_vec(token_out_vec_33),
        .dl_detect_out(dl_in_vec[33]));

    assign proc_33_data_FIFO_blk[0] = 1'b0 | (~grp_cnn_pipeline_fu_1933.cnn_write_logits_U0.grp_cnn_write_logits_Pipeline_CNN_WRITE_fu_64.scores_blk_n);
    assign proc_33_data_PIPO_blk[0] = 1'b0;
    assign proc_33_start_FIFO_blk[0] = 1'b0;
    assign proc_33_TLF_FIFO_blk[0] = 1'b0;
    assign proc_33_input_sync_blk[0] = 1'b0;
    assign proc_33_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_33[0] = dl_detect_out ? proc_dep_vld_vec_33_reg[0] : (proc_33_data_FIFO_blk[0] | proc_33_data_PIPO_blk[0] | proc_33_start_FIFO_blk[0] | proc_33_TLF_FIFO_blk[0] | proc_33_input_sync_blk[0] | proc_33_output_sync_blk[0]);
    assign proc_33_data_FIFO_blk[1] = 1'b0 | (~grp_cnn_pipeline_fu_1933.cnn_write_logits_U0.grp_cnn_write_logits_Pipeline_CNN_WRITE_fu_64.scores_blk_n);
    assign proc_33_data_PIPO_blk[1] = 1'b0;
    assign proc_33_start_FIFO_blk[1] = 1'b0;
    assign proc_33_TLF_FIFO_blk[1] = 1'b0;
    assign proc_33_input_sync_blk[1] = 1'b0;
    assign proc_33_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_33[1] = dl_detect_out ? proc_dep_vld_vec_33_reg[1] : (proc_33_data_FIFO_blk[1] | proc_33_data_PIPO_blk[1] | proc_33_start_FIFO_blk[1] | proc_33_TLF_FIFO_blk[1] | proc_33_input_sync_blk[1] | proc_33_output_sync_blk[1]);
    assign proc_33_data_FIFO_blk[2] = 1'b0 | (~grp_cnn_pipeline_fu_1933.cnn_write_logits_U0.out_r_blk_n);
    assign proc_33_data_PIPO_blk[2] = 1'b0;
    assign proc_33_start_FIFO_blk[2] = 1'b0 | (~grp_cnn_pipeline_fu_1933.start_for_cnn_write_logits_U0_U.if_empty_n & grp_cnn_pipeline_fu_1933.cnn_write_logits_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.start_for_cnn_write_logits_U0_U.if_write);
    assign proc_33_TLF_FIFO_blk[2] = 1'b0;
    assign proc_33_input_sync_blk[2] = 1'b0;
    assign proc_33_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_33[2] = dl_detect_out ? proc_dep_vld_vec_33_reg[2] : (proc_33_data_FIFO_blk[2] | proc_33_data_PIPO_blk[2] | proc_33_start_FIFO_blk[2] | proc_33_TLF_FIFO_blk[2] | proc_33_input_sync_blk[2] | proc_33_output_sync_blk[2]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_33_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_33_reg <= proc_dep_vld_vec_33;
        end
    end
    assign in_chan_dep_vld_vec_33[0] = dep_chan_vld_0_33;
    assign in_chan_dep_data_vec_33[33 : 0] = dep_chan_data_0_33;
    assign token_in_vec_33[0] = token_0_33;
    assign in_chan_dep_vld_vec_33[1] = dep_chan_vld_29_33;
    assign in_chan_dep_data_vec_33[67 : 34] = dep_chan_data_29_33;
    assign token_in_vec_33[1] = token_29_33;
    assign in_chan_dep_vld_vec_33[2] = dep_chan_vld_32_33;
    assign in_chan_dep_data_vec_33[101 : 68] = dep_chan_data_32_33;
    assign token_in_vec_33[2] = token_32_33;
    assign dep_chan_vld_33_29 = out_chan_dep_vld_vec_33[0];
    assign dep_chan_data_33_29 = out_chan_dep_data_33;
    assign token_33_29 = token_out_vec_33[0];
    assign dep_chan_vld_33_32 = out_chan_dep_vld_vec_33[1];
    assign dep_chan_data_33_32 = out_chan_dep_data_33;
    assign token_33_32 = token_out_vec_33[1];
    assign dep_chan_vld_33_0 = out_chan_dep_vld_vec_33[2];
    assign dep_chan_data_33_0 = out_chan_dep_data_33;
    assign token_33_0 = token_out_vec_33[2];


`include "cnn_hls_deadlock_report_unit.vh"
