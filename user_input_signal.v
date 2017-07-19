module user_input_signal(
    input user_input,
    output user_input_clock
    );
    reg user_input_clock_reg = 1'b0;
    assign user_input_clock = user_input_clock_reg;
    always @(posedge user_input)
    begin: user_clock_alternate
        user_input_clock_reg <= ~user_input_clock_reg;
    end // user_clock_alternate
endmodule
