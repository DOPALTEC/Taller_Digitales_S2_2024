`timescale 1ns / 1ps


//module Interfaz_UART_Nexys #(parameter Palabra = 32) (
//------------AL FINALIZAR PRUEBAS CAMBIAR A 32-------------------//
module Interfaz_UART_Nexys #(parameter Palabra = 8) (
    input  wire CLK100MHZ,
    input  wire rst,
    
    input wire wr_i, //usar switch
    input wire reg_sel_i, //usar switch
    
    input wire [Palabra-1:0]  entrada_i, //USAR SWITCHES
    input wire addr_i, //usar switch
    
    output wire [Palabra-1:0]  salida_o //Usar LEDS 
    );
    
reg WR1_reg_ctrl;
reg WR1_reg_data;
    
DeMUX DeMUX_inst(
    .wr_i(wr_i),        // Bit de entrada
    .reg_sel_i(reg_sel_i),   // Bit de control
    .WR1_reg_ctrl(WR1_reg_ctrl), // Salida cuando reg_sel_i = 0
    .WR1_reg_data(WR1_reg_data) 
);

reg [Palabra-1:0] OUT_data;

Reg_Data #(.Palabra(Palabra)) 
Reg_Data_inst(
    .IN1(entrada_i),       // Entrada 1 de 32 bits
    .IN2(),       // Entrada 2 de 32 bits Proveniente de UART
    .addr1(addr_i),            // Línea de dirección para IN1
    .addr2(),            // Línea de dirección para IN2 Proveniente de UART
    .WR1(WR1_reg_data),              // Bit de escritura para IN1
    .WR2(),              // Bit de escritura para IN2 Proveniente de UART
    .hold_ctrl(),        // Control para seleccionar el registro Proveniente de UART
    .OUT(OUT_data)  
);

reg [Palabra-1:0] OUT_ctrl;

Reg_ctrl #(.Palabra(Palabra)) Reg_ctrl_inst(
    .IN1(entrada_i),       // Entrada 1 de 32 bits
    .IN2(),       // Entrada 2 de 32 bits
    .WR1(WR1_reg_ctrl),              // Señal de escritura 1
    .WR2(),              // Señal de escritura 2
    .out(OUT_ctrl) 
);

MUX_UI_UART MUX_UI_UART_inst(
    .OUT_ctrl(OUT_ctrl),  // Entrada 1
    .OUT_data(OUT_data),  // Entrada 2
    .reg_sel_i(reg_sel_i),              // Línea de selección
    .salida_o(salida_o)
);
    
endmodule
