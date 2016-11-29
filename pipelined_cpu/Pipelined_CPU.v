module Pipelined_CPU(SW,KEY,LEDR,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,CLOCK_50); // todo remove hex4 hex5
  input  [9:0] SW;
  input  [3:0] KEY;
  input  CLOCK_50;
  output [9:0] LEDR;
  output [6:0] HEX0,HEX1,HEX2,HEX3;
  output [6:0] HEX4,HEX5;
 
  parameter DBITS                        = 32;
  parameter INST_SIZE                = 32'd4;
  parameter INST_BIT_WIDTH               = 32;
  parameter START_PC                 = 32'h40;
  parameter REG_INDEX_BIT_WIDTH          = 4;
  parameter ADDR_KEY                     = 32'hF0000010;
  parameter ADDR_SW                      = 32'hF0000014;
  parameter ADDR_HEX                     = 32'hF0000000;
  parameter ADDR_LEDR                    = 32'hF0000004;
  
  parameter IMEM_INIT_FILE                 = "Sorter2.mif";
  parameter IMEM_ADDR_BIT_WIDTH          = 11;
  parameter IMEM_DATA_BIT_WIDTH          = INST_BIT_WIDTH;
  parameter IMEM_PC_BITS_HI              = IMEM_ADDR_BIT_WIDTH + 2;
  parameter IMEM_PC_BITS_LO              = 2;
  
  parameter DMEMADDRBITS                 = 13;
  parameter DMEMWORDBITS         = 2;
  parameter DMEMTOTALBITS                = 32;
  parameter DMEMWORDS          = 2048;
  
  
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
  wire ifDefEn, decExeEn, exeMemEn, memWbEn;  

  // PC calculations
  wire[DBITS - 1: 0] pcOutPlusOne;
  wire[DBITS - 1: 0] pcBranchIn;
  wire[DBITS - 1: 0] pcBufOut1, pcBufOut2;

  // PC output
  wire pcWrtEn = 1'b1;
  wire[DBITS - 1: 0] pcIn;
  wire[DBITS - 1: 0] pcOut;

  // IR output
  wire[IMEM_DATA_BIT_WIDTH - 1: 0] instOut;
  wire[IMEM_DATA_BIT_WIDTH - 1: 0] instBufOut;

  // RR input
  wire[REG_INDEX_BIT_WIDTH - 1: 0] src_index1, src_index2, dst_index;

  // RR output
  wire[15:0] imm;
  wire[DBITS-1: 0] imm_ext;
  wire[1:0] alu_mux, dstdata_mux, next_pc_mux;
  wire reg_wrt_en, mem_wrt_en;

  wire[DBITS - 1 : 0] dst_data;
  wire[DBITS - 1 : 0] src1_data, src2_data;
  wire[DBITS - 1 : 0] alu_b;
  wire[DBITS - 1 : 0] alu_out;
  wire[4 : 0] alu_op;
  wire cmd_flag;

  wire[DBITS - 1 : 0] mem_out;

  PCIncrementer #(.BIT_WIDTH(DBITS)) pcPlusOneAdder (pcOut, pcOutPlusOne);

  Register #(.BIT_WIDTH(DBITS), .RESET_VALUE(START_PC)) pc (clk, reset, pcWrtEn, pcIn, pcOut);
  Mux4 #(.BIT_WIDTH(DBITS)) pcInMux (next_pc_mux, pcOutPlusOne, pcBranchIn, alu_out, 32'b0, pcIn);
  InstMemory #(IMEM_INIT_FILE, IMEM_ADDR_BIT_WIDTH, IMEM_DATA_BIT_WIDTH) instMem (pcOut[IMEM_PC_BITS_HI - 1: IMEM_PC_BITS_LO], instOut);
  
  IF_DEC_Buffer if_dec_buf(clk, reset, ifDecEn, pcOutPlusOne, pcBufOut1, instOut, instBufOut);

  Controller #(.INST_BIT_WIDTH(DBITS)) control(instBufOut, src_index1, src_index2, dst_index, imm,
    alu_op, alu_mux, dstdata_mux, reg_wrt_en, mem_wrt_en, next_pc_mux, cmd_flag);
  
  SignExtension #(16, DBITS) sign_ext(imm, imm_ext);

  RegFile #(.BIT_WIDTH(DBITS)) regfile(clk, reset, src_index1, src_index2, dst_index_3, end_res_out, src1_data, src2_data, reg_wrt_en);

  DEC_EXE_Buffer dec_exe_buf(clk, reset, decExeEn, pcBufOut1, pcBufOut2, src1_data, src1_buf_out, src2_data, 
    src2_buf_out, imm_ext, imm_buf_out, alu_op, alu_op_buf_out, alu_mux, alu_mux_buf_out, 
    dst_index, dst_index_1, mem_wrt_en, mem_wrt_en_1, reg_file_wrt_en, reg_file_wrt_en_1);
  
  Mux4 #(.BIT_WIDTH(DBITS)) aluSrc2Mux (alu_mux_buf_out, src2_data, imm_buf_out, (imm_ext << 2), 32'b0, alu_b);
  ALU #(.BIT_WIDTH(DBITS)) alu(alu_op_buf_out, src1_data, alu_b, alu_res_in, cmd_flag);

  EXE_MEM_Buffer exe_mem_buf(clk, reset, exeMemEn, src1_buf_out, src1_buf_out1, alu_res_in, alu_res_out, dst_index_1, 
    dst_index_2, mem_wrt_en_1, mem_wrt_en_2, reg_file_wrt_en_1, reg_file_wrt_en_2);
  DataMemory dataMemory (clk, mem_wrt_en_2, alu_res_out, src2_data, SW, KEY, LEDR, hex, mem_out);
  Mux4 #(.BIT_WIDTH(DBITS)) registerDestMux (dstdata_mux, alu_res_out, mem_out, pcOutPlusOne, 32'b0, end_res_in);

  MEM_WB_Buffer mem_wb_buf(clk, reset, memWbEn, reg_file_wrt_en_2, reg_file_wrt_en_3, dst_index_2,
    dst_index_3, end_res_in, end_res_out);

  wire [15 : 0] hex;
  SevenSeg h0 (hex[3:0], HEX0);
  SevenSeg h1 (hex[7:4], HEX1);
  SevenSeg h2 (hex[11:8], HEX2);
  SevenSeg h3 (hex[15:12], HEX3);
  SevenSeg h4 (pcIn[3:0], HEX4);
  SevenSeg h5 (pcIn[7:4], HEX5);

endmodule