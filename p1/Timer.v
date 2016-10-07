// module Timer(SW, KEY, LEDR, HEX0, HEX1, HEX2, HEX3, CLOCK_50);
// 	input[7:0] SW;
// 	input[3:0] KEY;
// 	input CLOCK_50;
	
// 	output[9:0] LEDR;
// 	output[6:0] HEX0;
// 	output[6:0] HEX1;
// 	output[6:0] HEX2;
// 	output[6:0] HEX3;
	
// 	wire reset;
// 	wire settimer;
// 	wire toggletimer;
	
// 	assign reset = KEY[0];
// 	assign settimer = KEY[1];
// 	assign toggletimer = KEY[2];
	
// 	wire clock1hz;
// 	wire[31:0] test_out;
// 	ClockDivider c1 (CLOCK_50, clock1hz);
// 	assign LEDR[0] = clock1hz;
// endmodule

module Timer(SW, KEY, LEDR, HEX0, HEX1, HEX2, HEX3, CLOCK_50);
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

    wire reset;
    wire settimer;
    wire toggletimer;
    
    assign reset = KEY[0];
    assign settimer = KEY[1];
    assign toggletimer = KEY[2];


    //logic
    always @ (posedge CLOCK_50) begin
        case(STATE)

        RESET: begin
            LEDR[9:0] = 0;
        end

        SECOND: begin
            LEDR[9:0] = 1;
        end

        MINUTE: begin
            LEDR[9:0] = 2;
        end

        STOP: begin
            LEDR[9:0] = 3;
        end

        START: begin
            LEDR[9:0] = 4;
        end

        FLASH: begin
            LEDR[9:0] = 5;
        end
    end

    always @ (negedge reset) begin
        STATE <= RESET
    end

    //transitions
    always @ (posedge CLOCK_50) begin
        case(STATE)
            RESET:
                STATE <= SECOND;
        endcase
    end

    always @ (negedge settimer and posedge CLOCK_50) begin
        if (STATE == SECOND) STATE <= MINUTE
        if (STATE == MINUTE) STATE <= MINUTE
    end
endmodule