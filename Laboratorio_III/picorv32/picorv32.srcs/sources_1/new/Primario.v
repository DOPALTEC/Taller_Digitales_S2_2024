`timescale 1ns / 1ps

module Primario #(parameter 
    STACKADDR=32'h0007_FFFF, // Posición especificada en el mapa de memoria para la RAM
    PROGADDR_RESET=32'h 0000_0000, // Posición inicial de la memoria de programa
    PROGADDR_IRQ=0,
    BARREL_SHIFTER=0,
    ENABLE_COMPRESSED=0, 
    ENABLE_COUNTERS=0,
    ENABLE_MUL=0, 
    ENABLE_DIV=0,
    ENABLE_FAST_MUL=0, 
    ENABLE_IRQ=0, 
    ENABLE_IRQ_QREGS=0)
(
    input  wire clk,
    input  wire rst
);

wire [31:0] mem_addr; //Direccion de memoria que lee 
wire  [31:0] mem_rdata; //Lee la instruccion

ROM ROM_inst (
  .a(mem_addr),      // input wire [8 : 0] a
  .spo(mem_rdata)  // output wire [31 : 0] spo
);

RAM RAM_inst (
  .a(a),      // input wire [14 : 0] a
  .d(d),      // input wire [31 : 0] d
  .clk(clk),  // input wire clk
  .we(we),    // input wire we
  .spo(spo)  // output wire [31 : 0] spo
);

/////////////////////INSTANCIACION DE RV32////////////////////////////
//INPUTS
reg mem_ready; //Habilita que la memoria esta lista
//OUTPUTS
wire mem_valid; //Indica que la memoria que esta leyendo es valida
wire mem_instr;
    //Escritura
wire [3:0] mem_wstrb; 
wire [31:0] mem_wdata;
wire trap;
picorv32 #() cpu (
    .clk(clk),
    .resetn(!rst),// Reset activo en bajo
    .trap(trap),
    .mem_valid(mem_valid), 
    .mem_instr(mem_instr),
    .mem_ready(mem_ready),
    .mem_addr(mem_addr),//Direccion de la memoria que va a leer
    .mem_wdata(mem_wdata),// Datos a escribir (si es escritura)
    .mem_wstrb(mem_wstrb),// Indica que hay un acceso de escritura valido
    .mem_rdata(mem_rdata)//Lee lo que hay en la memoria
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        mem_ready <= 0; // Inicializa mem_ready en 0 al reset
    end else begin
        mem_ready <= 0; // Por defecto, mem_ready es 0
        if (mem_valid && !mem_ready) begin
            mem_ready <= 1; // Habilita mem_ready si hay operación válida
        end
    end
end

endmodule
