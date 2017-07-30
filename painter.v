module painter(
    input CLOCK_50,
    input game_pulse,
    input [6:0]box_y,
    input [8:0]pipe_one_x,
    input [6:0]pipe_one_y,
    input [8:0]pipe_two_x,
    input [6:0]pipe_two_y,
    input [8:0]pipe_three_x,
    input [8:0]pipe_three_y,
    input collided,
    input key_press,
    output plot,
    output [8:0] x,
    output [6:0] y,
    output [2:0] colour,
    output game_tick_after_erase
    );

    // the main module that handles all the incoming x and y coordinates from the pipes and boxes and sends the
    // relevant x and y coordinates 1 by 1 to the vga so the vga can draw them on the screen


    // the register to store the different values to be outputted
	reg [8:0] x_reg; // x coordinate
	reg [6:0] y_reg; // y coordinate
    assign x[8:0] = x_reg[8:0];
    assign y[6:0] = y_reg[6:0];
    reg [6:0] temp_y_reg; // temporary y coordinate
    reg plot_reg; // plot signal
	assign plot = plot_reg;
    reg [2:0]colour_reg; // color
    assign colour[2:0] = colour_reg[2:0];
    reg [6:0] gap_counter; // the gap for the pipe
    reg is_erase; // signal to erase and draw the pipes again
	reg game_tick_after_erase_reg; // game tick signal
	assign game_tick_after_erase = game_tick_after_erase_reg;
    reg [8:0] current_state, next_state;
    
    // assign different states of the finite state machine to a number
    // as well as assign the different non-changing binary bits to a variable
    // such as 3'b000 to the variable BLACK, making it easier to set the color to black
    localparam  DRAW_BOX_1          			= 9'd0,
                DRAW_BOX_2          			= 9'd1,
                DRAW_BOX_3          			= 9'd2,
                DRAW_BOX_4          			= 9'd3,
                DRAW_BOX_5         			= 9'd4,
                DRAW_BOX_6          			= 9'd5,
                DRAW_BOX_7          			= 9'd6,
                DRAW_BOX_8         			= 9'd7,
                DRAW_BOX_9          			= 9'd8,
		DRAW_BOX_PREPARE 			= 9'd9,
		DRAW_BOX				= 9'd10,
		DRAW_PIPE_ONE_LINE_PREPARE 		= 9'd11,
                DRAW_PIPE_ONE_LINE  			= 9'd12,
                DRAW_PIPE_TWO_LINE_PREPARE   		= 9'd13,
		DRAW_PIPE_TWO_LINE			= 9'd14,
		DRAW_PIPE_THREE_LINE_PREPARE 		= 9'd15,
		DRAW_PIPE_THREE_LINE 			= 9'd16,
		WAIT_DRAW				= 9'd17,
		WAIT_ERASE				= 9'd18,
		ERASE_PIPE_LINE     			= 9'd19,
		DONE_ERASE				= 9'd20,
                WAIT                			= 9'd21,
                START_SCREEN       			= 9'd22,
                GREEN               			= 3'b010,
                BLACK               			= 3'b000,
		RED		    			= 3'b100,
		PIPE_GAP_LENGTH				= 7'd30;
	 reg [6:0] seven_bit_counter =7'd30;

    // the finite state machine table, the condition required for different states to go to the next one
    always@(*)
    begin: state_table
            case (current_state)
                START_SCREEN: // start at the start screen state, where the entire screen is black until the key press input sends a signal
                    next_state = key_press ? DRAW_BOX_PREPARE : START_SCREEN;
				DRAW_BOX_PREPARE: // state to prepare the relevant parameters to draw the box
					next_state = DRAW_BOX;
				DRAW_BOX: // the state where it sends the signal out to the vga so the box can be drawn
					next_state = DRAW_PIPE_ONE_LINE_PREPARE;
				DRAW_PIPE_ONE_LINE_PREPARE: // state where it prepares the relevant parameters to draw pipe 1
					next_state = DRAW_PIPE_ONE_LINE;
				DRAW_PIPE_ONE_LINE: // state where the individual coordinates of the pipe is sent to the vga, until seven_bit_counter is 0 it'll loop in this state, once it's 0 it'll draw pipe 2
					next_state = (seven_bit_counter == 0) ? DRAW_PIPE_TWO_LINE_PREPARE: DRAW_PIPE_ONE_LINE;
				DRAW_PIPE_TWO_LINE_PREPARE: // prepares the parameter for pipe 2
					next_state = DRAW_PIPE_TWO_LINE;
				DRAW_PIPE_TWO_LINE: // loops in this state until pipe 2 is drawn, then it advances to draw pipe 3
					next_state = (seven_bit_counter == 0) ? DRAW_PIPE_THREE_LINE_PREPARE : DRAW_PIPE_TWO_LINE;
				DRAW_PIPE_THREE_LINE_PREPARE: // prepare the parameteres for pipe 3
					next_state = DRAW_PIPE_THREE_LINE;
				DRAW_PIPE_THREE_LINE: begin // loops in this state until pipe 3 is drawn, then it goes to prepare for erasing the screen to draw the next frame, or back to drawing if it was erasing
					next_state = DRAW_PIPE_THREE_LINE;
					if(seven_bit_counter == 0 && is_erase)
						next_state = DONE_ERASE;
					else if(seven_bit_counter == 0 && !is_erase)
						next_state = WAIT_ERASE;
					end
                // state to prepare the parameter for erasing, then it will go back to draw_box_prepare and loop through the states again to either erase or draw
				WAIT_ERASE: next_state = game_pulse ? DRAW_BOX_PREPARE : WAIT_ERASE;
                // once it is done erasing or drawing, it will resets the variables required for either drawing or erasing respectively
				DONE_ERASE : next_state = collided ? START_SCREEN : DRAW_BOX_PREPARE;
