module clock(CLOCK_50, clk_speed, current_number, collided, key_press);
    
    // a clock that allows the user to choose the how many clocks cycle to send a signal
	input CLOCK_50; // the base clock, ticks once every 1/50 million seconds
	input[2:0] clk_speed; // the input to choose the clock speed
    input collided; // if the pipe and box has collided then stop the clock
    input key_press; // the key to reset the clock back to 0 
	output [3:0] current_number; // it outputs how many ticks it has counted
	
    // use a register to store the number of ticks and output it
	reg[3:0] q = 4'b0;
	assign current_number = q;
	reg Enable;
	
    // the wires for the different clokc speeds
	wire[28:0] counter_50; // the base clock speed
	wire[28:0] counter_1; // 1sec / tick
	wire[28:0] counter_025; //0.25 second/tick
	wire[28:0] counter_05; // 0.5 seconds/tick
    wire[28:0] counter_01; //0.1second/tick
	wire[28:0] wire_025Hz = 28'b1011111010111100001000000000;
	wire[28:0] wire_05Hz = 28'b0101111101011110000100000000;
	wire[28:0] wire_1Hz = 28'b0010111110101111000010000000;
	wire[28:0] wire_01Hz = 28'b0000010011000100101101000000;
	wire[28:0] wire_50MHz = 28'b0000000000000000000000000001;
	
    // create different rateDivider modules to control the speed

    // rate divider for the base clock speed
	RateDivider rDivider_50 (
		.clk(CLOCK_50),
		.rate(wire_50MHz),
		.current_rate(counter_50)
		);

    // rate divider for the 1 second / tick 
	RateDivider rDivider_1 (
		.clk(CLOCK_50),
		.rate(wire_1Hz),
		.current_rate(counter_1)
		);
	
    // the 0.5 second per tick
	RateDivider rDivider_05 (
		.clk(CLOCK_50),
		.rate(wire_05Hz),
		.current_rate(counter_05)
		);

    // 0.25 second per tick rate divider
	RateDivider rDivider_025 (
		.clk(CLOCK_50),
		.rate(wire_025Hz),
		.current_rate(counter_025)
		);

    // the 0.1 second / tick rate divider
	RateDivider rDivider_01 (
        .clk(CLOCK_50),
        .rate(wire_01Hz),
        .current_rate(counter_01)
        );

    // check if the different clock speeds reaches 0, so that it counts as one tick

	always@(posedge CLOCK_50)
	begin
		if (clk_speed == 3'd0)
			Enable <= (counter_50 == 28'b0000000000000000000000000000) ? 1 : 0;
		else if (clk_speed == 3'd1)
			Enable <= (counter_1 == 28'b0000000000000000000000000000) ? 1 : 0;
		else if (clk_speed == 3'd2)
			Enable <= (counter_05 == 28'b0000000000000000000000000000) ? 1 : 0;
		else if (clk_speed == 3'd3)
			Enable <= (counter_025 == 28'b0000000000000000000000000000) ? 1 : 0;
		else if (clk_speed == 3'd4)
			Enable <= (counter_01 == 28'b0000000000000000000000000000) ? 1 : 0;
	end

    // once the clock ticks once, the output goes up by one
    // if box and pipe has collided then stop the clock
	always@(posedge CLOCK_50)
	begin
		if(q == 4'd10 || key_press == 1'b1)
			q <= 0;
		else if(Enable == 1'b1 && ~collided)
			q <= q + 1'b1;
	end
endmodule

