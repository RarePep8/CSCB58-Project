module box_register( // A register for holding and manipulating information about the character(the box). Allows a key to control the height of the character. When inputted, the character would go up otherwise, the character will continuously go down until the bottom then it warps back up.
    input game_clk, // a clock that regulates the cycles
	input  user_input, // the user's input that controls the height of the box
	output [6:0] y_coordinate, // the current y coordinate of the box
	input collided // input that shows if the box has touched (collided) with a pipe
	);
    // a register to store and modify the y coordinate of the box
	reg [6:0] current_y_coordinate = 7'd60;
    // assign the y coordinate output to the y coordinate register
	assign y_coordinate[6:0] = current_y_coordinate[6:0];

    // during the 0 to 1 cycle of the game_clk, modify the y coordinate of the box
    // based on the input of the user and if the box has collided with the pipes
    always @(posedge game_clk)
    begin: box_location_update                
			if(collided)
                // reset the y coordinate of the box if it collided with a pipe
				current_y_coordinate <= 7'd60;
			else if(user_input)
                // if the user pressed the key, make the box go up
				current_y_coordinate <= current_y_coordinate - 1;
			else
                // the character should continuously go down
				current_y_coordinate <= current_y_coordinate + 1;
//        else
//            current_y_coordinate <= 0;

    end // box_location_update

// todo: add an initialize to set the box's height at the start of the game

endmodule
