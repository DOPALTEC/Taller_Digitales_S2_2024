`timescale 1ns / 1ps

module tb_top;
    // Inputs
    reg clk;
    reg rst_n;
    reg [3:0] in2;           // Entrada externa in2 de 4 bits
    reg [1:0] enable;       // Entradas para enable

    // Outputs
    wire [3:0] output_decoder;
    wire [1:0] count;       // Contador como salida

    // Instanciar el top module
    top uut (
        .clk(clk),
        .rst_n(rst_n),
        .enable(enable),         // Conectar enable
        .in2(in2),               // Conectar entrada externa in2
        .output_decoder(output_decoder),
        .count(count)            // Conectar contador como salida
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

    initial begin
        // Inicializar entradas
        rst_n = 0;
        enable = 2'b00;          // Inicializar enable
        in2 = 4'b0000;           // Inicializar entrada in2

        #20;                    
        rst_n = 1;              

        #10;
        in2 = 4'b1101;          
        enable = 2'b01;         
        #100;                   

        in2 = 4'b0011;          
        enable = 2'b10;         
        #100;                   

        in2 = 4'b1111;          
        enable = 2'b11;         
        #100;                   

        in2 = 4'b0000;          
        enable = 2'b00;         
        #100;                   

        // Finalizar simulacion
        $finish;
    end

    // Monitorear las salidas
    initial begin
        $monitor("Time: %0t | In2: %b | Enable: %b | Output Decoder: %b | Count: %b", 
                 $time, in2, enable, output_decoder, count);
    end

endmodule
