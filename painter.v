module painter(
    input clk,
    input draw_box,
    input box_y,
    output plot,
    output [7:0] x,
    output [6:0] y,
    output drawing
    );
	reg [7:0] x_reg;
	reg [6:0] y_reg;
    assign x[7:0] = x_reg[7:0];
    assign y[6:0] = y_reg[6:0];
    reg plot_reg;
	assign plot = plot_reg;
    reg drawing_reg;
    assign drawing = drawing_reg;


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
		        DRAW_BOX_18     = 9'd17
                DRAW_BOX_19      = 9'd0,
                DRAW_BOX_20      = 9'd1,
                DRAW_BOX_21      = 9'd2,
                DRAW_BOX_22      = 9'd3,
                DRAW_BOX_23      = 9'd4,
                DRAW_BOX_24      = 9'd5,
		        DRAW_BOX_25      = 9'd6,
                DRAW_BOX_26      = 9'd7,
		        DRAW_BOX_27      = 9'd8,
                DRAW_BOX_28     = 9'd9,
                DRAW_BOX_29     = 9'd10,
                DRAW_BOX_30     = 9'd11,
                DRAW_BOX_31     = 9'd12,
                DRAW_BOX_32     = 9'd13,
                DRAW_BOX_33     = 9'd14,
		        DRAW_BOX_34     = 9'd15,
                DRAW_BOX_35     = 9'd16,
		        DRAW_BOX_36     = 9'd17


    always@(posedge clk) begin
        plot_reg <= 1'b0;
	    if(draw_box == 1'b1) begin //DRAW_NEXT_FRAME
		    plot_reg <= 1'b1;
		    x_reg[7:0] <= 8'b00000010;
		    y_reg[6:0] <= box_y[6:0];
	    end     
    end
endmodule
