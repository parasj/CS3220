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
	
	reg[2:0] STATE = RESET;
	parameter RESET = 3'b000, SECOND = 3'b001, MINUTE = 3'b010, STOP = 3'b011, START = 3'b100, FLASH = 3'b101;

	wire reset_btn;
	wire set_timer_btn;
	wire toggle_timer_btn;

	reg [3:0] sec_unit;
	reg [3:0] sec_10;
	reg [3:0] min_unit;
	reg [3:0] min_10;

	reg	timer_finished;
	reg start;

	assign reset_btn = KEY[0];
	assign set_timer_btn = KEY[1];
	assign toggle_timer_btn = KEY[2];
	wire[1:0] x;

	TFlipFlop u0 (KEY[0], KEY[1], x[0]);
	TFlipFlop u1 (KEY[0], KEY[2] & (STATE > 2'b10), x[1]);

	dec2_7seg h0(sec_unit, HEX0);
	dec2_7seg h1(sec_10, HEX1);
	dec2_7seg h2(min_unit, HEX2);
	dec2_7seg h3(min_10, HEX3); 

	PulseGenerator p1 (reset_btn, start, CLOCK_50, pulse1hz);
	ClockDivider c1 (CLOCK_50, clock1hz);

	assign LEDR[9:0] = (STATE == FLASH) ? {10{clock1hz}} : 0;


	always @ (posedge CLOCK_50) begin
		case(STATE)
			RESET: begin
				sec_unit <= 0;
				sec_10 <= 0;
				min_unit <= 0;
				min_10 <= 0;
				timer_finished <= 0;
			end

			SECOND: begin
				timer_finished <= 1'b0;	
				if (SW[3:0] < 4'b1010) begin
					sec_unit <= SW[3:0];
				end else begin
					sec_unit <= 9;
				end
				if (SW[7:4] < 4'b0110) begin
					sec_10 <= SW[7:4];
				end else begin
					sec_10 <= 5;
				end
			end

			MINUTE: begin
				if (SW[3:0] < 4'b1010) begin
					min_unit <= SW[3:0];
				end else begin
					min_unit <= 9;
				end
				if (SW[7:4] < 4'b1010) begin
					min_10 <= SW[7:4];
				end else begin
					min_10 <= 9;
				end
			end

			START: begin
				if (pulse1hz == 1'b1) begin
					if (sec_unit > 0) begin
						sec_unit <= sec_unit - 1;
					end else if (sec_10 > 0 | min_unit > 0 | min_10 > 0) begin
						sec_unit <= 9;
						if (sec_10 > 0) begin
							sec_10 <= sec_10 - 1;
						end else begin
							sec_10 <= 5;
							if (min_unit > 0) begin
								min_unit <= min_unit - 1;
							end else begin
								min_unit <= 9;
								min_10 <= min_10 - 1;
							end
						end
					end
				end
				if (sec_unit == 1'b0 & sec_10 == 1'b0 & min_unit == 1'b0 & min_10 == 1'b0) begin
					timer_finished <= 1'b1;
				end
			end
		endcase
	end

	//transitions
	always @ (posedge CLOCK_50) begin
		if (reset_btn == 1'b0) begin
			STATE <= RESET;
			start <= 0;
		end
		case(STATE)
			RESET: begin
				if (x[0] == 1'b1) begin
					STATE <= SECOND;
				end
			end
		
			SECOND: begin
				if (x[0] == 1'b0) begin
					STATE <= MINUTE;
				end
			end

			MINUTE: begin
				if (x[0] == 1'b1) begin
					STATE <= STOP;
					start <= 1;
				end
			end

			START: begin
				if (x[1] == 1'b0) begin
					STATE <= STOP;
					start <= 0;
				end
				if (timer_finished == 1'b1) begin
					STATE <= FLASH;
				end
			end
			
			STOP: begin
				if (x[1] == 1'b1) begin
					STATE <= START;
					start <= 1;
				end
			end
		endcase
	end
endmodule