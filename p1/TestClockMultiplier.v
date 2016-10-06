`timescale 1ns / 1ps
module TestClockMultipler();
    reg     reset;
    reg     clk_in;
    wire    clk_out;
	wire[3:0] num_out;
	ClockMultiplier clk_mult(reset, clk_in, 2, clk_out, num_out);

    always
        #20 clk_in = !clk_in;

    initial begin
        reset   =   0;
        #100
        $stop;
    end
end
