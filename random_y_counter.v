module random_y_counter(
    input clk,
    input user_input,
    output[6:0]random_number
    );

    reg[6:0]y_counter = 7'd100;
    reg[6:0]random_number_reg = 7'd100;
    assign random_number[6:0] = random_number_reg[6:0];
    always @(posedge clk)
    begin
        if(y_counter <= 7'd30)
            y_counter <= 7'd100;
        else
            y_counter <= y_counter -1'b1;
        if(user_input)
            random_number_reg[6:0] <= y_counter[6:0];
    end
endmodule
