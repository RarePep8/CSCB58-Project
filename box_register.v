module box_register( // A register for holding and manipulating information about the character(the box)
    input game_tick_clock,
	input  tap, // a pulse signal triggered by pos edge of an user input
	output flying, 
	output [6:0] y_coordinate 
	);

	reg [5:0] current_state, next_state; 
	reg[3:0] velocity = 4'd0;
	reg [6:0] current_y_coordinate = 7'd60;
	assign y_coordinate[6:0] = current_y_coordinate[6:0];
	reg is_flying;
	assign flying = is_flying;
	
	localparam FALLING = 3'd0,
		       FALLING_TO_FLYING = 3'd1,
               FLYING = 3'd2,
               FLYING_TO_FALLING = 3'd3;


    always @(game_tick_clock)
    begin: box_location_update

                
        if(current_y_coordinate <= 7'd120) begin
			current_y_coordinate <= current_y_coordinate + 1;
        end

    end // box_location_update
    
    always@(posedge game_tick_clock)
    begin: state_FFs
        current_state <= next_state;
    end // state_FFS    
endmodule
