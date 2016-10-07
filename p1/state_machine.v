module state_machine(SW, KEY, LEDR, HEX0, HEX1, HEX2, HEX3, CLOCK_50);
    input[7:0] SW;
    input[3:0] KEY;
    input CLOCK_50;
    
    output[9:0] LEDR;
    output[6:0] HEX0;
    output[6:0] HEX1;
    output[6:0] HEX2;
    output[6:0] HEX3;
    
    reg[2:0] STATE;
    parameter RESET = 3'b000, SECOND = 3'b001, MINUTE = 3'b010, STOP = 3'b011, START = 3'b100, FLASH = 3'b101;

    assign reset = KEY[0];

    //logic
    always @ (posedge CLOCK_50) begin
        case(STATE)
    end

    always @ (negedge reset) begin
        STATE <= RESET
    end

    //transitions
    always @ (posedge CLOCK_50) begin
        case(STATE)
    end
endmodule