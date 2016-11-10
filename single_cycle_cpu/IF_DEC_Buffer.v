module IF_DEC_Buffer(clk, reset, en, pc_in, pc_out, inst_in, inst_out);
	parameter BIT_WIDTH = 32;
	parameter INST_BIT_WIDTH				 = 32;

	input clk, reset, en;
	input[BIT_WIDTH - 1 : 0] pc_in
	input[INST_BIT_WIDTH - 1 : 0] inst_in;
	output[BIT_WIDTH - 1 : 0] pc_out
	output[INST_BIT_WIDTH - 1 : 0] inst_out;

	
	Register #(.BIT_WIDTH(BIT_WIDTH)) pc_reg(clk, reset, en, pc_in, pc_out);
	Register #(.BIT_WIDTH(INST_BIT_WIDTH)) inst_reg(clk, reset, en, inst_in, inst_out);
endmodule