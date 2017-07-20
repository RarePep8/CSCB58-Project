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
    always @(posedge game_clk)
    begin: box_location_update                
			// During each game tick, the box falls 1 pixel
			if(user_input_clock)
				current_y_coordinate <= current_y_coordinate - 1;
			else
				current_y_coordinate <= current_y_coordinate + 1;
//        else
//            current_y_coordinate <= 0;

    end // box_location_update
	

endmodule
