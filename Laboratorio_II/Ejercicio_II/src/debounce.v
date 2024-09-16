module debouncer (
    input wire clk,
    input wire key_in,
    output reg key_out
);

reg [7:0] shift_reg;

always @(posedge clk) begin
    shift_reg <= {shift_reg[6:0], key_in};
    if (shift_reg == 8'b11111111)
        key_out <= 1'b1;
    else if (shift_reg == 8'b00000000)
        key_out <= 1'b0;
end

endmodule
