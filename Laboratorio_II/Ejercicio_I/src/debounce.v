`timescale 1ns / 1ps

module debounce (
    input clk,
    input reset,
    input key,  
    output debounced_out         
);

    reg key_rst;
    reg key_rst_r;
    reg low_sw;
    reg low_sw_r;
    reg [7:0] cnt;  // Usamos 8 bits para contar hasta 200
    
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
    wire cnt_rst = (~key_rst_r) & key_rst;

    // Contador
    always @(posedge clk) begin
        if (!reset) begin
            cnt <= 8'd0;  // Reinicio del contador
        end else if (cnt_rst) begin
            cnt <= 8'd0;  // Reinicia si hay un cambio en la tecla
        end else if (cnt < 8'd200) begin  // Solo incrementa hasta 200
            cnt <= cnt + 1'b1;  // Incrementa el contador
        end
    end
    
    // Lógica para actualizar low_sw cuando el contador alcanza 200
    always @(posedge clk) begin
        if (!reset) begin
            low_sw <= 1'b0;
        end else if (cnt == 8'd200) begin  // Cuando el contador alcanza 200
            low_sw <= key;
        end
    end
    
    // Registro para la salida retrasada de low_sw
    always @(posedge clk) begin
        if (!reset) begin
            low_sw_r <= 1'b0;
        end else begin
            low_sw_r <= low_sw;
        end
    end
    
    // Salida debounced
    assign debounced_out = (~low_sw_r) & low_sw;  // Activa cuando hay un cambio en low_sw

endmodule


