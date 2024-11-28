`timescale 1ns / 1ps

module tb_Lab_III;
    parameter prescale = 1302;
    // Se�ales del testbench
    reg clk;
    reg rst;
    reg rxd;
    wire txd;
    
    reg rxd_B;
    wire txd_B;

    // Instanciaci�n de la unidad bajo prueba
    Primario #(.prescale(prescale)) uut (
        .clk(clk),
        .rst(rst),
        .SW(),
        .LED(),
        .BTNU(),
        .BTNL(),
        .BTNR(),
        .BTND(),
        .rxd(rxd),
        .txd(txd),
        .rxd_B(rxd_B),
        .txd_B(txd_B)
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
        rxd_B=1;
        #10;      // Esperar 200 ns para estabilizar
        rst = 0;   // Desactivar reset

        // Ejecutar simulaci�n
        #800;    // Simulaci�n de 10,000 ns (10 �s)
        
   #500;  // Tiempo para que el transmisor complete el env?o
   
   
           rxd = 0;  // Start bit
    #104167    // Tiempo para cada bit (ajustado seg?n baudrate)
    rxd = 0;  #104167;
    rxd = 1;  #104167;
    rxd = 0;  #104167;
    rxd = 0;  #104167;
    rxd = 0;  #104167;
    rxd = 0;  #104167;
    rxd = 0;  #104167;
    rxd = 0;  #104167;

    // Stop bit
    rxd = 1;  #104167;
    
    
    ///////PRIMERA PALABRA//////////////
    
        rxd = 0;  // Start bit
    #104167    // Tiempo para cada bit (ajustado seg?n baudrate)
    rxd = 0;  #104167;
    rxd = 1;  #104167;
    rxd = 1;  #104167;
    rxd = 1;  #104167;
    rxd = 1;  #104167;
    rxd = 1;  #104167;
    rxd = 0;  #104167;
    rxd = 1;  #104167;

    // Stop bit
    rxd = 1;  #104167;
    
    
            rxd = 0;  // Start bit
    #104167    // Tiempo para cada bit (ajustado seg?n baudrate)
    rxd = 0;  #104167;
    rxd = 1;  #104167;
    rxd = 1;  #104167;
    rxd = 1;  #104167;
    rxd = 1;  #104167;
    rxd = 1;  #104167;
    rxd = 0;  #104167;
    rxd = 1;  #104167;

    // Stop bit
    rxd = 1;  #104167;
    
    
         rxd = 0;  // Start bit
    #104167    // Tiempo para cada bit (ajustado seg?n baudrate)
    rxd = 0;  #104167;
    rxd = 1;  #104167;
    rxd = 0;  #104167;
    rxd = 1;  #104167;
    rxd = 0;  #104167;
    rxd = 0;  #104167;
    rxd = 1;  #104167;
    rxd = 1;  #104167;

    // Stop bit
    rxd = 1;  #104167;
    
    
        rxd = 0;  // Start bit
    #104167    // Tiempo para cada bit (ajustado seg?n baudrate)
    rxd = 0;  #104167;
    rxd = 0;  #104167;
    rxd = 0;  #104167;
    rxd = 0;  #104167;
    rxd = 1;  #104167;
    rxd = 1;  #104167;
    rxd = 1;  #104167;
    rxd = 1;  #104167;

    // Stop bit
    rxd = 1;  #104167;
//////////SEGUNDA PALABRA//////////////////
   
    rxd = 0;  // Start bit
    #104167    // Tiempo para cada bit (ajustado seg?n baudrate)

    // Simulaci?n de bits de datos (env?a 8'hA5)
    rxd = 1;  #104167;
    rxd = 0;  #104167;
    rxd = 1;  #104167;
    rxd = 1;  #104167;
    rxd = 1;  #104167;
    rxd = 0;  #104167;
    rxd = 0;  #104167;
    rxd = 0;  #104167;

    // Stop bit
    rxd = 1;  #104167;
    
    #104167;
    
    rxd = 0;  // Start bit
    #104167    // Tiempo para cada bit (ajustado seg?n baudrate)
    rxd = 1;  #104167;
    rxd = 1;  #104167;
    rxd = 0;  #104167;
    rxd = 1;  #104167;
    rxd = 0;  #104167;
    rxd = 1;  #104167;
    rxd = 0;  #104167;
    rxd = 1;  #104167;

    // Stop bit
    rxd = 1;  #104167;
    
    
    #104167;
    
    rxd = 0;  // Start bit
    #104167    // Tiempo para cada bit (ajustado seg?n baudrate)
    rxd = 1;  #104167;
    rxd = 0;  #104167;
    rxd = 1;  #104167;
    rxd = 1;  #104167;
    rxd = 0;  #104167;
    rxd = 0;  #104167;
    rxd = 0;  #104167;
    rxd = 0;  #104167;

    // Stop bit
    rxd = 1;  #104167;
    
    #104167;

        rxd = 0;  // Start bit
    #104167    // Tiempo para cada bit (ajustado seg?n baudrate)
    rxd = 0;  #104167;
    rxd = 0;  #104167;
    rxd = 0;  #104167;
    rxd = 0;  #104167;
    rxd = 0;  #104167;
    rxd = 0;  #104167;
    rxd = 0;  #104167;
    rxd = 0;  #104167;

    // Stop bit
    rxd = 1;  #104167;
    

    
    #104167;
  
  //////PETICION DE IMAGEN 1
  
      rxd_B = 0;  // Start bit
    #104167    // Tiempo para cada bit (ajustado seg?n baudrate)
    rxd_B = 0;  #104167;
    rxd_B = 1;  #104167;
    rxd_B = 0;  #104167;
    rxd_B = 0;  #104167;
    rxd_B = 0;  #104167;
    rxd_B = 0;  #104167;
    rxd_B = 0;  #104167;
    rxd_B = 0;  #104167; 
    // Stop bit
    rxd_B = 1;  #104167;

    #3004167;
        // Terminar la simulaci�n
        $finish;
    end

endmodule
