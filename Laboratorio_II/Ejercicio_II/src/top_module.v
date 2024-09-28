`timescale 1ns / 1ps

module top_module (
    input clk,                     // Reloj global
    input reset,                   // Señal de reset
    input [1:0] fila,              // Entrada de 2 bits (también usada como external_in)
    output reg [1:0] count,            // Salida del contador
    output [3:0] Q                 // Salida del sincronizador
);

    wire key_out;                 // Salida del módulo key_detect
    wire debounced_out;           // Salida del módulo debounce

    // Instancia del módulo key_detect
    key_detect key_detect_inst (
        .clk(clk), 
        .reset(reset), 
        .fila(fila), 
        .key_out(key_out)          // Salida de detección de la tecla
    );

    // Instancia del módulo debounce
    debounce debounce_inst (
        .clk(clk), 
        .reset(reset), 
        .key(key_out),             // La salida de key_detect es la entrada del debounce
        .debounced_out(debounced_out)  // La salida del debounce
    );

    // Instancia del módulo counter
    counter counter_inst (
        .clk(clk), 
        .reset(reset), 
        .enable(debounced_out),    // El enable del contador es la salida del debounce
        .count(count)               // La salida del contador
    );

    // Instancia del módulo sincronizador
    sincronizador sincronizador_inst (
        .external_in(fila),        // Usa fila como entrada externa
        .counter_out(count),       // Salida del contador
        .clk(clk), 
        .rst(reset), 
        .Q(Q)                      // Salida del sincronizador
    );

endmodule
