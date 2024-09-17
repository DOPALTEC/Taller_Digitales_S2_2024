`timescale 1ns / 1ps

module tb_uart;

// Parametros
parameter DATA_WIDTH = 8;
//Entradas: reg
//Salidas: wire

reg clk;
reg rst;
reg [15:0] prescale;


//////////////////SEÑALES PARA DISPOSITIVO #1////////////////////////
//TX

reg [DATA_WIDTH-1:0] s_axis_tdata;
reg s_axis_tvalid;
//wire txd;
wire tx_busy;
wire s_axis_tready;

//RX
wire m_axis_tvalid;
reg m_axis_tready;
//reg rxd;
wire rx_busy;

wire [DATA_WIDTH-1:0] m_axis_tdata;


wire rx_overrun_error;
wire rx_frame_error;

//////////////////SEÑALES PARA DISPOSITIVO #2////////////////////////

reg [DATA_WIDTH-1:0] s_axis_tdata_2;
reg s_axis_tvalid_2;
//wire txd_2;
wire tx_busy_2;
wire s_axis_tready_2;

//RX
wire m_axis_tvalid_2;
reg m_axis_tready_2;
//reg rxd_2;
wire rx_busy_2;

wire [DATA_WIDTH-1:0] m_axis_tdata_2;


wire rx_overrun_error_2;
wire rx_frame_error_2;

///////Generacion de Cables para Interconectar tx´s con rx´s

wire tx_to_rx_1_2;
wire tx_to_rx_2_1;

//assign tx_to_rx_1_2 = txd;  // Conectar el transmisor del dispositivo 1 al receptor del dispositivo 2
//assign tx_to_rx_2_1 = txd_2; // Conectar el transmisor del dispositivo 2 al receptor del dispositivo 1


// DISPOSITIVO #1: Instancia del DUT (UART completo) 
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
    .rxd(tx_to_rx_2_1),
    .txd(tx_to_rx_1_2),
    .tx_busy(tx_busy),
    .rx_busy(rx_busy),
    .rx_overrun_error(rx_overrun_error),
    .rx_frame_error(rx_frame_error),
    .prescale(prescale)
);


//DISPOSITIVO #2


uart #(
    .DATA_WIDTH(DATA_WIDTH)
)
uart_inst_2 (
    .clk(clk),
    .rst(rst),
    .s_axis_tdata(s_axis_tdata_2),
    .s_axis_tvalid(s_axis_tvalid_2),
    .s_axis_tready(s_axis_tready_2),
    .m_axis_tdata(m_axis_tdata_2),
    .m_axis_tvalid(m_axis_tvalid_2),
    .m_axis_tready(m_axis_tready_2),
    .rxd(tx_to_rx_1_2),
    .txd(tx_to_rx_2_1),
    .tx_busy(tx_busy_2),
    .rx_busy(rx_busy_2),
    .rx_overrun_error(rx_overrun_error_2),
    .rx_frame_error(rx_frame_error_2),
    .prescale(prescale)
);


// Generador de reloj
initial begin
    clk = 0;
    forever #5 clk = ~clk; // Genera un ciclo de reloj de 10 ns (100 MHz)
end


integer seed;

initial begin
    // Inicializacion de senhales
    rst = 1;
    s_axis_tdata = 8'h00;
    s_axis_tdata_2 = 8'h00;
    s_axis_tvalid = 0;
    s_axis_tvalid_2 = 0;
    m_axis_tready = 0;
    m_axis_tready_2 = 0;
    //rxd = 1;  // Inactivo (idle) es alto
    //rxd_2 = 1;  // Inactivo (idle) es alto
    prescale = 16'd1302; // Configuraciï¿½n de prescaler para tasa de baudios
    seed = 32'h6C1322A8;
    
    //Inicializar senhales de verificacion

    
    ////////////////////////////////////////

    // Liberaciï¿½n del reset despuï¿½s de un tiempo
    #20;
    rst = 0;

    // Espera para estabilizar
    #100;

    // Prueba de transmisiï¿½n
 // Generaciï¿½n de valores aleatorios
    s_axis_tdata = $random(seed);  // Dato a transmitir esperado aleatorio
    s_axis_tdata_2 = $random(seed);   // Dato a recibir esperado aleatorio
    
    
    
    //Bits de Activacion de Envio y Recepcion
    s_axis_tvalid = 1;  //Activa el envio de datos
    s_axis_tvalid_2 = 1;  //Activa el envio de datos
    
    
    #937503;
    
    m_axis_tready = 1;  // Aceptar datos recibidos
    m_axis_tready_2 = 1;  // Aceptar datos recibidos

    
    //rxd = 0; // Start bit para receptor
    //rxd_2 = 0; // Start bit para receptor
    

    s_axis_tvalid = 0;  // Finaliza la transmisiï¿½n de datos
    s_axis_tvalid_2 = 0;  // Finaliza la transmisiï¿½n de datos
    //#104167 rxd = 1;  // Stop bit
    //rxd_2 = 1;  // Stop bit
    //#104167;

    // Espera para observar las seï¿½ales de salida
    #500;
    
    m_axis_tready = 0;  // Aceptar datos recibidos
    m_axis_tready_2 = 0;  // Aceptar datos recibidos
     #937503;
    //si el valor transmitido de #1 es el mismo que el recibido en el 2 y viceversa...
    if((s_axis_tdata==m_axis_tdata_2)||(s_axis_tdata_2==m_axis_tdata))begin
        $display("Transmision y Recepcion Exitosa:\n|Dispositivo|---TX---|---RX---|\n|-----1-----|---%h---|---%h---|\n|-----2-----|---%h---|---%h---|", s_axis_tdata, m_axis_tdata,s_axis_tdata_2, m_axis_tdata_2);
    end
    else begin
        $display("Transmision y Recepcion Fallida:\n|Dispositivo|---TX---|---RX---|\n|-----1-----|---%h---|---%h---|\n|-----2-----|---%h---|---%h---|", s_axis_tdata, m_axis_tdata,s_axis_tdata_2, m_axis_tdata_2);
    end

    #500;
    
    $finish;
end

endmodule
