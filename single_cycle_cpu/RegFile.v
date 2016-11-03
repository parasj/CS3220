module RegFile(clk, rst, src1, src2, dst, dst_data, src1_data, src2_data, wrt_en);
	parameter BIT_WIDTH = 32;

	input clk, rst;
	input [3:0] src1, src2, dst;
	input [BIT_WIDTH - 1 : 0] dst_data;
	input	wrt_en;
	output [BIT_WIDTH - 1 : 0] src1_data, src2_data;

	reg [BIT_WIDTH - 1 : 0]	file [0:15];

	assign src1_data = file[src1];
	assign src2_data = file[src2];

	integer i;
	always @ (posedge clk or posedge rst) begin
		if (rst) begin
			for (i = 0; i < 16; i = i + 1) begin
				file[i] <= 0;
			end
		end else if (wrt_en == 1'b1 && dst != 0) begin
			file[dst] <= dst_data;
		end
	end
endmodule