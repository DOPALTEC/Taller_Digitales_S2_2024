module output_register (
    input wire clk,
    input wire reset,
    input wire [3:0] hex_in,
    input wire key_pressed_in,
    output reg [3:0] hex_out,
    output reg key_pressed_out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        hex_out <= 4'h0;
        key_pressed_out <= 1'b0;
    end else if (key_pressed_in) begin
        hex_out <= hex_in;
        key_pressed_out <= 1'b1;
    end else begin
        key_pressed_out <= 1'b0;
    end
end

endmodule