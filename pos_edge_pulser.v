module pos_edge_pulser(
    input in,
    output pulse
    );
    reg current_signal;
    reg input_pulse_wire;
    assign input_pulse = input_pulse_wire;
    always@(*)
    begin
        if(current_signal == 1'b0 && in == 1'b0)
            input_pulse_wire <= 1'b1;
        else
            input_pulse_wire <= 1'b0;
        current_signal <= in;
    end
endmodule
