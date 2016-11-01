module ClockDivider (
	inclk0,
	c0,
	locked);
	
	// Implement this yourself
	// Slow down the clock to ensure the cycle is long enough for all operations to execute
	// If you don't, you might get weird errors

	parameter[31 : 0] tmin = 32'd200; // period time in ns, multiple of 20 where n >= 40

	input	  inclk0;
	output	  c0 = outclk;
	output	  locked = outlocked; // clock is paused when locked is 1

	reg[27:0] counter;
	reg outclk;
	reg outlocked;

	initial begin
		outclk = 1'b0;
		outlocked = 1'b0;
	end

	always @(posedge clk or posedge rst) begin
		if (rst) begin
			counter <= tmin;
			outclk = 1'b0;
			outlocked = 1'b0;
		end
		else begin
			counter <= counter - 32'b1;
			if (counter == 32'b0) begin
				counter <= tmin;
				outclk <= ~outclk;
				outlocked = 1'b0;
			end
		end
	end
endmodule
