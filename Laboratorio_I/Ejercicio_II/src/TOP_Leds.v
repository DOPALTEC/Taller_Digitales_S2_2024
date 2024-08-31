`timescale 1ns / 1ps

module top(
    input [3:0] sw,
    output [3:0] led
);
    
Complemento_a_2 C2(
    .sw(sw), 
    .led(led)
);
    
endmodule
