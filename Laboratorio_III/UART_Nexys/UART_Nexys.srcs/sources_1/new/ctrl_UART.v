`timescale 1ns / 1ps

module ctrl_UART #(
    parameter palabra = 32  // Tamaño por defecto de la palabra
    //parameter N = 2         // Tamaño por defecto de addr2
)(
    input  wire CLK100MHZ,
    input  wire rst,
    // Entradas
    input wire [palabra-1:0] ctrl,    // Entrada de control
    input wire [palabra-1:0] data,    // Entrada de datos

    // Salidas
    output reg [palabra-1:0] IN2_data,    // Salida de datos IN2
    output reg WR2_data,                  // Señal de escritura para datos
    output reg [palabra-1:0] IN2_ctrl,    // Salida de control IN2
    output reg WR2_ctrl,                  // Señal de escritura para control

    // Dirección de salida
    //output reg [N-1:0] addr2,             // Salida de dirección
    output reg addr2,
    
    input  wire rxd, //Para el constraint
    output wire txd //Para el constraint
);

//GENERACION DE ESTADOS
localparam IDLE=2'B00;


UART_Nexys #(.DATA_WIDTH(8), .prescale(1303))(
    .CLK100MHZ(CLK100MHZ),
    .rst(rst),

    .dato_tx(), //Es de 8 bits por tanto se debe empaquetar el envío de la palabra
    .hay_dato_tx(), //Se activa cuando hay un dato ingresado para enviar
    //Para pruebas usar un led
    .transmitir(), //En alto transmite el dato, para pruebas un boton

    .dato_rx(), 
    .m_axis_tvalid(),
    .recibir(), //NO afecta

    .rxd(rxd),
    .txd(txd),

    .tx_busy(),
    .rx_busy(),
    .rx_overrun_error(),
    .rx_frame_error()
);




endmodule
