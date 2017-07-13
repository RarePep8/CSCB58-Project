module painter(
    input clk,
    input draw,
    input [6:0]box_y,
    output plot,
    output [7:0] x,
    output [6:0] y
    );
	reg [7:0] x_reg;
	reg [6:0] y_reg;
    assign x[7:0] = x_reg[7:0];
    assign y[6:0] = y_reg[6:0];
    reg plot_reg;
	assign plot = plot_reg;



    reg [5:0] current_state, next_state; 
    localparam  DRAW_BOX_1      = 9'd0,
                DRAW_BOX_2      = 9'd1,
                DRAW_BOX_3      = 9'd2,
                DRAW_BOX_4      = 9'd3,
                DRAW_BOX_5      = 9'd4,
                DRAW_BOX_6      = 9'd5,
                DRAW_BOX_7      = 9'd6,
                DRAW_BOX_8      = 9'd7,
                DRAW_BOX_9      = 9'd8,
                DRAW_BOX_10     = 9'd9,
                DRAW_BOX_11     = 9'd10,
                DRAW_BOX_12     = 9'd11,
                DRAW_BOX_13     = 9'd12,
                DRAW_BOX_14     = 9'd13,
                DRAW_BOX_15     = 9'd14,
                DRAW_BOX_16     = 9'd15,
                DRAW_BOX_17     = 9'd16,
                DRAW_BOX_18     = 9'd17,
                DRAW_BOX_19     = 9'd18,
                DRAW_BOX_20     = 9'd19,
                DRAW_BOX_21     = 9'd20,
                DRAW_BOX_22     = 9'd21,
                DRAW_BOX_23     = 9'd22,
                DRAW_BOX_24     = 9'd23,
                DRAW_BOX_25     = 9'd24,
                DRAW_BOX_26     = 9'd25,
                DRAW_BOX_27     = 9'd26,
                DRAW_BOX_28     = 9'd27,
                DRAW_BOX_29     = 9'd28,
                DRAW_BOX_30     = 9'd29,
                DRAW_BOX_31     = 9'd30,
                DRAW_BOX_32     = 9'd31,
                DRAW_BOX_33     = 9'd32,
		        DRAW_BOX_34     = 9'd33,
                DRAW_BOX_35     = 9'd34,
		        DRAW_BOX_36     = 9'd35,
                WAIT            = 9'd36;

    always@(*)
    begin: state_table
            case (current_state)
                DRAW_BOX_1: next_state = DRAW_BOX_2;
                DRAW_BOX_2: next_state = DRAW_BOX_3;
                DRAW_BOX_3: next_state = DRAW_BOX_4;
                DRAW_BOX_4: next_state = DRAW_BOX_5;
                DRAW_BOX_5: next_state = DRAW_BOX_6;
                DRAW_BOX_6: next_state = DRAW_BOX_7;
                DRAW_BOX_7: next_state = DRAW_BOX_8;
                DRAW_BOX_8: next_state = DRAW_BOX_9;
                DRAW_BOX_9: next_state = WAIT;
            endcase
    end

    // Output logic aka all of our datapath control signals
    always @(*)
    begin: enable_signals
        // By default make all our signals 0


        case (current_state)
            DRAW_BOX_1: begin
                plot_reg = 1'b1;
                x_reg[7:0] <= 8'b00000100;
                y_reg[6:0] <= box_y[6:0];
                end
            DRAW_BOX_2: begin
                y_reg[6:0] <= box_y[6:0] + 1;
                end
            DRAW_BOX_3: begin
                y_reg[6:0] <= box_y[6:0] - 1;
                end
            DRAW_BOX_4: begin
                x_reg[7:0] <= 8'b00000011;
                y_reg[6:0] <= box_y[6:0];
                end
            DRAW_BOX_5: begin
                y_reg[6:0] <= box_y[6:0] + 1;
                end
            DRAW_BOX_6: begin
                y_reg[6:0] <= box_y[6:0] - 1;
                end
            DRAW_BOX_7: begin
                x_reg[7:0] <= 8'b00000101;
                y_reg[6:0] <= box_y[6:0];
                end
            DRAW_BOX_8: begin
                y_reg[6:0] <= box_y[6:0] + 1;
                end
            DRAW_BOX_9: begin
                y_reg[6:0] <= box_y[6:0] - 1;
                end


            WAIT: begin
                plot_reg <= 1'b0;
                end
           // default:    
        // don't need default since we already made sure all of our outputs were assigned a value at the start of the always block
        endcase
    end // enable_signals






    always@(posedge clk)
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
