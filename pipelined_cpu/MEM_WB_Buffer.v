module MEM_WB_Buffer(clk, reset, en, reg_file_wrt_en_in, reg_file_wrt_en_out, dst_ind_in,
	dst_ind_out, end_res_in, end_res_out);
    parameter BIT_WIDTH = 32;
    parameter REG_INDEX_BIT_WIDTH        = 4;

    input clk, reset, en, reg_file_wrt_en_in;
    input[REG_INDEX_BIT_WIDTH-1 : 0] dst_ind_in;
    input[BIT_WIDTH-1 : 0] end_res_in;
    output reg_file_wrt_en_out;
    output[REG_INDEX_BIT_WIDTH-1 : 0] dst_ind_out;
    output[BIT_WIDTH-1 : 0] end_res_out;

    Register #(.BIT_WIDTH(1)) reg_file_en_reg(clk, reset, en,
        reg_file_wrt_en_in, reg_file_wrt_en_out);
    Register #(.BIT_WIDTH(REG_INDEX_BIT_WIDTH)) dst_reg(clk,
        reset, en, dst_ind_in, dst_ind_out);
    Register #(.BIT_WIDTH(BIT_WIDTH)) end_res(clk,
        reset, en, end_res_in, end_res_out);
endmodule