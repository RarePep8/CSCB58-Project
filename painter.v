module painter(
	 input CLOCK_50,
    input draw_frame,
    input [6:0]box_y,
	 input [7:0]pipe_1_x,
	 input [6:0]pipe_1_y,
    output plot,
    output [7:0] x,
    output [6:0] y,
    output [2:0] colour
    );
	reg [7:0] x_reg;
	reg [6:0] y_reg;
    assign x[7:0] = x_reg[7:0];
    assign y[6:0] = y_reg[6:0];
    reg plot_reg;
	assign plot = plot_reg;
    reg [2:0]colour_reg;
    assign colour[2:0] = colour_reg[2:0];
    reg [6:0] seven_bit_counter;
    reg [6:0] gap_counter;


    reg [5:0] current_state, next_state; 
    localparam  DRAW_BOX_1          = 9'd0,
                DRAW_BOX_2          = 9'd1,
                DRAW_BOX_3          = 9'd2,
                DRAW_BOX_4          = 9'd3,
                DRAW_BOX_5          = 9'd4,
                DRAW_BOX_6          = 9'd5,
                DRAW_BOX_7          = 9'd6,
                DRAW_BOX_8          = 9'd7,
                DRAW_BOX_9          = 9'd8,
                DRAW_PIPE_ONE_1     = 9'd9,
                DRAW_PIPE_ONE_GAP   = 9'd10,
                WAIT                = 9'd36,
                GREEN               = 3'b010,
                BLACK               = 3'b000;

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
                DRAW_PIPE_ONE_LINE: next_state = (seven_bit_counter == 0) ? DRAW_PIPE_ONE_GAP : DRAW_PIPE_ONE_LINE;
                DRAW_PIPE_ONE_GAP: next_state = (gap_counter == 0) ? DRAW_PIPE_ONE_LINE : DRAW_PIPE_ONE_GAP;
            endcase
    end

    // Output logic aka all of our datapath control signals
    always @(*)
    begin: enable_signals
        // By default make all our signals 0


        case (current_state)
//            DRAW_BOX_1: begin
//                plot_reg <= 1'b1;
//                x_reg[7:0] <= 8'b00000100;
//                y_reg[6:0] <= box_y[6:0];
//                end
            DRAW_PIPE_ONE_LINE: begin
                plot_reg <= 1'b1;
                colour <= GREEN;
                x_reg[7:0] <= pipe_1_x[7:0];
                seven_bit_counter <= seven_bit_counter + 1'b1;
                y_reg[6:0] <= seven_bit_counter;
                end
            DRAW_PIPE_ONE_GAP: begin
                plot_reg <= 1'b1;
                colour <= BLACK;
                x_reg[7:0] <= pipe_1_x[7:0];
                y_reg[6:0] <= y_reg[6:0] + {3'b0, gap_counter[2:0]};
                gap_counter <= gap_counter + 1'b1;
                end
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


//            WAIT: begin
//                plot_reg <= 1'b0;
//                end
           // default:    
        // don't need default since we already made sure all of our outputs were assigned a value at the start of the always block
        endcase
    end // enable_signals






    always@(CLOCK_50)
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
