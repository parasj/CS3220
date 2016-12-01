module DEC_EXE_Buffer(clk, reset, en, pc_in, pc_out, src1_in, src1_out, src2_in,
	src2_out, imm_in, imm_out, alu_op_in, alu_op_out, alu_mux_in, alu_mux_out, dst_mux_in, 
	dst_mux_out, dst_ind_in, dst_ind_out, mem_wrt_en_in, mem_wrt_en_out, reg_file_wrt_en_in,
	reg_file_wrt_en_out);
	parameter BIT_WIDTH = 32;
	parameter REG_INDEX_BIT_WIDTH 		 = 4;

	input clk, reset, en, mem_wrt_en_in, reg_file_wrt_en_in;
	input[BIT_WIDTH-1 : 0] pc_in, imm_in;
	input[BIT_WIDTH-1 : 0] src1_in, src2_in;
	input[REG_INDEX_BIT_WIDTH-1: 0] dst_ind_in;
	input alu_mux_in;
	input[4:0] alu_op_in;
	input dst_mux_in;
	output mem_wrt_en_out, reg_file_wrt_en_out;
	output[BIT_WIDTH-1 : 0] pc_out, imm_out;
	output[BIT_WIDTH-1 : 0] src1_out, src2_out;
	output[REG_INDEX_BIT_WIDTH-1: 0] dst_ind_out;
	output alu_mux_out;
	output[4:0] alu_op_out;
	output dst_mux_out;

	Register #(.BIT_WIDTH(1)) mem_en_reg(clk, reset, en, mem_wrt_en_in, mem_wrt_en_out);
	Register #(.BIT_WIDTH(1)) reg_file_en_reg(clk, reset, en,
		reg_file_wrt_en_in, reg_file_wrt_en_out);
	Register #(.BIT_WIDTH(1)) alu_mux_reg(clk, reset, en, alu_mux_in, alu_mux_out);
	Register #(.BIT_WIDTH(BIT_WIDTH)) pc_reg(clk, reset, en, pc_in, pc_out);
	Register #(.BIT_WIDTH(5)) alu_op_reg(clk, reset, en, alu_op_in, alu_op_out);
	Register #(.BIT_WIDTH(BIT_WIDTH)) src1_reg(clk,
		reset, en, src1_in, src1_out);
	Register #(.BIT_WIDTH(BIT_WIDTH)) src2_reg(clk,
		reset, en, src2_in, src2_out);
	Register #(.BIT_WIDTH(BIT_WIDTH)) imm_reg(clk,
		reset, en, imm_in, imm_out);
	Register #(.BIT_WIDTH(REG_INDEX_BIT_WIDTH)) dst_reg(clk,
		reset, en, dst_ind_in, dst_ind_out);
	Register #(.BIT_WIDTH(1)) dst_mux_reg(clk, reset, en, dst_mux_in, dst_mux_out);
endmodule