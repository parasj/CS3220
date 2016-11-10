`timescale 1ns / 1ps
module TestRegFile();
	reg clk, rst;
	reg [3:0] src1, src2, dst;
	reg [31:0] dst_data;
	reg	wrt_en;
	wire [31:0] src1_data, src2_data;

	RegFile rf(clk, rst, src1, src2, dst, dst_data, src1_data, src2_data, wrt_en);

	always begin
		#1 clk = !clk;
	end

	initial begin
		clk = 0;
		rst = 1;
		src1 = 1;
		src2 = 1;
		dst = 1;
		dst_data = 5;
		wrt_en = 0;
		#1
		rst = 0;
		wrt_en = 1;
		#1
    dst = 2;
    src2 = 2;
    #1
    dst_data = 3;
    #2
		$stop;
	end
endmodule