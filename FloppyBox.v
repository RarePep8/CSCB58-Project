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
		VGA_B,   						//	VGA Blue[9:0]
        HEX0,
        HEX1,
        HEX2
	);
    
    // the main module where all the different module parts are connected together to make the game work

	input			CLOCK_50;				//	50 MHz
	input   [3:0]   KEY;
    output [6:0]    HEX0;
    output [6:0]    HEX1;
    output [6:0]    HEX2;
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
	wire [2:0] colour;
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
			.plot(writeEn),//writeEn
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120"; //160x120
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";
			
	// Put your code here. Your code should produce signals x,y,colour and writeEn/plot
	// for the VGA controller, in addition to any other functionality your design may require.

    // different wires to connect the output and inputs of different modules together
	wire game_tick_wire;
	wire game_pulse_wire;
	wire advance_frame_wire;
	wire pulse_early_wire;
	wire [8:0]pipe_one_x_wire;
	wire [6:0]pipe_one_y_wire;
	wire [8:0]pipe_two_x_wire;
	wire [6:0]pipe_two_y_wire;
	wire [8:0]pipe_three_x_wire;
	wire [6:0]pipe_three_y_wire;
    wire [6:0]box_y_wire;
    wire collided_wire;
    wire [3:0] current_time_wire;

    // a special clock used to give the different clock cycles to the necessary modules
	 game_clock gc(
			.CLOCK_50(CLOCK_50),
			.NEW_CLOCK(game_tick_wire),
			.NEW_CLOCK_EARLY(game_pulse_wire),
			.NEW_PULSE_EARLY(pulse_early_wire)
            );

    // the module for the first pipe, it outputs the x and y coordinates to the painter module so it can be drawn
	 pipe_register pr1(
			.key_press(~KEY[0]),
			.CLOCK_50(CLOCK_50),
			.starting_x(9'd160),
			.starting_y(7'd50),
			.game_clk(advance_frame_wire),//advance_frame_wire
			.x(pipe_one_x_wire),
			.y(pipe_one_y_wire),
			.collided(collided_wire)
			);

    // the module for the second pipe, it is 100 pixel behind the first pipe
	 pipe_register pr2(
			.key_press(~KEY[0]),
			.CLOCK_50(CLOCK_50),
			.starting_x(9'd260),
			.starting_y(7'd30),
			.game_clk(advance_frame_wire),//advance_frame_wire
			.x(pipe_two_x_wire),
			.y(pipe_two_y_wire),
			.collided(collided_wire)
			);
			
    // the module for the third pipe, it is 100 pixel behind the second pipe
	 pipe_register pr3(
			.key_press(~KEY[0]),
			.CLOCK_50(CLOCK_50),
			.starting_x(9'd360),
			.starting_y(7'd70),
			.game_clk(advance_frame_wire),//advance_frame_wire
			.x(pipe_three_x_wire),
			.y(pipe_three_y_wire),
			.collided(collided_wire)
			);

    // the clock is used to send signals to the time_counter module to see if a second has passed or not
    clock time_last(
        .CLOCK_50(CLOCK_50),
        .clk_speed(3'd1),
        .current_number(current_time_wire)
        );

    // the box module, used to send its height to the painter module so it can be painted, the key0 can make it go up
    box_register box_reg(
        .game_clk(game_tick_wire), //advance_frame_wire
        .user_input(~(KEY[0])), 
        .y_coordinate(box_y_wire),
		  .collided(collided_wire)
        );

    // the counter used to display how many seconds the player has lasted, it is also the score of the game
    // this is displayed on the 7 segment display on the board
    time_counter current_time(
        .binary_time(current_time_wire),
		  .CLOCK_50(CLOCK_50),
        .hex_0(HEX0),
        .hex_1(HEX1),
        .hex_2(HEX2),
		  .collided(collided_wire)
        );

    // it takes in the coordinate of the pipes and box and checks if it has collided so the game can stop
    collision_detector collision(
        .box_y(box_y_wire),
        .CLOCK_50(CLOCK_50),
        .key_press(~KEY[3]),
        .pipe_x1(pipe_one_x_wire),
        .pipe_y1(pipe_one_y_wire),
        .pipe_x2(pipe_two_x_wire),
        .pipe_y2(pipe_two_y_wire),
        .pipe_x3(pipe_three_x_wire),
        .pipe_y3(pipe_three_y_wire),
        .collided(collided_wire)
        );

    // it help sends the different x and y coordinates as well as color to the vga so the vga can draw it on the screen
	painter p(
        .CLOCK_50(CLOCK_50),
        .game_pulse(pulse_early_wire), //game_pulse_wire
        .box_y(box_y_wire),
        .pipe_one_x(pipe_one_x_wire),
        .pipe_one_y(pipe_one_y_wire),
		  .pipe_two_x(pipe_two_x_wire),
		  .pipe_two_y(pipe_two_y_wire),
		  .pipe_three_x(pipe_three_x_wire),
		  .pipe_three_y(pipe_three_y_wire),
        .collided(collided_wire),
        .key_press(~KEY[3]),
        .plot(writeEn),
        .x(x),
        .y(y),
        .colour(colour),
        .game_tick_after_erase(advance_frame_wire)
	    );
endmodule
