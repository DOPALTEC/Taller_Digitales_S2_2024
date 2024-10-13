`timescale 1ns / 1ps

module tb_UART_Nexys;

parameter Palabra = 32;

// Señales
reg clk;
reg rst;
reg wr_i;
reg reg_sel_i;
reg [Palabra-1:0] entrada_i;
reg addr_i;
wire [Palabra-1:0] salida_o;
reg rxd;
wire txd;

// Instancia del módulo Interfaz_UART_Nexys
Interfaz_UART_Nexys #(
    .Palabra(Palabra)
) uut (
    .CLK100MHZ(clk),
    .rst(rst),
    .wr_i(wr_i), 
    .reg_sel_i(reg_sel_i), 
    .entrada_i(entrada_i), 
    .addr_i(addr_i), 
    .salida_o(salida_o), 
    .rxd(rxd), 
    .txd(txd)
);

// Generación del reloj de 100 MHz
always begin
    #5 clk = ~clk; // 100 MHz, 10ns por ciclo
end

// Procedimiento inicial para la simulación
initial begin
    // Inicialización de señales
    clk = 0;
    rst = 1;
    wr_i = 0;
    reg_sel_i = 1;
    entrada_i = 32'h00000000;
    addr_i = 0;
    rxd = 1;  // UART inactivo por defecto

    // Reinicio del sistema
    #5000;
    rst = 0;
    
    // Escenario 1: Escritura de un valor en el registro de datos
    #10000;
    wr_i = 1;
    reg_sel_i = 1;
    entrada_i = 32'hAA55FFA5;  // Valor de prueba para transmisión
    addr_i = 0;
    #100;
    wr_i = 0;  // Finaliza la escritura
    
    //Cambia al registro de control para transmitir el dato
    #10000;
    reg_sel_i=0;
    entrada_i = 32'h00000001; //bit send =1
    wr_i=1;
    #100000;
    wr_i=0;
    
    
    
    // Escenario 2: Simulación de recepción de datos en UART (RX)
    #500; 
    rxd = 0;  // Start bit
    #104167; // Tiempo entre bits para 9600 baudios
    rxd = 1;  #104167;
    rxd = 0;  #104167;
    rxd = 1;  #104167;
    rxd = 1;  #104167;
    rxd = 0;  #104167;  // Envío de 8 bits simulados
    rxd = 1;  #104167;
    rxd = 0;  #104167;
    rxd = 1;  #104167; // Stop bit
    
    // Pausa para observar la recepcion
    #100000;
    wr_i = 1;
    reg_sel_i = 1;
    #100;
    // Escenario 3: Cambia el dato de entrada y prueba otro valor de transmisión
    entrada_i = 32'h11223344;

    #500;
    wr_i = 0;

    // Detenemos la simulación
    #200000;
    $stop;
end

endmodule
