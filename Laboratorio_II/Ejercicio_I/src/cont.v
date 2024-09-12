`timescale 1ns / 1ps
module contador(
    input clk,
    input rst,            //  reset
    input EN,             //  enable
    output reg [7:0] cont   // 8-bit counter output
);
// up counter 
    always @(posedge clk or negedge rst) 
    begin
        if (!rst)
            cont <= 8'b0;  // Reset 
        else if (EN)
            cont <= cont + 1;  // incrementa el contador 
    end
endmodule
