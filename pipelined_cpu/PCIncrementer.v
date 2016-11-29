module PCIncrementer(a, c);
	parameter BIT_WIDTH = 32;

	input[BIT_WIDTH - 1 : 0] a;
	output[BIT_WIDTH - 1 : 0] c;

	assign c = a + {{(BIT_WIDTH - 3){1'b0}}, 3'b100};
endmodule