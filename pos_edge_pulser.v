module pos_edge_pulser(
    input in,
    output pulse
    );
    reg current_signal = 1'b0;
    reg input_pulse_reg;
    assign input_pulse = input_pulse_reg;
    always@(*)
    begin
        if(current_signal == 1'b0 && in == 1'b0)
            input_pulse_reg <= 1'b1;
        else
            input_pulse_reg <= 1'b0;
        current_signal <= in;
    end
endmodule
