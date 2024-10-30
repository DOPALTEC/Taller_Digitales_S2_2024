`timescale 1ns / 1ps

module tb_Primario;
    parameter prescale = 1303;
    // Señales del testbench
    reg clk;
    reg rst;
    reg rxd;
    wire txd;
    //wire [31:0] rom_addr_o;
    //wire mem_valid_o;
    //wire mem_instr_o;
    //wire [31:0] mem_rdata_i;

    // Instanciación de la unidad bajo prueba
    Primario #(.prescale(prescale)) uut (
        .clk(clk),
        .rst(rst),
        .rxd(rxd),
        .txd(txd)
        //.rom_addr_o(rom_addr_o),
        //.mem_valid_o(mem_valid_o),
        //.mem_instr_o(mem_instr_o)
        //.mem_rdata_i(mem_rdata_i)
    );

    // Generación de reloj
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // Periodo de reloj de 10 ns (100 MHz)
    end

    // Inicialización y simulación
    initial begin
        // Inicializar señales
        rst = 1;   // Activar reset
        rxd=1;
        #10;      // Esperar 200 ns para estabilizar
        rst = 0;   // Desactivar reset

        // Ejecutar simulación
        #800;    // Simulación de 10,000 ns (10 µs)
        
   #500;  // Tiempo para que el transmisor complete el env?o
    rxd = 0;  // Start bit
    #104167    // Tiempo para cada bit (ajustado seg?n baudrate)

    // Simulaci?n de bits de datos (env?a 8'hA5)
    rxd = 1;  #104167;
    rxd = 0;  #104167;
    rxd = 1;  #104167;
    rxd = 0;  #104167;
    rxd = 1;  #104167;
    rxd = 0;  #104167;
    rxd = 1;  #104167;
    rxd = 0;  #104167;

    // Stop bit
    rxd = 1;  #104167;

        // Terminar la simulación
        $finish;
    end

endmodule
