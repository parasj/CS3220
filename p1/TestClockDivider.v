`timescale 1ns / 1ps
module TestClockDivider();
    reg     clk_in;
    wire    clk_out;
	wire[3:0] num_out;
	ClockMultiplier clk_mult(clk_in, clk_out, num_out);

    always
        #20 clk_in = !clk_in;

    initial begin
        clk_in  =   0;
        #500
        $stop;
    end
endmodule
