`timescale 1ns / 1ps
module DeMUX(
    input wire wr_i,        // Bit de entrada
    input wire reg_sel_i,   // Bit de control
    output wire WR1_reg_ctrl, // Salida cuando reg_sel_i = 0
    output wire WR1_reg_data  // Salida cuando reg_sel_i = 1
    );
    
assign WR1_reg_ctrl = (reg_sel_i == 0) ? wr_i : 0;
assign WR1_reg_data = (reg_sel_i == 1) ? wr_i : 0;

endmodule
