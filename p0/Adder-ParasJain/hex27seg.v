module hex27seg(
	input[3:0] num,
	output[6:0] display
);
	assign display =
		num  ==  0 ? ~7'b0111111  :
		num  ==  1 ? ~7'b0000110  :
		num  ==  2 ? ~7'b1011011  :
		num  ==  3 ? ~7'b1001111  :
		num  ==  4 ? ~7'b1100110  :
		num  ==  5 ? ~7'b1101101  :
		num  ==  6 ? ~7'b1111101  :
		num  ==  7 ? ~7'b0000111  :
		num  ==  8 ? ~7'b1111111  :
		num  ==  9 ? ~7'b1100111  :
		num  ==  9 ? ~7'b1100111  :
		num  ==  10 ? ~7'b1110111 : //a
		num  ==  11 ? ~7'b1111100 : //b
		num  ==  12 ? ~7'b0111001 : //c
		num  ==  13 ? ~7'b1011110 : //d
		num  ==  14 ? ~7'b1111001 : //e
		num  ==  15 ? ~7'b1110001 : //f
		~7'b1000000;

endmodule