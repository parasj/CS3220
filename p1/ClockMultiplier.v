module ClockMultiplier (reset, clkin, multiple, clkoutport);
	input reset;
	input clkin;
	input[31:0] multiple;
	output clkoutport;

	reg clkout;
	reg[31:0] counter;
	
	assign clkoutport = clkout;

	initial begin
		counter <= multiple;
		clkout <= 1'b0;
	end
	
	always @ (posedge reset or posedge clkin) begin
		if (reset == 1'b1) begin
			counter <= multiple;
			clkout <= 1'b0;
		end else begin
			if (counter == 1) begin
				counter <= multiple;
				clkout <= ~clkout;
			end else
				counter <= counter - 1;
		end
	end
	
endmodule