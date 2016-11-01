module mux2(s, d0, d1, out) begin
	input s;
	input [31:0] d0, d1;
	output reg[31:0] out;

	assign mux_out = (sel) ? d1: d0;
endmodule