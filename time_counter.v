module time_counter(binary_time, CLOCK_50, hex_0, hex_1, hex_2, collided, key_press);
    // a counter used to display the amount of time the player have lasted through the 7 segment display

    input [3:0] binary_time;
	input CLOCK_50;
	input collided; // stops the counter if its collided
    input key_press; // the key to reset the counter
    output [6:0] hex_0;
    output [6:0] hex_1;
    output [6:0] hex_2;
    
    // the register used to store the second and third digits
    reg [3:0] digit2 = 4'b0;
    reg [3:0] digit3 = 4'b0;
    reg in_game = 1'b1;

    // hex decoder used to help translate binary to the 7 segment displays in decimal
    hex_decoder h0(
        .hex_digit(binary_time[3:0]),
        .segments(hex_0)
        );

    hex_decoder h1(
        .hex_digit(digit2[3:0]),
        .segments(hex_1)
        );

    hex_decoder h2(
        .hex_digit(digit3[3:0]),
        .segments(hex_2)
        );

    // increase the values of digit 2 and digit 3 whenever the value before it reaches 10
    // if pipe and box has collided then set all digits to 0
    always @(posedge CLOCK_50)
        begin
		  if(~collided) begin
			  if (binary_time == 4'd10)
					digit2 <= digit2 + 1'b1;
			  if (digit2 == 4'd10)
					begin
					digit3 <= digit3 + 1'b1;
					digit2 <= 4'b0;
					end
				if (digit3 == 4'd10)
					digit3 <= 4'b0;
				end
			if (key_press) begin
				digit2 <= 4'd0;
				digit3 <= 4'd0;
				end
        end
		  

endmodule

module hex_decoder(hex_digit, segments);
    // decodes binary to seven segment display outputs
    // CREDIT TO: BRIAN HARRINGTON
    
    input [3:0] hex_digit;
    output reg [6:0] segments;
   
    always @(*)
        case (hex_digit)
            4'h0: segments = 7'b100_0000;
            4'h1: segments = 7'b111_1001;
            4'h2: segments = 7'b010_0100;
            4'h3: segments = 7'b011_0000;
            4'h4: segments = 7'b001_1001;
            4'h5: segments = 7'b001_0010;
            4'h6: segments = 7'b000_0010;
            4'h7: segments = 7'b111_1000;
            4'h8: segments = 7'b000_0000;
            4'h9: segments = 7'b001_1000;
            default: segments = 7'b100_0000;
        endcase
endmodule
