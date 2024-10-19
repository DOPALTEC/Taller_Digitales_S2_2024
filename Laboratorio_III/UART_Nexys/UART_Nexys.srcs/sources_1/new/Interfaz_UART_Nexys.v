`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////////////


module Interfaz_UART_Nexys #(parameter palabra = 8, parameter prescale = 2604)(
    input  wire clk,
    input  wire rst,
    
    input wire wr_i, //usar switch
    input wire reg_sel_i, //usar switch, controla a los dos registros, dice cual de los dos opera
    //input wire addr_i, //usar switch
    //output wire [Palabra-1:0]  salida_o, //Usar LEDS 
    //////BORRAR AL PROBAR///////////////////////////////////
    input wire [palabra-1:0] entrada_i,    // Entrada de control
    input wire [palabra-1:0] data,    // Entrada de datos

    // Salidas
    ///////Al Registro de Datos///////////////
    output wire [palabra-1:0] IN2_data,    // Salida de datos IN2
    output wire WR2_data,      
    output wire addr2,
    
    ///////Al Registro de Control///////////////
    output wire [palabra-1:0] ctrl,    // Salida de control IN2
    output wire WR2_ctrl,  
    
    output wire hold_ctrl,
    
    input  wire rxd, //Para el constraint
    output wire txd //Para el constraint
    ////////////////////////////////////////////////
    );

    wire locked;
    wire CLK_200MHZ;
        
  CLK_GEN_200MHz instance_name
   (
    // Clock out ports
    .CLK200MHZ(CLK_200MHZ),     // output CLK200MHZ
    // Status and control signals
    .reset(rst), // input reset
    .locked(locked),       // output locked
   // Clock in ports
    .CLK100MHZ(clk));      // input CLK100MHZ
// INST_TAG_END ------ End INSTANTIATION Template ---------
    
    wire WR1_reg_ctrl;
    wire WR1_reg_data;
    DeMUX DeMUX_inst (
        .wr_i(wr_i),              // Conectar señal wr_i
        .reg_sel_i(reg_sel_i),    // Conectar señal reg_sel_i
        .WR1_reg_ctrl(WR1_reg_ctrl),  // Conectar salida WR1_reg_ctrl
        .WR1_reg_data(WR1_reg_data)   // Conectar salida WR1_reg_data
    );

    
    wire [palabra-1:0] IN2_ctrl;
    Reg_ctrl #(.palabra(palabra)) Reg_ctrl_inst(
        .clk(CLK_200MHZ),                     // Señal de reloj
        .rst(rst),                     // Señal de reset 
        .locked(locked),
        .IN1(entrada_i),       // Entrada 1 de 32 bits
        .IN2(IN2_ctrl),       // Entrada 2 de 32 bits
        .WR1(WR1_reg_ctrl),                     // Señal de escritura 1 (para bit 0)
        .WR2(WR2_ctrl),                     // Señal de escritura 2 (para bit 1)
        .out(ctrl) 
    );
    
    
    ctrl_UART #(.palabra(palabra), .prescale(prescale)) ctrl_UART_inst
    (
        .clk(CLK_200MHZ),
        .rst(rst),
        .locked(locked),
        .ctrl(ctrl),
        .data(data),
        .IN2_data(IN2_data),
        .WR2_data(WR2_data),
        .addr2(addr2),
        .IN2_ctrl(IN2_ctrl),
        .WR2_ctrl(WR2_ctrl),
        .hold_ctrl(hold_ctrl),
        .rxd(rxd),
        .txd(txd)
    );
endmodule



