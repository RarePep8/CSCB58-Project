module NewClock(CLOCK_50, NEW_CLOCK);
	input CLOCK_50;
   output NEW_CLOCK;
	reg Alternater =0;
	reg Enable;
	assign NEW_CLOCK = Alternater;
	wire[28:0] counter_25;
	wire[28:0] wire_25MHz = 28'b0000101111101011110000100000;
	RateDivider rDivider_25 (
		.clk(CLOCK_50),
		.rate(wire_25MHz),
		.current_rate(counter_25)
		);
	always@(posedge CLOCK_50)
	begin
		Enable <= (counter_25 == 28'b0000000000000000000000000000) ? 1 : 0;
		if(Enable)
			Alternater = ~Alternater;
	end
endmodule
