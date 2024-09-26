`timescale 1ns / 1ps
module contador(
    input clk,
    input reset,
    input en,           // Señal de habilitación (enable)
    output reg [7:0] q
);

    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            q <= 8'd0;     // Resetear el contador a 0
        end
        else if (en) begin
            q <= q + 1'b1; // Incrementar el contador si el enable está activo
        end
        
        // Si 'en' está en bajo, q mantiene su valor actual
    end

endmodule
