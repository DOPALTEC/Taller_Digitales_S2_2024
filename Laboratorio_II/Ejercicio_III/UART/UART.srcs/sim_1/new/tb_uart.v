`timescale 1ns / 1ps

module tb_uart;

// Parámetros
parameter DATA_WIDTH = 8;
//Entradas: reg
//Salidas: wire

reg clk;
reg rst;
reg [15:0] prescale;

//TX

reg [DATA_WIDTH-1:0] s_axis_tdata;
reg s_axis_tvalid;
wire txd;
wire tx_busy;
wire s_axis_tready;

//RX
wire m_axis_tvalid;
reg m_axis_tready;
reg rxd;
wire rx_busy;

wire [DATA_WIDTH-1:0] m_axis_tdata;


wire rx_overrun_error;
wire rx_frame_error;

// Instancia del DUT (UART completo)
uart #(
    .DATA_WIDTH(DATA_WIDTH)
)
uart_inst (
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
    .rx_frame_error(rx_frame_error),
    .prescale(prescale)
);

// Generador de reloj
initial begin
    clk = 0;
    forever #5 clk = ~clk; // Genera un ciclo de reloj de 10 ns (100 MHz)
end

// Estímulos de simulación
reg [DATA_WIDTH-1:0] tx_muestreado;
reg [DATA_WIDTH-1:0] rx_muestreado;
reg [DATA_WIDTH-1:0] rx_recibido;
integer i;

initial begin
    // Inicialización de señales
    rst = 1;
    s_axis_tdata = 8'h00;
    s_axis_tvalid = 0;
    m_axis_tready = 0;
    rxd = 1;  // Inactivo (idle) es alto
    prescale = 16'd1302; // Configuración de prescaler para tasa de baudios
    
    //Inicializar señales de verificación///
    tx_muestreado=0;
    rx_muestreado=0;
    rx_recibido=0;
    
    ////////////////////////////////////////

    // Liberación del reset después de un tiempo
    #20;
    rst = 0;

    // Espera para estabilizar
    #100;

    // Prueba de transmisión
    s_axis_tdata = 8'hA5;  // Dato a transmitir
    s_axis_tvalid = 1;
    for(i=0; i<DATA_WIDTH;i=i+1)begin
        #104167 tx_muestreado[i]=txd;
    end
    #10;
    s_axis_tvalid = 0;  // Finaliza la transmisión de datos

    // Espera mientras el dato se transmite
    #200;
    rx_recibido=8'hDA;
    // Simula recepción de datos
    m_axis_tready = 1;  // Aceptar datos recibidos
    // Simula el envío de bits de datos (0xA5)
    rxd = 0; // Start bit
    for(i=0; i<DATA_WIDTH;i=i+1)begin
        #104167 rxd=rx_recibido[i];
    end
    #104167 rxd = 1;  // Stop bit
    #104167;
    
    
    //#104167 rxd = 0;  // Start bit
    //#104167 rxd = 0;  // Bit 0 LSB (Bit mas a la derecha)
    //#104167 rxd = 1;  // Bit 1
    //#104167 rxd = 0;  // Bit 2
    //#104167 rxd = 1;  // Bit 3
    //#104167 rxd = 1;  // Bit 4
    //#104167 rxd = 0;  // Bit 5
    //#104167 rxd = 1;  // Bit 6
    //#104167 rxd = 1;  // Bit 7 MSB (Bit Mas a la Izquierda)
    //#104167 rxd = 1;  // Stop bit
    //#104167;

    // Espera para observar las señales de salida
    #500;
    
    m_axis_tready = 0;  // Aceptar datos recibidos
    
    if(s_axis_tdata==tx_muestreado)begin
        $display("Transmision Exitosa: Los datos enviados (%b) coinciden con los datos que se esperan transmitir(%b)", tx_muestreado, s_axis_tdata);
    end
    else begin
        $display("Transmision Fallida: Los datos enviados (%b) NO coinciden con los datos que se esperan transmitir(%b)", tx_muestreado, s_axis_tdata);
    end
    #500;
    
    $finish;
end

endmodule
