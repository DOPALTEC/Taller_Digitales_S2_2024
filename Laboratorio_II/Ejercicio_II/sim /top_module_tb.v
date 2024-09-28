`timescale 1ns / 1ps

module tb_top_module;

    // Definición de señales
    reg clk;
    reg reset;
    reg [1:0] fila;               // Entrada de 2 bits (fila)
    wire [1:0] count;            // Salida del contador
    wire [3:0] Q;                // Salida del sincronizador

    // Instancia del top module
    top_module uut (
        .clk(clk),
        .reset(reset),
        .fila(fila),              // Conecta fila directamente
        .count(count),
        .Q(Q)
    );

    // Generador de reloj
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // Cambia el reloj cada 10ns
    end

    // Bloque de estímulos
    initial begin
        // Inicialización
        reset = 0;
        fila = 2'b00;  // Inicializa la fila
        #20;           // Espera 100ns

        // Desactiva el reset
        reset = 1;
        #20;            // Espera 20ns

        // Prueba de la detección de claves
        fila = 2'b01;   // Cambia la fila
        #300;            // Espera 20ns
        fila = 2'b00;   // Cambia nuevamente la fila
        #20;            // Espera 20ns
        fila = 2'b01;   // Cambia la fila
        #20;            // Espera 20ns
        fila = 2'b10;   // Cambia a otra fila
        #300;            // Espera 20ns
        fila = 2'b11;   // Cambia a otra fila
        #300;            // Espera 20ns
        fila = 2'b00;   // Vuelve a 00
        #20;            // Espera 20ns


        // Termina la simulación
        $stop;
    end
        // Monitorear las señales
    initial begin
        $monitor("Time: %0t | fila: %b | count: %b |Q: %b" , $time, fila, count, Q);
    end

endmodule
