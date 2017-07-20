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
    output plot,
    output [8:0] x,
    output [6:0] y,
    output [2:0] colour,
    output game_tick_after_erase
    );
	reg [8:0] x_reg;
	reg [6:0] y_reg;
    assign x[8:0] = x_reg[8:0];
    assign y[6:0] = y_reg[6:0];
    reg [6:0] temp_y_reg;
    reg plot_reg;
	assign plot = plot_reg;
    reg [2:0]colour_reg;
    assign colour[2:0] = colour_reg[2:0];
    reg [6:0] seven_bit_counter =7'd40;
    reg [6:0] gap_counter;
    reg is_erase;
	reg game_tick_after_erase_reg;
	assign game_tick_after_erase = game_tick_after_erase_reg;
    reg [8:0] current_state, next_state;
    localparam  DRAW_BOX_1          = 9'd0,
                DRAW_BOX_2          = 9'd1,
                DRAW_BOX_3          = 9'd2,
                DRAW_BOX_4          = 9'd3,
                DRAW_BOX_5          = 9'd4,
                DRAW_BOX_6          = 9'd5,
                DRAW_BOX_7          = 9'd6,
                DRAW_BOX_8          = 9'd7,
                DRAW_BOX_9          = 9'd8,
					 DRAW_BOX_PREPARE 	= 9'd9,
					 DRAW_BOX				= 9'd10,
					 DRAW_PIPE_ONE_LINE_PREPARE = 9'd11,
                DRAW_PIPE_ONE_LINE  = 9'd12,
                DRAW_PIPE_TWO_LINE_PREPARE   = 9'd13,
					 DRAW_PIPE_TWO_LINE			= 9'd14,
					 DRAW_PIPE_THREE_LINE_PREPARE = 9'd15,
					 DRAW_PIPE_THREE_LINE = 9'd16,
					 WAIT_DRAW				= 9'd17,
					 WAIT_ERASE				= 9'd18,
					 ERASE_PIPE_LINE     = 9'd19,
					 DONE_ERASE				= 9'd20,
                WAIT                = 9'd21,
                GREEN               = 3'b010,
                BLACK               = 3'b000,
					 RED						= 3'b100;
    always@(*)
    begin: state_table
            case (current_state)
//                DRAW_BOX_1: next_state = DRAW_BOX_2;
//                DRAW_BOX_2: next_state = DRAW_BOX_3;
//                DRAW_BOX_3: next_state = DRAW_BOX_4;
//                DRAW_BOX_4: next_state = DRAW_BOX_5;
//                DRAW_BOX_5: next_state = DRAW_BOX_6;
//                DRAW_BOX_6: next_state = DRAW_BOX_7;
//                DRAW_BOX_7: next_state = DRAW_BOX_8;
//                DRAW_BOX_8: next_state = DRAW_BOX_9;
//                DRAW_BOX_9: next_state = DRAW_PIPE_ONE_1;
				DRAW_BOX_PREPARE:
					next_state = DRAW_BOX;
				DRAW_BOX:
					next_state = DRAW_PIPE_ONE_LINE_PREPARE;
				DRAW_PIPE_ONE_LINE_PREPARE:
					next_state = DRAW_PIPE_ONE_LINE;
				DRAW_PIPE_ONE_LINE:
					next_state = (seven_bit_counter == 0) ? DRAW_PIPE_TWO_LINE_PREPARE: DRAW_PIPE_ONE_LINE;
				DRAW_PIPE_TWO_LINE_PREPARE:
					next_state = DRAW_PIPE_TWO_LINE;
				DRAW_PIPE_TWO_LINE:
					next_state = (seven_bit_counter == 0) ? DRAW_PIPE_THREE_LINE_PREPARE : DRAW_PIPE_TWO_LINE;
				DRAW_PIPE_THREE_LINE_PREPARE: 
					next_state = DRAW_PIPE_THREE_LINE;
				DRAW_PIPE_THREE_LINE: begin
					next_state = DRAW_PIPE_THREE_LINE;
					if(seven_bit_counter == 0 && is_erase)
						next_state = DONE_ERASE;
					else if(seven_bit_counter == 0 && !is_erase)
						next_state = WAIT_ERASE;
					end
				WAIT_ERASE: next_state = game_pulse ? DRAW_BOX_PREPARE : WAIT_ERASE;
				DONE_ERASE : next_state = DRAW_BOX_PREPARE;
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


        case (current_state)
