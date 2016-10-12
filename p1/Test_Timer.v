`timescale 1s / 1ns
module Test_Timer(CLOCK_50);
	reg [7:0] SW;
	reg	[3:0] KEY;
	input CLOCK_50;

	wire[9:0] LEDR;
	wire[6:0] HEX0;
	wire[6:0] HEX1;
	wire[6:0] HEX2;
	wire[6:0] HEX3;

	Timer t1(SW, KEY, LEDR, HEX0, HEX1, HEX2, HEX3);

	initial begin
		SW = 0;
		KEY = 0;
		#100 $stop;
	end

//	always
//		#10	CLOCK_50 = !CLOCK_50;
endmodule