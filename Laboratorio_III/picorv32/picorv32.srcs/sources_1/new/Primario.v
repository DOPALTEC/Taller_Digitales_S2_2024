`timescale 1ns / 1ps


module Primario #(parameter 
ENABLE_COMPRESSED=0, 
ENABLE_MUL=0, 
ENABLE_DIV=0, 
ENABLE_IRQ=0, 
ENABLE_FAST_MUL=0,
ENABLE_IRQ_QREGS=0 )(
    input  wire clk,
    input  wire rst
    );
    
    wire locked;
    wire CLK_200MHZ;
    
   CLK_Gen CLK_Gen_inst
   (
    .CLK_100MHZ(clk), //input de 100mhz
    .reset(rst),
    .locked(locked),
    .CLK_200MHZ(CLK_200MHZ));//output de 200mhz

    
    picorv32 #(
		.STACKADDR(STACKADDR),
		.PROGADDR_RESET(PROGADDR_RESET),
		.PROGADDR_IRQ(PROGADDR_IRQ),
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
