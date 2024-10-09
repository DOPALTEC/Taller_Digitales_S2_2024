`timescale 1ns / 1ps


module UART #(parameter DATA_WIDTH = 8, parameter prescale=1303)(
    input  wire clk,
    input  wire rst,
    /*
     * AXI input
     */
    input  wire [DATA_WIDTH-1:0] dato_tx,
    output wire hay_dato_tx, //Se activa cuando hay un dato ingresado para enviar
    //Para pruebas usar un led
    input  wire transmitir, //En alto transmite el dato, para pruebas un boton

    /*
     * AXI output
     */
    output wire [DATA_WIDTH-1:0] dato_rx,
    output wire m_axis_tvalid,
    input  wire recibir,
    /*
     * UART interface
     */
    input  wire rxd,
    output wire txd,
    /*
     * Status
     */
    output wire tx_busy,
    output wire rx_busy,
    output wire rx_overrun_error,
    output wire rx_frame_error
    /*
     * Configuration
     */
    //input  wire [15:0] prescale
    );
    
    uart_tx #(
    .DATA_WIDTH(DATA_WIDTH), .prescale(prescale)
)
uart_tx_inst (
    .clk(clk),
    .rst(rst),
    // axi input
    .dato_tx(dato_tx),
    .transmitir(transmitir),
    .hay_dato_tx(hay_dato_tx),
    // output
    .txd(txd),
    // status
    .busy(tx_busy)
    // configuration
    //.prescale(prescale)
);

uart_rx #(
    .DATA_WIDTH(DATA_WIDTH), .prescale(prescale)
)
uart_rx_inst (
    .clk(clk),
    .rst(rst),
    // axi output
    .dato_rx(dato_rx),
    .m_axis_tvalid(m_axis_tvalid),
    .recibir(recibir),
    // input
    .rxd(rxd),
    // status
    .busy(rx_busy),
    .overrun_error(rx_overrun_error),
    .frame_error(rx_frame_error)
    // configuration
    //.prescale(prescale)
);
    
endmodule