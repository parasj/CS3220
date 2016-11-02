module Mux4(s, d0, d1, d2, d3, out);
	input [1 : 0]	s;
	input [31 : 0] d0, d1, d2, d3;
	output [31 : 0] out;
	assign out = (s == 0) ? d0 :
						  (s == 1) ? d1 :
				 		  (s == 2) ? d2 : d3;
endmodule