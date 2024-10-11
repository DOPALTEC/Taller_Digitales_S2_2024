`timescale 1ns / 1ps

module DeMUX(
    input wire wr_i,        // Bit de entrada
    input wire reg_sel_i,   // Bit de control
    output reg WR1_reg_ctrl, // Salida cuando reg_sel_i = 0
    output reg WR1_reg_data  // Salida cuando reg_sel_i = 1
    );
    
always @(*) begin
    if (reg_sel_i == 0) begin
        WR1_reg_ctrl = wr_i;  // Paso de wr_i cuando reg_sel_i es 0
        WR1_reg_data = 0;
    end else begin
        WR1_reg_data = wr_i;  // Paso de wr_i cuando reg_sel_i es 1
        WR1_reg_ctrl = 0;
    end
end


endmodule



