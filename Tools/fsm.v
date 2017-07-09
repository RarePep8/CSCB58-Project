module state_control(
    input game_tick_pulse, // This clock speed dictates game/frame speed
    input input_signal
    );

    
    localparam  DRAW_START_SCREEN    = 3'd0,
                WAIT_START_SCREEN    = 3'd1,
                ERASE_CURRENT_FAME   = 3'd2,
                DRAW_NEXT_FRAME      = 3'd3,
                WAIT_FOR_RESTART     = 3'd4;
               

    always@(*)
    begin: state_table
            case (current_state)
                DRAW_START_SCREEN: next_state = WAIT_START_SCREEN;
                WAIT_START_SCREEN: next_state = input_signal ? ERASE_START_SCREEN : WAIT_START_SCREEN;
                ERASE_START_SCREEN: next_state = DRAW_NEXT_FRAME;
                DRAW_NEXT_FRAME: next_state = STALL_FRAME
                STALL_FRAME: next_state = game_tick_pulse ? ERASE_CURRENT_FRAME
                ERASE_CURRENT_FRAME: next_state = DRAW_NEXT_FRAME 
                DRAW_GAME_OVER: next_state = WAIT_GAME_OVER;
                WAIT_GAME_OVER: next_state = input_signal ? 
    end
endmodule

module pipe_coordinate_register(


module pos_edge_pulser(
    input in,
    output pulse
    );
    reg current_signal;
    reg input_pulse_wire;
    assign input_pulse = input_pulse_wire;
    always@(*)
    begin
        if(current_signal == 1'b0 && in == 1'b0)
            input_pulse_wire <= 1'b1;
        else
            input_pulse_wire <= 1'b0;
        current_signal <= in;
    end
endmodule
        
        
