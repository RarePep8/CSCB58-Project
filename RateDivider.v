module RateDivider(clk, rate, current_rate);
	input clk;
	input[28:0] rate;
	output[28:0] current_rate;
	reg[28:0] out= 0;
	assign current_rate = out;
	
    // every time the clock ticks, out decreases by 1, and if its 0 then reset it to the inputted rate
    // output the out variable
	always @(posedge clk)
	begin
		if(out == 0)
			out <= rate;
		else
			out <= out - 1'b1;
	end

endmodule
