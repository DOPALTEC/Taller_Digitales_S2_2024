`timescale 1ms / 100us
module counter_8bit (
    input wire clk,
    input wire rst_n,
    input wire key_pressed, //Representa el enable 
    output reg [7:0] count
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 8'b00000000;
        end else if (!key_pressed) begin  // Cuenta cuando no hay ninguna tecla presionada
            count <= count + 1;
        end
    end
endmodule
