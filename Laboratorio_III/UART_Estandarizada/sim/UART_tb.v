`timescale 1ns / 1ps

module tb_UART;

// Par�metros del dise�o
parameter DATA_WIDTH = 8;
parameter prescale = 1303;

// Se�ales
reg clk;
reg rst;
reg [DATA_WIDTH-1:0] dato_tx;
wire hay_dato_tx;
reg transmitir;
wire txd;
wire tx_busy;
reg recibir;
reg rxd;
wire rx_busy;
wire [DATA_WIDTH-1:0] dato_rx;
wire m_axis_tvalid;
wire rx_overrun_error;
wire rx_frame_error;
//reg [15:0] prescale;

// Instancia del m�dulo UART_Nexys
UART #(
    .DATA_WIDTH(DATA_WIDTH), .prescale(prescale)
) uut (
    .CLK100MHZ(clk),
    .rst(rst),
    .dato_tx(dato_tx),
    .transmitir(transmitir),
    .hay_dato_tx(hay_dato_tx),
    .dato_rx(dato_rx),
    .m_axis_tvalid(m_axis_tvalid),
    .recibir(recibir),
    .rxd(rxd),
    .txd(txd),
    .tx_busy(tx_busy),
    .rx_busy(rx_busy),
    .rx_overrun_error(rx_overrun_error),
    .rx_frame_error(rx_frame_error)
    //.prescale(prescale)
);


always begin
    #5 clk = ~clk; // Genera un ciclo de reloj de 10 ns (100 MHz)
end

// Procedimiento inicial para la simulaci�n
initial begin
    // Inicializaci�n de se�ales
    clk = 0;
    rst = 1;
    dato_tx = 0;
    transmitir = 0;
    recibir = 0;
    rxd = 1;  // UART inactivo por defecto
    //prescale=16'd1303;
    //o
    //prescale = 16'd651;  // Prescaler para baudrate (aj�stalo seg�n la frecuencia de reloj)

    // Reinicio del sistema
    #5000;
    rst = 0;
    
    // Env�o de datos a trav�s de la UART
    #10000;
    dato_tx = 8'hA5;  // Datos a enviar
    #100000;
    transmitir = 1;
    #937503;
    //wait (s_axis_tready);  // Espera hasta que UART est� lista
    recibir=1;
    transmitir=0;
   

    
    // Simulaci�n de recepci�n de datos en UART
    #500;  // Tiempo para que el transmisor complete el env�o
    rxd = 0;  // Start bit
    #104167    // Tiempo para cada bit (ajustado seg�n baudrate)

    // Simulaci�n de bits de datos (env�a 8'hA5)
    rxd = 1;  #104167;
    rxd = 0;  #104167;
    rxd = 1;  #104167;
    rxd = 0;  #104167;
    rxd = 1;  #104167;
    rxd = 0;  #104167;
    rxd = 1;  #104167;
    rxd = 0;  #104167;

    // Stop bit
    rxd = 1;  #104167;

    // Simulaci�n de recepci�n
    #500;
    recibir = 0;  // El receptor est� listo para recibir datos

    #1000;
    $stop;  // Deten la simulaci�n
end

endmodule
