`timescale 1ns / 1ps

module Reg_ctrl #(parameter palabra=32) (
    input wire [palabra-1:0] IN1,       // Entrada 1 de 32 bits
    input wire [palabra-1:0] IN2,       // Entrada 2 de 32 bits
    input wire WR1,                     // Se�al de escritura 1
    input wire WR2,                     // Se�al de escritura 2
    input wire rst,                     // Se�al de reset
    output reg [palabra-1:0] out        // Salida de 32 bits
);

    // Definici�n de los bits especiales de la salida
    wire send = out[0];          // Bit 0 se llama 'send'
    wire new_rx = out[1];        // Bit 1 se llama 'new_rx'

    // Inicializaci�n del registro en 0
    always @(posedge WR1 or posedge WR2 or posedge rst) begin
        if (rst) begin
            out <= 0;            // Inicializa 'out' en 0 si rst est� activa
        end else begin
            if (WR1 && WR2==0) begin
                out <= IN1;       // Escribe IN1 en el registro si WR1 est� activa
            end else if (WR2 && WR1==0) begin
                out <= IN2;       // Escribe IN2 en el registro si WR2 est� activa
            end
            else if(WR2) begin //Prioriza que se limpien los valores del control
                out <= IN2; 
            end
            else begin
                out<=0;
            end
        end
    end

endmodule
