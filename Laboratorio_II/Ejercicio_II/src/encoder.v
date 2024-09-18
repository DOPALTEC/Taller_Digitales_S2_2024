`timescale 1ns / 1ps
module encoder_4to2 (
    input [3:0] in2,    // Entrada de 4 bits
    output reg [1:0] out2 // Salida de 2 bits
);

always @(*) begin
    case (in2)
        4'b1110: out2 = 2'b00;
        4'b1101: out2 = 2'b01;
        4'b1011: out2 = 2'b10;
        4'b0111: out2 = 2'b11;
        4'b1111: out2 = 2'b00;
        default: out2 = 2'b00;
    endcase
end

endmodule