//                DRAW_PIPE_ONE_GAP: next_state = (gap_counter == 0) ? DRAW_PIPE_ONE_LINE : DRAW_PIPE_ONE_GAP;
//						ERASE_OR_DRAW: next_state = (is_erase) ? WAIT_ERASE : WAIT_DRAW;
//						WAIT_ERASE : next_state = game_pulse ? DRAW_PIPE_ONE_LINE : WAIT_ERASE;
//						WAIT_DRAW: next_state = DRAW_PIPE_ONE_LINE;
            endcase
    end

    
    // Output logic aka all of our datapath control signals
    always @(posedge CLOCK_50)
    begin: enable_signals
        // By default make all our signals 0

        // based on the current state, it will perform one of the following functions
        case (current_state)
    
				DRAW_BOX_PREPARE: begin // prepare the parameters to draw the box
					plot_reg <= 1'b0; // disable plotting
					x_reg[7:0] <= 8'b00000100; // x coordinate of the box
					y_reg[6:0] <= box_y[6:0]; // y coord of the box
					colour_reg <= RED; // the color of the box
					if(is_erase) // if its time to erase, set the color to black
						colour_reg <= BLACK;
					end

				DRAW_BOX: begin // begin sending the info to the vga to draw on the screen
					plot_reg <= 1'b1; // enable plotting
					y_reg[6:0] <= box_y[6:0];
					end		

				DRAW_PIPE_ONE_LINE_PREPARE: begin // prepare the parameters to draw the first pipe
					plot_reg <= 1'b0; // disable plotting
					seven_bit_counter <= 7'd30; // the counter for the opening of the pipe
					x_reg[8:0] <= pipe_one_x[8:0]; // x coord
					temp_y_reg[6:0] <= pipe_one_y[6:0]; // y coord
					colour_reg <= GREEN; // color of the pipe
               				if(is_erase) // set color to black if it is time to erase
                   				colour_reg <= BLACK;
						end

            			DRAW_PIPE_ONE_LINE: begin // send the individual bits to the vga to be drawn on the screen, loop in this state until the pipe is drawn
					plot_reg <= 1'b1; // enable plotting
                			seven_bit_counter <= seven_bit_counter + 1'b1; // increase the counter by 1 so it will draw on the pixel below the current one
					if(seven_bit_counter > 7'b1111111)
						seven_bit_counter <= 7'b0;
                			y_reg[6:0] <= temp_y_reg[6:0] + seven_bit_counter[6:0]; // add the old y coord and the counter to get the new y coord
                			end

				DRAW_PIPE_TWO_LINE_PREPARE: begin // prepare the parameters to draw pipe 2, same as the pipe 1 prepare 
					plot_reg <= 1'b0;
					seven_bit_counter <= 7'd30;
					x_reg[8:0] <= pipe_two_x[8:0];
					temp_y_reg[6:0] <= pipe_two_y[6:0];
					colour_reg <= GREEN;
               				if(is_erase)
                   				colour_reg <= BLACK;
						end

				DRAW_PIPE_TWO_LINE: begin // send the info out to the vga to draw the pipe 2, same as the pipe 1 
					plot_reg <= 1'b1;
                			seven_bit_counter <= seven_bit_counter + 1'b1;
					 if(seven_bit_counter > 7'b1111111) begin
						seven_bit_counter <= 7'b0;
						end
                			y_reg[6:0] <= temp_y_reg[6:0] + seven_bit_counter[6:0];
                			end

				DRAW_PIPE_THREE_LINE_PREPARE: begin // prepare the parameter to draw pipe 3, same as pipe 1 prepare
					plot_reg <= 1'b0;
					seven_bit_counter <= 7'd30;
					x_reg[8:0] <= pipe_three_x[8:0];
					temp_y_reg[6:0] <= pipe_three_y[6:0];
					colour_reg <= GREEN;
               				if(is_erase)
                   				colour_reg <= BLACK;
						end

				DRAW_PIPE_THREE_LINE: begin // send the info to the vga to draw pipe3, same as pipe1
					plot_reg <= 1'b1;
                			seven_bit_counter <= seven_bit_counter + 1'b1;
					 if(seven_bit_counter > 7'b1111111)
						seven_bit_counter <= 7'b0;
                			y_reg[6:0] <= temp_y_reg[6:0] + seven_bit_counter[6:0];
                			end

				START_SCREEN: // the start screen state
						game_tick_after_erase_reg <= ~game_tick_after_erase_reg; // it sets the game tick signal to the opposite signal

				DONE_ERASE: begin // sets the game tick signal to the opposite
						game_tick_after_erase_reg <= ~game_tick_after_erase_reg;
						seven_bit_counter <= 7'd30; // reset the seven bit counter
						is_erase <= 1'b0; // reset the is erase variable
						end

				WAIT_ERASE: begin // set the seven bit counter and the is erase variable for erasing
						seven_bit_counter <= 7'd30;
                      				is_erase <= 1'b1;
						end

           // default:    
        // don't need default since we already made sure all of our outputs were assigned a value at the start of the always block
        endcase
    end // enable_signals





    // assigning the next state to the current state
    always@(posedge CLOCK_50)
    begin: state_FFs
        current_state <= next_state;
    end // state_FFS
/*
    always@(posedge clk) begin
        plot_reg <= 1'b0;
	    if(draw_box == 1'b1) begin //DRAW_NEXT_FRAME
		    plot_reg <= 1'b1;
		    x_reg[7:0] <= 8'b00000010;
		    y_reg[6:0] <= box_y[6:0];
	    end     
    end
*/
endmodule
