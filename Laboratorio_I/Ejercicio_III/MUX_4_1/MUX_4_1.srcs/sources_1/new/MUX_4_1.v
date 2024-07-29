`timescale 1ns / 1ps

module MUX_4_1 #(parameter N=3)(
    input [N:0] IN_1,
    input [N:0] IN_2,
    input [N:0] IN_3,
    input [N:0] IN_4,
    input [1:0] sel,
    output reg [N:0] OUT
    );
    
always @(*) begin
    case(sel)
    2'b00: OUT=IN_1;
    2'b01: OUT=IN_2;
    2'b10: OUT=IN_3;
    2'b11: OUT=IN_4;
    endcase
end


endmodule
