`timescale 1ns / 1ps

module counter_tb;

    reg clk;
    reg reset;
    reg enable;  
    wire [7:0] count;  

    // Instancia del módulo counter
    counter uut (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .count(count)
    );

    // Generador de reloj (clock)
    always begin
        #5 clk = ~clk;  
    end

    // Simulación
    initial begin
        // Inicialización
        clk = 0;
        reset = 0;
        enable = 0;  
      
        #10 reset = 1;  
        #10 enable = 1;  
        #30;  
        #10 enable = 0; 
        #80;
        #10 enable = 1; 
        #300;  

        // Finalizar la simulación
        #10 $stop;
    end
endmodule
