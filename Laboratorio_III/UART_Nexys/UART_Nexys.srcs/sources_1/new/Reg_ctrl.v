`timescale 1ns / 1ps

module Reg_ctrl #(parameter palabra=32) (
    input wire [palabra-1:0] IN1,       // Entrada 1 de 32 bits
    input wire [palabra-1:0] IN2,       // Entrada 2 de 32 bits
    input wire WR1,              // Se�al de escritura 1
    input wire WR2,              // Se�al de escritura 2
    output reg [palabra-1:0] out        // Salida de 32 bits
);

    // Definici�n de los bits especiales de la salida
    wire send = out[0];          // Bit 0 se llama 'send'
    wire new_rx = out[1];        // Bit 1 se llama 'new_rx'

    always @(posedge WR1 or posedge WR2) begin
        if (WR1) begin
            out <= IN1;          // Escribe IN1 en el registro si WR1 est� activa
        end else if (WR2) begin
            out <= IN2;          // Escribe IN2 en el registro si WR2 est� activa
        end
    end

endmodule
