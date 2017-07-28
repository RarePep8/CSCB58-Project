module game_clock(CLOCK_50, NEW_CLOCK, NEW_PULSE, key_press);
    // uses clock_50 as a base, it sends out different clock signals which the modules can use for their respective purposes
    
	input CLOCK_50;
    output NEW_CLOCK;
	output NEW_PULSE;
	input key_press;
    // use the registers to store the values for the clocks and assign the outputs to them
	reg Alternater_early = 0;
	reg Alternater =0;
	reg Enable;
	reg Enable_early;
    
	assign NEW_PULSE = Enable;
	assign NEW_CLOCK = Alternater;

	wire[28:0] counter_25;
	reg[28:0] wire_TBDMHz_reg = 28'b0000000010001011110000100000;
	wire[28:0] wire_TBDMHz;
	assign wire_TBDMHz[28:0] =  wire_TBDMHz_reg[28:0];

    // a rate divider to help with the counting of the cycles
	RateDivider rDivider_25 (
		.clk(CLOCK_50),
		.rate(wire_TBDMHz),
		.current_rate(counter_25)
		);

    // whenever the counter_25 reaches 0, enable sends a signal
    // whenever counter_25 reaches 255, enable_early sends a signal
	always@(posedge CLOCK_50)
	begin
		if(key_press)
			wire_TBDMHz_reg <= 28'b0000000010001011110000100000;
		Enable <= (counter_25 == 28'b0000000000000000000000000000) ? 1 : 0;
		if(Enable) begin
			if(wire_TBDMHz >= 28'b00000000000101111000010000)
                // As long as the current rate is greater than a certain threshold, decrease it each game tick to gradually speed up
				wire_TBDMHz_reg <= wire_TBDMHz_reg - 28'b0000000000000000000010000000;
			Alternater <= ~Alternater;
            end
	end



endmodule
