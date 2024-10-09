`timescale 1ns / 1ps

module tb_UART_Nexys;

// Parámetros del diseño
parameter DATA_WIDTH = 8;
parameter prescale = 1303;

// Señales
reg clk;
reg rst;
reg [DATA_WIDTH-1:0] s_axis_tdata;
reg s_axis_tvalid;
wire s_axis_tready;
wire [DATA_WIDTH-1:0] m_axis_tdata;
wire m_axis_tvalid;
reg m_axis_tready;
reg rxd;
wire txd;
wire tx_busy;
wire rx_busy;
wire rx_overrun_error;
wire rx_frame_error;
//reg [15:0] prescale;

// Instancia del módulo UART_Nexys
UART_Nexys #(
    .DATA_WIDTH(DATA_WIDTH), .prescale(prescale)
) uut (
    .clk(clk),
    .rst(rst),
    .s_axis_tdata(s_axis_tdata),
    .s_axis_tvalid(s_axis_tvalid),
    .s_axis_tready(s_axis_tready),
    .m_axis_tdata(m_axis_tdata),
    .m_axis_tvalid(m_axis_tvalid),
    .m_axis_tready(m_axis_tready),
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
    s_axis_tdata = 0;
    s_axis_tvalid = 0;
    m_axis_tready = 0;
    rxd = 1;  // UART inactivo por defecto
    //prescale=16'd1303;
    //o
    //prescale = 16'd651;  // Prescaler para baudrate (ajústalo según la frecuencia de reloj)

    // Reinicio del sistema
    #5000;
    rst = 0;
    
    // Envío de datos a través de la UART
    #10000;
    s_axis_tdata = 8'hA5;  // Datos a enviar
    s_axis_tvalid = 1;
    #937503;
    //wait (s_axis_tready);  // Espera hasta que UART esté lista
    m_axis_tready=1;
    s_axis_tvalid=0;
   
    
    
    //s_axis_tvalid = 0;     // Desactiva el tvalid después de que se acepte
    
    // Simulación de recepción de datos en UART
    #500;  // Tiempo para que el transmisor complete el envío
    //m_axis_tready = 0;
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
    m_axis_tready = 0;  // El receptor está listo para recibir datos

    #1000;
    $stop;  // Deten la simulación
end

endmodule
