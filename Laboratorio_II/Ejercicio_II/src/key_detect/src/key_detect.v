`timescale 1ns / 1ps

module key_detect (
    input clk,
    input reset,
    input [1:0] fila,  // Entrada de 2 bits
    output reg key_out      // Salida de 1 bit
);

    // Registro para almacenar la entrada anterior
    reg [1:0] fila_prev;

    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            fila_prev <= 2'b00; // Inicializa a 00 en reset
            key_out <= 1'b0;    // Inicializa la salida a 0
        end else begin
            // Detectar cambio en la entrada
            if (fila != fila_prev) begin
                key_out <= ~key_out; // Cambia el estado de key_out
            end
            fila_prev <= fila; // Actualiza el registro de la entrada anterior
        end
    end

endmodule
