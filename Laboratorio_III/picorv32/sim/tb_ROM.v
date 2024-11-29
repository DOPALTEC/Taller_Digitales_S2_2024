`timescale 1ns / 1ps

module testbench_rom;
    // Entradas del testbench
    reg [8:0] rom_addr;  // Direcci�n de entrada (recortada a 9 bits)
    
    // Salidas de la ROM
    wire [31:0] rom_data_out; // Datos de salida de la ROM

    // Instancia de la ROM
    ROM ROM_inst (
        .a(rom_addr),    // Direcci�n de entrada
        .spo(rom_data_out) // Datos de salida
    );

    // Inicializaci�n y control de la simulaci�n
    initial begin

        // Inicializar la direcci�n
        rom_addr = 9'd0;

        // Probar varias direcciones en la ROM
        #10000 rom_addr = 9'd1;
        #10000 rom_addr = 9'd2;
        #10000 rom_addr = 9'd3;
        #10000 rom_addr = 9'd4;
        #10000 rom_addr = 9'd5;
        #10000 rom_addr = 9'd255;  // Probar el valor m�s alto posible
        #10000;

        // Terminar la simulaci�n
        $finish;
    end

    // Monitorizar la salida
    initial begin
        $monitor("Time: %0t | rom_addr: %h | rom_data_out: %h", $time, rom_addr, rom_data_out);
    end
endmodule
