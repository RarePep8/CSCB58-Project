module random_y_counter(
    input clk,
    input user_input,
    output[6:0]random_number
    );
    // a counter to produce a random number for the y coordinate of the pipe opening
    reg[6:0]y_counter = 7'd100;
    reg[6:0]random_number_reg = 7'd100;

    
    assign random_number[6:0] = random_number_reg[6:0];

    // randomizes the number based on the user's input
    always @(posedge clk)
    begin
        if(y_counter <= 7'd30) // if y counter is 30, then it resets back to 100
            y_counter <= 7'd100; 
        else
            y_counter <= y_counter -1'b1; // y counter decreases by 1 every time 
        if(user_input) // when the user inputs, set the random number register as the y counter
            random_number_reg[6:0] <= y_counter[6:0];
    end
endmodule
