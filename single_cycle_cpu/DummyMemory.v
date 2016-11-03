module DummyMemory(addr, dataOut);
	parameter MEM_INIT_FILE;
	parameter ADDR_BIT_WIDTH = 11;
	parameter DATA_BIT_WIDTH = 32;
	parameter N_WORDS = (1 << ADDR_BIT_WIDTH);
	
	input[ADDR_BIT_WIDTH - 1: 0] addr;
	output[DATA_BIT_WIDTH - 1: 0] dataOut;

	reg[DATA_BIT_WIDTH - 1: 0] data[0: N_WORDS - 1];
	
	assign dataOut = data[addr];

	initial begin
		data[16] = 32'h4fe00000;
		data[17] = 32'h47ee2000;
		data[18] = 32'h4fc0f000;
		data[19] = 32'h40660000;
		data[20] = 32'h306c0004;
		data[21] = 32'h47460100;
		data[22] = 32'h47541000;
		data[23] = 32'h47760009;
		data[24] = 32'h30740000;
		data[25] = 32'h4777000d;
		data[26] = 32'h47440004;
		data[27] = 32'h2545fffc;
		data[28] = 32'h60f6002d;
	end
endmodule