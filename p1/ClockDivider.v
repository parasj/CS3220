module ClockDivider (clkin, clkoutport);
	parameter multiple = 25000000;

	input clkin;
	output clkoutport;

	reg clkout = 1'b0;
	reg[31:0] counter = multiple;
	assign clkoutport = clkout;

	always @ (posedge clkin) begin
		counter <= counter - 1;

		if (counter == 32'b1) begin
			counter <= multiple;
			clkout <= ~clkout;
		end
	end
endmodule