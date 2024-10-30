`timescale 1ns / 1ps
module Reg_ctrl #(parameter palabra = 8) (
    input wire clk,                     // Se�al de reloj
    input wire rst,                     // Se�al de reset 
    input wire locked,
    input wire [palabra-1:0] IN1,       // Entrada 1 de palabra bits
    input wire [palabra-1:0] IN2,       // Entrada 2 de palabra bits
    input wire WR1,                     // Se�al de escritura 1 (para bit 0)
    input wire WR2,                     // Se�al de escritura 2 (para bit 1)
    output reg [palabra-1:0] out        // Salida de palabra bits
);

    // Bloque secuencial controlado por el reloj y el reset
    always @(posedge clk or posedge rst) begin
        //if (rst || !locked) begin
        if (rst) begin
            out <= 0;                   // Inicializa 'out' en 0 si rst est� activo
        end
        else begin
            // Control del bit 0: Solo se escribe si WR1 est� activo y el bit 1 de IN2 est� bajo
            
            // Control del bit 1: Solo se escribe si WR2 est� activo
            if (WR2) begin
                //out[0] <= IN2[0];
                out[1] <= IN2[1];        // Actualiza el bit 1 de out
            end
            if (WR1) begin
                //out[0] <= IN2[0];
                out[0] <= IN1[0];        // Actualiza el bit 1 de out
            end
            

            //else if (WR1 && !IN2[1]) begin 
            //    out[0] <= IN1[0];        // Actualiza el bit 0 de out
            //end
            //else begin 
            //    out[0] <= IN2[0];
            //    out[1] <= IN2[1];
            //end
            // Los dem�s bits de 'out' permanecen sin cambios
        end
    end
endmodule
