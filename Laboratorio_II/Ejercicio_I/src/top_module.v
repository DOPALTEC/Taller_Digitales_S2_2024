`timescale 1ns / 1ps

module top_module (
    input clk,        // Señal de reloj
    input reset,      // Señal de reset
    input key,        // Entrada del botón que será debounced
    output [7:0] count  // Salida del contador
);

    wire debounced_out;  // Señal de salida del módulo debounce

    // Instancia del módulo debounce
    debounce debounce_inst (
        .clk(clk), 
        .reset(reset), 
        .key(key), 
        .debounced_out(debounced_out)  // La salida del debounce se usa como enable del contador
    );

    // Instancia del módulo contador
    counter counter_inst (
        .clk(clk), 
        .reset(reset), 
        .enable(debounced_out),  // El enable es la salida del debounce
        .count(count)  // La salida count es la salida del contador
    );

endmodule
