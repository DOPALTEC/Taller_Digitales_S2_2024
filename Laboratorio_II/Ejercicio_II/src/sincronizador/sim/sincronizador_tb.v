`timescale 1ns / 1ps

module sincronizador_tb;

    // Declaración de señales
    reg clk;
    reg rst;
    reg [1:0] external_in;
    reg [1:0] counter_out;
    wire [3:0] Q;

    // Instanciación del módulo 
    sincronizador uut (
        .clk(clk),
        .rst(rst),
        .external_in(external_in),
        .counter_out(counter_out),
        .Q(Q)
    );

    // Generador de reloj
    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

    // Secuencia de prueba
    initial begin
        // Inicialización
        rst = 0;
        external_in = 2'b00;
        counter_out = 2'b00;
        #20;

        // Activar el reset
        rst = 1;
        external_in = 2'b01;
        counter_out = 2'b10;
        #20;
        external_in = 2'b11;
        counter_out = 2'b10;
        #20;
        external_in = 2'b10;
        counter_out = 2'b00;
        #20;

        // Finaliza la simulación
        $stop;
    end

    // Monitorear las señales
    initial begin
        $monitor("Time: %0t | counter_out: %b | external_in: %b | Q: %b", $time, counter_out, external_in, Q);
    end

endmodule
