// Testbench
// https://www.edaplayground.com/x/5cQk

`define ALU_UNUSED 5'b0
`define ALU_ADD 5'b1
`define ALU_SUB 5'b10
`define ALU_AND 5'b11
`define ALU_OR 5'b100
`define ALU_XOR 5'b101
`define ALU_NAND 5'b110
`define ALU_NOR 5'b111
`define ALU_XNOR 5'b1000
`define ALU_MVHI 5'b1001
`define ALU_F 5'b1010
`define ALU_EQ 5'b1011
`define ALU_LT 5'b1100
`define ALU_LTE 5'b1101
`define ALU_T 5'b1110
`define ALU_NE 5'b1111
`define ALU_GTE 5'b10000
`define ALU_GT 5'b10001
`define ALU_BEQZ 5'b10010
`define ALU_BLTZ 5'b10011
`define ALU_BLTEZ 5'b10100
`define ALU_BNEZ 5'b10101
`define ALU_BGTEZ 5'b10110
`define ALU_BGTZ 5'b10111

module ALUTest;

  reg[4:0] aluop;
  reg[31:0] a;
  reg[31:0] b;
  wire[31:0] c;
  wire cmdflag;
  
  // Instantiate design under test
  ALU #(32) a1(.aluop(aluop), .a(a), .b(b), .c(c), .cmdflag(cmdflag));
          
  initial begin
    a = 32'h4b;
    b = 32'h22;

    aluop = `ALU_UNUSED;
    display;

    aluop = `ALU_ADD;
    display;

    aluop = `ALU_SUB;
    display;

    aluop = `ALU_AND;
    display;

    aluop = `ALU_OR;
    display;

    aluop = `ALU_XOR;
    display;

    aluop = `ALU_NAND;
    display;

    aluop = `ALU_NOR;
    display;

    aluop = `ALU_XNOR;
    display;

    aluop = `ALU_MVHI;
    display;

    aluop = `ALU_F;
    display;

    aluop = `ALU_EQ;
    display;

    aluop = `ALU_LT;
    display;

    aluop = `ALU_LTE;
    display;

    aluop = `ALU_T;
    display;

    aluop = `ALU_NE;
    display;

    aluop = `ALU_GTE;
    display;

    aluop = `ALU_GT;
    display;

    aluop = `ALU_BEQZ;
    display;

    aluop = `ALU_BLTZ;
    display;

    aluop = `ALU_BLTEZ;
    display;

    aluop = `ALU_BNEZ;
    display;

    aluop = `ALU_BGTEZ;
    display;

    aluop = `ALU_BGTZ;
    display;

  end
  
  task display;
    #10 $display("%h (%00000b) %h = %h cmdflag: %0b", a, aluop, b, c, cmdflag);
  endtask

endmodule

