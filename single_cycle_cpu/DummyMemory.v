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
		data[16] = 32'h4fc00001;
		data[17] = 32'h47550014;
		data[18] = 32'h305c0000;
		data[19] = 32'h40550000;
		data[20] = 32'h4755001e;
		data[21] = 32'h305c0004;
		data[22] = 32'h705c0000;
		data[23] = 32'h704c0004;
		data[24] = 32'hc6445000;
		data[25] = 32'h47440001;
		data[26] = 32'b0;
		data[27] = 32'b0;
	end
endmodule