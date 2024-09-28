`timescale 1ns / 1ps

module debounce (
    input clk,
    input reset,
    input key,  
    output reg debounced_out         
);

    reg key_rst;

    // Registro para capturar el estado de 'key'
    always @(posedge clk) begin
        if (!reset) begin
            key_rst <= 1'b1;
        end else begin
            key_rst <= key;
        end
    end
        
    reg key_rst_r;
    
    // Registro para capturar el estado anterior de 'key'
    always @(posedge clk) begin
        if (!reset) begin
            key_rst_r <= 1'b1;
        end else begin
            key_rst_r <= key_rst;
        end
    end
    
    // Señal para reiniciar el contador cuando hay un cambio en el estado de 'key'
    wire cnt_rst = (key_rst_r != key_rst);
    
    reg [16:0] cnt; 

    // Contador para medir el tiempo que la señal 'key' ha estado estable
    always @(posedge clk) begin
        if (!reset) begin
            cnt <= 17'd0;
        end else if (cnt_rst) begin
            cnt <= 17'd0;  // Reinicia el contador si hay un cambio en 'key'
        end else if (cnt < 17'd100000 && key_rst == 1'b1) begin  // Tiempo de debounce 
            cnt <= cnt + 1'b1;
        end else begin
            cnt <= 17'd0;
        end
    end
    
    // Lógica para activar y desactivar 'debounced_out'
    always @(posedge clk) begin
        if (!reset) begin
            debounced_out <= 1'b0;  // Reinicia la salida
        end else if (cnt == 17'd100000 && key == 1'b1) begin  
            debounced_out <= 1'b1;  // Activa después de que 'key' esté estable por el tiempo suficiente
        end else if (key == 1'b0) begin
            debounced_out <= 1'b0;  // Desactiva cuando 'key' se desactiva
        end
    end

endmodule
