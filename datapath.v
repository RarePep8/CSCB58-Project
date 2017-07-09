module datapath(
    input clk,
    input draw_box,
    input box_y,
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
	 
    // input registers
    // Registers x, y, draw with respective input logic
    always@(posedge clk) begin
        plot_reg <= 1'b0;

	    if(draw_box == 1'b1) begin //DRAW_NEXT_FRAME
		    plot_reg <= 1'b1;
		    x_reg[7:0] <= 8'b00000010;
		    y_reg[6:0] <= box_y[6:0];
	    end

                
    end



endmodule
