`timescale 1ns / 1ps

module debounce_tb();

    reg clk;
    reg reset;
    reg key;  // Entrada de 1 bit para el teclado
    wire debounced_out;  // Salida de 1 bit
    
    // Instancia del módulo debounce
    debounce uut (
        .clk(clk),
        .reset(reset),
        .key(key),
        .debounced_out(debounced_out)
    );
    
    // Generador de reloj (clock)
    always begin
        #5 clk = ~clk;  // Periodo de 10 ns, frecuencia de 100 MHz
    end
    
    // Simulación
    initial begin
        // Inicialización
        clk = 1;
        reset = 0;
        key = 0;  // No hay tecla presionada al inicio
        
        // Reinicio del sistema
        #20 reset = 1;
        
        // Simulación de rebotes (señal inestable)
        #30 key = 1;  // Cambio en una fila, simulando una tecla
        #2  key = 0;  // Rebote
        #2  key = 1;  // Rebote
        #2  key = 0;  // Rebote
        #2  key = 1;  // Rebote
        
        // Estabilización de la señal después de 20 ns
        #200 key = 0;  // Tecla estable
        
        // Espera para observar el comportamiento de la salida
        #100;
        
        // Mostrar el estado después de un tiempo
        
        // Fin de la simulación
        $stop;
    end

endmodule
