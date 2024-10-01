`timescale 1ms / 100us

module top_module (
    input wire clk,       // Reloj del sistema
    input wire rst_n,     // Señal de reset
    input wire key_in,    // Entrada del botón sin debouncing
    output wire [7:0] count // Salida del contador de 8 bits
);

    wire key_pressed; // Señal debounced que se usará como enable

    // Instancia del módulo de debouncing
    key_debounce #(
        .DEBOUNCE_TIME(1000)  
    ) debounce_inst (
        .clk(clk),
        .rst_n(rst_n),
        .key_in(key_in),
        .key_pressed(key_pressed)
    );

    // Instancia del contador de 8 bits
    counter_8bit counter_inst (
        .clk(clk),
        .rst_n(rst_n),
        .key_pressed(key_pressed),  
        .count(count)
    );

endmodule
