`timescale 1ns / 1ps

module tb_UART_Nexys;

parameter Palabra = 32;

//parameter prescale = 2604; //Para 200Mhz y Generar 9600 baudios (104,167us)

// Se�ales
reg clk;
reg rst;
reg wr_i;
reg reg_sel_i;

reg [Palabra-1:0] entrada_i;
reg addr_i;

wire [Palabra-1:0] salida_o;

reg rxd;
wire txd;

// Instancia del m�dulo UART_Nexys
Interfaz_UART_Nexys #(
    .Palabra(Palabra)) uut (
    .CLK100MHZ(clk),
    .rst(rst),
    .wr_i(wr_i), //usar switch
    .reg_sel_i(reg_sel_i), //usar switch, controla a los dos registros, dice cual de los dos opera
    
    .entrada_i(entrada_i), //USAR SWITCHES
    .addr_i(addr_i), //usar switch
    
    .salida_o(salida_o), //Usar LEDS 
    
    .rxd(rxd), //Para el constraint
    .txd(txd) //Para el constraint
);


always begin
    #5 clk = ~clk; // Genera un ciclo de reloj de 10 ns (100 MHz)
end

// Procedimiento inicial para la simulaci�n
initial begin
    // Inicializaci�n de se�ales
    clk = 0;
    rst = 1;
    
    wr_i=0;
    reg_sel_i=1;
    
    entrada_i=0;
    addr_i=0;

    rxd = 1;  // UART inactivo por defecto
    //prescale=16'd1303;
    //o
    //prescale = 16'd651;  // Prescaler para baudrate (aj�stalo seg�n la frecuencia de reloj)

    // Reinicio del sistema
    #5000;
    rst = 0;
    
    // Env�o de datos a trav�s de la UART
    #10000;
    wr_i=1;
    reg_sel_i=1;
    entrada_i=32'h00AAFF32;
    addr_i=0;
    #500;
    wr_i=0;
    // Simulaci�n de recepci�n de datos en UART
    
    #500;  // Tiempo para que el transmisor complete el env�o
    rxd = 0;  // Start bit
    #104167    // Tiempo para cada bit (ajustado seg�n baudrate)

    // Simulaci�n de bits de datos (del bit menos significativo al mas, de derecha a izquierda)
    //Segundo Termino
    rxd = 1;  #104167;
    rxd = 1;  #104167;
    rxd = 1;  #104167;
    rxd = 0;  #104167;
    //Primer termino
    rxd = 1;  #104167;
    rxd = 1;  #104167;
    rxd = 0;  #104167;
    rxd = 1;  #104167;

    // Stop bit
    rxd = 1;  #104167;

    // Simulaci�n de recepci�n

    #1000;
    //entrada_i=32'h00000001;
    //wr_i=1;
    //reg_sel_i=0;
    #50000;
    entrada_i=32'h00000000;
    wr_i=1;
    reg_sel_i=0;
    
    #100000;
    wr_i=0;
    reg_sel_i=1;
    
    #100000;
    entrada_i=32'h00000001;
    wr_i=1;
    reg_sel_i=0;
    
    #100000;
    wr_i=0;
    reg_sel_i=1;
    
    #50000;
    entrada_i=32'h00000000;
    wr_i=1;
    reg_sel_i=0;
    #100000;
    
    reg_sel_i=1;
    wr_i=0;
    
    


    #1000;
    $stop;  // Deten la simulaci�n
end

endmodule
