module ClockDivider (clkin, clkoutport, currentvalue);
	parameter multiple = 4;

	input clkin;
	output clkoutport;
	output[31:0] currentvalue;

	reg clkout = 1'b0;
	reg[31:0] counter = multiple;

	assign currentvalue = counter;
	
	assign clkoutport = clkout;

	always @ (posedge clkin) begin
		counter <= counter - 1;

		if (counter == 32'b1) begin
			counter <= multiple;
			clkout <= ~clkout;
		end
	end
endmodule