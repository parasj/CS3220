module BranchPredictorHysteresis(clk, reset, pcAddr, resAddr, result, resultVal, prediction);
	parameter BIT_WIDTH = 32;
	parameter TABLE_WIDTH = 3;
	parameter TABLE_SELECT_BITS = 12;
	parameter TABLE_LENGTH = 4096; // 2^TABLE_SELECT_BITS

	input clk;
	input[BIT_WIDTH - 1 : 0] pcAddr;
	input[BIT_WIDTH - 1 : 0] resAddr;

	input result;
	input resultVal;
	output reg prediction;

	wire[TABLE_SELECT_BITS - 1 : 0] pcSel = pcAddr[TABLE_SELECT_BITS - 1 : 0];
	wire[TABLE_SELECT_BITS - 1 : 0] resSel = resSel[TABLE_SELECT_BITS - 1 : 0];

	reg[TABLE_WIDTH - 1 : 0] tbl[TABLE_LENGTH - 1 : 0];

	initial begin
	   for (i = 0; i < TABLE_LENGTH; i = i + 1) begin
	      tbl[i] = {1'b1, {(TABLE_WIDTH - 1){1'b0}}};
	   end
	end

	always @ (posedge clk) begin
		if (reset == 1'b1) begin
			prediction <= 0;
			// for (i = 0; i < TABLE_LENGTH; i = i + 1) begin
			//    tbl[i] <= {1'b1, {(TABLE_WIDTH - 1){1'b0}}};
			// end
		end else begin
			prediction <= tbl[pcSel][TABLE_WIDTH - 1 : TABLE_WIDTH - 2];

			if (result == 1'b1) begin
				if (resultVal == 1'b1)
					tbl[resAddr] = tbl[resAddr] + 1; 
				else if (resultVal == 1'b0)
					tbl[resAddr] = tbl[resAddr] + 1; 
			end
		end
	end

endmodule