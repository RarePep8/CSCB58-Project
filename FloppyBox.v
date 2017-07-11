module FloppyBox(
	CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
        KEY,
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
	//assign resetn = KEY[0];
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.
	wire [2:0] colour = 3'b001;
	wire [7:0] x;
	wire [6:0] y;
	wire writeEn;
	wire screen_state;
	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller
	vga_adapter VGA(
			.resetn(1'b1),
			.clock(CLOCK_50),
			.colour(colour),//colour
			.x(x),
			.y(y),
			.plot(1'b1),//writeEn
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
    wire draw_box_wire;
    wire [6:0]box_y_wire;
    wire flying_wire;
    box_register box_reg(
        .game_tick_clock(CLOCK_50),// Temp
        .tap(1'b0), // Temp
        .flying(flying_wire),
        .y_coordinate(box_y_wire)
        );

	state_control state_ctrl(
		.game_tick_pulse(CLOCK_50),// Temp
		.input_signal(KEY[0]), // Temp
        .draw_box(draw_box_wire)
		);

	datapath data(
        .clk(CLOCK_50),
        .draw_box(draw_box_wire),
        .box_y(box_y_wire),
        .plot(writeEn),
        .x(x),
        .y(y)
	);
endmodule

			

/*
module box_state(
	input press;
	input clk;
	output y;
	
	localparam START_FLYING = 3'd0,
		IS_FLYING = 3'd1,
		START_FALLING = 3'd2,
		IS_FALLING = 3'd3;

	always@(*)
	begin: state_table
		case (current_state)
			FALLING: next_state = press ? FLYING : FALLING;
			FLYING: next_state = done_flying ? FALLING : FLYING;


endmodule
*/


/*
module pipe_coordinate_register(
	input load_x,
	input load_y);
	reg is_empty;
	reg x_coordinate;
	reg y_coordinate;
	always@(*)
	if(load_x
	always@(game_tick_pulse)
	if(x_coordinate == 0)
		is_empty <= 1;
	if(x_coordinate != 0)
		x_coordinate <= x_coordinate - 1;

endmodule
*/

/*
module RateDivider(clk, rate, current_rate);
	input clk;
	input[28:0] rate;
	output[28:0] current_rate;
	reg[28:0] out= 0;
	assign current_rate = out;
	
	always @(posedge clk)
	begin
		if(out == 0)
			out <= rate;
		else
			out <= out - 1'b1;
	end

endmodule
*/

/*
module pos_edge_pulser(// Converts a continuous "on" signal, to a short "on" pulse 
    input in, // Continuous signal
    output pulse // Single pulse
    );
    reg current_signal;
    reg input_pulse_wire;
    assign input_pulse = input_pulse_wire;
    always@(*)
    begin
        if(current_signal == 1'b0 && in == 1'b1)
            input_pulse_wire <= 1'b1;
        else
            input_pulse_wire <= 1'b0;
        current_signal <= in;
    end
endmodule
*/
   
        
