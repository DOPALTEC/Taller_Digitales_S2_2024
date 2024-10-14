`timescale 1ns / 1ps

module Reg_ctrl #(parameter palabra=32) (
    input wire [palabra-1:0] IN1,       // Entrada 1 de 32 bits
    input wire [palabra-1:0] IN2,       // Entrada 2 de 32 bits
    input wire WR1,                     // Señal de escritura 1
    input wire WR2,                     // Señal de escritura 2
    input wire rst,                     // Señal de reset
    output reg [palabra-1:0] out        // Salida de 32 bits
);

    // Inicialización del registro en 0
    always @(posedge WR1 or posedge WR2 or posedge rst) begin
        if (rst) begin
            out <= 0;            // Inicializa 'out' en 0 si rst está activa
        end
        else begin
            if (WR1) begin
                out <= IN1;       // Escribe IN1 en el registro si WR1 está activa
            end 
            else if (WR2) begin
                out <= IN2;       // Escribe IN1 en el registro si WR1 está activa
            end 
            else if ((WR2==0 && WR1==0)|| WR2 && WR1) begin
                out <= IN1;       // Escribe IN2 en el registro si WR2 está activa
            end
        end
    end
endmodule
