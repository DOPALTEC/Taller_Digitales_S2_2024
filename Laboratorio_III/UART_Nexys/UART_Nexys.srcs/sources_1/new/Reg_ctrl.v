`timescale 1ns / 1ps
module Reg_ctrl #(parameter palabra=8) (
    input wire clk,                     // Se�al de reloj
    input wire rst,                     // Se�al de reset 
    input wire [palabra-1:0] IN1,       // Entrada 1 de 32 bits
    input wire [palabra-1:0] IN2,       // Entrada 2 de 32 bits
    input wire WR1,                     // Se�al de escritura 1
    input wire WR2,                     // Se�al de escritura 2
    output reg [palabra-1:0] out        // Salida de 32 bits
);

    // Bloque secuencial controlado por el reloj y el reset
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            out <= 0;                   // Inicializa 'out' en 0 si rst est� activa
        end
        else begin
            if (WR1) begin
                out <= IN1;              // Escribe IN1 en el registro si WR1 est� activa
            end 
            else if (WR2 && !WR1) begin //Prioriza la transmision de datos
                out <= IN2;              // Escribe IN2 en el registro si WR2 est� activa
            end
        end
    end
endmodule
