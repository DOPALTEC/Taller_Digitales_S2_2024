`timescale 1ns / 1ps 

module Primario #(parameter 
    STACKADDR=32'h0007_FFFF, // Posici�n especificada en el mapa de memoria para la RAM
    PROGADDR_RESET=32'h 0000_0000,// Posici�n inicial de la memoria de programa
    PROGADDR_IRQ=0,
    //BARREL_SHIFTER=1,
    BARREL_SHIFTER=0,
    ENABLE_COMPRESSED=0, 
    //ENABLE_COUNTERS=1,
    ENABLE_COUNTERS=0,
    ENABLE_MUL=0, 
    ENABLE_DIV=0,
    ENABLE_FAST_MUL=0, 
    ENABLE_IRQ=0, 
    ENABLE_IRQ_QREGS=0)(
    input  wire clk,
    input  wire rst,
    input wire mem_ready
    
);
    
wire locked;
wire CLK_200MHZ;
    
// Instanciaci�n de CLK 200 MHZ

  CLK_Gen CLK_Gen_inst
   (
    // Clock out ports
    .CLK_200MHZ(CLK_200MHZ),     // output CLK_200MHZ
    // Status and control signals
    .reset(rst), // input reset
    .locked(locked),       // output locked
   // Clock in ports
    .CLK_100MHZ(clk));      // input CLK_100MHZ

// Instanciaci�n de RV32
wire mem_valid;            
wire mem_instr;           
//wire mem_ready;           
wire [31:0] mem_addr; 
wire [31:0] mem_wdata; 
wire [3:0] mem_wstrb; 
wire [31:0] mem_rdata;     

picorv32 #(
    .STACKADDR(STACKADDR),
    .PROGADDR_RESET(PROGADDR_RESET),
    .PROGADDR_IRQ(PROGADDR_IRQ),
    .BARREL_SHIFTER(BARREL_SHIFTER),
    .COMPRESSED_ISA(ENABLE_COMPRESSED),
    .ENABLE_COUNTERS(ENABLE_COUNTERS),
    .ENABLE_MUL(ENABLE_MUL),
    .ENABLE_DIV(ENABLE_DIV),
    .ENABLE_FAST_MUL(ENABLE_FAST_MUL),
    .ENABLE_IRQ(ENABLE_IRQ),
    .ENABLE_IRQ_QREGS(ENABLE_IRQ_QREGS)
) cpu (
    .clk(CLK_200MHZ),
    .resetn(rst), // Inversi�n si es necesario
    .mem_valid(mem_valid), 
    .mem_instr(mem_instr),
    .mem_ready(mem_ready),
    .mem_addr(mem_addr),
    .mem_wdata(mem_wdata),
    .mem_wstrb(mem_wstrb),
    .mem_rdata(mem_rdata),
    .irq()
);
	
// Instanciaci�n de ROM
reg [8:0] rom_a;              
wire [31:0] rom_spo;           

ROM ROM_inst (
    .a(rom_a),      
    .spo(rom_spo)
);

// Instanciaci�n de RAM
reg [14:0] ram_a;         
reg [31:0] ram_d;         
reg ram_we;               

RAM RAM_inst (
    .a(ram_a),
    .d(ram_d),      
    .clk(CLK_200MHZ), 
    .we(ram_we),    
    .spo(mem_rdata)  
);

always @(*) begin
    // Inicializar las se�ales
    ram_we = 0; // Inicialmente no se escribe en RAM
    rom_a = 0;  // Inicializar la direcci�n de ROM
    ram_a = 0;  // Inicializar la direcci�n de RAM
    ram_d = 0;  // Inicializar los datos a escribir en RAM

    if (locked) begin
        if (mem_valid) begin
            if (mem_instr) begin
                // Si es un fetch de instrucci�n, se lee de la ROM
                rom_a = mem_addr[8:0]; // Asumiendo que la ROM tiene un rango adecuado
            end else begin
                // Si no es un fetch, se trata de una operaci�n de escritura
                ram_a = mem_addr[14:0]; // Ajustar seg�n el tama�o de tu RAM
                ram_d = mem_wdata; // Datos a escribir
                ram_we = |mem_wstrb; // Habilitar escritura si alguna l�nea de escritura est� activa
            end
        end
    end
end

endmodule
