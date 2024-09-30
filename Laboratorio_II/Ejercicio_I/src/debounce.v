`timescale 1ms / 100us
module key_debounce #(
    parameter DEBOUNCE_TIME = 1000000  // Adjust based on your clock frequency
)(
    input wire clk,
    input wire rst_n,
    input wire key_in,
    output reg key_pressed  // Changed from key_valid to key_pressed
);
    reg [19:0] counter;
    reg key_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 0;
            key_reg <= 0;
            key_pressed <= 0;
        end else begin
            key_reg <= key_in;
            if (key_reg != key_in) begin
                counter <= 0;
                key_pressed <= 0;
            end else if (counter == DEBOUNCE_TIME - 1) begin
                key_pressed <= key_in;  // Output follows the debounced input
            end else begin
                counter <= counter + 1;
            end
        end
    end
endmodule
