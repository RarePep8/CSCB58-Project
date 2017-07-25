module pipe_register(CLOCK_50, key_press, starting_x, starting_y, game_clk, x, y, collided);
    input key_press;
    input CLOCK_50;
    input [8:0] starting_x;
    input [6:0] starting_y;
    input game_clk;
    output [8:0] x;
    output [6:0] y;
	 input collided;

    // height of the opening is 30 pixels, its y coordinate is the top of the opening
    // counter to store 10 y coordinates for new pipes
    // counter to count which pipe to store in
    reg [3:0] curr_counter = 4'b0000;

    // x and y of the pipe
    reg [8:0] curr_x;
    assign x[8:0] = curr_x[8:0];
	 reg [6:0] curr_y;
    assign y[6:0] = curr_y[6:0];
	
    reg initialize = 1'b1;
	 

    // assign a random number to each of the counters based on
    // curr_counter's number
    reg [6:0] random = 7'd10;
	 reg [6:0] counter= 7'd10;
    always @(posedge CLOCK_50)
	     begin
		      counter[6:0] <= counter[6:0] + 7'd1;
				if(counter[6:0] >= 7'd70)
					counter[6:0] <= 7'd10;
			end
    always @(posedge key_press)
        begin
		      random[6:0] <= counter[6:0];
			end 

                
    // move the pipe by 1
    always @(posedge game_clk)
    begin
	     if (initialize || collided) begin // if its in the state of initializing or resetting the game, then reset the coordinate of the pipe and its opening
            initialize <= 1'b0;
				curr_x[8:0] <= starting_x[8:0];
            curr_y[6:0] <= starting_y[6:0];
				end
        else if (curr_x == 9'd0) // else if the pipe reaches the left edge of the screen, move it back to the right edge and give it a new opening
            begin
                curr_y[6:0] <= random[6:0];
                curr_x[8:0] <= 9'd160;
            end
        else // move the pipe by 1 pixel every game clock cycle
            curr_x[8:0] <= curr_x[8:0] - 8'd1;
    end


endmodule
