`timescale 1ms / 100us
module counter_2bit (
    input wire clk,
    input wire rst_n,
    input wire key_pressed,  // Changed from key_valid to key_pressed
    output reg [1:0] count
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 2'b00;
        end else if (!key_pressed) begin  // Count when key is not pressed
            count <= count + 1;
        end
    end
endmodule

