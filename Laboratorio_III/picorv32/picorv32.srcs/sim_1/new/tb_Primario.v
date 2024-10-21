`timescale 1ns / 1ps

module tb_Primario;

    // Par�metros del testbench
    reg clk;
    reg rst;
    wire mem_valid;
    wire mem_instr;
    //wire mem_ready;
    wire [31:0] mem_addr;
    wire [31:0] mem_wdata;
    wire [3:0] mem_wstrb;
    wire [31:0] mem_rdata;
    reg mem_ready;

    // Instanciaci�n de la unidad a probar
    Primario uut (
        .clk(clk),
        .rst(rst),
        .mem_ready(mem_ready)
    );

    // Generaci�n de reloj
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Reloj de 100MHz
    end

    // Inicializaci�n y simulaci�n
    initial begin
        // Inicializar se�ales
        rst = 1; // Activar reset
        mem_ready = 0;
        #20000 rst = 0; // Desactivar reset despu�s de 20 ns
        mem_ready = 1;
        #100;
        mem_ready = 0;
        // Esperar un tiempo para ver el funcionamiento
        #100000;

        // Terminar la simulaci�n
        $finish;
    end

    // Simulaci�n de se�ales de memoria


endmodule
