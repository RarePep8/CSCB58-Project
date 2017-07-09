module vga 
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
        KEY,
        SW,
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
	);

	input			CLOCK_50;				//	50 MHz
	input   [9:0]   SW;
	input   [3:0]   KEY;

	// Declare your inputs and outputs here
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	
	wire resetn;
	assign resetn = KEY[0];
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.
	wire [2:0] colour;
	wire [7:0] x;
	wire [6:0] y;
	wire writeEn;
	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";
			
	// Put your code here. Your code should produce signals x,y,colour and writeEn/plot
	// for the VGA controller, in addition to any other functionality your design may require.
    
    // Instansiate datapath
	// datapath d0(...);
    wire wireldx, wireldy, wirelddraw;
    control mycontrol(.clk(CLOCK_50),
            .resetn(KEY[0]),
            .go(KEY[3]),
            .load_x(wireldx),
            .load_y(wireldy),
            .load_draw(wirelddraw)
            );
    // Instansiate FSM control
    // control c0(...);
    datapath mydatapath(.clk(CLOCK_50),
             .resetn(KEY[0]),
             .data_in(SW[6:0]),
             .colour_in(SW[9:7]),
             .ld_x(wireldx),
             .ld_y(wireldy),
             .ld_draw(wirelddraw),
             .plot(writeEn),
             .x(x),
             .y(y),
             .colour(colour)
             );
endmodule
module control(
    input clk,
    input resetn,
    input go,
    output load_x, load_y, load_draw
    );
    reg ld_x, ld_y, ld_draw;
    assign load_x = ld_x;
    assign load_y = ld_y;
    assign load_draw = ld_draw;
    reg [5:0] current_state, next_state; 
    
    localparam  S_LOAD_X        = 5'd0,
                S_LOAD_X_WAIT   = 5'd1,
                S_LOAD_Y        = 5'd2,
                S_LOAD_Y_WAIT   = 5'd3,
                S_LOAD_DRAW        = 5'd4,
                S_LOAD_DRAW_WAIT   = 5'd5;

    
    // Next state logic aka our state table
    always@(*)
    begin: state_table 
            case (current_state)
                S_LOAD_X: next_state = go ? S_LOAD_X_WAIT : S_LOAD_X; // Loop in current state until value is input
                S_LOAD_X_WAIT: next_state = go ? S_LOAD_X_WAIT : S_LOAD_Y; // Loop in current state until go signal goes low
                S_LOAD_Y: next_state = go ? S_LOAD_Y_WAIT : S_LOAD_Y; // Loop in current state until value is input
                S_LOAD_Y_WAIT: next_state = go ? S_LOAD_Y_WAIT : S_LOAD_X; // Loop in current state until go signal goes low
 // Loop in current state until value is input
 // Loop in current state until go signal goes low
            default:     next_state = S_LOAD_X;
        endcase
    end // state_table
   

    // Output logic aka all of our datapath control signals
    always @(*)
    begin: enable_signals
        // By default make all our signals 0
        ld_x = 1'b0;
        ld_y = 1'b0;
        ld_draw = 1'b0;

        case (current_state)
            S_LOAD_X: begin
                ld_x = 1'b1;
                end
            S_LOAD_Y: begin
                ld_y = 1'b1;
					 ld_draw = 1'b1;
                end
        // default:    // don't need default since we already made sure all of our outputs were assigned a value at the start of the always block
        endcase
    end // enable_signals
   
    // current_state registers
    always@(posedge clk)
    begin: state_FFs
        if(!resetn)
            current_state <= S_LOAD_X;
        else
            current_state <= next_state;
    end // state_FFS
endmodule
module datapath(
    input clk,
    input resetn,
    input [6:0] data_in,
    input [2:0] colour_in,
    input ld_x, ld_y, ld_draw,
    output plot,
    output [7:0] x,
    output [6:0] y,
    output [2:0] colour
    );
    
    // input registers
	 reg [2:0] tempColour;
    reg [6:0] original_x,original_y;
    reg draw;
    reg vga_out = 1'b0;
    reg [3:0] fourbitcounter = 4'b0;
    assign plot = vga_out;
    assign x = original_x + fourbitcounter[1:0];
    assign y = original_y + fourbitcounter[3:2];
    assign colour[2:0] = colour_in[2:0];
    // Registers x, y, draw with respective input logic
    always@(posedge clk) begin
        
        if(!resetn) begin
            original_x <= 7'b0; 
            original_y <= 7'b0; 
            draw <= 1'b0; 
            vga_out <= 1'b0;
        end
        else begin
            
            if(ld_x)
                original_x <= {1'b0, data_in}; // load alu_out if load_alu_out signal is high, otherwise load from data_in
            if(ld_y)
                original_y <= data_in; // load alu_out if load_alu_out signal is high, otherwise load from data_in

            if(vga_out) begin
                fourbitcounter <= fourbitcounter + 1;
                if(fourbitcounter == 4'b0000) begin
                    vga_out <= 1'b0;

                end
        end
            if(ld_draw)
                vga_out <= 1'b1;
                
    end
end


    
endmodule
