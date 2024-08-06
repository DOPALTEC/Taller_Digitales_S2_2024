`timescale 1ns / 1ps

module ALU_TOP #(parameter N=3) (
    input [N:0] A,
    input [N:0] B,
    input [N:0] ALUControl,
    input ALUFlagIn,
    output reg C,
    output reg zero,
    output reg [N:0] Y
);

always @* begin
    case(ALUControl)
        4'b0000: Y= A&B;
    endcase

end
    
    
endmodule
