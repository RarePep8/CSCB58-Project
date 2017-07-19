module box_register( // A register for holding and manipulating information about the character(the box)
    input game_clk,
	input  user_input_clock, // a clock that alternates its signal every time the user inputs
	output [6:0] y_coordinate 
	);
	reg curr_signal = 1'b0;
    reg tapped = 1'b0;
    reg [3:0]fly_speed = 4'd0;
	reg [6:0] current_y_coordinate = 7'd60;
	assign y_coordinate[6:0] = current_y_coordinate[6:0];
    always @(game_clk)
    begin: box_location_update                
        if(current_y_coordinate <= 7'd120)
			current_y_coordinate <= current_y_coordinate + 1; // During each game tick, the box falls 1 pixel
        if(tapped)
			fly_speed <= 4'd5;
		 if(fly_speed > 0)
            fly_speed <= fly_speed - 1'd1; // During each game tick, the upward speed of the box decreases by 1 pixel if it is not already 0
        if(fly_speed < current_y_coordinate)
            current_y_coordinate <= current_y_coordinate - fly_speed;
        else
            current_y_coordinate <= 0;

    end // box_location_update

    always @(user_input_clock, game_clk)
	 begin: fly_update
        if(curr_signal != user_input_clock) begin
            tapped <= 1'b1;
			curr_signal <= user_input_clock;
			end
        else
            tapped <= 1'b0;    
    end //fly_update
endmodule
