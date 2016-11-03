`timescale 1ns / 1ps
module TestTop();
  reg  [9:0] SW;
  reg  [3:0] KEY;
  reg  clk;
  reg  rst;
  wire [9:0] LEDR;
  wire [6:0] HEX0,HEX1,HEX2,HEX3;

	NickTest n(SW,KEY,LEDR,HEX0,HEX1,HEX2,HEX3,clk, rst);

  always begin
    #1 clk = ! clk;
  end

  initial begin
    clk = 0;
    rst = 1;
    #2
    rst = 0;
    #60
    $stop;
  end
endmodule