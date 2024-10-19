`timescale 1ns / 1ps

module Interfaz_UART_Nexys_tb;

    // Par�metros
    parameter palabra = 8;
    parameter prescale = 2604; 

    // Se�ales de prueba
    reg clk;
    reg rst;
    reg wr_i;
    reg reg_sel_i;
    reg [palabra-1:0] entrada_i;    
    reg [palabra-1:0] data;    
    wire [palabra-1:0] IN2_data;    
    wire WR2_data;      
    wire addr2;
    reg rxd; // Se�al de recepci�n
    wire txd; // Se�al de transmisi�n

    // Instanciar el m�dulo ctrl_UART
    Interfaz_UART_Nexys #(
        .palabra(palabra),
        .prescale(prescale)
    ) Interfaz_UART_Nexys_inst (
        .clk(clk),
        .rst(rst),
        .wr_i(wr_i),
        .reg_sel_i(reg_sel_i),
        .entrada_i(entrada_i),
        .data(data),
        .IN2_data(IN2_data),
        .WR2_data(WR2_data),
        .addr2(addr2),
        .rxd(rxd),
        .txd(txd)
    );

    // Generar la se�al de reloj
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100 MHz
    end

    // Proceso de inicializaci�n y prueba
    initial begin
        // Inicializar se�ales
        rst = 1;
        entrada_i = 0;
        data = 0;
        rxd = 1; // Inicialmente inactivo
        wr_i=0;
        reg_sel_i=0;

        // Desactivar el reset
        #100000 
        rst = 0;
        data = 8'hAA; // Ejemplo de datos a transmitir

        // Esperar un tiempo y activar ctrl[0] para iniciar la transmisi�n
        #100000 
        //entrada_i = 8'h01;
        //wr_i=1;
    
    rxd = 0;  // Start bit
    #104167; // Tiempo entre bits para 9600 baudios
    rxd = 1;  #104167;
    rxd = 0;  #104167;
    rxd = 1;  #104167;
    rxd = 1;  #104167;
    rxd = 0;  #104167;  // Env�o de 8 bits simulados
    rxd = 1;  #104167;
    rxd = 0;  #104167;
    rxd = 1;  #104167; 
    rxd= 1; #104167; //Stop Bit

        // Esperar el tiempo necesario para la transmisi�n
    #50000;
    entrada_i = 8'h01;
    wr_i=1;
    reg_sel_i=0;
    
    rxd = 0;  // Start bit
    #104167; // Tiempo entre bits para 9600 baudios
    rxd = 1;  #104167;
    rxd = 0;  #104167;
    rxd = 1;  #104167;
    rxd = 0;  #104167;
    rxd = 1;  #104167;  // Env�o de 8 bits simulados
    rxd = 0;  #104167;
    rxd = 1;  #104167;
    rxd = 0;  #104167;
    rxd= 1; #104167; //Stop Bit
    
        entrada_i = 8'h00;
        #1000;
        wr_i=0;
        #50000;
        //wr_i=1;
        //reg_sel_i=0;
        // Dejar de transmitir
        //ctrl[0] = 0;

        // Verificar el comportamiento despu�s de la transmisi�n
        #5000000;

        // Realizar m�s pruebas aqu� si es necesario...

        // Finalizar simulaci�n
        #100 $finish;
    end

    // Monitor para ver las se�ales
    initial begin
        $monitor("Time: %0t | RST: %b | ENTRADA_i: %b | DATA: %h | WR2_DATA: %b | ADDR2: %b | IN2_DATA: %h | TXD: %b", 
                 $time, rst, entrada_i, data, WR2_data, addr2, IN2_data, txd);
    end

endmodule
