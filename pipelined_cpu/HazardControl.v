module HazardControl(src1, src2, cmd_flag, data_exe, dst_exe, wrt_en_exe, dst_data_mux_exe, data_mem, dst_mem, wrt_en_mem, src1_sel, src2_sel
    if_dec_reset, dec_exe_reset, if_dec_en, dec_exe_en, pc_wrt_en);
    parameter BIT_WIDTH = 32;
    parameter REG_INDEX_BIT_WIDTH = 4;

    input [BIT_WIDTH - 1 : 0] data_exe, data_mem;
    input [REG_INDEX_BIT_WIDTH - 1 : 0] src1, src2, dst_exe, dst_mem;
    input wrt_en_exe, wrt_en_mem, cmd_flag;
    output[1 : 0] src1_sel, src2_sel;
    output if_dec_reset, if_dec_en, dec_exe_reset, dec_exe_en, pc_wrt_en;

    // forwarding
    always @ (*) begin
        if (src1 == dst_exe and dst_data_mux_exe == 0 and wrt_en_exe == 1) begin
            src1_sel <= 1;
        end else if (src1 == dst_mem and wrt_en_mem == 1) begin
            src1_sel <= 2;
        end else begin
            src1_sel <= 0;
        end

        if (src2 == dst_exe and dst_data_mux_exe == 0 and wrt_en_exe == 1) begin
            src2_sel <= 1;
        end else if (src2 == dst_mem and wrt_en_mem == 1) begin
            src2_sel <= 2;
        end else begin
            src2_sel <= 0;
        end

        if ((src1 == dst_exe or src2 == dst_exe) and dst_data_mux_exe == 1 and wrt_en_exe == 1) begin
            if_dec_en <= 0;
            pc_wrt_en <= 0;
            dec_exe_reset <= 1;
        end

        if (cmd_flag == 1 and )
    end
endmodule