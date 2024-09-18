module clock_divider (
    input wire clk_in,
    input wire reset,
    output reg clk_out
);

parameter DIVIDER = 50; 
reg [15:0] counter;

always @(posedge clk_in or posedge reset) begin
    if (!reset) begin
        counter <= 16'd0;
        clk_out <= 1'b0;
    end else if (counter == DIVIDER - 1) begin
        counter <= 16'd0;
        clk_out <= ~clk_out;
    end else begin
        counter <= counter + 1'b1;
    end
end

endmodule



