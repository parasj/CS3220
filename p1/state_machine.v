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

    assign reset = KEY[0];

    always @ (STATE) begin
        case STATE...
    end

    always @ (reset) begin
        STATE <= RESET
    end

    always @ (posedge CLOCK_50) begin
        if (reset = 1'b1) begin
            STATE <= RESET;
        end
    end
endmodule