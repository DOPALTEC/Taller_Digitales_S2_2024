`timescale 1ns / 1ps

module tb_UART_Nexys;

// Parámetros del diseño
parameter DATA_WIDTH = 8;
parameter prescale = 1303;

// Señales
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

// Instancia del módulo UART_Nexys
UART_Nexys #(
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

// Procedimiento inicial para la simulación
initial begin
    // Inicialización de señales
    clk = 0;
    rst = 1;
    dato_tx = 0;
    transmitir = 0;
    recibir = 0;
    rxd = 1;  // UART inactivo por defecto
    //prescale=16'd1303;
    //o
    //prescale = 16'd651;  // Prescaler para baudrate (ajústalo según la frecuencia de reloj)

    // Reinicio del sistema
    #5000;
    rst = 0;
    
    // Envío de datos a través de la UART
    #10000;
    dato_tx = 8'hA5;  // Datos a enviar
    #100000;
    transmitir = 1;
    #937503;
    //wait (s_axis_tready);  // Espera hasta que UART esté lista
    recibir=1;
    transmitir=0;
   

    
    // Simulación de recepción de datos en UART
    #500;  // Tiempo para que el transmisor complete el envío
    rxd = 0;  // Start bit
    #104167    // Tiempo para cada bit (ajustado según baudrate)

    // Simulación de bits de datos (envía 8'hA5)
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

    // Simulación de recepción
    #500;
    recibir = 0;  // El receptor está listo para recibir datos

    #1000;
    $stop;  // Deten la simulación
end

endmodule
