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

//INSTANCIACION DE ROM
ROM ROM_inst (
  .a(a),      // input wire [8 : 0] Address, direccion de ROM
  .spo(spo)  // output wire [31 : 0] spo
);

RAM RAM_inst (
  .a(a),      // input wire [14 : 0] a Direccion de RAM
  .d(d),      // input wire [31 : 0] Entrada dato a almacenar
  .clk(CLK_200MHZ), 
  .we(we),    // input Escritura en Memoria de Datos
  .spo(spo)  // output wire [31 : 0] spo
);


    
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
		.mem_valid   (mem_valid  ),
		.mem_instr   (mem_instr  ),
		.mem_ready   (mem_ready  ),
		.mem_addr    (mem_addr   ),
		.mem_wdata   (mem_wdata  ),
		.mem_wstrb   (mem_wstrb  ),
		.mem_rdata   (mem_rdata  ),
		.irq         (irq        )
	);
    
endmodule
