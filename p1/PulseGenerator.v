module PulseGenerator (reset, start, clkin, clkoutport);
	parameter multiple = 50000000;
	input reset;
	input start;
	input clkin;
	output clkoutport;

	reg clkout = 1'b0;
	reg[31:0] counter = multiple;
	assign clkoutport = clkout;

	always @ (negedge reset or posedge clkin) begin
		if (reset == 1'b0) begin
			counter <= multiple;
		end else if (start == 1'b1) begin
	 		counter <= counter - 1;

			if (counter == 32'b1) begin
				counter <= multiple;
				clkout <= 1;
			end else begin
				clkout <= 0;
			end
		end
	end
endmodule