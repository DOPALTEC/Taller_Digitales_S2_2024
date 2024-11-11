`timescale 1ns / 1ps

module tb_Primario;
    parameter prescale = 1302;
    // Se�ales del testbench
    reg clk;
    reg rst;
    reg rxd;
    wire txd;

    // Instanciaci�n de la unidad bajo prueba
    Primario #(.prescale(prescale)) uut (
        .clk(clk),
        .rst(rst),
        .rxd(rxd),
        .txd(txd)
    );

    // Generaci�n de reloj
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // Periodo de reloj de 10 ns (100 MHz)
    end

    // Inicializaci�n y simulaci�n
    initial begin
        // Inicializar se�ales
        rst = 1;   // Activar reset
        rxd=1;
        #10;      // Esperar 200 ns para estabilizar
        rst = 0;   // Desactivar reset

        // Ejecutar simulaci�n
        #800;    // Simulaci�n de 10,000 ns (10 �s)
        
   #500;  // Tiempo para que el transmisor complete el env?o
    rxd = 0;  // Start bit
    #104167    // Tiempo para cada bit (ajustado seg?n baudrate)

    // Simulaci?n de bits de datos (env?a 8'hA5)
    rxd = 1;  #104167;
    rxd = 0;  #104167;
    rxd = 1;  #104167;
    rxd = 0;  #104167;
    rxd = 0;  #104167;
    rxd = 1;  #104167;
    rxd = 0;  #104167;
    rxd = 1;  #104167;

    // Stop bit
    rxd = 1;  #104167;

        // Terminar la simulaci�n
        $finish;
    end

endmodule
