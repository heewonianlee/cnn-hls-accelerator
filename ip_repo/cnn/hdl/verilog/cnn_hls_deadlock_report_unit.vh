   
    parameter PROC_NUM = 34;
    parameter ST_IDLE = 3'b000;
    parameter ST_FILTER_FAKE = 3'b001;
    parameter ST_DL_DETECTED = 3'b010;
    parameter ST_DL_REPORT = 3'b100;
   

    reg [2:0] CS_fsm;
    reg [2:0] NS_fsm;
    reg [PROC_NUM - 1:0] dl_detect_reg;
    reg [PROC_NUM - 1:0] dl_done_reg;
    reg [PROC_NUM - 1:0] origin_reg;
    reg [PROC_NUM - 1:0] dl_in_vec_reg;
    reg [31:0] dl_keep_cnt;
    reg stop_report_path;
    reg [PROC_NUM - 1:0] reported_proc;
    integer i;
    integer fp;

    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            reported_proc <= 'b0;
        end
        else if (CS_fsm == ST_DL_REPORT) begin
            reported_proc <= reported_proc | dl_in_vec;
        end
        else if (CS_fsm == ST_DL_DETECTED) begin
            reported_proc <= 'b0;
        end
    end

    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            stop_report_path <= 1'b0;
        end
        else if (CS_fsm == ST_DL_REPORT && (|(dl_in_vec & reported_proc))) begin
            stop_report_path <= 1'b1;
        end
        else if (CS_fsm == ST_IDLE) begin
            stop_report_path <= 1'b0;
        end
    end

    // FSM State machine
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            CS_fsm <= ST_IDLE;
        end
        else begin
            CS_fsm <= NS_fsm;
        end
    end

    always @ (CS_fsm or dl_in_vec or dl_detect_reg or dl_done_reg or dl_in_vec or origin_reg or dl_keep_cnt) begin
        case (CS_fsm)
            ST_IDLE : begin
                if (|dl_in_vec) begin
                    NS_fsm = ST_FILTER_FAKE;
                end
                else begin
                    NS_fsm = ST_IDLE;
                end
            end
            ST_FILTER_FAKE: begin
                if (dl_keep_cnt >= 32'd1000) begin
                    NS_fsm = ST_DL_DETECTED;
                end
                else if (dl_detect_reg != (dl_detect_reg & dl_in_vec)) begin
                    NS_fsm = ST_IDLE;
                end
                else begin
                    NS_fsm = ST_FILTER_FAKE;
                end
            end
            ST_DL_DETECTED: begin
                // has unreported deadlock cycle
                if ((dl_detect_reg != dl_done_reg) && stop_report_path == 1'b0) begin
                    NS_fsm = ST_DL_REPORT;
                end
                else begin
                    NS_fsm = ST_DL_DETECTED;
                end
            end
            ST_DL_REPORT: begin
                if (|(dl_in_vec & origin_reg)) begin
                    NS_fsm = ST_DL_DETECTED;
                end
                // avoid report deadlock ring.
                else if (|(dl_in_vec & reported_proc)) begin
                    NS_fsm = ST_DL_DETECTED;
                end
                else begin
                    NS_fsm = ST_DL_REPORT;
                end
            end
            default: NS_fsm = ST_IDLE;
        endcase
    end

    // dl_detect_reg record the procs that first detect deadlock
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            dl_detect_reg <= 'b0;
        end
        else begin
            if (CS_fsm == ST_IDLE) begin
                dl_detect_reg <= dl_in_vec;
            end
        end
    end

    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            dl_keep_cnt <= 32'h0;
        end
        else begin
            if (CS_fsm == ST_FILTER_FAKE && (dl_detect_reg == (dl_detect_reg & dl_in_vec))) begin
                dl_keep_cnt <= dl_keep_cnt + 32'h1;
            end
            else if (CS_fsm == ST_FILTER_FAKE && (dl_detect_reg != (dl_detect_reg & dl_in_vec))) begin
                dl_keep_cnt <= 32'h0;
            end
        end
    end

    // dl_detect_out keeps in high after deadlock detected
    assign dl_detect_out = (|dl_detect_reg) && (CS_fsm == ST_DL_DETECTED || CS_fsm == ST_DL_REPORT);

    // dl_done_reg record the cycles has been reported
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            dl_done_reg <= 'b0;
        end
        else begin
            if ((CS_fsm == ST_DL_REPORT) && (|(dl_in_vec & dl_detect_reg) == 'b1)) begin
                dl_done_reg <= dl_done_reg | dl_in_vec;
            end
        end
    end

    // clear token once a cycle is done
    assign token_clear = (CS_fsm == ST_DL_REPORT) ? ((|(dl_in_vec & origin_reg)) ? 'b1 : 'b0) : 'b0;

    // origin_reg record the current cycle start id
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            origin_reg <= 'b0;
        end
        else begin
            if (CS_fsm == ST_DL_DETECTED) begin
                origin_reg <= origin;
            end
        end
    end
   
    // origin will be valid for only one cycle
    wire [PROC_NUM*PROC_NUM - 1:0] origin_tmp;
    assign origin_tmp[PROC_NUM - 1:0] = (dl_detect_reg[0] & ~dl_done_reg[0]) ? 'b1 : 'b0;
    genvar j;
    generate
    for(j = 1;j < PROC_NUM;j = j + 1) begin: F1
        assign origin_tmp[j*PROC_NUM +: PROC_NUM] = (dl_detect_reg[j] & ~dl_done_reg[j]) ? ('b1 << j) : origin_tmp[(j - 1)*PROC_NUM +: PROC_NUM];
    end
    endgenerate
    always @ (CS_fsm or origin_tmp) begin
        if (CS_fsm == ST_DL_DETECTED) begin
            origin = origin_tmp[(PROC_NUM - 1)*PROC_NUM +: PROC_NUM];
        end
        else begin
            origin = 'b0;
        end
    end

    
    // dl_in_vec_reg record the current cycle dl_in_vec
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            dl_in_vec_reg <= 'b0;
        end
        else begin
            if (CS_fsm == ST_DL_DETECTED) begin
                dl_in_vec_reg <= origin;
            end
            else if (CS_fsm == ST_DL_REPORT) begin
                dl_in_vec_reg <= dl_in_vec;
            end
        end
    end
    
    // find_df_deadlock to report the deadlock
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            find_df_deadlock <= 1'b0;
        end
        else begin
            if (CS_fsm == ST_DL_DETECTED && ((dl_detect_reg == dl_done_reg) || (stop_report_path == 1'b1))) begin
                find_df_deadlock <= 1'b1;
            end
            else if (CS_fsm == ST_IDLE) begin
                find_df_deadlock <= 1'b0;
            end
        end
    end
    
    // get the first valid proc index in dl vector
    function integer proc_index(input [PROC_NUM - 1:0] dl_vec);
        begin
            proc_index = 0;
            for (i = 0; i < PROC_NUM; i = i + 1) begin
                if (dl_vec[i]) begin
                    proc_index = i;
                end
            end
        end
    endfunction

    // get the proc path based on dl vector
    function [728:0] proc_path(input [PROC_NUM - 1:0] dl_vec);
        integer index;
        begin
            index = proc_index(dl_vec);
            case (index)
                0 : begin
                    proc_path = "cnn_cnn.grp_cnn_pipeline_fu_1933.entry_proc_U0";
                end
                1 : begin
                    proc_path = "cnn_cnn.grp_cnn_pipeline_fu_1933.cnn_read_input_U0";
                end
                2 : begin
                    proc_path = "cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0";
                end
                3 : begin
                    proc_path = "cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.conv1_1_lane2_windows_U0";
                end
                4 : begin
                    proc_path = "cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.conv1_1_lane2_mac_U0";
                end
                5 : begin
                    proc_path = "cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0";
                end
                6 : begin
                    proc_path = "cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_windows_U0";
                end
                7 : begin
                    proc_path = "cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_pack_windows_U0";
                end
                8 : begin
                    proc_path = "cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_mac_U0";
                end
                9 : begin
                    proc_path = "cnn_cnn.grp_cnn_pipeline_fu_1933.maxpool1_lane2_U0";
                end
                10 : begin
                    proc_path = "cnn_cnn.grp_cnn_pipeline_fu_1933.cnn_unpack_pool1_lane2_U0";
                end
                11 : begin
                    proc_path = "cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0";
                end
                12 : begin
                    proc_path = "cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_windows_U0";
                end
                13 : begin
                    proc_path = "cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_pack_windows_U0";
                end
                14 : begin
                    proc_path = "cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_compute_U0";
                end
                15 : begin
                    proc_path = "cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0";
                end
                16 : begin
                    proc_path = "cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_windows_U0";
                end
                17 : begin
                    proc_path = "cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_pack_windows_U0";
                end
                18 : begin
                    proc_path = "cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_compute_U0";
                end
                19 : begin
                    proc_path = "cnn_cnn.grp_cnn_pipeline_fu_1933.maxpool2_U0";
                end
                20 : begin
                    proc_path = "cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0";
                end
                21 : begin
                    proc_path = "cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_windows_U0";
                end
                22 : begin
                    proc_path = "cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_pack_windows_U0";
                end
                23 : begin
                    proc_path = "cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_compute_U0";
                end
                24 : begin
                    proc_path = "cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0";
                end
                25 : begin
                    proc_path = "cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_windows_U0";
                end
                26 : begin
                    proc_path = "cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_pack_windows_U0";
                end
                27 : begin
                    proc_path = "cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_compute_U0";
                end
                28 : begin
                    proc_path = "cnn_cnn.grp_cnn_pipeline_fu_1933.maxpool3_U0";
                end
                29 : begin
                    proc_path = "cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0";
                end
                30 : begin
                    proc_path = "cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_global_avg_pool_U0";
                end
                31 : begin
                    proc_path = "cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_dense64_relu_U0";
                end
                32 : begin
                    proc_path = "cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_dense2_logits_U0";
                end
                33 : begin
                    proc_path = "cnn_cnn.grp_cnn_pipeline_fu_1933.cnn_write_logits_U0";
                end
                default : begin
                    proc_path = "unknown";
                end
            endcase
        end
    endfunction

    // print the headlines of deadlock detection
    task print_dl_head;
        begin
            $display("\n//////////////////////////////////////////////////////////////////////////////");
            $display("// ERROR!!! DEADLOCK DETECTED at %0t ns! SIMULATION WILL BE STOPPED! //", $time);
            $display("//////////////////////////////////////////////////////////////////////////////");
            fp = $fopen("deadlock_db.dat", "w");
        end
    endtask

    // print the start of a cycle
    task print_cycle_start(input reg [728:0] proc_path, input integer cycle_id);
        begin
            $display("/////////////////////////");
            $display("// Dependence cycle %0d:", cycle_id);
            $display("// (1): Process: %0s", proc_path);
            $fdisplay(fp, "Dependence_Cycle_ID %0d", cycle_id);
            $fdisplay(fp, "Dependence_Process_ID 1");
            $fdisplay(fp, "Dependence_Process_path %0s", proc_path);
        end
    endtask

    // print the end of deadlock detection
    task print_dl_end(input integer num, input integer record_time);
        begin
            $display("////////////////////////////////////////////////////////////////////////");
            $display("// Totally %0d cycles detected!", num);
            $display("////////////////////////////////////////////////////////////////////////");
            $display("// ERROR!!! DEADLOCK DETECTED at %0t ns! SIMULATION WILL BE STOPPED! //", record_time);
            $display("//////////////////////////////////////////////////////////////////////////////");
            $fdisplay(fp, "Dependence_Cycle_Number %0d", num);
            $fclose(fp);
        end
    endtask

    // print one proc component in the cycle
    task print_cycle_proc_comp(input reg [728:0] proc_path, input integer cycle_comp_id);
        begin
            $display("// (%0d): Process: %0s", cycle_comp_id, proc_path);
            $fdisplay(fp, "Dependence_Process_ID %0d", cycle_comp_id);
            $fdisplay(fp, "Dependence_Process_path %0s", proc_path);
        end
    endtask

    // print one channel component in the cycle
    task print_cycle_chan_comp(input [PROC_NUM - 1:0] dl_vec1, input [PROC_NUM - 1:0] dl_vec2);
        reg [800:0] chan_path;
        integer index1;
        integer index2;
        begin
            index1 = proc_index(dl_vec1);
            index2 = proc_index(dl_vec2);
            case (index1)
                0 : begin // for proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.entry_proc_U0'
                    case(index2)
                    33: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.cnn_write_logits_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.logits_c_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.entry_proc_U0.logits_c_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.entry_proc_U0.logits_c_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.logits_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.logits_c_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.cnn_write_logits_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.logits_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.logits_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.logits_c_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.cnn_write_logits_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.logits_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.start_for_cnn_write_logits_U0_U' info is :
// blk sig is {{~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.start_for_cnn_write_logits_U0_U.if_full_n & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.entry_proc_U0.ap_start & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.entry_proc_U0.real_start & (trans_in_cnt_9 == trans_out_cnt_9) & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.start_for_cnn_write_logits_U0_U.if_read} start_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.start_for_cnn_write_logits_U0_U.if_full_n & grp_cnn_pipeline_fu_1933.entry_proc_U0.ap_start & ~grp_cnn_pipeline_fu_1933.entry_proc_U0.real_start & (trans_in_cnt_9 == trans_out_cnt_9) & ~grp_cnn_pipeline_fu_1933.start_for_cnn_write_logits_U0_U.if_read)) begin
                            $display("//      Blocked by full output start propagation FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.start_for_cnn_write_logits_U0_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.cnn_write_logits_U0',");
                        end
                    end
                    1: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.cnn_read_input_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_entry_proc_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.entry_proc_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_cnn_read_input_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_entry_proc_U0_ap_ready & grp_cnn_pipeline_fu_1933.entry_proc_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_cnn_read_input_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.cnn_read_input_U0'");
                        end
                    end
                    2: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_entry_proc_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.entry_proc_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv1_1_lane2_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_entry_proc_U0_ap_ready & grp_cnn_pipeline_fu_1933.entry_proc_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv1_1_lane2_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0'");
                        end
                    end
                    5: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_entry_proc_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.entry_proc_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv1_2_lane2_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_entry_proc_U0_ap_ready & grp_cnn_pipeline_fu_1933.entry_proc_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv1_2_lane2_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0'");
                        end
                    end
                    11: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_entry_proc_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.entry_proc_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv2_1_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_entry_proc_U0_ap_ready & grp_cnn_pipeline_fu_1933.entry_proc_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv2_1_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0'");
                        end
                    end
                    15: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_entry_proc_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.entry_proc_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv2_2_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_entry_proc_U0_ap_ready & grp_cnn_pipeline_fu_1933.entry_proc_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv2_2_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0'");
                        end
                    end
                    20: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_entry_proc_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.entry_proc_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv3_1_reuse16_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_entry_proc_U0_ap_ready & grp_cnn_pipeline_fu_1933.entry_proc_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv3_1_reuse16_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0'");
                        end
                    end
                    24: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_entry_proc_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.entry_proc_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv3_2_reuse32_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_entry_proc_U0_ap_ready & grp_cnn_pipeline_fu_1933.entry_proc_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv3_2_reuse32_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0'");
                        end
                    end
                    29: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_entry_proc_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.entry_proc_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_classification_head_stream_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_entry_proc_U0_ap_ready & grp_cnn_pipeline_fu_1933.entry_proc_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_classification_head_stream_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0'");
                        end
                    end
                    endcase
                end
                1 : begin // for proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.cnn_read_input_U0'
                    case(index2)
                    2: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.in_stream_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.cnn_read_input_U0.in_stream_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.cnn_read_input_U0.in_stream_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.in_stream_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.in_stream_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.in_stream_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.in_stream_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.in_stream_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.in_stream_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_cnn_read_input_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.cnn_read_input_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv1_1_lane2_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_cnn_read_input_U0_ap_ready & grp_cnn_pipeline_fu_1933.cnn_read_input_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv1_1_lane2_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0'");
                        end
                    end
                    3: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.conv1_1_lane2_windows_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.in_stream_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.cnn_read_input_U0.in_stream_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.cnn_read_input_U0.in_stream_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.in_stream_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.in_stream_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.conv1_1_lane2_windows_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.in_stream_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.in_stream_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.in_stream_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.conv1_1_lane2_windows_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.in_stream_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    0: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.entry_proc_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_cnn_read_input_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.cnn_read_input_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_entry_proc_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_cnn_read_input_U0_ap_ready & grp_cnn_pipeline_fu_1933.cnn_read_input_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_entry_proc_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.entry_proc_U0'");
                        end
                    end
                    5: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_cnn_read_input_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.cnn_read_input_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv1_2_lane2_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_cnn_read_input_U0_ap_ready & grp_cnn_pipeline_fu_1933.cnn_read_input_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv1_2_lane2_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0'");
                        end
                    end
                    11: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_cnn_read_input_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.cnn_read_input_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv2_1_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_cnn_read_input_U0_ap_ready & grp_cnn_pipeline_fu_1933.cnn_read_input_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv2_1_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0'");
                        end
                    end
                    15: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_cnn_read_input_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.cnn_read_input_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv2_2_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_cnn_read_input_U0_ap_ready & grp_cnn_pipeline_fu_1933.cnn_read_input_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv2_2_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0'");
                        end
                    end
                    20: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_cnn_read_input_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.cnn_read_input_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv3_1_reuse16_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_cnn_read_input_U0_ap_ready & grp_cnn_pipeline_fu_1933.cnn_read_input_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv3_1_reuse16_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0'");
                        end
                    end
                    24: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_cnn_read_input_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.cnn_read_input_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv3_2_reuse32_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_cnn_read_input_U0_ap_ready & grp_cnn_pipeline_fu_1933.cnn_read_input_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv3_2_reuse32_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0'");
                        end
                    end
                    29: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_cnn_read_input_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.cnn_read_input_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_classification_head_stream_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_cnn_read_input_U0_ap_ready & grp_cnn_pipeline_fu_1933.cnn_read_input_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_classification_head_stream_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0'");
                        end
                    end
                    endcase
                end
                2 : begin // for proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0'
                    case(index2)
                    1: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.cnn_read_input_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.in_stream_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.conv1_1_lane2_windows_U0.in_stream_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.conv1_1_lane2_windows_U0.in_stream_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.in_stream_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.in_stream_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.cnn_read_input_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.in_stream_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.in_stream_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.in_stream_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.cnn_read_input_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.in_stream_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv1_1_lane2_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_cnn_read_input_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_conv1_1_lane2_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_cnn_read_input_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.cnn_read_input_U0'");
                        end
                    end
                    5: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c11_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.conv1_1_lane2_mac_U0.grp_conv1_1_lane2_mac_Pipeline_COMPUTE_SPATIAL_COMPUTE_GROUPS_fu_178.s_c11_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.conv1_1_lane2_mac_U0.grp_conv1_1_lane2_mac_Pipeline_COMPUTE_SPATIAL_COMPUTE_GROUPS_fu_178.s_c11_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.s_c11_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c11_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c11_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.s_c11_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c11_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c11_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv1_1_lane2_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv1_2_lane2_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_conv1_1_lane2_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv1_2_lane2_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0'");
                        end
                    end
                    6: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_windows_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c11_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.conv1_1_lane2_mac_U0.grp_conv1_1_lane2_mac_Pipeline_COMPUTE_SPATIAL_COMPUTE_GROUPS_fu_178.s_c11_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.conv1_1_lane2_mac_U0.grp_conv1_1_lane2_mac_Pipeline_COMPUTE_SPATIAL_COMPUTE_GROUPS_fu_178.s_c11_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.s_c11_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c11_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_windows_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c11_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.s_c11_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c11_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_windows_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c11_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    0: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.entry_proc_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv1_1_lane2_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_entry_proc_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_conv1_1_lane2_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_entry_proc_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.entry_proc_U0'");
                        end
                    end
                    11: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv1_1_lane2_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv2_1_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_conv1_1_lane2_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv2_1_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0'");
                        end
                    end
                    15: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv1_1_lane2_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv2_2_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_conv1_1_lane2_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv2_2_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0'");
                        end
                    end
                    20: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv1_1_lane2_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv3_1_reuse16_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_conv1_1_lane2_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv3_1_reuse16_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0'");
                        end
                    end
                    24: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv1_1_lane2_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv3_2_reuse32_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_conv1_1_lane2_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv3_2_reuse32_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0'");
                        end
                    end
                    29: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv1_1_lane2_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_classification_head_stream_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_conv1_1_lane2_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_classification_head_stream_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0'");
                        end
                    end
                    endcase
                end
                3 : begin // for proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.conv1_1_lane2_windows_U0'
                    case(index2)
                    1: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.cnn_read_input_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.in_stream_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.conv1_1_lane2_windows_U0.in_stream_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.conv1_1_lane2_windows_U0.in_stream_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.in_stream_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.in_stream_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.cnn_read_input_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.in_stream_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.in_stream_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.in_stream_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.cnn_read_input_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.in_stream_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    4: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.conv1_1_lane2_mac_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.windows_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.conv1_1_lane2_windows_U0.windows_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.conv1_1_lane2_windows_U0.windows_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.windows_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.windows_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.conv1_1_lane2_mac_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.windows_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.windows_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.windows_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.conv1_1_lane2_mac_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.windows_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.ap_sync_conv1_1_lane2_windows_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.conv1_1_lane2_windows_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.ap_sync_conv1_1_lane2_mac_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.ap_sync_conv1_1_lane2_windows_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.conv1_1_lane2_windows_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.ap_sync_conv1_1_lane2_mac_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.conv1_1_lane2_mac_U0'");
                        end
                    end
                    endcase
                end
                4 : begin // for proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.conv1_1_lane2_mac_U0'
                    case(index2)
                    3: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.conv1_1_lane2_windows_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.windows_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.conv1_1_lane2_mac_U0.grp_conv1_1_lane2_mac_Pipeline_COMPUTE_SPATIAL_COMPUTE_GROUPS_fu_178.windows_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.conv1_1_lane2_mac_U0.grp_conv1_1_lane2_mac_Pipeline_COMPUTE_SPATIAL_COMPUTE_GROUPS_fu_178.windows_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.windows_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.windows_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.conv1_1_lane2_windows_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.windows_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.windows_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.windows_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.conv1_1_lane2_windows_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.windows_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.ap_sync_conv1_1_lane2_mac_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.conv1_1_lane2_mac_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.ap_sync_conv1_1_lane2_windows_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.ap_sync_conv1_1_lane2_mac_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.conv1_1_lane2_mac_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.ap_sync_conv1_1_lane2_windows_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.conv1_1_lane2_windows_U0'");
                        end
                    end
                    5: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c11_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.conv1_1_lane2_mac_U0.grp_conv1_1_lane2_mac_Pipeline_COMPUTE_SPATIAL_COMPUTE_GROUPS_fu_178.s_c11_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.conv1_1_lane2_mac_U0.grp_conv1_1_lane2_mac_Pipeline_COMPUTE_SPATIAL_COMPUTE_GROUPS_fu_178.s_c11_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.s_c11_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c11_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c11_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.s_c11_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c11_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c11_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    6: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_windows_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c11_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.conv1_1_lane2_mac_U0.grp_conv1_1_lane2_mac_Pipeline_COMPUTE_SPATIAL_COMPUTE_GROUPS_fu_178.s_c11_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.conv1_1_lane2_mac_U0.grp_conv1_1_lane2_mac_Pipeline_COMPUTE_SPATIAL_COMPUTE_GROUPS_fu_178.s_c11_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.s_c11_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c11_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_windows_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c11_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.s_c11_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c11_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_windows_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c11_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    endcase
                end
                5 : begin // for proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0'
                    case(index2)
                    2: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c11_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_windows_U0.s_c11_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_windows_U0.s_c11_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.s_c11_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c11_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c11_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.s_c11_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c11_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c11_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv1_2_lane2_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv1_1_lane2_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_conv1_2_lane2_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv1_1_lane2_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0'");
                        end
                    end
                    4: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.conv1_1_lane2_mac_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c11_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_windows_U0.s_c11_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_windows_U0.s_c11_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.s_c11_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c11_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.conv1_1_lane2_mac_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c11_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.s_c11_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c11_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.conv1_1_lane2_mac_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c11_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    9: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.maxpool1_lane2_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c12_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_mac_U0.grp_conv1_2_lane2_mac_Pipeline_COMPUTE_SPATIAL_COMPUTE_GROUPS_fu_238.s_c12_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_mac_U0.grp_conv1_2_lane2_mac_Pipeline_COMPUTE_SPATIAL_COMPUTE_GROUPS_fu_238.s_c12_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.s_c12_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c12_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.maxpool1_lane2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c12_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.s_c12_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c12_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.maxpool1_lane2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c12_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.start_for_maxpool1_lane2_U0_U' info is :
// blk sig is {{~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.start_for_maxpool1_lane2_U0_U.if_full_n & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.ap_start & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.real_start & (trans_in_cnt_1 == trans_out_cnt_1) & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.start_for_maxpool1_lane2_U0_U.if_read} start_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.start_for_maxpool1_lane2_U0_U.if_full_n & grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.ap_start & ~grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.real_start & (trans_in_cnt_1 == trans_out_cnt_1) & ~grp_cnn_pipeline_fu_1933.start_for_maxpool1_lane2_U0_U.if_read)) begin
                            $display("//      Blocked by full output start propagation FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.start_for_maxpool1_lane2_U0_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.maxpool1_lane2_U0',");
                        end
                    end
                    0: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.entry_proc_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv1_2_lane2_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_entry_proc_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_conv1_2_lane2_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_entry_proc_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.entry_proc_U0'");
                        end
                    end
                    1: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.cnn_read_input_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv1_2_lane2_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_cnn_read_input_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_conv1_2_lane2_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_cnn_read_input_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.cnn_read_input_U0'");
                        end
                    end
                    11: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv1_2_lane2_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv2_1_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_conv1_2_lane2_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv2_1_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0'");
                        end
                    end
                    15: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv1_2_lane2_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv2_2_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_conv1_2_lane2_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv2_2_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0'");
                        end
                    end
                    20: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv1_2_lane2_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv3_1_reuse16_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_conv1_2_lane2_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv3_1_reuse16_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0'");
                        end
                    end
                    24: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv1_2_lane2_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv3_2_reuse32_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_conv1_2_lane2_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv3_2_reuse32_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0'");
                        end
                    end
                    29: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv1_2_lane2_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_classification_head_stream_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_conv1_2_lane2_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_classification_head_stream_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0'");
                        end
                    end
                    endcase
                end
                6 : begin // for proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_windows_U0'
                    case(index2)
                    2: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c11_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_windows_U0.s_c11_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_windows_U0.s_c11_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.s_c11_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c11_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c11_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.s_c11_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c11_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c11_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    4: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.conv1_1_lane2_mac_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c11_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_windows_U0.s_c11_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_windows_U0.s_c11_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.s_c11_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c11_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.conv1_1_lane2_mac_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c11_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.s_c11_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c11_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0.conv1_1_lane2_mac_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c11_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    7: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_pack_windows_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.windows_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_windows_U0.windows_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_windows_U0.windows_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.windows_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.windows_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_pack_windows_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.windows_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.windows_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.windows_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_pack_windows_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.windows_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.start_for_conv1_2_lane2_pack_windows_U0_U' info is :
// blk sig is {{~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.start_for_conv1_2_lane2_pack_windows_U0_U.if_full_n & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_windows_U0.ap_start & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_windows_U0.real_start & (trans_in_cnt_0 == trans_out_cnt_0) & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.start_for_conv1_2_lane2_pack_windows_U0_U.if_read} start_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.start_for_conv1_2_lane2_pack_windows_U0_U.if_full_n & grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_windows_U0.ap_start & ~grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_windows_U0.real_start & (trans_in_cnt_0 == trans_out_cnt_0) & ~grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.start_for_conv1_2_lane2_pack_windows_U0_U.if_read)) begin
                            $display("//      Blocked by full output start propagation FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.start_for_conv1_2_lane2_pack_windows_U0_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_pack_windows_U0',");
                        end
                    end
                    8: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_mac_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.ap_sync_conv1_2_lane2_windows_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_windows_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.ap_sync_conv1_2_lane2_mac_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.ap_sync_conv1_2_lane2_windows_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_windows_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.ap_sync_conv1_2_lane2_mac_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_mac_U0'");
                        end
                    end
                    endcase
                end
                7 : begin // for proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_pack_windows_U0'
                    case(index2)
                    6: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_windows_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.windows_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_pack_windows_U0.windows_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_pack_windows_U0.windows_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.windows_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.windows_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_windows_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.windows_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.windows_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.windows_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_windows_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.windows_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.start_for_conv1_2_lane2_pack_windows_U0_U' info is :
// blk sig is {{~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.start_for_conv1_2_lane2_pack_windows_U0_U.if_empty_n & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_pack_windows_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.start_for_conv1_2_lane2_pack_windows_U0_U.if_write} start_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.start_for_conv1_2_lane2_pack_windows_U0_U.if_empty_n & grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_pack_windows_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.start_for_conv1_2_lane2_pack_windows_U0_U.if_write)) begin
                            $display("//      Blocked by missing 'ap_start' from start propagation FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.start_for_conv1_2_lane2_pack_windows_U0_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_windows_U0',");
                        end
                    end
                    8: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_mac_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.window_sets_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_pack_windows_U0.window_sets_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_pack_windows_U0.window_sets_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.window_sets_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.window_sets_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_mac_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.window_sets_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.window_sets_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.window_sets_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_mac_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.window_sets_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    endcase
                end
                8 : begin // for proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_mac_U0'
                    case(index2)
                    7: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_pack_windows_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.window_sets_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_mac_U0.grp_conv1_2_lane2_mac_Pipeline_COMPUTE_SPATIAL_COMPUTE_GROUPS_fu_238.window_sets_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_mac_U0.grp_conv1_2_lane2_mac_Pipeline_COMPUTE_SPATIAL_COMPUTE_GROUPS_fu_238.window_sets_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.window_sets_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.window_sets_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_pack_windows_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.window_sets_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.window_sets_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.window_sets_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_pack_windows_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.window_sets_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    9: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.maxpool1_lane2_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c12_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_mac_U0.grp_conv1_2_lane2_mac_Pipeline_COMPUTE_SPATIAL_COMPUTE_GROUPS_fu_238.s_c12_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_mac_U0.grp_conv1_2_lane2_mac_Pipeline_COMPUTE_SPATIAL_COMPUTE_GROUPS_fu_238.s_c12_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.s_c12_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c12_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.maxpool1_lane2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c12_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.s_c12_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c12_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.maxpool1_lane2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c12_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    6: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_windows_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.ap_sync_conv1_2_lane2_mac_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_mac_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.ap_sync_conv1_2_lane2_windows_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.ap_sync_conv1_2_lane2_mac_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_mac_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.ap_sync_conv1_2_lane2_windows_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_windows_U0'");
                        end
                    end
                    endcase
                end
                9 : begin // for proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.maxpool1_lane2_U0'
                    case(index2)
                    5: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c12_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.maxpool1_lane2_U0.s_c12_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.maxpool1_lane2_U0.s_c12_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.s_c12_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c12_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c12_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.s_c12_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c12_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c12_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.start_for_maxpool1_lane2_U0_U' info is :
// blk sig is {{~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.start_for_maxpool1_lane2_U0_U.if_empty_n & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.maxpool1_lane2_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.start_for_maxpool1_lane2_U0_U.if_write} start_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.start_for_maxpool1_lane2_U0_U.if_empty_n & grp_cnn_pipeline_fu_1933.maxpool1_lane2_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.start_for_maxpool1_lane2_U0_U.if_write)) begin
                            $display("//      Blocked by missing 'ap_start' from start propagation FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.start_for_maxpool1_lane2_U0_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0',");
                        end
                    end
                    8: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_mac_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c12_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.maxpool1_lane2_U0.s_c12_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.maxpool1_lane2_U0.s_c12_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.s_c12_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c12_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_mac_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c12_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.s_c12_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c12_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0.conv1_2_lane2_mac_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c12_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    10: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.cnn_unpack_pool1_lane2_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool1_packed_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.maxpool1_lane2_U0.s_pool1_packed_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.maxpool1_lane2_U0.s_pool1_packed_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.s_pool1_packed_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool1_packed_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.cnn_unpack_pool1_lane2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool1_packed_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.s_pool1_packed_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool1_packed_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.cnn_unpack_pool1_lane2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool1_packed_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.start_for_cnn_unpack_pool1_lane2_U0_U' info is :
// blk sig is {{~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.start_for_cnn_unpack_pool1_lane2_U0_U.if_full_n & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.maxpool1_lane2_U0.ap_start & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.maxpool1_lane2_U0.real_start & (trans_in_cnt_2 == trans_out_cnt_2) & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.start_for_cnn_unpack_pool1_lane2_U0_U.if_read} start_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.start_for_cnn_unpack_pool1_lane2_U0_U.if_full_n & grp_cnn_pipeline_fu_1933.maxpool1_lane2_U0.ap_start & ~grp_cnn_pipeline_fu_1933.maxpool1_lane2_U0.real_start & (trans_in_cnt_2 == trans_out_cnt_2) & ~grp_cnn_pipeline_fu_1933.start_for_cnn_unpack_pool1_lane2_U0_U.if_read)) begin
                            $display("//      Blocked by full output start propagation FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.start_for_cnn_unpack_pool1_lane2_U0_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.cnn_unpack_pool1_lane2_U0',");
                        end
                    end
                    endcase
                end
                10 : begin // for proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.cnn_unpack_pool1_lane2_U0'
                    case(index2)
                    9: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.maxpool1_lane2_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool1_packed_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.cnn_unpack_pool1_lane2_U0.s_pool1_packed_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.cnn_unpack_pool1_lane2_U0.s_pool1_packed_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.s_pool1_packed_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool1_packed_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.maxpool1_lane2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool1_packed_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.s_pool1_packed_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool1_packed_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.maxpool1_lane2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool1_packed_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.start_for_cnn_unpack_pool1_lane2_U0_U' info is :
// blk sig is {{~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.start_for_cnn_unpack_pool1_lane2_U0_U.if_empty_n & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.cnn_unpack_pool1_lane2_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.start_for_cnn_unpack_pool1_lane2_U0_U.if_write} start_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.start_for_cnn_unpack_pool1_lane2_U0_U.if_empty_n & grp_cnn_pipeline_fu_1933.cnn_unpack_pool1_lane2_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.start_for_cnn_unpack_pool1_lane2_U0_U.if_write)) begin
                            $display("//      Blocked by missing 'ap_start' from start propagation FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.start_for_cnn_unpack_pool1_lane2_U0_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.maxpool1_lane2_U0',");
                        end
                    end
                    11: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool1_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.cnn_unpack_pool1_lane2_U0.s_pool1_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.cnn_unpack_pool1_lane2_U0.s_pool1_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.s_pool1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool1_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.s_pool1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool1_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    12: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_windows_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool1_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.cnn_unpack_pool1_lane2_U0.s_pool1_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.cnn_unpack_pool1_lane2_U0.s_pool1_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.s_pool1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool1_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_windows_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.s_pool1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool1_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_windows_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    endcase
                end
                11 : begin // for proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0'
                    case(index2)
                    10: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.cnn_unpack_pool1_lane2_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool1_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_windows_U0.s_pool1_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_windows_U0.s_pool1_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.s_pool1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool1_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.cnn_unpack_pool1_lane2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.s_pool1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool1_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.cnn_unpack_pool1_lane2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    15: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c21_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_compute_U0.grp_conv2_1_compute_Pipeline_CONV2_1_COMPUTE_OUTPUTS_fu_78.s_c21_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_compute_U0.grp_conv2_1_compute_Pipeline_CONV2_1_COMPUTE_OUTPUTS_fu_78.s_c21_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.s_c21_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c21_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c21_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.s_c21_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c21_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c21_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv2_1_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv2_1_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv2_2_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_conv2_1_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv2_1_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv2_2_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0'");
                        end
                    end
                    16: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_windows_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c21_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_compute_U0.grp_conv2_1_compute_Pipeline_CONV2_1_COMPUTE_OUTPUTS_fu_78.s_c21_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_compute_U0.grp_conv2_1_compute_Pipeline_CONV2_1_COMPUTE_OUTPUTS_fu_78.s_c21_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.s_c21_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c21_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_windows_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c21_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.s_c21_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c21_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_windows_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c21_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    0: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.entry_proc_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv2_1_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv2_1_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_entry_proc_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_conv2_1_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv2_1_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_entry_proc_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.entry_proc_U0'");
                        end
                    end
                    1: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.cnn_read_input_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv2_1_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv2_1_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_cnn_read_input_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_conv2_1_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv2_1_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_cnn_read_input_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.cnn_read_input_U0'");
                        end
                    end
                    2: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv2_1_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv2_1_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv1_1_lane2_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_conv2_1_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv2_1_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv1_1_lane2_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0'");
                        end
                    end
                    5: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv2_1_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv2_1_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv1_2_lane2_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_conv2_1_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv2_1_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv1_2_lane2_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0'");
                        end
                    end
                    20: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv2_1_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv2_1_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv3_1_reuse16_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_conv2_1_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv2_1_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv3_1_reuse16_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0'");
                        end
                    end
                    24: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv2_1_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv2_1_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv3_2_reuse32_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_conv2_1_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv2_1_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv3_2_reuse32_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0'");
                        end
                    end
                    29: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv2_1_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv2_1_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_classification_head_stream_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_conv2_1_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv2_1_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_classification_head_stream_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0'");
                        end
                    end
                    endcase
                end
                12 : begin // for proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_windows_U0'
                    case(index2)
                    10: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.cnn_unpack_pool1_lane2_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool1_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_windows_U0.s_pool1_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_windows_U0.s_pool1_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.s_pool1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool1_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.cnn_unpack_pool1_lane2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.s_pool1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool1_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.cnn_unpack_pool1_lane2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    13: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_pack_windows_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0.windows_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_windows_U0.windows_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_windows_U0.windows_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.conv2_1_U0.windows_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0.windows_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_pack_windows_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0.windows_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.conv2_1_U0.windows_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0.windows_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_pack_windows_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0.windows_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0.start_for_conv2_1_pack_windows_U0_U' info is :
// blk sig is {{~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv2_1_U0.start_for_conv2_1_pack_windows_U0_U.if_full_n & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_windows_U0.ap_start & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_windows_U0.real_start & (trans_in_cnt_3 == trans_out_cnt_3) & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv2_1_U0.start_for_conv2_1_pack_windows_U0_U.if_read} start_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv2_1_U0.start_for_conv2_1_pack_windows_U0_U.if_full_n & grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_windows_U0.ap_start & ~grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_windows_U0.real_start & (trans_in_cnt_3 == trans_out_cnt_3) & ~grp_cnn_pipeline_fu_1933.conv2_1_U0.start_for_conv2_1_pack_windows_U0_U.if_read)) begin
                            $display("//      Blocked by full output start propagation FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0.start_for_conv2_1_pack_windows_U0_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_pack_windows_U0',");
                        end
                    end
                    14: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_compute_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv2_1_U0.ap_sync_conv2_1_windows_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_windows_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv2_1_U0.ap_sync_conv2_1_compute_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.conv2_1_U0.ap_sync_conv2_1_windows_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_windows_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.conv2_1_U0.ap_sync_conv2_1_compute_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_compute_U0'");
                        end
                    end
                    endcase
                end
                13 : begin // for proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_pack_windows_U0'
                    case(index2)
                    12: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_windows_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0.windows_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_pack_windows_U0.windows_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_pack_windows_U0.windows_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.conv2_1_U0.windows_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0.windows_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_windows_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0.windows_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.conv2_1_U0.windows_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0.windows_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_windows_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0.windows_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0.start_for_conv2_1_pack_windows_U0_U' info is :
// blk sig is {{~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv2_1_U0.start_for_conv2_1_pack_windows_U0_U.if_empty_n & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_pack_windows_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv2_1_U0.start_for_conv2_1_pack_windows_U0_U.if_write} start_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv2_1_U0.start_for_conv2_1_pack_windows_U0_U.if_empty_n & grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_pack_windows_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.conv2_1_U0.start_for_conv2_1_pack_windows_U0_U.if_write)) begin
                            $display("//      Blocked by missing 'ap_start' from start propagation FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0.start_for_conv2_1_pack_windows_U0_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_windows_U0',");
                        end
                    end
                    14: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_compute_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0.window_sets_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_pack_windows_U0.window_sets_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_pack_windows_U0.window_sets_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.conv2_1_U0.window_sets_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0.window_sets_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_compute_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0.window_sets_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.conv2_1_U0.window_sets_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0.window_sets_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_compute_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0.window_sets_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    endcase
                end
                14 : begin // for proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_compute_U0'
                    case(index2)
                    13: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_pack_windows_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0.window_sets_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_compute_U0.grp_conv2_1_compute_Pipeline_CONV2_1_COMPUTE_OUTPUTS_fu_78.window_sets_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_compute_U0.grp_conv2_1_compute_Pipeline_CONV2_1_COMPUTE_OUTPUTS_fu_78.window_sets_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.conv2_1_U0.window_sets_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0.window_sets_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_pack_windows_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0.window_sets_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.conv2_1_U0.window_sets_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0.window_sets_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_pack_windows_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0.window_sets_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    15: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c21_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_compute_U0.grp_conv2_1_compute_Pipeline_CONV2_1_COMPUTE_OUTPUTS_fu_78.s_c21_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_compute_U0.grp_conv2_1_compute_Pipeline_CONV2_1_COMPUTE_OUTPUTS_fu_78.s_c21_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.s_c21_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c21_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c21_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.s_c21_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c21_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c21_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    16: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_windows_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c21_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_compute_U0.grp_conv2_1_compute_Pipeline_CONV2_1_COMPUTE_OUTPUTS_fu_78.s_c21_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_compute_U0.grp_conv2_1_compute_Pipeline_CONV2_1_COMPUTE_OUTPUTS_fu_78.s_c21_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.s_c21_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c21_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_windows_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c21_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.s_c21_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c21_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_windows_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c21_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    12: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_windows_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv2_1_U0.ap_sync_conv2_1_compute_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_compute_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv2_1_U0.ap_sync_conv2_1_windows_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.conv2_1_U0.ap_sync_conv2_1_compute_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_compute_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.conv2_1_U0.ap_sync_conv2_1_windows_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_windows_U0'");
                        end
                    end
                    endcase
                end
                15 : begin // for proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0'
                    case(index2)
                    11: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c21_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_windows_U0.s_c21_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_windows_U0.s_c21_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.s_c21_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c21_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c21_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.s_c21_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c21_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c21_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv2_2_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv2_2_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv2_1_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_conv2_2_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv2_2_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv2_1_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0'");
                        end
                    end
                    14: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_compute_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c21_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_windows_U0.s_c21_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_windows_U0.s_c21_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.s_c21_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c21_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_compute_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c21_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.s_c21_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c21_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_compute_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c21_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    19: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.maxpool2_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c22_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_compute_U0.grp_conv2_2_compute_Pipeline_CONV2_2_COMPUTE_OUTPUTS_fu_112.s_c22_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_compute_U0.grp_conv2_2_compute_Pipeline_CONV2_2_COMPUTE_OUTPUTS_fu_112.s_c22_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.s_c22_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c22_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.maxpool2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c22_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.s_c22_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c22_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.maxpool2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c22_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.start_for_maxpool2_U0_U' info is :
// blk sig is {{~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.start_for_maxpool2_U0_U.if_full_n & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv2_2_U0.ap_start & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv2_2_U0.real_start & (trans_in_cnt_5 == trans_out_cnt_5) & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.start_for_maxpool2_U0_U.if_read} start_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.start_for_maxpool2_U0_U.if_full_n & grp_cnn_pipeline_fu_1933.conv2_2_U0.ap_start & ~grp_cnn_pipeline_fu_1933.conv2_2_U0.real_start & (trans_in_cnt_5 == trans_out_cnt_5) & ~grp_cnn_pipeline_fu_1933.start_for_maxpool2_U0_U.if_read)) begin
                            $display("//      Blocked by full output start propagation FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.start_for_maxpool2_U0_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.maxpool2_U0',");
                        end
                    end
                    0: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.entry_proc_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv2_2_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv2_2_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_entry_proc_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_conv2_2_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv2_2_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_entry_proc_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.entry_proc_U0'");
                        end
                    end
                    1: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.cnn_read_input_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv2_2_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv2_2_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_cnn_read_input_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_conv2_2_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv2_2_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_cnn_read_input_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.cnn_read_input_U0'");
                        end
                    end
                    2: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv2_2_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv2_2_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv1_1_lane2_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_conv2_2_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv2_2_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv1_1_lane2_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0'");
                        end
                    end
                    5: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv2_2_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv2_2_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv1_2_lane2_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_conv2_2_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv2_2_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv1_2_lane2_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0'");
                        end
                    end
                    20: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv2_2_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv2_2_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv3_1_reuse16_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_conv2_2_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv2_2_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv3_1_reuse16_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0'");
                        end
                    end
                    24: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv2_2_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv2_2_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv3_2_reuse32_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_conv2_2_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv2_2_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv3_2_reuse32_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0'");
                        end
                    end
                    29: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv2_2_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv2_2_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_classification_head_stream_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_conv2_2_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv2_2_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_classification_head_stream_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0'");
                        end
                    end
                    endcase
                end
                16 : begin // for proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_windows_U0'
                    case(index2)
                    11: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c21_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_windows_U0.s_c21_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_windows_U0.s_c21_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.s_c21_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c21_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c21_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.s_c21_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c21_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c21_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    14: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_compute_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c21_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_windows_U0.s_c21_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_windows_U0.s_c21_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.s_c21_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c21_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_compute_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c21_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.s_c21_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c21_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0.conv2_1_compute_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c21_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    17: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_pack_windows_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0.windows_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_windows_U0.windows_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_windows_U0.windows_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.conv2_2_U0.windows_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0.windows_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_pack_windows_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0.windows_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.conv2_2_U0.windows_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0.windows_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_pack_windows_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0.windows_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0.start_for_conv2_2_pack_windows_U0_U' info is :
// blk sig is {{~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv2_2_U0.start_for_conv2_2_pack_windows_U0_U.if_full_n & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_windows_U0.ap_start & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_windows_U0.real_start & (trans_in_cnt_4 == trans_out_cnt_4) & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv2_2_U0.start_for_conv2_2_pack_windows_U0_U.if_read} start_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv2_2_U0.start_for_conv2_2_pack_windows_U0_U.if_full_n & grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_windows_U0.ap_start & ~grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_windows_U0.real_start & (trans_in_cnt_4 == trans_out_cnt_4) & ~grp_cnn_pipeline_fu_1933.conv2_2_U0.start_for_conv2_2_pack_windows_U0_U.if_read)) begin
                            $display("//      Blocked by full output start propagation FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0.start_for_conv2_2_pack_windows_U0_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_pack_windows_U0',");
                        end
                    end
                    18: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_compute_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv2_2_U0.ap_sync_conv2_2_windows_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_windows_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv2_2_U0.ap_sync_conv2_2_compute_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.conv2_2_U0.ap_sync_conv2_2_windows_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_windows_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.conv2_2_U0.ap_sync_conv2_2_compute_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_compute_U0'");
                        end
                    end
                    endcase
                end
                17 : begin // for proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_pack_windows_U0'
                    case(index2)
                    16: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_windows_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0.windows_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_pack_windows_U0.windows_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_pack_windows_U0.windows_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.conv2_2_U0.windows_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0.windows_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_windows_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0.windows_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.conv2_2_U0.windows_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0.windows_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_windows_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0.windows_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0.start_for_conv2_2_pack_windows_U0_U' info is :
// blk sig is {{~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv2_2_U0.start_for_conv2_2_pack_windows_U0_U.if_empty_n & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_pack_windows_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv2_2_U0.start_for_conv2_2_pack_windows_U0_U.if_write} start_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv2_2_U0.start_for_conv2_2_pack_windows_U0_U.if_empty_n & grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_pack_windows_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.conv2_2_U0.start_for_conv2_2_pack_windows_U0_U.if_write)) begin
                            $display("//      Blocked by missing 'ap_start' from start propagation FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0.start_for_conv2_2_pack_windows_U0_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_windows_U0',");
                        end
                    end
                    18: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_compute_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0.window_sets_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_pack_windows_U0.window_sets_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_pack_windows_U0.window_sets_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.conv2_2_U0.window_sets_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0.window_sets_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_compute_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0.window_sets_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.conv2_2_U0.window_sets_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0.window_sets_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_compute_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0.window_sets_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    endcase
                end
                18 : begin // for proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_compute_U0'
                    case(index2)
                    17: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_pack_windows_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0.window_sets_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_compute_U0.grp_conv2_2_compute_Pipeline_CONV2_2_COMPUTE_OUTPUTS_fu_112.window_sets_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_compute_U0.grp_conv2_2_compute_Pipeline_CONV2_2_COMPUTE_OUTPUTS_fu_112.window_sets_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.conv2_2_U0.window_sets_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0.window_sets_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_pack_windows_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0.window_sets_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.conv2_2_U0.window_sets_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0.window_sets_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_pack_windows_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0.window_sets_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    19: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.maxpool2_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c22_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_compute_U0.grp_conv2_2_compute_Pipeline_CONV2_2_COMPUTE_OUTPUTS_fu_112.s_c22_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_compute_U0.grp_conv2_2_compute_Pipeline_CONV2_2_COMPUTE_OUTPUTS_fu_112.s_c22_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.s_c22_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c22_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.maxpool2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c22_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.s_c22_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c22_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.maxpool2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c22_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    16: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_windows_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv2_2_U0.ap_sync_conv2_2_compute_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_compute_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv2_2_U0.ap_sync_conv2_2_windows_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.conv2_2_U0.ap_sync_conv2_2_compute_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_compute_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.conv2_2_U0.ap_sync_conv2_2_windows_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_windows_U0'");
                        end
                    end
                    endcase
                end
                19 : begin // for proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.maxpool2_U0'
                    case(index2)
                    15: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c22_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.maxpool2_U0.s_c22_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.maxpool2_U0.s_c22_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.s_c22_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c22_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c22_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.s_c22_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c22_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c22_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.start_for_maxpool2_U0_U' info is :
// blk sig is {{~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.start_for_maxpool2_U0_U.if_empty_n & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.maxpool2_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.start_for_maxpool2_U0_U.if_write} start_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.start_for_maxpool2_U0_U.if_empty_n & grp_cnn_pipeline_fu_1933.maxpool2_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.start_for_maxpool2_U0_U.if_write)) begin
                            $display("//      Blocked by missing 'ap_start' from start propagation FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.start_for_maxpool2_U0_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0',");
                        end
                    end
                    18: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_compute_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c22_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.maxpool2_U0.s_c22_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.maxpool2_U0.s_c22_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.s_c22_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c22_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_compute_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c22_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.s_c22_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c22_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0.conv2_2_compute_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c22_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    20: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool2_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.maxpool2_U0.s_pool2_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.maxpool2_U0.s_pool2_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.s_pool2_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool2_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool2_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.s_pool2_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool2_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool2_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    21: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_windows_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool2_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.maxpool2_U0.s_pool2_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.maxpool2_U0.s_pool2_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.s_pool2_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool2_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_windows_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool2_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.s_pool2_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool2_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_windows_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool2_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    endcase
                end
                20 : begin // for proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0'
                    case(index2)
                    19: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.maxpool2_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool2_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_windows_U0.s_pool2_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_windows_U0.s_pool2_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.s_pool2_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool2_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.maxpool2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool2_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.s_pool2_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool2_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.maxpool2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool2_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    24: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c31_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_compute_U0.grp_conv3_1_reuse16_compute_Pipeline_CONV3_1_REUSE_PHASES_fu_80.s_c31_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_compute_U0.grp_conv3_1_reuse16_compute_Pipeline_CONV3_1_REUSE_PHASES_fu_80.s_c31_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.s_c31_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c31_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c31_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.s_c31_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c31_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c31_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv3_1_reuse16_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv3_2_reuse32_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_conv3_1_reuse16_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv3_2_reuse32_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0'");
                        end
                    end
                    25: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_windows_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c31_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_compute_U0.grp_conv3_1_reuse16_compute_Pipeline_CONV3_1_REUSE_PHASES_fu_80.s_c31_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_compute_U0.grp_conv3_1_reuse16_compute_Pipeline_CONV3_1_REUSE_PHASES_fu_80.s_c31_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.s_c31_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c31_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_windows_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c31_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.s_c31_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c31_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_windows_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c31_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    0: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.entry_proc_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv3_1_reuse16_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_entry_proc_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_conv3_1_reuse16_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_entry_proc_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.entry_proc_U0'");
                        end
                    end
                    1: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.cnn_read_input_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv3_1_reuse16_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_cnn_read_input_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_conv3_1_reuse16_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_cnn_read_input_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.cnn_read_input_U0'");
                        end
                    end
                    2: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv3_1_reuse16_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv1_1_lane2_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_conv3_1_reuse16_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv1_1_lane2_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0'");
                        end
                    end
                    5: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv3_1_reuse16_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv1_2_lane2_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_conv3_1_reuse16_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv1_2_lane2_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0'");
                        end
                    end
                    11: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv3_1_reuse16_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv2_1_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_conv3_1_reuse16_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv2_1_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0'");
                        end
                    end
                    15: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv3_1_reuse16_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv2_2_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_conv3_1_reuse16_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv2_2_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0'");
                        end
                    end
                    29: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv3_1_reuse16_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_classification_head_stream_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_conv3_1_reuse16_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_classification_head_stream_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0'");
                        end
                    end
                    endcase
                end
                21 : begin // for proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_windows_U0'
                    case(index2)
                    19: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.maxpool2_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool2_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_windows_U0.s_pool2_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_windows_U0.s_pool2_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.s_pool2_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool2_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.maxpool2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool2_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.s_pool2_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool2_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.maxpool2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool2_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    22: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_pack_windows_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.windows_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_windows_U0.windows_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_windows_U0.windows_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.windows_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.windows_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_pack_windows_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.windows_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.windows_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.windows_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_pack_windows_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.windows_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.start_for_conv3_1_reuse16_pack_windows_U0_U' info is :
// blk sig is {{~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.start_for_conv3_1_reuse16_pack_windows_U0_U.if_full_n & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_windows_U0.ap_start & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_windows_U0.real_start & (trans_in_cnt_6 == trans_out_cnt_6) & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.start_for_conv3_1_reuse16_pack_windows_U0_U.if_read} start_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.start_for_conv3_1_reuse16_pack_windows_U0_U.if_full_n & grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_windows_U0.ap_start & ~grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_windows_U0.real_start & (trans_in_cnt_6 == trans_out_cnt_6) & ~grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.start_for_conv3_1_reuse16_pack_windows_U0_U.if_read)) begin
                            $display("//      Blocked by full output start propagation FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.start_for_conv3_1_reuse16_pack_windows_U0_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_pack_windows_U0',");
                        end
                    end
                    23: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_compute_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.ap_sync_conv3_1_reuse16_windows_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_windows_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.ap_sync_conv3_1_reuse16_compute_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.ap_sync_conv3_1_reuse16_windows_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_windows_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.ap_sync_conv3_1_reuse16_compute_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_compute_U0'");
                        end
                    end
                    endcase
                end
                22 : begin // for proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_pack_windows_U0'
                    case(index2)
                    21: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_windows_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.windows_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_pack_windows_U0.windows_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_pack_windows_U0.windows_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.windows_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.windows_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_windows_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.windows_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.windows_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.windows_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_windows_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.windows_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.start_for_conv3_1_reuse16_pack_windows_U0_U' info is :
// blk sig is {{~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.start_for_conv3_1_reuse16_pack_windows_U0_U.if_empty_n & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_pack_windows_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.start_for_conv3_1_reuse16_pack_windows_U0_U.if_write} start_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.start_for_conv3_1_reuse16_pack_windows_U0_U.if_empty_n & grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_pack_windows_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.start_for_conv3_1_reuse16_pack_windows_U0_U.if_write)) begin
                            $display("//      Blocked by missing 'ap_start' from start propagation FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.start_for_conv3_1_reuse16_pack_windows_U0_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_windows_U0',");
                        end
                    end
                    23: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_compute_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.window_sets_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_pack_windows_U0.window_sets_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_pack_windows_U0.window_sets_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.window_sets_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.window_sets_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_compute_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.window_sets_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.window_sets_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.window_sets_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_compute_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.window_sets_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    endcase
                end
                23 : begin // for proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_compute_U0'
                    case(index2)
                    22: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_pack_windows_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.window_sets_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_compute_U0.grp_conv3_1_reuse16_compute_Pipeline_CONV3_1_REUSE_PHASES_fu_80.window_sets_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_compute_U0.grp_conv3_1_reuse16_compute_Pipeline_CONV3_1_REUSE_PHASES_fu_80.window_sets_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.window_sets_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.window_sets_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_pack_windows_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.window_sets_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.window_sets_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.window_sets_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_pack_windows_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.window_sets_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    24: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c31_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_compute_U0.grp_conv3_1_reuse16_compute_Pipeline_CONV3_1_REUSE_PHASES_fu_80.s_c31_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_compute_U0.grp_conv3_1_reuse16_compute_Pipeline_CONV3_1_REUSE_PHASES_fu_80.s_c31_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.s_c31_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c31_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c31_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.s_c31_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c31_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c31_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    25: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_windows_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c31_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_compute_U0.grp_conv3_1_reuse16_compute_Pipeline_CONV3_1_REUSE_PHASES_fu_80.s_c31_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_compute_U0.grp_conv3_1_reuse16_compute_Pipeline_CONV3_1_REUSE_PHASES_fu_80.s_c31_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.s_c31_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c31_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_windows_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c31_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.s_c31_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c31_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_windows_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c31_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    21: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_windows_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.ap_sync_conv3_1_reuse16_compute_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_compute_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.ap_sync_conv3_1_reuse16_windows_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.ap_sync_conv3_1_reuse16_compute_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_compute_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.ap_sync_conv3_1_reuse16_windows_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_windows_U0'");
                        end
                    end
                    endcase
                end
                24 : begin // for proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0'
                    case(index2)
                    20: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c31_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_windows_U0.s_c31_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_windows_U0.s_c31_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.s_c31_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c31_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c31_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.s_c31_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c31_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c31_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv3_2_reuse32_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv3_1_reuse16_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_conv3_2_reuse32_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv3_1_reuse16_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0'");
                        end
                    end
                    23: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_compute_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c31_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_windows_U0.s_c31_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_windows_U0.s_c31_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.s_c31_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c31_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_compute_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c31_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.s_c31_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c31_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_compute_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c31_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    28: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.maxpool3_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c32_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_compute_U0.grp_conv3_2_reuse32_compute_Pipeline_CONV3_2_REUSE_PHASES_fu_112.s_c32_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_compute_U0.grp_conv3_2_reuse32_compute_Pipeline_CONV3_2_REUSE_PHASES_fu_112.s_c32_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.s_c32_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c32_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.maxpool3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c32_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.s_c32_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c32_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.maxpool3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c32_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.start_for_maxpool3_U0_U' info is :
// blk sig is {{~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.start_for_maxpool3_U0_U.if_full_n & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.ap_start & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.real_start & (trans_in_cnt_8 == trans_out_cnt_8) & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.start_for_maxpool3_U0_U.if_read} start_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.start_for_maxpool3_U0_U.if_full_n & grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.ap_start & ~grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.real_start & (trans_in_cnt_8 == trans_out_cnt_8) & ~grp_cnn_pipeline_fu_1933.start_for_maxpool3_U0_U.if_read)) begin
                            $display("//      Blocked by full output start propagation FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.start_for_maxpool3_U0_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.maxpool3_U0',");
                        end
                    end
                    0: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.entry_proc_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv3_2_reuse32_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_entry_proc_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_conv3_2_reuse32_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_entry_proc_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.entry_proc_U0'");
                        end
                    end
                    1: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.cnn_read_input_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv3_2_reuse32_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_cnn_read_input_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_conv3_2_reuse32_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_cnn_read_input_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.cnn_read_input_U0'");
                        end
                    end
                    2: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv3_2_reuse32_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv1_1_lane2_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_conv3_2_reuse32_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv1_1_lane2_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0'");
                        end
                    end
                    5: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv3_2_reuse32_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv1_2_lane2_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_conv3_2_reuse32_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv1_2_lane2_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0'");
                        end
                    end
                    11: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv3_2_reuse32_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv2_1_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_conv3_2_reuse32_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv2_1_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0'");
                        end
                    end
                    15: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv3_2_reuse32_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv2_2_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_conv3_2_reuse32_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv2_2_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0'");
                        end
                    end
                    29: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv3_2_reuse32_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_classification_head_stream_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_conv3_2_reuse32_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_classification_head_stream_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0'");
                        end
                    end
                    endcase
                end
                25 : begin // for proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_windows_U0'
                    case(index2)
                    20: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c31_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_windows_U0.s_c31_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_windows_U0.s_c31_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.s_c31_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c31_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c31_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.s_c31_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c31_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c31_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    23: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_compute_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c31_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_windows_U0.s_c31_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_windows_U0.s_c31_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.s_c31_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c31_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_compute_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c31_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.s_c31_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c31_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0.conv3_1_reuse16_compute_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c31_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    26: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_pack_windows_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.windows_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_windows_U0.windows_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_windows_U0.windows_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.windows_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.windows_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_pack_windows_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.windows_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.windows_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.windows_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_pack_windows_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.windows_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.start_for_conv3_2_reuse32_pack_windows_U0_U' info is :
// blk sig is {{~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.start_for_conv3_2_reuse32_pack_windows_U0_U.if_full_n & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_windows_U0.ap_start & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_windows_U0.real_start & (trans_in_cnt_7 == trans_out_cnt_7) & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.start_for_conv3_2_reuse32_pack_windows_U0_U.if_read} start_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.start_for_conv3_2_reuse32_pack_windows_U0_U.if_full_n & grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_windows_U0.ap_start & ~grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_windows_U0.real_start & (trans_in_cnt_7 == trans_out_cnt_7) & ~grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.start_for_conv3_2_reuse32_pack_windows_U0_U.if_read)) begin
                            $display("//      Blocked by full output start propagation FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.start_for_conv3_2_reuse32_pack_windows_U0_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_pack_windows_U0',");
                        end
                    end
                    27: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_compute_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.ap_sync_conv3_2_reuse32_windows_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_windows_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.ap_sync_conv3_2_reuse32_compute_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.ap_sync_conv3_2_reuse32_windows_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_windows_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.ap_sync_conv3_2_reuse32_compute_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_compute_U0'");
                        end
                    end
                    endcase
                end
                26 : begin // for proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_pack_windows_U0'
                    case(index2)
                    25: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_windows_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.windows_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_pack_windows_U0.windows_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_pack_windows_U0.windows_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.windows_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.windows_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_windows_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.windows_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.windows_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.windows_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_windows_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.windows_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.start_for_conv3_2_reuse32_pack_windows_U0_U' info is :
// blk sig is {{~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.start_for_conv3_2_reuse32_pack_windows_U0_U.if_empty_n & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_pack_windows_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.start_for_conv3_2_reuse32_pack_windows_U0_U.if_write} start_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.start_for_conv3_2_reuse32_pack_windows_U0_U.if_empty_n & grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_pack_windows_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.start_for_conv3_2_reuse32_pack_windows_U0_U.if_write)) begin
                            $display("//      Blocked by missing 'ap_start' from start propagation FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.start_for_conv3_2_reuse32_pack_windows_U0_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_windows_U0',");
                        end
                    end
                    27: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_compute_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.window_sets_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_pack_windows_U0.window_sets_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_pack_windows_U0.window_sets_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.window_sets_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.window_sets_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_compute_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.window_sets_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.window_sets_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.window_sets_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_compute_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.window_sets_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    endcase
                end
                27 : begin // for proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_compute_U0'
                    case(index2)
                    26: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_pack_windows_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.window_sets_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_compute_U0.grp_conv3_2_reuse32_compute_Pipeline_CONV3_2_REUSE_PHASES_fu_112.window_sets_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_compute_U0.grp_conv3_2_reuse32_compute_Pipeline_CONV3_2_REUSE_PHASES_fu_112.window_sets_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.window_sets_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.window_sets_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_pack_windows_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.window_sets_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.window_sets_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.window_sets_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_pack_windows_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.window_sets_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    28: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.maxpool3_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c32_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_compute_U0.grp_conv3_2_reuse32_compute_Pipeline_CONV3_2_REUSE_PHASES_fu_112.s_c32_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_compute_U0.grp_conv3_2_reuse32_compute_Pipeline_CONV3_2_REUSE_PHASES_fu_112.s_c32_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.s_c32_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c32_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.maxpool3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c32_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.s_c32_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c32_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.maxpool3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c32_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    25: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_windows_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.ap_sync_conv3_2_reuse32_compute_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_compute_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.ap_sync_conv3_2_reuse32_windows_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.ap_sync_conv3_2_reuse32_compute_U0_ap_ready & grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_compute_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.ap_sync_conv3_2_reuse32_windows_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_windows_U0'");
                        end
                    end
                    endcase
                end
                28 : begin // for proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.maxpool3_U0'
                    case(index2)
                    24: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c32_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.maxpool3_U0.s_c32_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.maxpool3_U0.s_c32_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.s_c32_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c32_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c32_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.s_c32_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c32_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c32_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.start_for_maxpool3_U0_U' info is :
// blk sig is {{~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.start_for_maxpool3_U0_U.if_empty_n & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.maxpool3_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.start_for_maxpool3_U0_U.if_write} start_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.start_for_maxpool3_U0_U.if_empty_n & grp_cnn_pipeline_fu_1933.maxpool3_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.start_for_maxpool3_U0_U.if_write)) begin
                            $display("//      Blocked by missing 'ap_start' from start propagation FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.start_for_maxpool3_U0_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0',");
                        end
                    end
                    27: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_compute_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c32_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.maxpool3_U0.s_c32_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.maxpool3_U0.s_c32_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.s_c32_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c32_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_compute_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c32_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.s_c32_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_c32_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0.conv3_2_reuse32_compute_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_c32_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    29: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool3_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.maxpool3_U0.s_pool3_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.maxpool3_U0.s_pool3_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.s_pool3_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool3_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool3_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.s_pool3_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool3_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool3_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    30: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_global_avg_pool_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool3_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.maxpool3_U0.s_pool3_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.maxpool3_U0.s_pool3_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.s_pool3_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool3_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_global_avg_pool_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool3_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.s_pool3_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool3_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_global_avg_pool_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool3_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    endcase
                end
                29 : begin // for proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0'
                    case(index2)
                    28: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.maxpool3_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool3_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_global_avg_pool_U0.grp_head_global_avg_pool_Pipeline_HEAD_GAP_READ_fu_278.s_pool3_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_global_avg_pool_U0.grp_head_global_avg_pool_Pipeline_HEAD_GAP_READ_fu_278.s_pool3_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.s_pool3_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool3_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.maxpool3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool3_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.s_pool3_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool3_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.maxpool3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool3_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    33: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.cnn_write_logits_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.scores_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_dense2_logits_U0.grp_head_dense2_logits_Pipeline_HEAD_FC2_OUTPUT_fu_478.scores_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_dense2_logits_U0.grp_head_dense2_logits_Pipeline_HEAD_FC2_OUTPUT_fu_478.scores_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.scores_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.scores_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.cnn_write_logits_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.scores_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.scores_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.scores_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.cnn_write_logits_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.scores_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    0: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.entry_proc_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_classification_head_stream_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_entry_proc_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_classification_head_stream_U0_ap_ready & grp_cnn_pipeline_fu_1933.classification_head_stream_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_entry_proc_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.entry_proc_U0'");
                        end
                    end
                    1: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.cnn_read_input_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_classification_head_stream_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_cnn_read_input_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_classification_head_stream_U0_ap_ready & grp_cnn_pipeline_fu_1933.classification_head_stream_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_cnn_read_input_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.cnn_read_input_U0'");
                        end
                    end
                    2: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_classification_head_stream_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv1_1_lane2_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_classification_head_stream_U0_ap_ready & grp_cnn_pipeline_fu_1933.classification_head_stream_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv1_1_lane2_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_1_lane2_U0'");
                        end
                    end
                    5: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_classification_head_stream_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv1_2_lane2_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_classification_head_stream_U0_ap_ready & grp_cnn_pipeline_fu_1933.classification_head_stream_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv1_2_lane2_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv1_2_lane2_U0'");
                        end
                    end
                    11: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_classification_head_stream_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv2_1_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_classification_head_stream_U0_ap_ready & grp_cnn_pipeline_fu_1933.classification_head_stream_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv2_1_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_1_U0'");
                        end
                    end
                    15: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_classification_head_stream_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv2_2_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_classification_head_stream_U0_ap_ready & grp_cnn_pipeline_fu_1933.classification_head_stream_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv2_2_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv2_2_U0'");
                        end
                    end
                    20: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_classification_head_stream_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv3_1_reuse16_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_classification_head_stream_U0_ap_ready & grp_cnn_pipeline_fu_1933.classification_head_stream_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv3_1_reuse16_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_1_reuse16_U0'");
                        end
                    end
                    24: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_classification_head_stream_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.ap_sync_conv3_2_reuse32_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.ap_sync_classification_head_stream_U0_ap_ready & grp_cnn_pipeline_fu_1933.classification_head_stream_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.ap_sync_conv3_2_reuse32_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.conv3_2_reuse32_U0'");
                        end
                    end
                    endcase
                end
                30 : begin // for proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_global_avg_pool_U0'
                    case(index2)
                    28: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.maxpool3_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool3_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_global_avg_pool_U0.grp_head_global_avg_pool_Pipeline_HEAD_GAP_READ_fu_278.s_pool3_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_global_avg_pool_U0.grp_head_global_avg_pool_Pipeline_HEAD_GAP_READ_fu_278.s_pool3_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.s_pool3_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool3_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.maxpool3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool3_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.s_pool3_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool3_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.maxpool3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.s_pool3_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    31: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_dense64_relu_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.pooled_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_global_avg_pool_U0.grp_head_global_avg_pool_Pipeline_HEAD_GAP_WRITE_fu_348.pooled_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_global_avg_pool_U0.grp_head_global_avg_pool_Pipeline_HEAD_GAP_WRITE_fu_348.pooled_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.classification_head_stream_U0.pooled_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.pooled_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_dense64_relu_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.pooled_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.classification_head_stream_U0.pooled_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.pooled_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_dense64_relu_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.pooled_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.ap_sync_head_global_avg_pool_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_global_avg_pool_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.ap_sync_head_dense64_relu_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.classification_head_stream_U0.ap_sync_head_global_avg_pool_U0_ap_ready & grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_global_avg_pool_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.classification_head_stream_U0.ap_sync_head_dense64_relu_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_dense64_relu_U0'");
                        end
                    end
                    32: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_dense2_logits_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.ap_sync_head_global_avg_pool_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_global_avg_pool_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.ap_sync_head_dense2_logits_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.classification_head_stream_U0.ap_sync_head_global_avg_pool_U0_ap_ready & grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_global_avg_pool_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.classification_head_stream_U0.ap_sync_head_dense2_logits_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_dense2_logits_U0'");
                        end
                    end
                    endcase
                end
                31 : begin // for proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_dense64_relu_U0'
                    case(index2)
                    30: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_global_avg_pool_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.pooled_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_dense64_relu_U0.grp_head_dense64_relu_Pipeline_HEAD_FC1_LOAD_fu_426.pooled_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_dense64_relu_U0.grp_head_dense64_relu_Pipeline_HEAD_FC1_LOAD_fu_426.pooled_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.classification_head_stream_U0.pooled_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.pooled_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_global_avg_pool_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.pooled_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.classification_head_stream_U0.pooled_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.pooled_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_global_avg_pool_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.pooled_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.ap_sync_head_dense64_relu_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_dense64_relu_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.ap_sync_head_global_avg_pool_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.classification_head_stream_U0.ap_sync_head_dense64_relu_U0_ap_ready & grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_dense64_relu_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.classification_head_stream_U0.ap_sync_head_global_avg_pool_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_global_avg_pool_U0'");
                        end
                    end
                    32: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_dense2_logits_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.hidden_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_dense64_relu_U0.grp_head_dense64_relu_Pipeline_HEAD_FC1_OUTPUT_fu_496.hidden_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_dense64_relu_U0.grp_head_dense64_relu_Pipeline_HEAD_FC1_OUTPUT_fu_496.hidden_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.classification_head_stream_U0.hidden_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.hidden_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_dense2_logits_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.hidden_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.classification_head_stream_U0.hidden_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.hidden_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_dense2_logits_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.hidden_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.ap_sync_head_dense64_relu_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_dense64_relu_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.ap_sync_head_dense2_logits_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.classification_head_stream_U0.ap_sync_head_dense64_relu_U0_ap_ready & grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_dense64_relu_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.classification_head_stream_U0.ap_sync_head_dense2_logits_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_dense2_logits_U0'");
                        end
                    end
                    endcase
                end
                32 : begin // for proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_dense2_logits_U0'
                    case(index2)
                    31: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_dense64_relu_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.hidden_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_dense2_logits_U0.grp_head_dense2_logits_Pipeline_HEAD_FC2_LOAD_fu_408.hidden_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_dense2_logits_U0.grp_head_dense2_logits_Pipeline_HEAD_FC2_LOAD_fu_408.hidden_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.classification_head_stream_U0.hidden_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.hidden_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_dense64_relu_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.hidden_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.classification_head_stream_U0.hidden_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.hidden_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_dense64_relu_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.hidden_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.ap_sync_head_dense2_logits_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_dense2_logits_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.ap_sync_head_dense64_relu_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.classification_head_stream_U0.ap_sync_head_dense2_logits_U0_ap_ready & grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_dense2_logits_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.classification_head_stream_U0.ap_sync_head_dense64_relu_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_dense64_relu_U0'");
                        end
                    end
                    33: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.cnn_write_logits_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.scores_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_dense2_logits_U0.grp_head_dense2_logits_Pipeline_HEAD_FC2_OUTPUT_fu_478.scores_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_dense2_logits_U0.grp_head_dense2_logits_Pipeline_HEAD_FC2_OUTPUT_fu_478.scores_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.scores_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.scores_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.cnn_write_logits_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.scores_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.scores_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.scores_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.cnn_write_logits_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.scores_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    30: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_global_avg_pool_U0'
// for dep channel '' info is :
// blk sig is {{cnn_cnn_inst.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.ap_sync_head_dense2_logits_U0_ap_ready & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_dense2_logits_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.ap_sync_head_global_avg_pool_U0_ap_ready} input_sync}
                        if ((grp_cnn_pipeline_fu_1933.classification_head_stream_U0.ap_sync_head_dense2_logits_U0_ap_ready & grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_dense2_logits_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.classification_head_stream_U0.ap_sync_head_global_avg_pool_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_global_avg_pool_U0'");
                        end
                    end
                    endcase
                end
                33 : begin // for proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.cnn_write_logits_U0'
                    case(index2)
                    29: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.scores_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.cnn_write_logits_U0.grp_cnn_write_logits_Pipeline_CNN_WRITE_fu_64.scores_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.cnn_write_logits_U0.grp_cnn_write_logits_Pipeline_CNN_WRITE_fu_64.scores_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.scores_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.scores_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.scores_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.scores_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.scores_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.scores_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    32: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_dense2_logits_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.scores_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.cnn_write_logits_U0.grp_cnn_write_logits_Pipeline_CNN_WRITE_fu_64.scores_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.cnn_write_logits_U0.grp_cnn_write_logits_Pipeline_CNN_WRITE_fu_64.scores_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.scores_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.scores_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_dense2_logits_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.scores_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.scores_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.scores_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.classification_head_stream_U0.head_dense2_logits_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.scores_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    0: begin //  for dep proc 'cnn_cnn.grp_cnn_pipeline_fu_1933.entry_proc_U0'
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.logits_c_U' info is :
// blk sig is {~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.cnn_write_logits_U0.out_r_blk_n data_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.cnn_write_logits_U0.out_r_blk_n)) begin
                            if (~grp_cnn_pipeline_fu_1933.logits_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.logits_c_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.entry_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.logits_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~grp_cnn_pipeline_fu_1933.logits_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.logits_c_U' read by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.entry_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path cnn_cnn.grp_cnn_pipeline_fu_1933.logits_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'cnn_cnn.grp_cnn_pipeline_fu_1933.start_for_cnn_write_logits_U0_U' info is :
// blk sig is {{~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.start_for_cnn_write_logits_U0_U.if_empty_n & cnn_cnn_inst.grp_cnn_pipeline_fu_1933.cnn_write_logits_U0.ap_idle & ~cnn_cnn_inst.grp_cnn_pipeline_fu_1933.start_for_cnn_write_logits_U0_U.if_write} start_FIFO}
                        if ((~grp_cnn_pipeline_fu_1933.start_for_cnn_write_logits_U0_U.if_empty_n & grp_cnn_pipeline_fu_1933.cnn_write_logits_U0.ap_idle & ~grp_cnn_pipeline_fu_1933.start_for_cnn_write_logits_U0_U.if_write)) begin
                            $display("//      Blocked by missing 'ap_start' from start propagation FIFO 'cnn_cnn.grp_cnn_pipeline_fu_1933.start_for_cnn_write_logits_U0_U' written by process 'cnn_cnn.grp_cnn_pipeline_fu_1933.entry_proc_U0',");
                        end
                    end
                    endcase
                end
            endcase
        end
    endtask

    // report
    initial begin : report_deadlock
        integer cycle_id;
        integer cycle_comp_id;
        integer record_time;
        wait (dl_reset == 1);
        cycle_id = 1;
        record_time = 0;
        while (1) begin
            @ (negedge dl_clock);
            case (CS_fsm)
                ST_DL_DETECTED: begin
                    cycle_comp_id = 2;
                    if (dl_detect_reg != dl_done_reg && stop_report_path == 1'b0) begin
                        if (dl_done_reg == 'b0) begin
                            print_dl_head;
                            record_time = $time;
                        end
                        print_cycle_start(proc_path(origin), cycle_id);
                        cycle_id = cycle_id + 1;
                    end
                    else begin
                        print_dl_end((cycle_id - 1),record_time);
                        @(negedge dl_clock);
                        @(negedge dl_clock);
                        $finish;
                    end
                end
                ST_DL_REPORT: begin
                    if ((|(dl_in_vec)) & ~(|(dl_in_vec & origin_reg)) & ~(|(reported_proc & dl_in_vec))) begin
                        print_cycle_chan_comp(dl_in_vec_reg, dl_in_vec);
                        print_cycle_proc_comp(proc_path(dl_in_vec), cycle_comp_id);
                        cycle_comp_id = cycle_comp_id + 1;
                    end
                    else if (~(|(dl_in_vec)))begin
                        print_cycle_chan_comp(dl_in_vec_reg, dl_in_vec);
                    end
                end
            endcase
        end
    end
 
