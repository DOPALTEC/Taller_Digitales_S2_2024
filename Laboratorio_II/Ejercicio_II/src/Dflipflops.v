`timescale 1ns / 1ps

module output_register (
    input wire clk,
    input wire reset,
    input wire [1:0] counter_input,  // Entrada de 2 bits del contador
    input wire [1:0] encoder_output,  // Salida de 2 bits del codificador
    output reg hex_out1,         // Salida combinada de 4 bits
    output reg hex_out2,   
    output reg hex_out3,   
    output reg hex_out4  
);

    // Flip-flops para almacenar cada bit de las entradas
    reg ff1, ff2, ff3, ff4;

    // Proceso sincronizado con el reloj
    always @(posedge clk) begin
        if (!reset) begin
            // Resetear todos los flip-flops
            ff1 <= 1'b0;
            ff2 <= 1'b0;
            ff3 <= 1'b0;
            ff4 <= 1'b0;
            hex_out1 <= 1'b0;
            hex_out2 <= 1'b0;
            hex_out3 <= 1'b0;
            hex_out4 <= 1'b0;
        end else begin
            // Actualizar flip-flops con cada bit de las entradas
            ff1 <= counter_input[0];    // Bit 0 del contador
            ff2 <= counter_input[1];    // Bit 1 del contador
            ff3 <= encoder_output[0];    // Bit 0 del codificador
            ff4 <= encoder_output[1];    // Bit 1 del codificador

            // Asignar la salida combinada de todos los flip-flops
            hex_out1 <= ff4;
            hex_out2 <= ff3;
            hex_out3 <= ff2;
            hex_out4 <= ff1;
            
        end
    end

endmodule
