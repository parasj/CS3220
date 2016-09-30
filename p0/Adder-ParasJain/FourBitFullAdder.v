module FourBitFullAdder (a, b, cin, s);
	input[3:0] a;
	input[3:0] b;
	input cin;
	
	output[4:0] s;
	
	wire[2:0] carry;
	
	FullAdder f0 (a[0], b[0], cin, s[0], carry[0]);
	FullAdder f1 (a[1], b[1], carry[0], s[1], carry[1]);
	FullAdder f2 (a[2], b[2], carry[1], s[2], carry[2]);
	FullAdder f3 (a[3], b[3], carry[2], s[3], s[4]);
endmodule