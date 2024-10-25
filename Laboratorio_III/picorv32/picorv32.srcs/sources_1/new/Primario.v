`timescale 1ns / 1ps

module Primario #(parameter 
    STACKADDR=32'h0007_FFFF, // Posicion especificada en el mapa de memoria para la RAM
    PROGADDR_RESET=32'h 0000_0000, // Posicion inicial de la memoria de programa
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

reg ram_we;
reg [31:0] ram_wdata;
wire [31:0] ram_addr; // Dirección ajustada para la RAM
wire [1:0] ram_select; // Señal para seleccionar el módulo de RAM
assign ram_addr = (mem_addr >= 32'h40000) ? (mem_addr - 32'h40000) : 32'h0; // Ajusta la dirección
assign ram_select = ram_addr[18:17];

wire [31:0] ram1_rdata; // Datos leídos desde RAM 1
wire [31:0] ram2_rdata; // Datos leídos desde RAM 2
wire [31:0] ram3_rdata; // Datos leídos desde RAM 3
wire [31:0] ram4_rdata; // Datos leídos desde RAM 4


RAM RAM_1_0_to_64 (
  .a(ram_addr[16:0]),      // input wire [14 : 0] a
  .d(ram_wdata),      // input wire [31 : 0] d
  .clk(clk),  // input wire clk
  .we(ram_we && (ram_select==2'b00)),    // input wire we
  .spo(ram1_rdata)  // output wire [31 : 0] spo
);

RAM RAM_2_64_to_128 (
  .a(ram_addr[16:0]),      // input wire [14 : 0] a
  .d(ram_wdata),      // input wire [31 : 0] d
  .clk(clk),  // input wire clk
  .we(ram_we && (ram_select==2'b01)),    // input wire we
  .spo(ram2_rdata)  // output wire [31 : 0] spo
);

RAM RAM_3_128_to_192 (
  .a(ram_addr[16:0]),      // input wire [14 : 0] a
  .d(ram_wdata),      // input wire [31 : 0] d
  .clk(clk),  // input wire clk
  .we(ram_we && (ram_select==2'b10)),    // input wire we
  .spo(ram3_rdata)  // output wire [31 : 0] spo
);
RAM RAM_4_192_to_256 (
  .a(ram_addr[16:0]),      // input wire [14 : 0] a
  .d(ram_wdata),      // input wire [31 : 0] d
  .clk(clk),  // input wire clk
  .we(ram_we && (ram_select==2'b11)),    // input wire we
  .spo(ram4_rdata)  // output wire [31 : 0] spo
);


wire [31:0] ram_rdata = (ram_select == 2'b00) ? ram1_rdata :
                         (ram_select == 2'b01) ? ram2_rdata :
                         (ram_select == 2'b10) ? ram3_rdata :
                         ram4_rdata; // Leer de la RAM correspondiente

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
            mem_ready <= 1; // Habilita mem_ready si hay operaciï¿½n vï¿½lida
            if(!mem_instr && (mem_wstrb[0] || mem_wstrb[1]) || mem_wstrb[2] || mem_wstrb[3])begin
                ram_wdata <= mem_wdata; // Asigna los datos a escribir en RAM
                ram_we <= 1; // Habilita escritura en RAM
            end
        end
    end
end

endmodule
