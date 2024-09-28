`timescale 1ns / 1ps

module top_module_tb;

  // Definimos las señales
  reg clk;
  reg reset;
  reg key;
  wire [7:0] count;  // Salida del contador

  // Instancia del top module
  top_module uut (
    .clk(clk),
    .reset(reset),
    .key(key),
    .count(count)
  );

  // Generador de reloj con periodo de 20ns (frecuencia de 50MHz)
  initial begin
    clk = 0;
    forever #5 clk = ~clk;  
  end

  // Bloque de estímulos para probar el comportamiento del top module
  initial begin
    // Inicialización
    reset = 0;    // Activamos el reset
    key = 0;      // Key inicialmente inactivo
    #100;         // Esperamos 100ns

    // Desactivamos el reset
    reset = 1;
    #100;         // Esperamos 100ns

    // Simulamos la activación del botón key (debouncing)
    key = 1;      // Presionamos el botón
    #500;       // Esperamos 50us (suficiente para debounce)
    key = 0;      // Soltamos el botón
    #100;       // Esperamos 50us más

    // Nuevamente presionamos el botón después de un tiempo
    key = 1;      // Presionamos el botón otra vez
    #20;       // Esperamos 50us
    key = 0;      // Soltamos el botón de nuevo
    #20;       // Esperamos 50us más
    key = 1;    // Desactivamos el reset
    #500;      // Esperamos 500us para observar el contador

    // Terminamos la simulación
    $stop;
  end

endmodule
