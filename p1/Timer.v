module Timer(SW, KEY, LEDR, HEX0, HEX1, HEX2, HEX3, CLOCK_50);
	input[7:0] SW;
	input[2:0] KEY;
	input CLOCK_50;
	
	output[9:0] LEDR;
	output[6:0] HEX0;
	output[6:0] HEX1;
	output[6:0] HEX2;
	output[6:0] HEX3;
	
	wire reset;
	wire settimer;
	wire toggletimer;
	
	assign reset = KEY[0];
	assign settimer = KEY[1];
	assign toggletimer = KEY[2];

	
	wire clock1;
	ClockMultiplier c1 (reset, SW[0], 5, clock1);

	assign LEDR[0] = clock1;	
	
endmodule