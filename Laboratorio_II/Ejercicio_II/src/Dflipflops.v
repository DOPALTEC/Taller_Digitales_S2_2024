// 4 D Flip-flops
`timescale 1ns / 1ps
module d_flip_flop(
    input clk, rst , enable ,          
    input [3:0] d,        // valores del teclado y contador 
    output reg [3:0] q         // salida a los leds de la FPGA
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            q <= 4'b0000;      // Reset output to 0
        end 
        else if (enable) begin
            q <= d;            // output los valores cuando están guardados
        end
    end
endmodule
