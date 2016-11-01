`define ALU_UNUSED 5'b0
`define ALU_ADD 5'b1
`define ALU_SUB 5'b10
`define ALU_AND 5'b11
`define ALU_OR 5'b100
`define ALU_XOR 5'b101
`define ALU_NAND 5'b110
`define ALU_NOR 5'b111
`define ALU_XNOR 5'b1000
`define ALU_MVHI 5'b1001
`define ALU_F 5'b1010
`define ALU_EQ 5'b1011
`define ALU_LT 5'b1100
`define ALU_LTE 5'b1101
`define ALU_T 5'b1110
`define ALU_NE 5'b1111
`define ALU_GTE 5'b10000
`define ALU_GT 5'b10001
`define ALU_BEQZ 5'b10010
`define ALU_BLTZ 5'b10011
`define ALU_BLTEZ 5'b10100
`define ALU_BNEZ 5'b10101
`define ALU_BGTEZ 5'b10110
`define ALU_BGTZ 5'b10111

module ALU(aluop, a, b, c, cmdflag);
	parameter WIDTH = 32;

	input[4 : 0] aluop;
	input[WIDTH - 1 : 0] a;
	input[WIDTH - 1 : 0] b;
	output reg[WIDTH - 1 : 0] c;
	output reg cmdflag;

	wire[WIDTH - 1 : 0] out_one = {{(WIDTH - 1){1'b0}}, 1'b1};
	wire[WIDTH - 1 : 0] out_zero = {WIDTH{1'b0}};

	wire lt, gt, eq;
	SignedComparator #(WIDTH) sc1(a, b, lt, gt, eq);

	wire ltz, gtz, eqz;
	SignedComparator #(WIDTH) sc2(a, out_zero, ltz, gtz, eqz);

	always @(aluop or a or b) begin
		case (aluop)
			`ALU_UNUSED: begin
				c <= {WIDTH{1'bx}};
				cmdflag <= 1'b0;
			end
			
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
				c <= ((b & ((1 << ((WIDTH >> 1) + 1))) - 1) << (WIDTH >> 1));
				cmdflag <= 1'b0;
			end

			`ALU_F: begin
				c <= out_zero;
				cmdflag <= 1'b0;
			end
			
			`ALU_EQ: begin
				if (eq) begin
					c <= out_one;
					cmdflag <= 1'b1;
				end else begin
					c <= out_zero;
					cmdflag <= 1'b0;
				end
			end
			
			`ALU_LT: begin
				if (lt) begin
					c <= out_one;
					cmdflag <= 1'b1;
				end else begin
					c <= out_zero;
					cmdflag <= 1'b0;
				end
			end
			
			`ALU_LTE: begin
				if (lt || eq) begin
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
				if (!eq) begin
					c <= out_one;
					cmdflag <= 1'b1;
				end else begin
					c <= out_zero;
					cmdflag <= 1'b0;
				end
			end
			
			`ALU_GTE: begin
				if (gt || eq) begin
					c <= out_one;
					cmdflag <= 1'b1;
				end else begin
					c <= out_zero;
					cmdflag <= 1'b0;
				end
			end
			
			`ALU_GT: begin
				if (gt) begin
					c <= out_one;
					cmdflag <= 1'b1;
				end else begin
					c <= out_zero;
					cmdflag <= 1'b0;
				end
			end
			
			`ALU_BEQZ: begin
				if (eqz) begin
					c <= out_one;
					cmdflag <= 1'b1;
				end else begin
					c <= out_zero;
					cmdflag <= 1'b0;
				end
			end
			
			`ALU_BLTZ: begin
				if (ltz) begin
					c <= out_one;
					cmdflag <= 1'b1;
				end else begin
					c <= out_zero;
					cmdflag <= 1'b0;
				end
			end
			
			`ALU_BLTEZ: begin
				if (ltz || eqz) begin
					c <= out_one;
					cmdflag <= 1'b1;
				end else begin
					c <= out_zero;
					cmdflag <= 1'b0;
				end
			end
			
			`ALU_BNEZ: begin
				if (!eqz) begin
					c <= out_one;
					cmdflag <= 1'b1;
				end else begin
					c <= out_zero;
					cmdflag <= 1'b0;
				end
			end
			
			`ALU_BGTEZ: begin
				if (gtz || eqz) begin
					c <= out_one;
					cmdflag <= 1'b1;
				end else begin
					c <= out_zero;
					cmdflag <= 1'b0;
				end
			end
			
			`ALU_BGTZ: begin
				if (gtz) begin
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

module SignedComparator(a, b, lt, gt, eq);
	parameter WIDTH = 32;
	input[WIDTH - 1 : 0] a;
	input[WIDTH  - 1: 0] b;
	
	output lt;
	output gt;
	output eq;

	wire[WIDTH - 1 : 0] delta = a - b;
	wire diff = delta[WIDTH - 1];

	assign eq = (diff == {WIDTH{1'b0}}) ? 1'b1 : 1'b0;
	assign lt = (!eq && diff == 1'b1) ? 1'b1 : 1'b0;
	assign gt = (!eq && diff == 1'b0) ? 1'b1 : 1'b0;
endmodule