module HazardControl(src1, src2, cmd_flag, dst_exe, wrt_en_exe, dst_data_mux_exe, dst_mem, wrt_en_mem, src1_sel, src2_sel,
    if_dec_reset, dec_exe_reset, if_dec_en, dec_exe_en, pc_wrt_en, dst_wb, wrt_en_wb, fn_exe_in);
    parameter BIT_WIDTH = 32;
    parameter REG_INDEX_BIT_WIDTH = 4;

    input [REG_INDEX_BIT_WIDTH - 1 : 0] src1, src2, dst_exe, dst_mem, dst_wb;
    input wrt_en_exe, wrt_en_mem, wrt_en_wb, cmd_flag;
    input dst_data_mux_exe;
    input [3:0] fn_exe_in;
    output reg[1 : 0] src1_sel, src2_sel;
    output reg if_dec_reset, if_dec_en, dec_exe_en, pc_wrt_en, dec_exe_reset;

    // forwarding
    always @ (*) begin
        if (src1 == dst_exe & dst_data_mux_exe == 0 & wrt_en_exe == 1) begin
            src1_sel <= 1;
        end else if (src1 == dst_mem & wrt_en_mem == 1) begin
            src1_sel <= 2;
        end else if (src1 == dst_wb & wrt_en_wb == 1) begin
            src1_sel <= 3;
        end else begin
            src1_sel <= 0;
        end

        if (src2 == dst_exe & dst_data_mux_exe == 0 & wrt_en_exe == 1) begin
            src2_sel <= 1;
        end else if (src2 == dst_mem & wrt_en_mem == 1) begin
            src2_sel <= 2;
        end else if (src2 == dst_wb & wrt_en_wb == 1) begin
            src2_sel <= 3;
        end else begin
            src2_sel <= 0;
        end

        if ((src1 == dst_exe | src2 == dst_exe) & dst_data_mux_exe == 1 & wrt_en_exe == 1) begin
            if_dec_en <= 0;
            dec_exe_en <= 0;
            pc_wrt_en <= 0;
            if_dec_reset <= 0;
            dec_exe_reset <= 1;
        end else if ((cmd_flag == 1 & fn_exe_in == 4'b0010 ) | fn_exe_in == 4'b0110) begin
            dec_exe_en <= 1;
            if_dec_en <= 0;
            if_dec_reset <= 1;
            pc_wrt_en <= 1;
            dec_exe_reset <= 1;
        end else begin
            dec_exe_en <= 1;
            if_dec_en <= 1;
            if_dec_reset <= 0;
            pc_wrt_en <= 1;
            dec_exe_reset <= 0;
        end
    end
endmodule