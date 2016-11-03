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
		data[16] = 32'h47440014;
		data[17] = 32'h4755000f;
		data[18] = 32'hc7645000;
		data[19] = 32'h40660000;
		data[20] = 32'h0;
		data[21] = 32'h0;
		data[22] = 32'h0;
		data[23] = 32'h0;
	end
endmodule