`timescale 1ns / 1ps

module Complemento_a_2(
    input [3:0] sw,
    output [3:0] led
);
    
wire [3:0] comp_1;
wire [3:0] comp_2;
    
assign comp_1 = ~sw;
assign comp_2 = comp_1 + 4'b0001;
assign led = comp_2;

endmodule
