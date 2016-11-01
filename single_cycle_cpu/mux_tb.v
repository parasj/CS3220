`timescale 1ns / 1ps
module mux_tb();
	reg s;
	reg [31:0] d0, d1;
	wire [31:0] out;

	mux2 m0(s, d0, d1, out);

	initial begin
		s = 0;
		d0 = 2;
		d1 = 1;
		#1;
		d0 = 4;
		d1 = 5;
		#1;
		s = 1;
		#1
		d1 = 10;
		#1
		$stop;
	end
endmodule