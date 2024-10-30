`timescale 1ns / 1ps

module Primario #(parameter prescale=1303
    //STACKADDR=32'h0007_FFFF, // Posicion especificada en el mapa de memoria para la RAM
    //PROGADDR_RESET=32'h 0000_0000, // Posicion inicial de la memoria de programa
    //PROGADDR_IRQ=0,
    //BARREL_SHIFTER=0,
    //ENABLE_COMPRESSED=0, 
    //ENABLE_COUNTERS=0,
    //ENABLE_MUL=0, 
    //ENABLE_DIV=0,
    //ENABLE_FAST_MUL=0, 
    //ENABLE_IRQ=0, 
    //ENABLE_IRQ_QREGS=0
    )
(
    input  wire clk,
    input  wire rst,
    
    //UART
    input  wire rxd, //Para el constraint
    output wire txd //Para el constraint
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
assign ram_addr = (mem_addr >= 32'h40000) ? (mem_addr - 32'h40000) : 32'h0; // Ajusta la dirección
wire [31:0] ram_addr_adj = ram_addr >> 2; //Escala para que la direccion en RAM sea de 1 en 1

wire [31:0] ram_rdata;
RAM RAM_inst (
  //.a(ram_addr[16:0]),      // input wire [14 : 0] a
  .a(ram_addr_adj[16:0]),
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
picorv32 cpu (
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




// Instancia del módulo Interfaz_UART_Nexys
reg wr_i;
reg reg_sel_i;
wire [31:0] ctrl;
wire [31:0] data;
reg [31:0] entrada_i;
reg addr_i;
reg [31:0] entrada_i_data;

Interfaz_UART_Nexys #(
    .palabra(8),
    .prescale(prescale)
) interfaz_uart_inst (
    .clk(clk),                // Reloj de entrada
    .rst(rst),                // Reset
    .wr_i(wr_i),              // Señal de escritura
    .reg_sel_i(reg_sel_i),    // Señal de selección de registro
    .addr_i(addr_i),          // Dirección
    .entrada_i(entrada_i[7:0]),    // Entrada de control
    .entrada_i_data(entrada_i_data[7:0]), // Entrada de datos
    .ctrl(ctrl),              // Salida de control
    .data(),              // Salida de datos
    .rxd(rxd),                // RX de entrada
    .txd(txd)                 // TX de salida
);


/*
Si se trata de un acceso a memoria de instruccion (mem_instr=1) 
lee la salida de la ROM caso contrario lee los datos de la RAM
*/
assign mem_rdata = (mem_instr) ? rom_rdata : ram_rdata; // Selecciona entre ROM o RAM para lecturas



//RAM
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

//Designa perifericos

always @(posedge clk or posedge rst) begin
    if (rst) begin
        wr_i <= 0;
        reg_sel_i <= 0;
        entrada_i <= 0;
        addr_i <= 0;
    end else begin
        if (mem_valid && mem_addr == 32'h2010) begin
            entrada_i <= mem_wdata; // Asigna el dato de memoria a entrada_i
            wr_i <= 1;              // Señal de escritura en 1
            reg_sel_i <= 0;         // Señal de selección en 0
        end 
        else if (mem_valid && mem_addr == 32'h2018)begin
            entrada_i_data <= mem_wdata; // Asigna el dato de memoria a entrada_i
            wr_i <= 1;              // Señal de escritura en 1
            reg_sel_i <= 1;         // Señal de selección en 1
            addr_i <= 0;
        end
        else if (mem_valid && mem_addr == 32'h201C && ctrl[1] == 1) begin
            addr_i <= 1;           // Asigna addr_i a 1 si se cumple la condición
            wr_i <= 1;             // Señal de escritura en 1
            reg_sel_i <= 1;        // Señal de selección en 1
        end
        else begin
            wr_i <= 0; 
            reg_sel_i<=0;
            addr_i<=0;    
        end
    end
end

endmodule
