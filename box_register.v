module box_register( // A register for holding and manipulating information about the character(the box)
    input game_tick_clock,
	input  tap, // a pulse signal triggered by pos edge of an user input
	output flying, 
	output [6:0] y_coordinate 
	);
    input CLOCK_50;
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

	always@(*)
	begin: state_table
		case (current_state)
			FALLING: next_state =  (velocity > -4'd10) ? FALLING_TO_FLYING : FALLING; // 
            FALLING_TO_FLYING: next_state = (velocity <= 4'd10 && velocity >= -4'd10) ? FALLING_TO_FLYING : FLYING;// A state where the character transitions from falling to flying  
			FLYING: next_state = (velocity < 4'd10) ? FLYING_TO_FALLING : FLYING;
            FLYING_TO_FALLING: next_state = (velocity <= 4'd3 && velocity >= -4'd3) ? FLYING_TO_FALLING : FALLING;// A state where the character transitions from flying to falling
        endcase
    end

    always @(game_tick_clock)
    begin: box_location_update

        case (current_state)
            FALLING: begin
                current_y_coordinate <= current_y_coordinate + velocity;
                velocity <= velocity - 1;
                end
            FALLING_TO_FLYING: begin
                current_y_coordinate <= current_y_coordinate + velocity;
                velocity <= velocity + 1;
		end
            FLYING: begin
                current_y_coordinate <= current_y_coordinate - velocity;
		velocity <= velocity - 1;
                end
            FLYING_TO_FALLING: begin
                current_y_coordinate <= current_y_coordinate - velocity;
                velocity <= velocity - 1;
                end
        // default:    // don't need default since we already made sure all of our outputs were assigned a value at the start of the always block
        endcase
    end // box_location_update
    
    always@(posedge CLOCK_50)
    begin: state_FFs
        current_state <= next_state;
    end // state_FFS    
endmodule
