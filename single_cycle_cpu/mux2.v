module Mux2(s, d0, d1, out);
	input s;
	input [31:0] d0, d1;
	output [31:0] out;

	wire [31:0] mux_out;

	assign out = mux_out;
	assign mux_out = s ? d1: d0;
endmodule