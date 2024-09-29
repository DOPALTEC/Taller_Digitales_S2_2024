`timescale 1ns / 1ps

module counter (
    input clk,
    input reset,
    input enable,  // Enable signal from debounce
    output reg [1:0] count  // Salida del contador
);

    // Registro para almacenar el estado de enable
    reg enable_latch;

    always @(posedge clk) begin
        if (!reset) begin
            count <= 2'b00;  // Reinicia el contador
            enable_latch <= 1'b0;  // Reinicia el latch de enable
        end else if (enable) begin
            enable_latch <= 1'b1;  // Activa el latch cuando enable es 1
        end else if (!enable && enable_latch) begin
            enable_latch <= 1'b0;  // Desactiva el latch cuando enable vuelve a 0
        end
    end

    // Incrementar el contador si el latch no está activado
    always @(posedge clk) begin
        if (!reset) begin
            count <= 2'b0;  // Reinicia el contador
        end else if (!enable_latch) begin
            count <= count + 1'b1;  // Incrementa el contador
        end
    end

endmodule
