module AdderSubtractor (SW, LEDR, HEX0, HEX2, HEX4);
	input[8:0] SW;
	output[4:0] LEDR;
	output[6:0] HEX0;
	output[6:0] HEX2;
	output[6:0] HEX4;
	
	wire[3:0] a;
	wire[3:0] b;
	wire cin;
	
	assign {b, a, cin} = SW;

	FourBitFullAdder fulladder (a, b ^ {4{cin}}, cin, LEDR);

	hex27seg h0 (a, HEX0);
	hex27seg h2 (b, HEX2);
	hex27seg h4 (LEDR[3:0], HEX4);
endmodule