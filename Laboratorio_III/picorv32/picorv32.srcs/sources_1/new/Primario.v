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
/*
Genera un desplazamiento a la derecha que dimensiona los saltos en 32 bits y no por bytes
Divide entre 4 el valor de las direcciones
*/
wire [11:0] rom_addr = mem_addr[13:2]; 
wire  [31:0] rom_rdata;
//Como la ROM termina en 0x0fff se puede acotar
ROM ROM_inst (
  .a(rom_addr),      // input wire [8 : 0] 
  .spo(rom_rdata)  // output wire [31 : 0] spo
);


wire  [31:0] ram_rdata;
reg ram_we;
wire [14:0] ram_addr = mem_addr[15:2]; //Escala de bytes a 1 palabra

reg [31:0] ram_wdata;
/*
No hay problema que una misma address caiga en ambas memorias
we determina si se escribe en ram o no
*/

RAM RAM_inst (
  .a(ram_addr),      // input wire [14 : 0] a
  .d(ram_wdata),      // input wire [31 : 0] d
  .clk(clk),  // input wire clk
  .we(ram_we),    // input wire we
  .spo(ram_rdata)  // output wire [31 : 0] spo
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

/*
Si se trata de un acceso a memoria de instruccion (mem_instr=1) 
lee la salida de la ROM caso contrario lee los datos de la RAM
*/
assign mem_rdata = (mem_instr) ? rom_rdata : ram_rdata; // Selecciona entre ROM o RAM para lecturas




always @(posedge clk or posedge rst) begin
    if (rst) begin
        mem_ready <= 0; // Inicializa mem_ready en 0 al reset
        ram_we<=0;
    end else begin
        mem_ready <= 0; // Por defecto, mem_ready es 0
        ram_we<=0;
        if (mem_valid && !mem_ready) begin
            mem_ready <= 1; // Habilita mem_ready si hay operación válida
            if(!mem_instr && (mem_wstrb[0] || mem_wstrb[1]) || mem_wstrb[2] || mem_wstrb[3])begin
                ram_wdata <= mem_wdata; // Asigna los datos a escribir en RAM
                ram_we <= 1; // Habilita escritura en RAM
            end
        end
    end
end

endmodule
