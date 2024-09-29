module top_module (
    input clk,         // Señal de reloj de la FPGA
    input reset,       // Señal de reset
    input enable,      // Enable activo en bajo
    output [1:0] count // Conectar los LEDs a esta salida
);

    wire slow_clk;

    // Divisor de reloj para hacer más lento el conteo
    clock_divider clk_div_inst (
        .clk(clk),
        .reset(reset),
        .slow_clk(slow_clk)
    );

    // Contador controlado por enable activo en bajo
    counter counter_inst (
        .clk(slow_clk),
        .reset(reset),
        .enable(enable),   // Habilita cuando enable está en bajo
        .count(count)      // Salida del contador conectada a los LEDs
    );

endmodule
