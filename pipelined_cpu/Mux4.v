module Mux4(s, d0, d1, d2, d3, out);
	parameter BIT_WIDTH = 32;
	input [1 : 0] s;
	input [BIT_WIDTH - 1 : 0] d0, d1, d2, d3;
	output [BIT_WIDTH - 1 : 0] out;
	assign out = (s == 0) ? d0 : (s == 1) ? d1 : (s == 2) ? d2 : d3;
endmodule