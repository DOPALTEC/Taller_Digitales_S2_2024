`timescale 1ms / 100us

module tb_key_debounce;

    // Entradas
    reg clk;
    reg rst_n;
    reg key_in;
    
    // Salida
    wire key_pressed;
    
    // Parámetro de debounce
    parameter DEBOUNCE_TIME = 1000000;  

    // Instanciar el módulo a probar
    key_debounce #(.DEBOUNCE_TIME(DEBOUNCE_TIME)) uut (
        .clk(clk),
        .rst_n(rst_n),
        .key_in(key_in),
        .key_pressed(key_pressed)
    );
    
    // Generar la señal de reloj
    always #0.5 clk = ~clk; 

    initial begin
        // Inicializar las señales
        clk = 0;
        rst_n = 0;
        key_in = 1;  
        
        // Monitorizar cambios
        $monitor("Tiempo: %d ms, clk: %b, rst_n: %b, key_in: %b, key_pressed: %b", $time, clk, rst_n, key_in, key_pressed);
        
        // Activar reset
        #1 rst_n = 1;  
        
        // Simular el rebote del botón
        #2 key_in = 0;  // El botón se presiona (primer rebote)
        #1 key_in = 1;  // Rebote
        #1 key_in = 0;  // Rebote
        #1 key_in = 1;  // Rebote
        #1 key_in = 0;  // Finalmente, el botón está presionado

        // Mantener el botón presionado por más tiempo que el tiempo de debounce
        #((DEBOUNCE_TIME / 1000) + 2) key_in = 1;  // Después de un tiempo, el botón se suelta
        
        // Finalizar la simulación
        #10 $finish;
    end
endmodule
