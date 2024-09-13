// 2 bit counter 
`timescale 1ns / 1ps
module counter(
    input clk,
    input rst,            
    output reg [1:0] count // 2-bit counter
);
    
    always @(posedge clk or negedge rst) begin
        if (!rst)
            count <= 2'b00;  // Reset counter 
        else
            count <= count + 1;  // i++
    end
endmodule
