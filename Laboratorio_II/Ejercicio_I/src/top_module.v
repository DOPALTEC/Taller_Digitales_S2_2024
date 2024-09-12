`timescale 1ns / 1ps
module top(
    input  clk,
    input rst_n,  
    input button, // button input
    output [7:0] cont
);
    wire sync_button, debounced_button;

    // Conexion de los modulos
    sync sync_inst (
        .clk(clk),
        .async_in(button),
        .sync_out(sync_button)
    );

    
    debounce debounce_inst (
        .clk(clk),
        .rst_n(rst_n),
        .button_in(sync_button),
        .debounced_out(debounced_button)
    );

    
    contador contador_inst (
        .clk(clk),
        .rst(rst_n),               
        .EN(debounced_button),     
        .cont(cont)
    );

endmodule
