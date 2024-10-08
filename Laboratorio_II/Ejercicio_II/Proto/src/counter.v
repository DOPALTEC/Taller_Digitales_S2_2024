`timescale 1ms / 100us
module counter_2bit (
    input wire clk,
    input wire rst_n,
    input wire key_pressed,  //Representa el enable
    output reg [1:0] count   //Salida 
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 2'b00;
        end else if (!key_pressed) begin  // Cuenta cuando no hay ninguna tecla presionada
            count <= count + 1;
        end
    end
endmodule
