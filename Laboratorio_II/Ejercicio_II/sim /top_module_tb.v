`timescale 1ns / 1ps

module top_module_tb;

    // Señales de prueba para el top module
    reg clk_in_tb;
    reg reset_tb;
    reg [3:0] external_in_tb;
    wire hex_out_tb1;
    wire hex_out_tb2;
    wire hex_out_tb3;
    wire hex_out_tb4;

    // Señales internas para los módulos
    wire clk_div_tb;              // Salida del divisor de reloj
    wire [1:0] debounced_out_tb;  // Salida del debouncer
    wire sync_signal_tb;          // Salida del sincronizador
    wire [1:0] counter_out_tb;    // Salida del contador
    wire [3:0] decoder_out_tb;    // Salida del decodificador
    wire [1:0] encoder_out_tb;    // Salida del codificador

    // Instancia del módulo top_module
    top_module uut (
        .clk_in(clk_in_tb),
        .reset(reset_tb),
        .external_in(external_in_tb),
        .hex_out1(hex_out_tb1),
        .hex_out2(hex_out_tb2),
        .hex_out3(hex_out_tb3),
        .hex_out4(hex_out_tb4)
    );

    // Conectar las señales internas
    assign clk_div_tb = uut.clk_div_inst.clk_out;
    assign debounced_out_tb = uut.debounce_inst.debounced_out;
    assign sync_signal_tb = uut.sync_inst.sync_out;
    assign counter_out_tb = uut.counter_inst.q;
    assign decoder_out_tb = uut.decoder_inst.out;
    assign encoder_out_tb = uut.encoder_inst.out2;

    // Generador de reloj
    always #5 clk_in_tb = ~clk_in_tb;  // Reloj con periodo de 10 ns (50 MHz)

    // Proceso de estímulos
    initial begin
        // Inicialización de señales
        clk_in_tb = 0;
        reset_tb = 0;
        external_in_tb = 4'b1111;

        // Esperar 20 ns y liberar el reset
        #20 reset_tb = 1;

        // Cambiar la entrada externa del codificador
        #200 external_in_tb = 4'b1110;
        #200 external_in_tb = 4'b1011;
        #200 external_in_tb = 4'b1101;
        #200 external_in_tb = 4'b0111;

        // Terminar la simulación
        #500 $finish;
    end

    // Monitorizar las salidas de cada módulo
    initial begin
        $monitor("Time: %0t | clk_div: %b | debounced_out: %b | sync_signal: %b | counter_out: %b | decoder_out: %b | encoder_out: %b | hex_out1: %b | hex_out2: %b | hex_out3: %b | hex_out4: %b",
            $time, clk_div_tb, debounced_out_tb, sync_signal_tb, counter_out_tb, decoder_out_tb, encoder_out_tb, hex_out_tb1, hex_out_tb2, hex_out_tb3, hex_out_tb4);
    end

endmodule
