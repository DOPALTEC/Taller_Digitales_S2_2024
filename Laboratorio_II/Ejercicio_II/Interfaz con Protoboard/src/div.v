`timescale 1ms / 100us
module clock_divider (
    input clk,           // Fast clock input
    input rst_n,         // Reset input
    output reg slow_clk  // Slower clock output
);

reg [24:0] counter;  // Adjust bit-width for the desired speed

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        counter <= 0;
    else
        counter <= counter + 1;
end

// Toggle slow clock every time the counter reaches a certain value
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        slow_clk <= 0;
    else if (counter == 25_000_000) // Adjust value based on system clock frequency
        slow_clk <= ~slow_clk;
end

endmodule
