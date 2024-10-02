`timescale 1ms / 100us

module tb_counter_2bit;

    // Entradas
    reg clk;
    reg rst_n;
    reg key_pressed;
    
    // Salida
    wire [1:0] count;
    
    // Instanciar el módulo a probar
    counter_2bit uut (
        .clk(clk),
        .rst_n(rst_n),
        .key_pressed(key_pressed),
        .count(count)
    );
    
    // Generar señal de reloj
    always #0.5 clk = ~clk;  
    
    initial begin
        // Inicialización de señales
        clk = 0;
        rst_n = 0;
        key_pressed = 1;  // Empieza como si el botón estuviera presionado
        
        // Monitorizar cambios
        $monitor("Tiempo: %d ms, clk: %b, rst_n: %b, key_pressed: %b, count: %b", $time, clk, rst_n, key_pressed, count);
        
        #1 rst_n = 1; 
        
        #1 key_pressed = 0;  // No presionado, empieza el conteo
        
        #5 key_pressed = 1;  // Botón presionado, debe detener el conteo
        
        #5 key_pressed = 0;  // No presionado, vuelve a contar
        
        // Finalizar la simulación
        #10 $finish;
    end
endmodule
