`timescale 1ns / 1ps
module TestController();
	reg [31:0] in;
	wire cmd_flag;
	wire[3:0] src_index1, src_index2, dst_index;
	wire[1:0] alu_mux, dstdata_mux, nextpc_mux;
	wire reg_wrt_en, mem_wrt_en;
	wire[4:0] alu_op;
	wire[15:0] imm;
	wire[31:0] imm_ext;
	wire[31:0] alu_b;

	wire [31:0]dst_data;
	reg clk, rst;
	wire [31:0]alu_out;
	wire [31:0]src1_data, src2_data;

	Controller c(in, src_index1, src_index2, dst_index, imm, alu_op, alu_mux, dstdata_mux, reg_wrt_en, mem_wrt_en, nextpc_mux, cmd_flag);
	RegFile r(clk, rst, src_index1, src_index2, dst_index, dst_data, src1_data, src2_data, reg_wrt_en);
	ALU a(alu_op, src1_data, alu_b, alu_out, cmd_flag);
	SignExtension #(16, 32) sign_ext(imm, imm_ext);
	Mux4 m1(alu_mux, src2_data, imm_ext, 0, 0, alu_b);
	Mux4 m2(dstdata_mux, alu_out, 0, 0, 0, dst_data);

	always begin
		#1 clk = ! clk;
	end

	initial begin
		clk = 0;
		rst = 1;
		in = 31'h47ee2000;
		#1
		rst = 0;
		#1
		in = 31'h47460100;
		#2;
		$stop;
	end
endmodule