`define ALU_ADD 4'b0000
`define ALU_SUB 4'b0001
`define ALU_AND 4'b0010
`define ALU_OR 4'b0011
`define ALU_XOR 4'b0100
`define ALU_NAND 4'b0101
`define ALU_NOR 4'b0110
`define ALU_XNOR 4'b0111

`define CMD_EQ 2'b00
`define CMD_LT 2'b01
`define CMD_GT 2'b10
`define CMD_XX 2'bxx


module ALU(aluop, a, b, c, cmdflag);
	parameter WIDTH = 8;


	input[3:0] aluop;
	input[WIDTH-1:0] a;
	input[WIDTH-1:0] b;
	output[WIDTH-1:0] c;

	// 00 = 0
	// 01 = lt 0
	// 10 = gt 0
	// 11 = unused
	output[1:0] cmdflag;

	assign c = (aluop == `ALU_ADD) ? (a + b) :
			   (aluop == `ALU_SUB) ? (a - b) :
			   (aluop == `ALU_AND) ? (a & b) :
			   (aluop == `ALU_OR) ? (a | b) :
			   (aluop == `ALU_XOR) ? (a ^ b) :
			   (aluop == `ALU_NAND) ? ~(a & b) :
			   (aluop == `ALU_NOR) ? ~(a | b) :
			   (aluop == `ALU_XNOR) ? a ^~ b :
			   {WIDTH{1'bx}};

	assign cmdflag = (c == {WIDTH{1'b0}}) ? `CMD_EQ :
					 (c[WIDTH-1] == 1'b1) ? `CMD_LT :
					 (c[WIDTH-1] == 1'b0) ? `CMD_GT :
					 `CMD_XX;
endmodule