module ClockDivider (inclk0, c0);
	parameter BIT_WIDTH = 32;

	// Implement this yourself
	// Slow down the clock to ensure the cycle is long enough for all operations to execute
	// If you don't, you might get weird errors

	parameter[BIT_WIDTH - 1 : 0] tmin = 32'd25000000;

	input	  inclk0;
	output	  c0;

	reg[BIT_WIDTH - 1 : 0] counter;
	reg outclk;

	assign c0 = outclk;

	initial begin
		outclk = 1'b0;
		counter = tmin;
	end

	always @(posedge inclk0) begin
		/*if (rst) begin
			counter <= tmin;
			outclk = 1'b0;
			outlocked = 1'b0;
		end
		else begin*/
			counter <= counter - 32'b1;
			if (counter == 32'b0) begin
				counter <= tmin;
				outclk <= ~outclk;
			end
		//end
	end
endmodule
