module BranchCalculator (imm, pcPlusOne, pcBranchAddress);
	parameter BIT_WIDTH = 32;
	input [BIT_WIDTH - 1 : 0] imm;
	input [BIT_WIDTH - 1 : 0] pcPlusOne;
	output [BIT_WIDTH - 1 : 0] pcBranchAddress;
	assign pcBranchAddress = (imm << 2) + pcPlusOne;
endmodule