`timescale 1ns / 1ps

module top (
    input wire clk_in,           // Reloj de entrada
    input wire reset,            // Señal de reset
    input wire [1:0] external_in, // Entrada externa para el codificador (salida del codificador)
    output wire hex_out1,    // Salida combinada del registro de salida
    output wire hex_out2,
    output wire hex_out3,
    output wire hex_out4,
    output wire [1:0] counter_out
);

    // Señales internas
    wire clk_div;                // Salida del divisor de reloj
    //wire clk_div;                // Salida del divisor de reloj
    wire [1:0] debounced_signal; // Salida del debouncer
    wire sync_signal;            // Salida del sincronizador
    wire [3:0] decoder_out;      // Salida del decodificador (2 a 4)
    wire [1:0] encoder_out;      // Salida del codificador (4 a 2)
    //wire [3:0] decoder_out;      // Salida del decodificador (2 a 4)
    //wire [1:0] encoder_out;      // Salida del codificador (4 a 2)

    // Divisor de reloj
   // clock_divider clk_div_inst (
    /*clock_divider clk_div_inst (
        .clk_in(clk_in),
        .reset(reset),
        .clk_out(clk_div)
    );
    );*/

    // Debouncer
    debounce debounce_inst (
        .clk(clk_in),
        .reset(reset),
        .button(encoder_out),
        .debounced_out(debounced_signal)
    );

    // Sincronizador
    sync sync_inst (
        .clk(clk_in),
        .async_in(debounced_signal),
        .sync_out(sync_signal)
    );

    // Contador (habilitado por el sincronizador)
    contador counter_inst (
        .clk(clk_in),
        .reset(reset),
        .en(sync_signal),
        .q(counter_out)
    );

    // Decodificador (de 2 a 4 bits)
    //decoder_2to4 decoder_inst (
    /*decoder_2to4 decoder_inst (
        .in(counter_out),
        .out(decoder_out)
    );
    // Codificador (de 4 a 2 bits)
    encoder_4to2 encoder_inst (
        .in2(external_in),
        .out2(encoder_out)
    );
    );*/

    // Registro de salida (almacena entradas de decodificador y codificador)
    output_register output_reg_inst (
        .clk(clk_in),
        .reset(reset),
        .counter_input(counter_out),
        .encoder_output(external_in),
        .hex_out1(hex_out1),
        .hex_out2(hex_out2),
        .hex_out3(hex_out3),
        .hex_out4(hex_out4)
    );

endmodule
