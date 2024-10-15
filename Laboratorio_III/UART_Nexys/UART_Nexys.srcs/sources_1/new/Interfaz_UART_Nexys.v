`timescale 1ns / 1ps


//module Interfaz_UART_Nexys #(parameter Palabra = 32) (
//------------AL FINALIZAR PRUEBAS CAMBIAR A 32-------------------//
module Interfaz_UART_Nexys #(parameter Palabra = 8) (
    input  wire CLK100MHZ,
    input  wire rst,
    
    input wire wr_i, //usar switch
    input wire reg_sel_i, //usar switch, controla a los dos registros, dice cual de los dos opera
    
    input wire [Palabra-1:0]  entrada_i, //USAR SWITCHES
    input wire addr_i, //usar switch
    
    output wire [Palabra-1:0]  salida_o, //Usar LEDS 
    
    input  wire rxd, //Para el constraint
    output wire txd //Para el constraint
    );
    
/////////////////////DE-MULTIPLEXOR PARA ESCRITURA EN REGISTROS////////////////////////////////////
localparam addr2=1;
    
wire WR1_reg_ctrl;
wire WR1_reg_data;
    
DeMUX DeMUX_inst(
    .wr_i(wr_i),        // Bit de entrada
    .reg_sel_i(reg_sel_i),   // Bit de control
    .WR1_reg_ctrl(WR1_reg_ctrl), // Salida cuando reg_sel_i = 0
    .WR1_reg_data(WR1_reg_data) 
);

////////////////////////////////////REGISTRO DE DATOS//////////////////////////////////////////

wire [Palabra-1:0] OUT_data;
wire hold_ctrl;
wire WR2_reg_data;
wire [Palabra-1:0] IN2_data;

Reg_Data #(.Palabra(Palabra)) 
Reg_Data_inst(
    .IN1(entrada_i),       // Entrada 1 de 32 bits
    .IN2(IN2_data),       // Entrada 2 de 32 bits Proveniente de UART
    .addr1(addr_i),            // Línea de dirección para IN1
    .addr2(addr2),            // Línea de dirección para IN2 Proveniente de UART
    .WR1(WR1_reg_data),              // Bit de escritura para IN1
    .WR2(WR2_reg_data),              // Bit de escritura para IN2 Proveniente de UART
    .hold_ctrl(hold_ctrl),        // Control para seleccionar el registro Proveniente de UART
    .OUT(OUT_data)  
);

//////////////////////////////////////REGISTRO DE CONTROL/////////////////////////////////////////////////

wire [Palabra-1:0] OUT_ctrl;
wire WR2_ctrl;
wire [Palabra-1:0] IN2_ctrl;

Reg_ctrl #(.palabra(Palabra)) Reg_ctrl_inst(
    .IN1(entrada_i),       // Entrada 1 de 32 bits
    .IN2(IN2_ctrl),       // Entrada 2 de 32 bits
    .WR1(WR1_reg_ctrl),              // Señal de escritura 1
    .WR2(WR2_ctrl),  
    .rst(rst),            // Señal de escritura 2
    .out(OUT_ctrl) 
);

////////////MULTIPLEXOR QUE CONTROLA SI LA SALIDA ES EL REGISTRO DE DATOS O EL DE CONTROL////////////////////////

MUX_UI_UART #(.Palabra(Palabra)) MUX_UI_UART_inst (
    .OUT_ctrl(OUT_ctrl),  // Entrada 1
    .OUT_data(OUT_data),  // Entrada 2
    .reg_sel_i(reg_sel_i),              // Línea de selección
    .salida_o(salida_o)
);

///////////////CONTROL DE LA UART/////////////////////////////////

ctrl_UART #(.palabra(Palabra)) ctrl_UART_inst(
    .CLK100MHZ(CLK100MHZ),
    .rst(rst),
    
    // Entradas
    .reg_sel_i(reg_sel_i),
    .wr_i(wr_i),
    
    .ctrl(OUT_ctrl),    // Entrada de control
    .data(OUT_data),    // Entrada de datos

    // Salidas
    .IN2_data(IN2_data),    // Salida de datos IN2
    .WR2_data(WR2_reg_data), 
    .hold_ctrl(hold_ctrl),                 // Señal de escritura para datos
    .IN2_ctrl(IN2_ctrl),    // Salida de control IN2
    .WR2_ctrl(WR2_ctrl),                  // Señal de escritura para control
    // Dirección de salida
    //.addr2(1'b1),
    
    .rxd(rxd), //Para el constraint
    .txd(txd), //Para el constraint
    .rx_busy()
);


endmodule
