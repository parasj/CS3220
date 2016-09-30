module AdderSubtractor (SW, LEDR, HEX0, HEX2, HEX4);
	input[8:0] SW;
	output[4:0] LEDR;
	output[6:0] HEX0;
	output[6:0] HEX2;
	output[6:0] HEX4;
	
	wire[3:0] a;
	wire[3:0] b;
	wire[3:0] b_xor;
	wire cin;
	
	assign cin = SW[0];
	assign a = SW[4:1];
	assign b = SW[8:5];
	
	assign b_xor[3] = b[3] ^ cin;
	assign b_xor[2] = b[2] ^ cin;
	assign b_xor[1] = b[1] ^ cin;
	assign b_xor[0] = b[0] ^ cin;
	
	FourBitFullAdder fulladder (a, b_xor, cin, LEDR);

	hex27seg h0 (a, HEX0);
	hex27seg h2 (b, HEX2);
	hex27seg h4 (LEDR[3:0], HEX4);
endmodule