module pipe_register(CLOCK_50, key_press, game_clk, x, y);
    input key_press;
    input CLOCK_50;
    input game_clk;
    output [7:0] x;
    output [6:0] y;

    // height of the opening is 20 pixels, its y coordinate is the top of the opening
    // counter to store 10 y coordinates for new pipes
    reg [6:0] counter0;
    reg [6:0] counter1;
    reg [6:0] counter2;
    reg [6:0] counter3;
    reg [6:0] counter4;
    reg [6:0] counter5;
    reg [6:0] counter6;
    reg [6:0] counter7;
    reg [6:0] counter8;
    reg [6:0] counter9;
    reg [6:0] output_counter;
    // counter to count which pipe to store in
    reg [3:0] curr_counter = 4'b0000;

    // x and y of the pipe
    reg [7:0] curr_x = 8'd160;
    assign x[7:0] = curr_x[7:0];
    reg [6:0] curr_y = 7'd50;
    assign y[6:0] = curr_y[6:0];

    // assign a random number to each of the counters based on
    // curr_counter's number
    wire [6:0] random;
	 
    clock get_y(
		.CLOCK_50(CLOCK_50), 
		.clk_speed(3'd4), 
		.current_number(random)
		);
    always @(posedge key_press)
        begin
            if (curr_counter == 0) 
                begin
                    counter0[6:0] <= random[6:0];
                    curr_counter <= curr_counter + 1;
                    output_counter[6:0] <= counter0[6:0];
                end 
            else if (curr_counter == 1)
                begin
                    counter1[6:0] <= random[6:0];
                    curr_counter <= curr_counter + 1;
                    output_counter[6:0] <= counter2[6:0];
                end 
            else if (curr_counter == 3)
                begin
                    counter3[6:0] <= random[6:0];
                    curr_counter <= curr_counter + 1;
                    output_counter[6:0] <= counter3[6:0];
                end 
            else if (curr_counter == 4)
                begin
                    counter4[6:0] <= random[6:0];
                    curr_counter <= curr_counter + 1;
                    output_counter[6:0] <= counter4[6:0];
                end 
            else if (curr_counter == 5)
                begin
                    counter5[6:0] <= random[6:0];
                    curr_counter <= curr_counter + 1;
                    output_counter[6:0] <= counter5[6:0];
                end 
            else if (curr_counter == 6)
                begin
                    counter6[6:0] <= random[6:0];
                    curr_counter <= curr_counter + 1;
                    output_counter[6:0] <= counter6[6:0];
                end 
            else if (curr_counter == 7)
                begin
                    counter7[6:0] <= random[6:0];
                    curr_counter <= curr_counter + 1;
              		  output_counter[6:0] <= counter7[6:0];
                end 
            else if (curr_counter == 8)
                begin
                    counter8[6:0] <= random[6:0];
                    curr_counter <= curr_counter + 1;
                    output_counter[6:0] <= counter8[6:0];
                end 
            else if (curr_counter == 9)
                begin
                    counter9[6:0] <= random[6:0];
                    curr_counter <= 0;
                    output_counter[6:0] <= counter9[6:0];
                end 
        end
                
    // move the pipe by 1
    always @(game_clk)
        begin
            if (curr_x == 0) 
                begin
                    curr_y[6:0] <= output_counter[6:0];
                    curr_x <= 8'd160;
                end
            else
                curr_x <= curr_x - 1'b1;
        end
   

endmodule
