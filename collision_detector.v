module collision_detector(box_y, CLOCK_50, key_press,
                            pipe_x1, pipe_y1, 
                            pipe_x2, pipe_y2, 
                            pipe_x3, pipe_y3, 
                            collided);

    // use to detect if the pipes and the box has collided and sends out a signal

    // initialize the different inputs 
    input[6:0] box_y;
    input CLOCK_50;
    input key_press; // key press to reset the signal that the box and pipe has touched

    input[8:0] pipe_x1;
    input[6:0] pipe_y1;

    input[8:0] pipe_x2;
    input[6:0] pipe_y2;

    input[8:0] pipe_x3;
    input[6:0] pipe_y3;
    
    // use a register to store if the box and pipe has touched or not
    output collided;
    reg touched = 1'b0;
    assign collided = touched;


    // there is no need for the box's x coordinate as input as its fixed at the 4th pixel
    // the box is a 1 pixel box
    reg[8:0] box_x = 9'd4;
    
    always @(posedge CLOCK_50) 
        begin
            // this checks if the x coordinate of the pipes and the box are the same
            // it also checks if the box is within the pipe's y coordinate
            // finally it determines if the two are touching
            if (pipe_x1 == (box_x) && (box_y < (pipe_y1) || box_y > (pipe_y1 + 30)))
                touched <= 1'b1;
            else if (pipe_x2 == (box_x) && (box_y < (pipe_y2) || box_y > (pipe_y2 + 30)))
                touched <= 1'b1;
            else if (pipe_x3 == (box_x) && (box_y < (pipe_y3) || box_y > (pipe_y3 + 30)))
                touched <= 1'b1;
            // the key press can reset the signal back to 0
            else if (key_press)
                touched <= 1'b0;
        end

endmodule
