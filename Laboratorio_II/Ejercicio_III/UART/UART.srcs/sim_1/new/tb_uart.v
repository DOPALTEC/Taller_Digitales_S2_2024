`timescale 1ns / 1ps

module tb_uart;

// Par�metros
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

// Est�mulos de simulaci�n
reg [DATA_WIDTH-1:0] tx_muestreado;
reg [DATA_WIDTH-1:0] rx_esperado;
integer i;
integer seed;

initial begin
    // Inicializaci�n de se�ales
    rst = 1;
    s_axis_tdata = 8'h00;
    s_axis_tvalid = 0;
    m_axis_tready = 0;
    rxd = 1;  // Inactivo (idle) es alto
    prescale = 16'd1302; // Configuraci�n de prescaler para tasa de baudios
    seed = 32'h6C1322A8;
    
    //Inicializar se�ales de verificaci�n///
    tx_muestreado=0;
    rx_esperado=0;
    
    ////////////////////////////////////////

    // Liberaci�n del reset despu�s de un tiempo
    #20;
    rst = 0;

    // Espera para estabilizar
    #100;

    // Prueba de transmisi�n
 // Generaci�n de valores aleatorios
    s_axis_tdata = $random(seed);  // Dato a transmitir esperado aleatorio
    rx_esperado = $random(seed);   // Dato a recibir esperado aleatorio
    
    //Bits de Activacion de Env�o y Recepci�n
    s_axis_tvalid = 1;  //Activa el envio de datos
    m_axis_tready = 1;  // Aceptar datos recibidos

    
    rxd = 0; // Start bit para receptor
    
    for(i=0; i<DATA_WIDTH;i=i+1)begin
        #104167 tx_muestreado[i]=txd;
        rxd=rx_esperado[i];
    end
    s_axis_tvalid = 0;  // Finaliza la transmisi�n de datos
    #104167 rxd = 1;  // Stop bit
    #104167;

    // Espera para observar las se�ales de salida
    #500;
    
    m_axis_tready = 0;  // Aceptar datos recibidos
    
    if(s_axis_tdata==tx_muestreado)begin
        $display("Transmision Exitosa: Los datos enviados (%b) coinciden con los datos que se esperan transmitir(%b)", tx_muestreado, s_axis_tdata);
    end
    else begin
        $display("Transmision Fallida: Los datos enviados (%b) NO coinciden con los datos que se esperan transmitir(%b)", tx_muestreado, s_axis_tdata);
    end
    
    if(rx_esperado==m_axis_tdata)begin
        $display("Recepcion Exitosa: Los datos recibidos (%b) coinciden con los datos que se esperan recibir(%b)", m_axis_tdata, rx_esperado);
    end
    else begin
        $display("Recepcion Fallida: Los datos recibidos (%b) NO coinciden con los datos que se esperan recibir(%b)", m_axis_tdata, rx_esperado);
    end
    #500;
    
    $finish;
end

endmodule
