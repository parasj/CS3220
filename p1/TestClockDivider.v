`timescale 1ns / 1ps
module TestClockDivider();
    reg     clk_in;
    wire    clk_out;
	wire[3:0] num_out;
	ClockDivider clk1(clk_in, clk_out);

    always
        #20 clk_in = !clk_in;

    initial begin
        clk_in  =   0;
        #5000000
        $stop;
    end
endmodule
