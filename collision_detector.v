module collision_detector(box_y, CLOCK_50, 
                            pipe_x1, pipe_y1, 
                            pipe_x2, pipe_y2, 
                            pipe_x3, pipe_y3, 
                            pipe_x4, pipe_y4, 
                            pipe_x5, pipe_y5, 
                            collided);

    input[6:0] box_y;
    input CLOCK_50;
    input[7:0] pipe_x1;
    input[6:0] pipe_y1;

    input[7:0] pipe_x2;
    input[6:0] pipe_y2;

    input[7:0] pipe_x3;
    input[6:0] pipe_y3;

    input[7:0] pipe_x4;
    input[6:0] pipe_y4;

    input[7:0] pipe_x5;
    input[6:0] pipe_y5;

    output collided;
    reg touched = 1'b0;
    assign collided = touched;


    // there is no need for the box's x coordinate as input as its fixed at the 4th pixel
    // the box is a 2 by 2 box
    reg[7:0] box_x = 8'd4;
    
    always @(posedge CLOCK_50) 
        begin
            // this checks if the x coordinate of the pipes and the box are the same
            // it also checks if the box is within the pipe's y coordinate
            // finally it determines if the two are touching
            if (pipe_x1 == (box_x + 1) && (box_y < pipe_y1 || box_y > (pipe_y1 + 19)))
                touched <= 1'b1;
            else if (pipe_x2 == (box_x + 1) && (box_y < pipe_y2 || box_y > (pipe_y2 + 19)))
                touched <= 1'b1;
            else if (pipe_x3 == (box_x + 1) && (box_y < pipe_y3 || box_y > (pipe_y3 + 19)))
                touched <= 1'b1;
            else if (pipe_x4 == (box_x + 1) && (box_y < pipe_y4 || box_y > (pipe_y4 + 19)))
                touched <= 1'b1;
            else if (pipe_x5 == (box_x + 1) && (box_y < pipe_y5 || box_y > (pipe_y5 + 19)))
                touched <= 1'b1;
        end

endmodule