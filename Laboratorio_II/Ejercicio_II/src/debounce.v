`timescale 1ns / 1ps

module debounce(
    input clk,             // Señal de reloj
    input reset,           // Señal de reset activa en bajo
    input button_in,       // Señal de entrada del botón
    output reg debounced_out // Señal de salida sin rebotes
);

    // Parámetro para el tiempo de debounce, ajustado para un reloj de 27 MHz
    localparam DEBOUNCE_DELAY = 54000;  // 2 ms a 27 MHz
    
    // Contador para medir la estabilidad de la señal del botón
    reg [15:0] counter;  
    
    // Señal interna que almacena el valor estable del botón
    reg button_stable;
    
    // Flip-flop de sincronización para la señal de salida
    reg sync_ff;

    // Proceso para detectar y filtrar los rebotes
    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            counter <= 16'b0;          // Reinicia el contador en caso de reset
            button_stable <= 1'b0;     // Reinicia la señal estable
        end else begin
            // Compara la señal de entrada con la señal estable
            if (button_in != button_stable) begin
                if (counter >= DEBOUNCE_DELAY) begin
                    button_stable <= button_in;  // Actualiza la señal estable cuando se alcanza el tiempo de debounce
                    counter <= 16'b0;            // Reinicia el contador
                end else begin
                    counter <= counter + 1;      // Incrementa el contador
                end
            end else begin
                counter <= 16'b0;                // Reinicia el contador si no hay cambio en button_in
            end
        end
    end

    // Sincronización de la señal debounced con el reloj
    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            sync_ff <= 1'b0;          // Reinicia el flip-flop de sincronización
            debounced_out <= 1'b0;    // Reinicia la señal de salida
        end else begin
            sync_ff <= button_stable;   // Captura la señal estable en el flip-flop
            debounced_out <= sync_ff;   // Actualiza la salida con la señal sincronizada
        end
    end

endmodule

endmodule
