`timescale 1ns / 1ps


module Primario #(parameter 
    STACKADDR=32'h0007_FFFF, //Posicion especificada en el mapa de memoria para la ram (memoria de datos)
    PROGADDR_RESET=32'h 0000_0000,//Posicion incial de la memoria de programa
    PROGADDR_IRQ=0,
    BARREL_SHIFTER=1,
    ENABLE_COMPRESSED=0, 
    ENABLE_COUNTERS=1,
    ENABLE_MUL=0, 
    ENABLE_DIV=0,
    ENABLE_FAST_MUL=0, 
    ENABLE_IRQ=0, 
    ENABLE_IRQ_QREGS=0)(
    input  wire clk,
    input  wire rst
);
    
wire locked;
wire CLK_200MHZ;
    
//INSTANCIACION DE CLK 200 MHZ
CLK_Gen CLK_Gen_inst(
    .CLK_100MHZ(clk), //input de 100mhz
    .reset(rst),
    .locked(locked),
    .CLK_200MHZ(CLK_200MHZ)//output de 200mhz
);

//INSTANCIACION DE RV32
    wire mem_valid;            // Transferencia de memoria válida
    wire mem_instr;           // Indica si es un fetch de instrucción
    wire mem_ready;// Indica que la memoria está lista
    wire [31:0] mem_addr; // Dirección de memoria
    wire [31:0] mem_wdata; // Datos a escribir
    wire [3:0] mem_wstrb; // Habilitadores de escritura
    wire [31:0] mem_rdata;     // Datos leídos desde la memoria
    picorv32 #(
		.STACKADDR(STACKADDR),//Direccion de la Pila
		.PROGADDR_RESET(PROGADDR_RESET), //Direccion inicial, al resetear
		.PROGADDR_IRQ(PROGADDR_IRQ), //Interrupciones Addres Programa (deshabilitado 0)
		.BARREL_SHIFTER(BARREL_SHIFTER),
		.COMPRESSED_ISA(ENABLE_COMPRESSED), //Instrucciones comprimidas no se usa (Deshabilitado 0)
		.ENABLE_COUNTERS(ENABLE_COUNTERS),
		.ENABLE_MUL(ENABLE_MUL), //Multiplicador (deshabilitado 0)
		.ENABLE_DIV(ENABLE_DIV), //Divisor (deshabilitado 0)
		.ENABLE_FAST_MUL(ENABLE_FAST_MUL),//Multiplicacion Rapida (deshabilitado 0)
		.ENABLE_IRQ(ENABLE_IRQ), //Interrupcion (deshabilitado 0)
		.ENABLE_IRQ_QREGS(ENABLE_IRQ_QREGS) //Interrupcion Registros (deshabilitado 0)
) cpu (
		.clk(CLK_200MHZ),
		.resetn(rst),
		.mem_valid(mem_valid), 
		.mem_instr(mem_instr),
		.mem_ready(mem_ready),
		.mem_addr(mem_addr),
		.mem_wdata(mem_wdata),
		.mem_wstrb(mem_wstrb),
		.mem_rdata(mem_rdata),
		.irq()
);
	
//INSTANCIACION DE ROM
reg [8:0] rom_a;              // Dirección de ROM
wire [31:0] rom_spo;           // Salida de la ROM
ROM ROM_inst (
  .a(rom_a),      // input wire [8 : 0] Address, direccion de ROM
  .spo(rom_spo)  // output wire [31 : 0] spo
);

//INSTANCIACION DE RAM
reg [14:0] ram_a;         // Dirección de RAM
reg [31:0] ram_d;         // Datos a almacenar en RAM
reg ram_we;               // Escritura en RAM
RAM RAM_inst (
  .a(ram_a),      // input wire [14 : 0] a Direccion de RAM
  .d(ram_d),      // input wire [31 : 0] Entrada dato a almacenar
  .clk(CLK_200MHZ), 
  .we(ram_we),    // input Escritura en Memoria de Datos
  .spo(mem_rdata)  //salida de RAM conectada a mem_rdata de rv32
);

always @(*) begin
    // Inicializar las señales
    ram_we = 0; // Inicialmente no se escribe en RAM
    rom_a = 0;  // Inicializar la dirección de ROM
    ram_a = 0;  // Inicializar la dirección de RAM
    ram_d = 0;  // Inicializar los datos a escribir en RAM

    if (mem_valid) begin
        if (mem_instr) begin
            // Si es un fetch de instrucción, se lee de la ROM
            rom_a = mem_addr[8:0]; // Asumiendo que la ROM tiene un rango adecuado
        end else begin
            // Si no es un fetch, se trata de una operación de escritura
            ram_a = mem_addr[14:0]; // Ajustar según el tamaño de tu RAM
            ram_d = mem_wdata; // Datos a escribir
            ram_we = |mem_wstrb; // Habilitar escritura si alguna línea de escritura está activa
        end
    end
end

    
endmodule
