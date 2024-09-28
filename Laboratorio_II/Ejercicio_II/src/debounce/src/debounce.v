`timescale 1ns / 1ps

module debounce (
    input clk,
    input reset,
    input key,  
    output reg debounced_out         
);

    reg key_rst;
    reg key_rst_r;
    reg [16:0] cnt;  
    
    // Flip-flop para almacenar el estado de la tecla
    always @(posedge clk) begin
        if (!reset) begin
            key_rst <= 1'b1;
        end else begin
            key_rst <= key;
        end
    end
    
    always @(posedge clk) begin
        if (!reset) begin
            key_rst_r <= 1'b1;
        end else begin
            key_rst_r <= key_rst;
        end
    end
    
    // Señal para reiniciar el contador cuando hay un cambio en el key
    wire cnt_rst = (key_rst_r != key_rst);

    // Contador
    always @(posedge clk) begin
        if (!reset) begin
            cnt <= 17'd0;  // Reinicio del contador
        end else if (cnt_rst) begin
            cnt <= 17'd0;  // Reinicia si hay un cambio en la tecla
        end else if (cnt < 17'd100000) begin 
            cnt <= cnt + 1'b1;  // Incrementa el contador
        end    
    // Lógica para activar debounced_out
        if (!reset) begin
            debounced_out <= 1'b0;  // Reinicia la salida
        end else if (cnt == 17'd100000) begin  
            debounced_out <= 1'b1;  // Activa debounced_out
        end else begin
            debounced_out <= 1'b0;
        end
    end

endmodule
