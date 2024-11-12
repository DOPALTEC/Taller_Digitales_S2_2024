`timescale 1ns / 1ps


module Primario #(parameter palabra=32, parameter prescale=1302)
(
    input  wire clk,
    input  wire rst,
    //Switches x2000
    input wire [15:0] SW,
    output reg [15:0] LED,
    
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
//CAMBIAR A BLOCK
//RAM RAM_inst (
  //.a(ram_addr[16:0]),      // input wire [14 : 0] a
//  .a(ram_addr_adj[16:0]),
//  .d(ram_wdata),      // input wire [31 : 0] d
//  .clk(clk),  // input wire clk
//  .we(ram_we),    // input wire we
//  .spo(ram_rdata)  // output wire [31 : 0] spo
//);
reg ena;
RAM_block RAM_inst (
  .clka(clk),    // input wire clka
  .ena(ena),      // input wire ena
  .wea(ram_we),      // input wire [0 : 0] wea
  .addra(ram_addr_adj[15:0]),  // input wire [15 : 0] addra
  .dina(ram_wdata),    // input wire [31 : 0] dina
  .douta(ram_rdata)  // output wire [31 : 0] douta
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


/////PROTOCOLO UART_A (NEXYS/PC)//////////////
reg wr_i_A;
reg reg_sel_i_A;
wire [31:0] ctrl_A;
wire [31:0] data_A;
reg [31:0] entrada_i_A;
reg addr_i_A;
reg [31:0] entrada_i_data_A;

Interfaz_UART_Nexys #(
    .palabra(palabra),
    .prescale(prescale)
) interfaz_uart_inst_A (
    .clk(clk),                // Reloj de entrada
    .rst(rst),                // Reset
    .wr_i(wr_i_A),              // Señal de escritura
    .reg_sel_i(reg_sel_i_A),    // Señal de selección de registro
    .addr_i(addr_i_A),          // Dirección
    .entrada_i(entrada_i_A),    // Entrada de control
    .entrada_i_data(entrada_i_data_A), // Entrada de datos
    .ctrl(ctrl_A),              // Salida de control
    .data(data_A),              // Salida de datos
    .rxd(rxd),                // RX de entrada
    .txd(txd)                 // TX de salida
);

/////PROTOCOLO UART_B (NEXYS/TANG)//////////////

reg wr_i_B;
reg reg_sel_i_B;
wire [31:0] ctrl_B;
wire [31:0] data_B;
reg [31:0] entrada_i_B;
reg addr_i_B;
reg [31:0] entrada_i_data_B;

Interfaz_UART_Nexys #(
    .palabra(palabra),
    .prescale(prescale)
) interfaz_uart_inst_B ( 
    .clk(clk),                // Reloj de entrada
    .rst(rst),                // Reset
    .wr_i(wr_i_B),              // Señal de escritura
    .reg_sel_i(reg_sel_i_B),    // Señal de selección de registro
    .addr_i(addr_i_B),          // Dirección
    .entrada_i(entrada_i_B),    // Entrada de control
    .entrada_i_data(entrada_i_data_B), // Entrada de datos
    .ctrl(ctrl_B),              // Salida de control
    .data(data_B),              // Salida de datos
    .rxd(rxd_B),                // RX de entrada
    .txd(txd_B)                 // TX de salida
);                 


/*
Si se trata de un acceso a memoria de instruccion (mem_instr=1) 
lee la salida de la ROM caso contrario lee los datos de la RAM
*/
//assign mem_rdata = (mem_instr) ? rom_rdata : ram_rdata; // Selecciona entre ROM o RAM para lecturas

// Asignación de mem_rdata
assign mem_rdata = 
                   (mem_addr == 32'h2000) ? {16'b0, SW} :
                   (mem_addr == 32'h2010) ? {24'b0, ctrl_A} :
                   (mem_addr == 32'h201C && ctrl_A[1]) ? {24'b0, data_A} :
                   (mem_instr ? rom_rdata : ram_rdata);
/*En base a mem_valid para cada uno de los perifericos debe haber un mem_ready, multiplexar 
tambien quien envia esto
*/
//RAM
always @(posedge clk or posedge rst) begin
    if (rst) begin
        mem_ready <= 0; // Inicializa mem_ready en 0 al reset
        ram_we<=0;
        ena<=0;
    end else begin
        mem_ready <= 0; // Por defecto, mem_ready es 0
        ram_we<=0;
        if (mem_valid && !mem_ready) begin
            mem_ready <= 1; // Habilita mem_ready si hay operaciï¿½n vï¿½lida
            if(!mem_instr && (mem_wstrb[0] || mem_wstrb[1]) || mem_wstrb[2] || mem_wstrb[3])begin
                ena<=1;
                ram_wdata <= mem_wdata; // Asigna los datos a escribir en RAM
                ram_we <= 1; // Habilita escritura en RAM
            end
        end
    end
end


reg addr_i_delay;
reg reg_sel_i_delay;
//Designa perifericos

always @(posedge clk or posedge rst) begin
    if (rst) begin
        wr_i_A <= 0;
        reg_sel_i_A <= 0;
        entrada_i_A <= 0;
        addr_i_A <= 0;
        ena<=0;
    end else begin
        if (mem_valid && mem_addr == 32'h2010) begin
            entrada_i_A <= mem_wdata; // Asigna el dato de memoria a entrada_i
            wr_i_A <= 1;              // Señal de escritura en 1
            reg_sel_i_A <= 0;         // Señal de selección en 0
        end 
        else if (mem_valid && mem_addr == 32'h2018)begin
            entrada_i_data_A <= mem_wdata; // Asigna el dato de memoria a entrada_i
            wr_i_A <= 1;              // Señal de escritura en 1
            reg_sel_i_A <= 1;         // Señal de selección en 1
            addr_i_A <= 0;
        end
        else if (mem_valid && mem_addr == 32'h201C && ctrl_A[1] == 1) begin
            addr_i_A <= 1;           // Asigna addr_i a 1 si se cumple la condición
            reg_sel_i_A <= 1;        // Señal de selección en 1
            addr_i_delay <= 1;     // Activa el retardo
            reg_sel_i_delay <= 1;
        end
        else if (mem_valid && mem_addr == 32'h2004)begin
            LED<=mem_wdata[15:0];
        end
        else begin
            wr_i_A <= 0; 
            reg_sel_i_A<=0;
            addr_i_A<=0;    
            reg_sel_i_A <= reg_sel_i_delay;
            addr_i_A <= addr_i_delay;
            reg_sel_i_delay <= 0; // Desactiva el retardo después de un ciclo
            addr_i_delay <= 0;
        end
    end
end

endmodule
