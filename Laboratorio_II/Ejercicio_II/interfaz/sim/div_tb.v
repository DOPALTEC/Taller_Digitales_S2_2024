`timescale 1ms / 100us

module tb_clock_divider;

    // Entradas
    reg clk;
    reg rst_n;
    
    // Salidas
    wire slow_clk;
    
    // Parámetro de frecuencia del reloj
    localparam FAST_CLOCK_FREQ = 100; 
    
    // Instanciar el módulo que se va a probar
    clock_divider uut (
        .clk(clk),
        .rst_n(rst_n),
        .slow_clk(slow_clk)
    );

    // Generar la señal de reloj rápido (clk)
    always #1 clk = ~clk;  

    initial begin
        // Inicializar señales
        clk = 0;
        rst_n = 0;  

        // Monitorear cambios en las señales
        $monitor("Tiempo: %0t, clk: %b, rst_n: %b, slow_clk: %b", $time, clk, rst_n, slow_clk);
        
        #5 rst_n = 1;  // Liberar reset 

        // Dejar correr el sistema por suficiente tiempo para observar varios ciclos de slow_clk
        #5000;  

        // Finalizar la simulación
        $finish;
    end
endmodule
