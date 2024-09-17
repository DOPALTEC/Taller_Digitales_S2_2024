`timescale 1ns / 1ps

module top_module_tb;

    // Señales de prueba
    reg clk_in_tb;
    reg reset_tb;
    reg [3:0] external_in_tb;
    wire [3:0] hex_out_tb;

    // Instancia del módulo top_module
    top_module uut (
        .clk_in(clk_in_tb),
        .reset(reset_tb),
        .external_in(external_in_tb),
        .hex_out(hex_out_tb)
    );

    // Generador de reloj
    always #5 clk_in_tb = ~clk_in_tb;  // Reloj con periodo de 10 ns (50 MHz)

    // Proceso de estímulos
    initial begin
        // Inicialización de señales
        clk_in_tb = 0;
        reset_tb = 0; // Inicialmente activo (para liberar después)
        external_in_tb = 4'b1111;

        // Mantener el reset activo por 20 ns
        #20 reset_tb = 1;  // Reset desactivado (si es activo en bajo)

        // Cambiar la entrada externa del codificador
        #200 external_in_tb = 4'b1110;
        #200 external_in_tb = 4'b1011;
        #200 external_in_tb = 4'b1101;
        #200 external_in_tb = 4'b0111;

        // Terminar la simulación
        #500 $finish;
    end

endmodule
