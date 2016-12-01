`timescale 1ns / 1ps

module CPUTestBench();
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
	
	reg reset = 0;
	reg clk;

	// Buffer enable signals
	wire ifDefEn, decExeEn, exeMemEn, memWbEn;

	// PC calculations
	wire[DBITS - 1: 0] pcOutPlusOne;
	wire[DBITS - 1: 0] pcBranchIn;
	wire[DBITS - 1: 0] pcBufOut1;

	// PC output
	wire pcWrtEn = 1'b1;
	wire[DBITS - 1: 0] pcIn;
	wire[DBITS - 1: 0] pcOut;

	// IR output
	wire[IMEM_DATA_BIT_WIDTH - 1: 0] instOut;

	// IF_DEC
	wire[IMEM_DATA_BIT_WIDTH - 1: 0] instBufOut;

	// Controller output
	wire[15:0] imm;
	wire[DBITS-1: 0] imm_ext;
	wire[1:0] alu_mux, dstdata_mux, next_pc_mux;
	wire reg_wrt_en, mem_wrt_en;
	wire[REG_INDEX_BIT_WIDTH - 1: 0] src_index1, src_index2, dst_index;
	wire[4:0] alu_op;

	// RF output
	wire[DBITS - 1 : 0] src1_data, src2_data;

	// DEC_EXE output
	wire[DBITS - 1 : 0] pcBufOut2, src1_buf_out, src2_buf_out, imm_buf_out;
	wire reg_wrt_en_1;
	wire mem_wrt_en_1;
	wire[REG_INDEX_BIT_WIDTH - 1: 0] dst_index_1;
	wire[4:0] alu_op_buf_out;
	wire[1:0] alu_mux_buf_out, dstdata_mux_1;

	// ALU input
	wire[DBITS - 1 : 0] alu_b;

	// ALU output
	wire[DBITS - 1 : 0] alu_res_in;
	wire cmd_flag;

	// EXE_MEM output
	wire[DBITS - 1 : 0] alu_res_out, src1_buf_out_1;
	wire reg_wrt_en_2;
	wire mem_wrt_en_2;
	wire[REG_INDEX_BIT_WIDTH - 1: 0] dst_index_2;
	wire[1:0] dstdata_mux_2;

	// MEM output
	wire[DBITS - 1 : 0] mem_out;

	// MEM_WB input
	wire[DBITS - 1 : 0] end_res_in;
	wire[DBITS - 1 : 0] end_res_out; 
	wire reg_wrt_en_3;
	wire[REG_INDEX_BIT_WIDTH - 1: 0] dst_index_3;

	wire isStalled = 1'b0;

	wire[9:0] led_wire = 0;
	wire[15:0] hex_wire = 0;

	// Stalled?
	// Staller stall (isStalled, ifDefEn, decExeEn, exeMemEn, memWbEn);
	assign ifDefEn = 1;
	assign decExeEn = 1;
	assign exeMemEn = 1;
	assign memWbEn = 1;

	// PC
	PCIncrementer #(.BIT_WIDTH(DBITS)) pcPlusOneAdder (pcOut, pcOutPlusOne);
	Mux4 #(.BIT_WIDTH(DBITS)) pcInMux (next_pc_mux, pcOutPlusOne, pcBranchIn, alu_res_in, 32'b0, pcIn);
	Register #(.BIT_WIDTH(DBITS), .RESET_VALUE(START_PC)) pc (clk, reset, pcWrtEn, pcIn, pcOut);

	// IF
	// InstMemory #(IMEM_INIT_FILE, IMEM_ADDR_BIT_WIDTH, IMEM_DATA_BIT_WIDTH) instMem (pcOut[IMEM_PC_BITS_HI - 1: IMEM_PC_BITS_LO], instOut);
	DummyMemory #(IMEM_INIT_FILE, IMEM_ADDR_BIT_WIDTH, IMEM_DATA_BIT_WIDTH) instMem (pcOut[IMEM_PC_BITS_HI - 1: IMEM_PC_BITS_LO], instOut);
	IF_DEC_Buffer if_dec_buf(clk, reset, ifDefEn, pcOutPlusOne, pcBufOut1, instOut, instBufOut);

	// ID
	Controller #(.INST_BIT_WIDTH(DBITS)) control(instBufOut, src_index1, src_index2, dst_index, imm,
	  alu_op, alu_mux, dstdata_mux, reg_wrt_en, mem_wrt_en, next_pc_mux, cmd_flag);
	RegFile #(.BIT_WIDTH(DBITS)) regfile(clk, reset, src_index1, src_index2, dst_index_3, end_res_out, src1_data, src2_data, reg_wrt_en_3);
	DEC_EXE_Buffer dec_exe_buf(clk, reset, decExeEn, pcBufOut1, pcBufOut2, src1_data, src1_buf_out, src2_data, 
	  src2_buf_out, imm_ext, imm_buf_out, alu_op, alu_op_buf_out, alu_mux, alu_mux_buf_out, dstdata_mux, dstdata_mux_1,
	  dst_index, dst_index_1, mem_wrt_en, mem_wrt_en_1, reg_wrt_en, reg_wrt_en_1);
	

	// EX
	// ForwardingLogic #(.BIT_WIDTH(DBITS)) forward ();
	Mux4 #(.BIT_WIDTH(DBITS)) aluSrc2Mux (alu_mux_buf_out, src2_data, imm_buf_out, (imm_ext << 2), 32'b0, alu_b);
	SignExtension #(16, DBITS) sign_ext(imm, imm_ext);
	ALU #(.BIT_WIDTH(DBITS)) alu(alu_op_buf_out, src1_buf_out, alu_b, alu_res_in, cmd_flag);
	EXE_MEM_Buffer exe_mem_buf(clk, reset, exeMemEn, src1_buf_out, src1_buf_out_1, alu_res_in, alu_res_out, dst_index_1, 
	  dst_index_2, dstdata_mux_1, dstdata_mux_2, mem_wrt_en_1, mem_wrt_en_2, reg_wrt_en_1, reg_wrt_en_2);

	// MEM
	DataMemory dataMemory (clk, mem_wrt_en_2, alu_res_out, src2_data, 10'b0, 4'b0, led_wire, hex_wire, mem_out);
	Mux4 #(.BIT_WIDTH(DBITS)) registerDestMux (dstdata_mux_2, alu_res_out, mem_out, pcOutPlusOne, 32'b0, end_res_in);
	MEM_WB_Buffer mem_wb_buf(clk, reset, memWbEn, reg_wrt_en_2, reg_wrt_en_3, dst_index_2,
	  dst_index_3, end_res_in, end_res_out);

	// WB
	// Piped directly to RR
	always begin
		#1 clk = !clk;
	end

	initial begin
	  $monitor("clk %b rst %b", clk, reset);

	  clk = 1'b0;
	  reset = 1'b0;
	  #20
	  //reset = 1'b1;
	  //dumpState;
	  //reset = 1'b0;

	  
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  // dumpState;
	  

	  $stop;
	end

	task dumpState;
		$stop;
		// begin
		//     clk = 1'b0;
		//     #20
		//     clk = 1'b1;
		    
		//     #20
		//     // $display("IMEM[%h] = %h", pcOut, instWord);
		//     // $display("  PC: PCOut %h", pcOut);
		//     // $display("  IR: InstWord %h", instWord);
		//     // $display("  RR: src1[%h] = %h, src2[%h] = %h", src_index1, src1_data, src_index2, src2_data);
		//     // $display("  ALU: %h (op=%b) %h = %h", src1_data, alu_op, alu_b, alu_out);
		//     // $display("       SRC2 = (RegSrc2 %h, ImmExt %h, 4*ImmExt %h)[%b]", src2_data, imm_ext, (imm_ext << 2), alu_mux);

		//     // if (reg_wrt_en == 1'b1) begin
		//     //   $display("  WB: RR_WRT_EN=%b    rr[%h] = %h", reg_wrt_en, dst_index, end_res_out);
		//     //   $display("  MEM: WRT mem_wrt_en %b    mem[%h] <- %h (=%h))", mem_wrt_en, alu_out, src2_data, mem_out);
		//     // end else begin
		//     //   $display("  MEM: GET mem[%h] == %h)", alu_out, mem_out);
		//     // end

		//     // $display("  PC UPDATE: pcin %h", pcIn);
		//     // $display("             pcin = MUX[%b](pcOutPlusOne %h, pcBranchIn %h, alu_out %h)", next_pc_mux, pcOutPlusOne, pcBranchIn, alu_out);

		//     // // $display("  ID -> **: , alu_op %b, alu_mux %b, reg_wrt_en %b, mem_wrt_en %b, next_pc_mux %b, cmd_flag %b", src_index1, src_index2, dst_index, imm, alu_op, alu_mux, dstdata_mux, reg_wrt_en, mem_wrt_en, next_pc_mux, cmd_flag);
		// end
	endtask
endmodule