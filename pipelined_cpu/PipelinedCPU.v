module PipelinedCPU(SW,KEY,LEDR,HEX0,HEX1,HEX2,HEX3,CLOCK_50);
	input  [9:0] SW;
	input  [3:0] KEY;
	input  CLOCK_50;
	output [9:0] LEDR;
	output [6:0] HEX0,HEX1,HEX2,HEX3;

	parameter DBITS                        = 32;
	parameter INST_SIZE                    = 32'd4;
	parameter INST_BIT_WIDTH               = 32;
	parameter START_PC                     = 32'h40;
	parameter REG_INDEX_BIT_WIDTH          = 4;
	parameter ADDR_KEY                     = 32'hF0000010;
	parameter ADDR_SW                      = 32'hF0000014;
	parameter ADDR_HEX                     = 32'hF0000000;
	parameter ADDR_LEDR                    = 32'hF0000004;
	
	parameter IMEM_INIT_FILE               = "Test2.mif";
	parameter IMEM_ADDR_BIT_WIDTH          = 11;
	parameter IMEM_DATA_BIT_WIDTH          = INST_BIT_WIDTH;
	parameter IMEM_PC_BITS_HI              = IMEM_ADDR_BIT_WIDTH + 2;
	parameter IMEM_PC_BITS_LO              = 2;
	
	parameter DMEMADDRBITS                 = 13;
	parameter DMEMWORDBITS                 = 2;
	parameter DMEMTOTALBITS                = 32;
	parameter DMEMWORDS                    = 2048;
	
	
	parameter OP1_ALUR                     = 4'b0000;
	parameter OP1_ALUI                     = 4'b1000;
	parameter OP1_CMPR                     = 4'b0010;
	parameter OP1_CMPI                     = 4'b1010;
	parameter OP1_BCOND                    = 4'b0110;
	parameter OP1_SW                       = 4'b0101;
	parameter OP1_LW                       = 4'b1001;
	parameter OP1_JAL                      = 4'b1011;
	
	wire reset = SW[0];
	wire clk;
	ClockDivider #(.BIT_WIDTH(DBITS)) clk_divider (.inclk0 (CLOCK_50),.c0 (clk));

	// Buffer enable signals
	wire ifDecEn, decExeEn, exeMemEn, memWbEn;

	// PC calculations
	wire[DBITS - 1: 0] pcOutPlusOne;
	wire[DBITS - 1: 0] pcBranchIn;
	wire[DBITS - 1: 0] pcBufOut1;

	// PC output
	wire pcWrtEn;
	wire[DBITS - 1: 0] pcIn;
	wire[DBITS - 1: 0] pcOut;

	// IR output
	wire[IMEM_DATA_BIT_WIDTH - 1: 0] instOut;

	// IF_DEC
	wire[IMEM_DATA_BIT_WIDTH - 1: 0] instBufOut;

	// Controller output
	wire[15:0] imm;
	wire[DBITS-1: 0] imm_ext;
	wire alu_mux, dstdata_mux, next_pc_mux;
	wire reg_wrt_en, mem_wrt_en;
	wire[REG_INDEX_BIT_WIDTH - 1: 0] src_index1, src_index2, dst_index;
	wire[4:0] alu_op;

	// RF output
	wire[DBITS - 1 : 0] src1_data, src2_data;
	wire[DBITS - 1 : 0] src1_forward, src2_forward;

	// DEC_EXE output
	wire[DBITS - 1 : 0] pcBufOut2, src1_buf_out, src2_buf_out, imm_buf_out;
	wire reg_wrt_en_1;
	wire mem_wrt_en_1;
	wire[REG_INDEX_BIT_WIDTH - 1: 0] dst_index_1;
	wire[4:0] alu_op_buf_out;
	wire alu_mux_buf_out, dstdata_mux_1;

	// ALU input
	wire[DBITS - 1 : 0] alu_b;

	// ALU output
	wire[DBITS - 1 : 0] alu_res_in;
	wire cmd_flag;

	// EXE_MEM output
	wire[DBITS - 1 : 0] alu_res_out, src1_buf_out_1, src2_buf_out_1;
	wire reg_wrt_en_2;
	wire mem_wrt_en_2;
	wire[REG_INDEX_BIT_WIDTH - 1: 0] dst_index_2;
	wire dstdata_mux_2;

	// MEM output
	wire[DBITS - 1 : 0] mem_out;

	// MEM_WB input
	wire[DBITS - 1 : 0] end_res_in;
	wire[DBITS - 1 : 0] end_res_out; 
	wire reg_wrt_en_3;
	wire[REG_INDEX_BIT_WIDTH - 1: 0] dst_index_3;

	wire isStalled = 1'b0;
	wire [1:0] src1_sel, src2_sel;

	wire[9:0] led_wire;
	wire[15:0] hex_wire;

	// Stalled?
	// Staller stall (isStalled, ifDefEn, decExeEn, exeMemEn, memWbEn);
	/*assign ifDecEn = 1;
	assign decExeEn = 1;*/
	assign exeMemEn = 1;
	assign memWbEn = 1;

	HazardControl #(.BIT_WIDTH(DBITS), .REG_INDEX_BIT_WIDTH(REG_INDEX_BIT_WIDTH)) hazardControl(src_index1, src_index2, cmd_flag,
		dst_index_1, reg_wrt_en_1, dstdata_mux_1, dst_index_2, reg_wrt_en_2, src1_sel, src2_sel,
		ifDecReset, decExeReset, ifDecEn, decExeEn, pcWrtEn, dst_index_3, reg_wrt_en_3);

	// PC
	PCIncrementer #(.BIT_WIDTH(DBITS)) pcPlusOneAdder (pcOut, pcOutPlusOne);
	Mux2 #(.BIT_WIDTH(DBITS)) pcInMux (next_pc_mux, pcOutPlusOne, imm_buf_out * 4 + pcBufOut2, pcIn);
	Register #(.BIT_WIDTH(DBITS), .RESET_VALUE(START_PC)) pc (clk, reset, pcWrtEn, pcIn, pcOut);

	// IF
	// InstMemory #(IMEM_INIT_FILE, IMEM_ADDR_BIT_WIDTH, IMEM_DATA_BIT_WIDTH) instMem (pcOut[IMEM_PC_BITS_HI - 1: IMEM_PC_BITS_LO], instOut);
	InstMemory #(IMEM_INIT_FILE, IMEM_ADDR_BIT_WIDTH, IMEM_DATA_BIT_WIDTH) instMem (pcOut[IMEM_PC_BITS_HI - 1: IMEM_PC_BITS_LO], instOut);
	IF_DEC_Buffer if_dec_buf(clk, ifDecReset, ifDecEn, pcOutPlusOne, pcBufOut1, instOut, instBufOut);

	// ID
	Controller #(.INST_BIT_WIDTH(DBITS)) control(instBufOut, src_index1, src_index2, dst_index, imm,
	  alu_op, alu_mux, dstdata_mux, reg_wrt_en, mem_wrt_en, next_pc_mux, cmd_flag);
	Mux4 #(.BIT_WIDTH(DBITS)) src1_mux(src1_sel, src1_data, alu_res_in, end_res_in, end_res_out, src1_forward);
	Mux4 #(.BIT_WIDTH(DBITS)) src2_mux(src2_sel, src2_data, alu_res_in, end_res_in, end_res_out, src2_forward);
	RegFile #(.BIT_WIDTH(DBITS)) regfile(clk, reset, src_index1, src_index2, dst_index_3, end_res_out, src1_data, src2_data, reg_wrt_en_3);
	DEC_EXE_Buffer dec_exe_buf(clk, reset, decExeEn, pcBufOut1, pcBufOut2, src1_forward, src1_buf_out, src2_forward, 
	  src2_buf_out, imm_ext, imm_buf_out, alu_op, alu_op_buf_out, alu_mux, alu_mux_buf_out, dstdata_mux, dstdata_mux_1,
	  dst_index, dst_index_1, mem_wrt_en, mem_wrt_en_1, reg_wrt_en, reg_wrt_en_1);

	// EX
	// forwarddingLogic #(.BIT_WIDTH(DBITS)) forward ();
	Mux2 #(.BIT_WIDTH(DBITS)) aluSrc2Mux (alu_mux_buf_out, src2_buf_out, imm_buf_out, alu_b);
	SignExtension #(16, DBITS) sign_ext(imm, imm_ext);
	ALU #(.BIT_WIDTH(DBITS)) alu(alu_op_buf_out, src1_buf_out, alu_b, alu_res_in, cmd_flag);
	EXE_MEM_Buffer exe_mem_buf(clk, reset, exeMemEn, src1_buf_out, src1_buf_out_1, alu_res_in, alu_res_out, dst_index_1, 
	  dst_index_2, dstdata_mux_1, dstdata_mux_2, mem_wrt_en_1, mem_wrt_en_2, reg_wrt_en_1, reg_wrt_en_2, src2_buf_out, src2_buf_out_1);

	// MEM
	DataMemory dataMemory (clk, mem_wrt_en_2, alu_res_out, src2_buf_out_1, 10'b0, 4'b0, LEDR, hex_wire, mem_out);
	Mux2 #(.BIT_WIDTH(DBITS)) registerDestMux (dstdata_mux_2, alu_res_out, mem_out, end_res_in);
	MEM_WB_Buffer mem_wb_buf(clk, reset, memWbEn, reg_wrt_en_2, reg_wrt_en_3, dst_index_2,
	  dst_index_3, end_res_in, end_res_out);

	SevenSeg h0 (hex_wire[3:0], HEX0);
	SevenSeg h1 (hex_wire[7:4], HEX1);
	SevenSeg h2 (hex_wire[11:8], HEX2);
	SevenSeg h3 (hex_wire[15:12], HEX3);
endmodule