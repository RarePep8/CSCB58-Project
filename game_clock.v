module game_clock(CLOCK_50, NEW_CLOCK, NEW_CLOCK_EARLY,NEW_PULSE);
	input CLOCK_50;
   output NEW_CLOCK;
	output NEW_CLOCK_EARLY;
	output NEW_PULSE;
	reg Alternater_early = 0;
	reg Alternater =0;
	reg Enable;
	reg Enable_early;
	assign NEW_PULSE = Enable;
	assign NEW_CLOCK = Alternater;
	assign NEW_CLOCK_EARLY = Alternater_early;
	wire[28:0] counter_25;
	wire[28:0] wire_TBDMHz = 28'b0000001111101011110000100000;
	RateDivider2 rDivider_25 (
		.clk(CLOCK_50),
		.rate(wire_TBDMHz),
		.current_rate(counter_25)
		);
	always@(posedge CLOCK_50)
	begin
		Enable <= (counter_25 == 28'b0000000000000000000000000000) ? 1 : 0;
		if(Enable)
			Alternater = ~Alternater;
//		Enable_early <= (counter_25 == 28'b0000000000000000000001111111) ? 1 : 0;
//		if(Enable_early)
//			Alternater_early = ~Alternater_early;
	end



endmodule
module RateDivider2(clk, rate, current_rate);
	input clk;
	input[28:0] rate;
	output[28:0] current_rate;
	reg[28:0] out= 0;
	assign current_rate = out;
	
	always @(posedge clk)
	begin
		if(out == 0)
			out <= rate;
		else
			out <= out - 1'b1;
	end

endmodule