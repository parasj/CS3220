module EXE_MEM_Buffer(clk, reset, en, src1_in, src1_out, alu_res_in, alu_res_out, dst_ind_in,
	dst_ind_out, mem_wrt_en_in, mem_wrt_en_out, reg_file_wrt_en_in, reg_file_wrt_en_out);
	parameter BIT_WIDTH = 32;
	parameter REG_INDEX_BIT_WIDTH 		 = 4;

	input clk, reset, en, mem_wrt_en_in, reg_file_wrt_en_in;
	input[REG_INDEX_BIT_WIDTH-1 : 0] src1_in, dst_ind_in;
	input[BIT_WIDTH-1 : 0] alu_res_in;
	output mem_wrt_en_out, reg_file_wrt_en_out;
	output[REG_INDEX_BIT_WIDTH-1 : 0] src1_out, dst_ind_out;
	output[BIT_WIDTH-1 : 0] alu_res_out;

	Register #(.BIT_WIDTH(1)) mem_en_reg(clk, reset, en, mem_wrt_en_in, mem_wrt_en_out);
	Register #(.BIT_WIDTH(1)) reg_file_en_reg(clk, reset, en,
		reg_file_wrt_en_in, reg_file_wrt_en_out);
	Register #(.BIT_WIDTH(BIT_WIDTH)) alu_res_reg(clk, reset, en, alu_res_in,
		alu_res_out);
	Register #(.BIT_WIDTH(REG_INDEX_BIT_WIDTH)) src1_reg(clk,
		reset, en, src1_in, src1_out);
	Register #(.BIT_WIDTH(REG_INDEX_BIT_WIDTH)) dst_reg(clk,
		reset, en, dst_ind_in, dst_ind_out);
endmodule