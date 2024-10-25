`timescale 1ns / 1ps

module tb_Primario;

    // Se�ales del testbench
    reg clk;
    reg rst;
    //wire [31:0] rom_addr_o;
    //wire mem_valid_o;
    //wire mem_instr_o;
    //wire [31:0] mem_rdata_i;

    // Instanciaci�n de la unidad bajo prueba
    Primario uut (
        .clk(clk),
        .rst(rst)
        //.rom_addr_o(rom_addr_o),
        //.mem_valid_o(mem_valid_o),
        //.mem_instr_o(mem_instr_o)
        //.mem_rdata_i(mem_rdata_i)
    );

    // Generaci�n de reloj
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // Periodo de reloj de 10 ns (100 MHz)
    end

    // Inicializaci�n y simulaci�n
    initial begin
        // Inicializar se�ales
        rst = 1;   // Activar reset
        #10;      // Esperar 200 ns para estabilizar
        rst = 0;   // Desactivar reset

        // Ejecutar simulaci�n
        #400;    // Simulaci�n de 10,000 ns (10 �s)

        // Terminar la simulaci�n
        $finish;
    end

endmodule
