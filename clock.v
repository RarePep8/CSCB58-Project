module clock(CLOCK_50, clk_speed, current_number);
	input CLOCK_50;
	input[2:0] clk_speed;
	output [6:0] current_number;
	
	reg[6:0] q = 6'b000000;
	assign current_number = q;
	reg Enable;
	

	wire[28:0] counter_50;
	wire[28:0] counter_1; // 1sec / tick
	wire[28:0] counter_025; //0.25 second/tick
	wire[28:0] counter_05; // 0.5 seconds/tick
    wire[28:0] counter_01; //0.1second/tick
	wire[28:0] wire_025Hz = 28'b1011111010111100001000000000;
	wire[28:0] wire_05Hz = 28'b0101111101011110000100000000;
	wire[28:0] wire_1Hz = 28'b0010111110101111000010000000;
	wire[28:0] wire_01Hz = 28'b0000010011000100101101000000;
	wire[28:0] wire_50MHz = 28'b0000000000000000000000000001;
	
	RateDivider rDivider_50 (
		.clk(CLOCK_50),
		.rate(wire_50MHz),
		.current_rate(counter_50)
		);

	RateDivider rDivider_1 (
		.clk(CLOCK_50),
		.rate(wire_1Hz),
		.current_rate(counter_1)
		);
	
	RateDivider rDivider_05 (
		.clk(CLOCK_50),
		.rate(wire_05Hz),
		.current_rate(counter_05)
		);

	RateDivider rDivider_025 (
		.clk(CLOCK_50),
		.rate(wire_025Hz),
		.current_rate(counter_025)
		);

	RateDivider rDivider_01 (
        .clk(CLOCK_50),
        .rate(wire_01Hz),
        .current_rate(counter_01)
        );

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


	always@(posedge CLOCK_50)
	begin
		if(q == 6'd100)
			q <= 0;
		else if(Enable == 1'b1)
			q <= q + 1'b1;
	end
endmodule



module RateDivider(clk, rate, current_rate);
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
