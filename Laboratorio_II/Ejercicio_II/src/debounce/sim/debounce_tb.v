`timescale 1ns / 1ps

module tb_debounce;

    reg clk;
    reg reset;
    reg key;
    wire debounced_out;

    // Instancia del módulo debounce
    debounce uut (
        .clk(clk),
        .reset(reset),
        .key(key),
        .debounced_out(debounced_out)
    );

    // Generación del reloj
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  
    end

    initial begin
        // Inicialización
        reset = 0;
        key = 1;
        #10;
        reset = 1;  

        // Prueba 1: Mantener key en 1
        key = 1;
        #200; 
        // Prueba 2: Cambiar a 0 y mantener
        key = 0;
        #200; 
        // Prueba 3: Cambiar a 1 y mantener
        key = 1;
        #200; 
        // Prueba 4: Cambiar rápidamente
        key = 0; 
        #10;
        key = 1;
        #10;
        key = 0;
        #10;
        key = 1;
        #10;
        key = 0; 
        #10;
        key = 1;
        #10;
        key = 0;
        #10;
        key = 1;
        #200;

        // Finalizar la simulación
        #50;
        $finish;
    end

endmodule
