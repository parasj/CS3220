module Project2(SW,KEY,LEDR,HEX0,HEX1,HEX2,HEX3,CLOCK_50);
  input  [9:0] SW;
  input  [3:0] KEY;
  input  CLOCK_50;
  output [9:0] LEDR;
  output [6:0] HEX0,HEX1,HEX2,HEX3;
 
  parameter DBITS         				 = 32;
  parameter INST_SIZE      			 = 32'd4;
  parameter INST_BIT_WIDTH				 = 32;
  parameter START_PC       			 = 32'h40;
  parameter REG_INDEX_BIT_WIDTH 		 = 4;
  parameter ADDR_KEY  					 = 32'hF0000010;
  parameter ADDR_SW   					 = 32'hF0000014;
  parameter ADDR_HEX  					 = 32'hF0000000;
  parameter ADDR_LEDR 					 = 32'hF0000004;
  
  parameter IMEM_INIT_FILE				 = "Sorter2.mif";
  parameter IMEM_ADDR_BIT_WIDTH 		 = 11;
  parameter IMEM_DATA_BIT_WIDTH 		 = INST_BIT_WIDTH;
  parameter IMEM_PC_BITS_HI     		 = IMEM_ADDR_BIT_WIDTH + 2;
  parameter IMEM_PC_BITS_LO     		 = 2;
  
  parameter DMEMADDRBITS 				 = 13;
  parameter DMEMWORDBITS				 = 2;
  parameter DMEMWORDS					 = 2048;
  
  parameter OP1_ALUR 					 = 4'b0000;
  parameter OP1_ALUI 					 = 4'b1000;
  parameter OP1_CMPR 					 = 4'b0010;
  parameter OP1_CMPI 					 = 4'b1010;
  parameter OP1_BCOND					 = 4'b0110;
  parameter OP1_SW   					 = 4'b0101;
  parameter OP1_LW   					 = 4'b1001;
  parameter OP1_JAL  					 = 4'b1011;
  
  // Add and modify parameters for various opcode and function code values
  
  ClockDivider	clk_divider (.inclk0 (CLOCK_50),.c0 (clk),.locked (lock));
  wire reset = ~lock;
  
  // Create PC and its logic
  wire pcWrtEn = 1'b1;
  wire[DBITS - 1: 0] pcIn; // Implement the logic that generates pcIn; you may change pcIn to reg if necessary
  wire[DBITS - 1: 0] pcOut;
  // This PC instantiation is your starting point
  Register #(.BIT_WIDTH(DBITS), .RESET_VALUE(START_PC)) pc (clk, reset, pcWrtEn, pcIn, pcOut);

  // Creat instruction memeory
  wire[IMEM_DATA_BIT_WIDTH - 1: 0] instWord;
  InstMemory #(IMEM_INIT_FILE, IMEM_ADDR_BIT_WIDTH, IMEM_DATA_BIT_WIDTH) instMem (pcOut[IMEM_PC_BITS_HI - 1: IMEM_PC_BITS_LO], instWord);
  
  // Put the code for getting opcode1, rd, rs, rt, imm, etc. here
  wire[REG_INDEX_BIT_WIDTH - 1: 0] src_index1, src_index2, dst_index;
  wire[15:0] imm;
  wire[DBITS-1: 0] imm_ext;
  wire[1:0] alu_mux, dstdata_mux, nextpc_mux;
  wire reg_wrt_en, mem_wrt_en;
  Controller control(instWord, src_index1, src_index2, dst_index, imm, alu_op, alu_mux, dstdata_mux, reg_wrt_en, mem_wrt_en, next_pc_mux, cmd_flag);
  SignExtension #(16, DBITS) sign_ext(imm, imm_ext);

  // Create the registers
  wire[DBITS - 1: 0] dst_data;
  wire[DBITS - 1: 0] src1_data, src2_data;
  wire[DBITS - 1: 0] alu_b;
  RegFile regfile(clk, reset, src_index1, src_index2, dst_index, dst_data, src1_data, src2_data, reg_wrt_en);
  
  // Create ALU unit
  wire[DBITS - 1: 0] alu_out;
  ALU alu(alu_op, src1_data, alu_b, alu_out, cmd_flag);
  

  // Put the code for data memory and I/O here
  wire[DBITS - 1: 0] mem_out;
  Mux4 m2(dstdata_mux, alu_out, mem_out, 0, 0, dst_data); // remember pc
  Mux4 m0(alu_mux, src2_data, imm_ext, 0, 0, alu_b); // remember to do shift
  // KEYS, SWITCHES, HEXS, and LEDS are memeory mapped IO
    
endmodule