module clock_divider (
    input clk,
    input reset,
    output reg slow_clk
);
    reg [24:0] counter; // Aumenta el tamaño del contador para un divisor más lento

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 25'b0;
            slow_clk <= 1'b0;
        end else begin
            counter <= counter + 1;
            slow_clk <= counter[24]; // Reduce la frecuencia original por un factor de 2^24
        end
    end
endmodule




