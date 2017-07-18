module box_register( // A register for holding and manipulating information about the character(the box)
    input game_clk,
	input  tap, // a pulse signal triggered by pos edge of an user input
	output [6:0] y_coordinate 
	);
    reg [3:0]fly_speed = 4'd0;
	reg [6:0] current_y_coordinate = 7'd60;
	assign y_coordinate[6:0] = current_y_coordinate[6:0];
    always @(game_clk)
    begin: box_location_update                
        if(current_y_coordinate <= 7'd120)
			current_y_coordinate <= current_y_coordinate + 1; // During each game tick, the box falls 1 pixel
        if(tap)
			fly_speed <= 4'd5;
		  if(fly_speed > 0)
            fly_speed <= fly_speed - 1'd1; // During each game tick, the upward speed of the box decreases by 1 pixel if it is not already 0
        if(fly_speed < current_y_coordinate)
            current_y_coordinate <= current_y_coordinate - fly_speed;
        else
            current_y_coordinate <= 0;

    end // box_location_update
    

endmodule
