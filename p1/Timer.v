// module Timer(SW, KEY, LEDR, HEX0, HEX1, HEX2, HEX3, CLOCK_50);
//  input[7:0] SW;
//  input[3:0] KEY;
//  input CLOCK_50;
	
//  output[9:0] LEDR;
//  output[6:0] HEX0;
//  output[6:0] HEX1;
//  output[6:0] HEX2;
//  output[6:0] HEX3;
	
//  wire reset_btn;
//  wire set_timer_btn;
//  wire toggle_timer_btn;
	
//  assign reset_btn = KEY[0];
//  assign set_timer_btn = KEY[1];
//  assign toggle_timer_btn = KEY[2];
	
//  wire clock1hz;
//  wire[31:0] test_out;
//  ClockDivider c1 (CLOCK_50, clock1hz);
//  assign LEDR[0] = clock1hz;
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
	parameter SECOND = 3'b000, MINUTE = 3'b001, STOP = 3'b010, START = 3'b011, FLASH = 3'b100;

	wire reset_btn;
	wire set_timer_btn;
	wire toggle_timer_btn;

	wire [3:0] sec_unit;
	wire [3:0] sec_10;
	wire [3:0] min_unit;
	wire [3:0] min_10;
	
	assign reset_btn = KEY[0];
	assign set_timer_btn = KEY[1];
	assign toggle_timer_btn = KEY[2];
	assign LEDR[2:0] = STATE;
	wire[1:0] x;

	TFlipFlop u0 (KEY[0], KEY[1], x[0]);
	TFlipFlop u1 (KEY[0], KEY[2] & (STATE > 2'b01), x[1]);

	ClockDivider c1 (CLOCK_50, clock1hz);

	assign LEDR[9:3] = (STATE == FLASH) ? {8{clock1hz}} : 0;

	//transitions
	always @ (posedge CLOCK_50) begin
		if (reset_btn == 1'b0) begin
			STATE <= SECOND;
		end
		case(STATE)

			SECOND: begin
				if (x[0] == 1'b1) begin
					STATE <= MINUTE;
				end
			end

			MINUTE: begin
				if (x[0] == 1'b0) begin
					STATE <= START;
				end
			end

			START: begin
				if (x[1] == 1'b0) begin
					STATE <= STOP;
				end
				if (SW[0] == 1'b1) begin
					STATE <= FLASH;
				end
			end
			
			STOP: begin
				if (x[1] == 1'b1) begin
					STATE <= START;
				end
			end
		endcase
	end
endmodule