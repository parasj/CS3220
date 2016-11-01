`timescale 1ns / 1ps
module TestMux();
	reg s0;
	reg [1:0] s1;
	reg [31:0] d0, d1, d2, d3;
	wire [31:0] out0, out1;

	Mux2 m0(s0, d0, d1, out0);
	Mux4 m1(s1, d0, d1, d2, d3, out1);

	initial begin
		s0 = 0;
		s1 = 0;
		d0 = 2;
		d1 = 1;
		d2 = 7;
		d3 = 9;
		#1;
		d0 = 4;
		d1 = 5;
		#1;
		s0 = 1;
		s1 = 1;
		#1
		d1 = 10;
		#1
		s1 = 2;
		#1
		s1 = 3;
		#1
		$stop;
	end
endmodule