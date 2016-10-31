`define ALU_ADD 4'b0000
`define ALU_SUB 4'b0001
`define ALU_AND 4'b0010
`define ALU_OR 4'b0011
`define ALU_XOR 4'b0100
`define ALU_NAND 4'b0101
`define ALU_NOR 4'b0110
`define ALU_XNOR 4'b0111

`define ALU_MVHI 4'b1000
`define ALU_EQ 4'b1001
`define ALU_LT 4'b1010
`define ALU_LTE 4'b1011
`define ALU_T 4'b1100
`define ALU_NE 4'b1101
`define ALU_GTE 4'b1110
`define ALU_GT 4'b1111

`define CMD_EQ 2'b00
`define CMD_LT 2'b01
`define CMD_GT 2'b10
`define CMD_XX 2'bxx


module ALU(aluop, a, b, c, cmdflag);
	parameter WIDTH = 32;

	input[3:0] aluop;
	input[WIDTH - 1:0] a;
	input[WIDTH - 1:0] b;
	output reg[WIDTH-1:0] c;
	output reg cmdflag;

	wire[WIDTH - 1:0] out_one;
	assign out_one = {{(WIDTH - 1){1'b0}}, 1'b1};
	wire[WIDTH - 1:0] out_zero;
	assign out_zero = {{(WIDTH - 1){1'b0}}, 1'b0};


	always @(aluop or a or b) begin
		case (aluop)
			`ALU_ADD: begin
				c <= a + b;
				cmdflag <= 1'b0;
			end
			`ALU_SUB: begin
				c <= a - b;
				cmdflag <= 1'b0;
			end
			`ALU_AND: begin
				c <= a & b;
				cmdflag <= 1'b0;
			end
			`ALU_OR: begin
				c <= a | b;
				cmdflag <= 1'b0;
			end
			`ALU_XOR: begin
				c <= a ^ b;
				cmdflag <= 1'b0;
			end
			`ALU_NAND: begin
				c <= ~(a & b);
				cmdflag <= 1'b0;
			end
			`ALU_NOR: begin
				c <= ~(a | b);
				cmdflag <= 1'b0;
			end
			`ALU_XNOR: begin
				c <= a ^~ b;
				cmdflag <= 1'b0;
			end
			`ALU_MVHI: begin
				c <= ((b & (1 << ((WIDTH >> 1) + 1))) << (WIDTH >> 1));
				cmdflag <= 1'b0;
			end
			`ALU_EQ: begin
				if (a == b) begin
					c <= out_one;
					cmdflag <= 1'b1;
				end else begin
					c <= out_zero;
					cmdflag <= 1'b0;
				end
			end
			`ALU_LT: begin
				if (a < b) begin
					c <= out_one;
					cmdflag <= 1'b1;
				end else begin
					c <= out_zero;
					cmdflag <= 1'b0;
				end
			end
			`ALU_LTE: begin
				if (a <= b) begin
					c <= out_one;
					cmdflag <= 1'b1;
				end else begin
					c <= out_zero;
					cmdflag <= 1'b0;
				end
			end
			`ALU_T: begin
				c <= out_one;
				cmdflag <= 1'b1;
			end
			`ALU_NE: begin
				if (a != b) begin
					c <= out_one;
					cmdflag <= 1'b1;
				end else begin
					c <= out_zero;
					cmdflag <= 1'b0;
				end
			end
			`ALU_GTE: begin
				if (a >= b) begin
					c <= out_one;
					cmdflag <= 1'b1;
				end else begin
					c <= out_zero;
					cmdflag <= 1'b0;
				end
			end
			`ALU_GT: begin
				if (a > b) begin
					c <= out_one;
					cmdflag <= 1'b1;
				end else begin
					c <= out_zero;
					cmdflag <= 1'b0;
				end
			end
			default: begin
				c <= {WIDTH{1'bx}};
				cmdflag <= 1'b0;
			end
		endcase
	end
endmodule