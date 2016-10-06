module ClockMultiplier (reset, clkin, multiple, clkout);
	input reset;
	input clkin;
	input[31:0] multiple;
	output clkout;
	
	reg[31:0] counter;
	
	initial begin
		counter = multiple;
		clkout = 1'b0;
	end
	
	always @ (posedge reset OR posedge clkin) begin
		counter <= counter - 1;
		if (reset == 1'b1) begin
			counter <= 32'b0;
			clkout <= 1'b0;
		end
	end
	
endmodule