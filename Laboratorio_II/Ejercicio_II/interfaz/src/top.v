`timescale 1ns / 1ps

module top (
    input clk,
    input rst_n,
    input [1:0] enable,      
    input [3:0] in2,           // Entrada externa para el codificador
    output [3:0] output_decoder, // Salida del decodificador
    output reg [1:0] count,    
    output reg count_bit1_reg,
    output reg count_bit0_reg,
    output reg enable_bit1_reg,
    output reg enable_bit0_reg
);

    wire slow_clk;
    wire [1:0] key_pressed;
    wire any_key_pressed;
    wire [1:0] encoder_output;    

    // Instanciación del divisor de reloj
    clock_divider clk_div_inst (
        .clk(clk),
        .rst_n(rst_n),
        .slow_clk(slow_clk)
    );

    // Instanciación del codificador 4 a 2
    encoder_4to2 encoder_inst (
        .in2(in2),                  
        .out2(encoder_output)        
    );

    // Instanciación de debounce para cada entrada de enable
    key_debounce key_debounce_0 (
        .clk(clk),
        .rst_n(rst_n),
        .key_in(encoder_output[0]), 
        .key_pressed(key_pressed[0])
    );

    key_debounce key_debounce_1 (
        .clk(clk),
        .rst_n(rst_n),
        .key_in(encoder_output[1]),
        .key_pressed(key_pressed[1])
    );

    assign any_key_pressed = key_pressed[0] | key_pressed[1];

    // Instanciación del contador 2 bits
    counter_2bit counter_inst (
        .clk(slow_clk),
        .rst_n(rst_n),
        .key_pressed(any_key_pressed),
        .count(count)               
    );

    // Instanciación del decodificador 2 a 4
    decoder_2to4 decoder_inst (
        .in(count),                 
        .out(output_decoder)        
    );

    // Lógica para almacenar valores en registros individuales
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count_bit1_reg <= 1'b0;
            count_bit0_reg <= 1'b0;
            enable_bit1_reg <= 1'b0;
            enable_bit0_reg <= 1'b0;
        end else begin
            if (any_key_pressed) begin
                count_bit1_reg <= count[1];
                count_bit0_reg <= count[0];
                enable_bit1_reg <= enable[1];
                enable_bit0_reg <= enable[0];
            end
        end
    end

endmodule
