`timescale 1ns / 1ps

module key_detect_tb;

    // Declaración de señales
    reg clk;
    reg reset;
    reg [1:0] fila;
    wire key_out;

    // Instanciación del módulo key_detect
    key_detect uut (
        .clk(clk),
        .reset(reset),
        .fila(fila),
        .key_out(key_out)
    );

    // Generador de reloj
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Cambia el reloj cada 5 ns (100 MHz)
    end

    // Secuencia de prueba
    initial begin
        // Inicialización
        reset = 0;
        fila = 2'b00;
        #10;

        // Activar el reset
        reset = 1;
        #10;

        // Prueba de diferentes entradas
        fila = 2'b00; #10; 
        fila = 2'b10; #10; 
        fila = 2'b11; #10; 
        fila = 2'b10; #10; 
        fila = 2'b00; #10; 
        fila = 2'b01; #10; 
        fila = 2'b01; #10; 
        fila = 2'b11; #10; 

        // Finaliza la simulación
        $stop;
    end

    // Monitorear las señales
    initial begin
        $monitor("Time: %0t | fila: %b | key_out: %b", $time, fila, key_out);
    end

endmodule
