module top (
    input wire clk_in,           // Reloj de entrada
    input wire reset,            // Señal de reset
    input wire [1:0] external_in, // Entrada externa para el codificador (salida del codificador)
    output wire hex_out1,    // Salida combinada del registro de salida
    output wire hex_out2,
    output wire hex_out3,

    //wire clk_div;                // Salida del divisor de reloj
    wire [1:0] debounced_signal; // Salida del debouncer
    wire sync_signal;            // Salida del sincronizador
    //wire [3:0] decoder_out;      // Salida del decodificador (2 a 4)
    //wire [1:0] encoder_out;      // Salida del codificador (4 a 2)

    // Divisor de reloj
    /*clock_divider clk_div_inst (
        .clk_in(clk_in),
        .reset(reset),
        .clk_out(clk_div)
    );*/

    // Debouncer
    debounce debounce_inst (
    );

    // Decodificador (de 2 a 4 bits)
    /*decoder_2to4 decoder_inst (
        .in(counter_out),
        .out(decoder_out)
    );
    encoder_4to2 encoder_inst (
        .in2(external_in),
        .out2(encoder_out)
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