//            DRAW_BOX_1: begin
//                plot_reg <= 1'b1;
//                x_reg[7:0] <= 8'b00000100;
//                y_reg[6:0] <= box_y[6:0];
//                end
				DRAW_BOX_PREPARE: begin
					plot_reg <= 1'b0;
					x_reg[7:0] <= 8'b00000100;
					y_reg[6:0] <= box_y[6:0];
					colour_reg <= RED;
					if(is_erase)
						colour_reg <= BLACK;
					end

				DRAW_BOX: begin
					plot_reg <= 1'b1;
					y_reg[6:0] <= box_y[6:0];
					end		
				DRAW_PIPE_ONE_LINE_PREPARE: begin
					plot_reg <= 1'b0;
					seven_bit_counter <= 7'd40;
					x_reg[8:0] <= pipe_one_x[8:0];
					temp_y_reg[6:0] <= pipe_one_y[6:0];
					colour_reg <= GREEN;
               if(is_erase)
                   colour_reg <= BLACK;
					end
            DRAW_PIPE_ONE_LINE: begin
					plot_reg <= 1'b1;
                seven_bit_counter <= seven_bit_counter + 1'b1;
					 if(seven_bit_counter > 7'b1111111) begin
						seven_bit_counter <= 7'b0;
						end
                y_reg[6:0] <= temp_y_reg[6:0] + seven_bit_counter[6:0];
                end
				DRAW_PIPE_TWO_LINE_PREPARE: begin
					plot_reg <= 1'b0;
					seven_bit_counter <= 7'd40;
					x_reg[8:0] <= pipe_two_x[8:0];
					temp_y_reg[6:0] <= pipe_two_y[6:0];
					colour_reg <= GREEN;
               if(is_erase)
                   colour_reg <= BLACK;
					end
				DRAW_PIPE_TWO_LINE: begin
					plot_reg <= 1'b1;
                seven_bit_counter <= seven_bit_counter + 1'b1;
					 if(seven_bit_counter > 7'b1111111) begin
						seven_bit_counter <= 7'b0;
						end
                y_reg[6:0] <= temp_y_reg[6:0] + seven_bit_counter[6:0];
                end
				DRAW_PIPE_THREE_LINE_PREPARE: begin
					plot_reg <= 1'b0;
					seven_bit_counter <= 7'd40;
					x_reg[8:0] <= pipe_three_x[8:0];
					temp_y_reg[6:0] <= pipe_three_y[6:0];
					colour_reg <= GREEN;
               if(is_erase)
                   colour_reg <= BLACK;
					end
				DRAW_PIPE_THREE_LINE: begin
					plot_reg <= 1'b1;
                seven_bit_counter <= seven_bit_counter + 1'b1;
					 if(seven_bit_counter > 7'b1111111) begin
						seven_bit_counter <= 7'b0;
						end
                y_reg[6:0] <= temp_y_reg[6:0] + seven_bit_counter[6:0];
                end
//            DRAW_PIPE_ONE_GAP: begin
//                plot_reg <= 1'b1;
//                colour_reg <= BLACK;
//                x_reg[7:0] <= pipe_one_x[7:0];
//                y_reg[6:0] <= y_reg[6:0] + {3'b0, gap_counter[2:0]};
//                gap_counter <= gap_counter + 1'b1;
//                end
//            DRAW_BOX_2: begin
//                y_reg[6:0] <= box_y[6:0] + 1;
//                end
//            DRAW_BOX_3: begin
//                y_reg[6:0] <= box_y[6:0] - 1;
//                end
//            DRAW_BOX_4: begin
//                x_reg[7:0] <= 8'b00000101;
//                y_reg[6:0] <= box_y[6:0];
//                end
//            DRAW_BOX_5: begin
//                y_reg[6:0] <= box_y[6:0] + 1;
//                end
//            DRAW_BOX_6: begin
//                y_reg[6:0] <= box_y[6:0] - 1;
//                end
//            DRAW_BOX_7: begin
//                x_reg[7:0] <= 8'b00000011;
//                y_reg[6:0] <= box_y[6:0];
//                end
//            DRAW_BOX_8: begin
//                y_reg[6:0] <= box_y[6:0] + 1;
//                end
//            DRAW_BOX_9: begin
//                y_reg[6:0] <= box_y[6:0] - 1;
//                end

				DONE_ERASE: begin
						game_tick_after_erase_reg <= ~game_tick_after_erase_reg;
						seven_bit_counter <= 7'd40;
						is_erase <= 1'b0;
						end
				WAIT_ERASE: begin
						seven_bit_counter <= 7'd40;
                  is_erase <= 1'b1;
						end

           // default:    
        // don't need default since we already made sure all of our outputs were assigned a value at the start of the always block
        endcase
    end // enable_signals






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
