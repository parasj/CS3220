`timescale 1ns / 1ps

module TestAdderSubtractor;
	reg cin;
	reg[3:0] a;
	reg[3:0] b;
	
	wire[4:0] led;
	
	integer i;
	wire[4:0] tempsum;
	assign tempsum = a + b;
	wire[4:0] tempsubtract;
	assign tempsubtract = a - b + 5'b10000;
	
	wire[8:0] switch;
	assign switch = {b, a, cin};
	
	AdderSubtractor as (switch, led);
	
	initial begin
		a = 4'b0;
		b = 4'b0;

		cin = 1'b0;
		// test addition
		for (i = 0; i < 256; i = i +1) begin
			#10 {a, b} = i;
			if(!(led == tempsum)) $display("FAIL %b + %b = %b, expect %b", a, b, led, tempsum);
			else $display("PASS %b + %b = %b", a, b, led);
		end
		
		cin = 1'b1;
		// test subtraction
		for (i = 0; i < 256; i = i +1) begin
			#10 {a, b} = i;
			if(!(led == tempsubtract)) $display("FAIL %b - %b = %b, expect %b", a, b, led, tempsubtract);
			else $display("PASS %b - %b = %b", a, b, led);
		end
	end
endmodule