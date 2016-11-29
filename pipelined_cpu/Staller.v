module Staller (isStalled, ifDefEn, decExeEn, exeMemEn, memWbEn);
	input isStalled;
	output ifDefEn;
	output decExeEn;
	output exeMemEn;
	output memWbEn;

	assign ifDefEn = isStalled ? 1'b1 : 1'b0;
	assign decExeEn = isStalled ? 1'b1 : 1'b0;
	assign exeMemEn = isStalled ? 1'b1 : 1'b0;
	assign memWbEn = isStalled ? 1'b1 : 1'b0;
endmodule
