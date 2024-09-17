`timescale 1ns / 1ps
module contador(
    input clk,
    input reset,
    input en,           // Señal de habilitación (enable)
    output reg [1:0] q
);

    always @(posedge clk ) begin
        if (!reset) begin
            q <= 2'b00;     // Resetear el contador a 0
        end
        else if (en) begin
            q <= q + 1'b1; // Incrementar el contador si el enable está activo
        end
        
        // Si 'en' está en bajo, q mantiene su valor actual
    end

endmodule
