`timescale 1ns / 1ps

module MUX_UI_UART #(parameter Palabra=8)(
    input wire [Palabra:0] OUT_ctrl,  // Entrada 1
    input wire [Palabra:0] OUT_data,  // Entrada 2
    input wire reg_sel_i,              // Línea de selección
    output wire [Palabra:0] salida_o  // Salida
);

    // Selección entre las dos entradas
    assign salida_o = (reg_sel_i == 1'b0) ? OUT_ctrl : OUT_data;

endmodule