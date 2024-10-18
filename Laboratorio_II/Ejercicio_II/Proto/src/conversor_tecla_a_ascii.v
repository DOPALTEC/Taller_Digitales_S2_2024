`timescale 1ns / 1ps
module conversor_tecla_a_ascii(
    input wire [3:0] tecla_4bits,  // Entrada del teclado (4 bits)
    output reg [7:0] ascii_8bits   // Salida en formato ASCII (8 bits)
);
    
    always @(*) begin
        case (tecla_4bits)
            4'b0000: ascii_8bits = 8'h30; // '0'
            4'b0001: ascii_8bits = 8'h31; // '1'
            4'b0010: ascii_8bits = 8'h32; // '2'
            4'b0011: ascii_8bits = 8'h33; // '3'
            4'b0100: ascii_8bits = 8'h34; // '4'
            4'b0101: ascii_8bits = 8'h35; // '5'
            4'b0110: ascii_8bits = 8'h36; // '6'
            4'b0111: ascii_8bits = 8'h37; // '7'
            4'b1000: ascii_8bits = 8'h38; // '8'
            4'b1001: ascii_8bits = 8'h39; // '9'
            default: ascii_8bits = 8'h3F; // '?' para teclas no reconocidas
        endcase
    end

endmodule
