`timescale 1ms / 100us

module tb_top_module;

    // Entradas
    reg clk;
    reg rst_n;
    reg key_in;

    // Salidas
    wire [7:0] count;

    // Instanciar el módulo superior (top_module)
    top_module uut (
        .clk(clk),
        .rst_n(rst_n),
        .key_in(key_in),
        .count(count)
    );

    // Generar el reloj (clk)
    always #5 clk = ~clk;  

    initial begin
        // Inicializar las señales
        clk = 0;
        rst_n = 0;
        key_in = 0; 

        // Monitorear los cambios en las señales
        $monitor("Tiempo: %0t | key_in = %b | key_pressed = %b | count = %b", $time, key_in, uut.debounce_inst.key_pressed, count);
        
        #5 rst_n = 1;  

        // Simular la presión del botón con rebotes
        #10 key_in = 1;  // Simular que el botón se presiona
        #20 key_in = 0;   // Rebote
        #20 key_in = 1;   // Rebote
        #20 key_in = 0;   // Soltar el botón
        #100 key_in = 1; 

        // Mantener el botón suelto durante un tiempo
        #800;

        // Simular otra presión del botón
        #10 key_in = 1;  
        #10 key_in = 0;  

        // Simulación continua por unos ciclos más
        #50;

        // Finalizar la simulación
        $finish;
    end
endmodule
