module box_register(
	input  tap,
	output flying,
	output [6:0] y_coordinate
	);
	reg [6:0] current_y_coordinate = 7'd60;
	assign y_coordinate[6:0] = current_y_coordinate[6:0];
	reg is_flying;
	assign flying = is_flying;
	

endmodule
