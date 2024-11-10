`timescale 1ns / 1ps

module Interfaz_UART_Nexys #(parameter palabra = 32, parameter prescale = 1303)(
    input  wire clk,
    input  wire rst,
    
    input wire wr_i, //usar switch
    input wire reg_sel_i, //usar switch, controla a los dos registros, dice cual de los dos opera
    input wire addr_i, //usar switch
    //output wire [Palabra-1:0]  salida_o, //Usar LEDS 
    //////BORRAR AL PROBAR///////////////////////////////////
    input wire [palabra-1:0] entrada_i,    // Entrada de control
    input wire [palabra-1:0] entrada_i_data,    // Entrada de datos

    // Salidas
    ///////Al Registro de Datos///////////////
    //output wire [palabra-1:0] IN2_data,    // Salida de datos IN2
    ///output wire WR2_data,      
    //output wire addr2,
    
    ///////Al Registro de Control///////////////
    output wire [palabra-1:0] ctrl,    // Salida de control IN2
    output wire [palabra-1:0] data,    // Salida de control IN2
    //output wire WR2_ctrl,  
    
    //output wire hold_ctrl,
    
    input  wire rxd, //Para el constraint
    output wire txd //Para el constraint
    ////////////////////////////////////////////////
    );

    wire locked;
    wire CLK_200MHZ;
        
  CLK_Gen CLK_200MHZ_inst
   (
    // Clock out ports
    .CLK_200MHZ(CLK_200MHZ),     // output CLK_200MHZ
    // Status and control signals
    .reset(rst), // input reset
    .locked(locked),       // output locked
   // Clock in ports
    .CLK_100MHZ(clk));      // input CLK_100MHZ
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
    wire WR2_ctrl;
    Reg_ctrl #(.palabra(palabra)) Reg_ctrl_inst(
        .clk(clk),                     // Señal de reloj
        .rst(rst),                     // Señal de reset 
        .locked(locked),
        .IN1(entrada_i),       // Entrada 1 de 32 bits
        .IN2(IN2_ctrl),       // Entrada 2 de 32 bits
        .WR1(WR1_reg_ctrl),                     // Señal de escritura 1 (para bit 0)
        .WR2(WR2_ctrl),                     // Señal de escritura 2 (para bit 1)
        .out(ctrl) 
    );
    
    wire hold_ctrl;
    wire [palabra-1:0] IN2_data;
    wire WR2_data;
    wire addr2;
    //wire data;
    
    // Instanciación del módulo Reg_Data
Reg_Data #(.Palabra(palabra)) reg_data_inst (
    .clk(clk),                 // Señal de reloj
    .rst(rst),                 // Señal de reset
    .locked(locked),           // Señal de locked
    .IN1(entrada_i_data),                 // Entrada 1 de 8 bits
    .IN2(IN2_data),                 // Entrada 2 de 8 bits
    .addr1(addr_i),             // Línea de dirección para IN1
    .addr2(addr2),             // Línea de dirección para IN2
    .WR1(WR1_reg_data),                 // Bit de escritura para IN1
    .WR2(WR2_data),                 // Bit de escritura para IN2
    .hold_ctrl(hold_ctrl),     // Control para seleccionar el registro
    .OUT(data)                  // Salida de 8 bits
);

    
    ctrl_UART #(.palabra(palabra), .prescale(prescale)) ctrl_UART_inst
    (
        .clk(clk),
        .rst(rst),
        .locked(locked),
        .reg_sel_i(reg_sel_i),
        .wr_i(wr_i),
        .addr_i(addr_i),
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



