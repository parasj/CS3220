module Mux2(s, d0, d1, out);
	parameter BIT_WIDTH = 32;
	input s;
	input [BIT_WIDTH - 1 : 0] d0, d1;
	output [BIT_WIDTH - 1 : 0] out;
	assign out = (s == 0) ? d0 : d1;
endmodule