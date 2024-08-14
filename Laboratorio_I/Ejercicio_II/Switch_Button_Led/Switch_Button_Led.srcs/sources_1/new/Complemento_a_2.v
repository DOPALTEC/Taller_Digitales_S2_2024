`timescale 1ns / 1ps

module Complemento_a_2(
    input [3:0] sw,  
    output [3:0] led  
);
    
    reg [3:0] comp_2; 

    always @(*) begin
        if (sw[3] == 1) 
            comp_2 = ~sw + 4'b0001; 
        else
            comp_2 = sw; 
    end
    
    assign led = comp_2;

endmodule
