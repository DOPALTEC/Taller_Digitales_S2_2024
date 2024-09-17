`timescale 1ns / 1ps

module output_register (
    input wire clk,
    input wire reset,
    input wire [1:0] counter_input,  // Entrada de 2 bits del contador
    input wire [1:0] encoder_output,  // Salida de 2 bits del codificador
    output reg [3:0] hex_out         // Salida combinada de 4 bits
);

    // Flip-flops para almacenar cada bit de las entradas
    reg ff1, ff2, ff3, ff4;

    // Proceso sincronizado con el reloj
    always @(posedge clk or posedge reset) begin
        if (!reset) begin
            // Resetear todos los flip-flops
            ff1 <= 1'b0;
            ff2 <= 1'b0;
            ff3 <= 1'b0;
            ff4 <= 1'b0;
            hex_out <= 4'b0000;
        end else begin
            // Actualizar flip-flops con cada bit de las entradas
            ff1 <= counter_input[0];    // Bit 0 del contador
            ff2 <= counter_input[1];    // Bit 1 del contador
            ff3 <= encoder_output[0];    // Bit 0 del codificador
            ff4 <= encoder_output[1];    // Bit 1 del codificador

            // Asignar la salida combinada de todos los flip-flops
            hex_out <= {ff4, ff3, ff2, ff1};  // Orden de los bits en la salida
        end
    end

endmodule
