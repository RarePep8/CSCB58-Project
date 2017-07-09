module state_control(
    input clock_pulse, // This clock speed dictates game/frame speed
    input input_signal,
    output draw_box
    );

    reg draw_box_reg;
	 assign draw_box = draw_box_reg;
    reg [5:0] current_state, next_state; 
    localparam  DRAW_START_SCREEN    = 3'd0,
                WAIT_START_SCREEN    = 3'd1,
                ERASE_START_SCREEN   = 3'd2,
                ERASE_CURRENT_FRAME  = 3'd3,
                PROGRESS_NEXT_FRAME  = 3'd4,
                DRAW_CURRENT_FRAME   = 3'd5,
		        STALL_FRAME          = 3'd6,
                DRAW_GAME_OVER       = 3'd7,
		        WAIT_GAME_OVER       = 3'd8;
                

    always@(*)
    begin: state_table
            case (current_state)
                DRAW_START_SCREEN: next_state = WAIT_START_SCREEN;
                WAIT_START_SCREEN: next_state = input_signal ? ERASE_START_SCREEN : WAIT_START_SCREEN;
                ERASE_START_SCREEN: next_state = DRAW_NEXT_FRAME;
                DRAW_CURRENT_FRAME: next_state = STALL_FRAME;
                STALL_FRAME: next_state = clock_pulse ? ERASE_CURRENT_FRAME : STALL_FRAME;
                ERASE_CURRENT_FRAME: next_state = PROGRESS_NEXT_FRAME;
                PROGRESS_NEXT_FRAME: next_state = DRAW_NEXT_FRAME;
                DRAW_GAME_OVER: next_state = WAIT_GAME_OVER;
                WAIT_GAME_OVER: next_state = input_signal ? DRAW_START_SCREEN : WAIT_GAME_OVER;
            endcase
    end

    always @(*)
    begin: enable_signals
        // By default make all our signals 0
        game_tick = 1'b0;
	    //draw_box_reg = 1'b0;
        case (current_state)
            DRAW_START_SCREEN: begin

                end
            WAIT_START_SCREEN: begin

                end
            ERASE_START_SCREEN: begin

                end
            DRAW_NEXT_FRAME: begin
		        draw_box_reg = 1'b1;
                end
            STALL_FRAME: begin 
                end
            ERASE_CURRENT_FRAME: begin
                end
            DRAW_GAME_OVER: begin
                end
            WAIT_GAME_OVER: begin

                end

        // default:    // don't need default since we already made sure all of our outputs were assigned a value at the start of the always block
        endcase
    end // enable_signals


	
   
endmodule
