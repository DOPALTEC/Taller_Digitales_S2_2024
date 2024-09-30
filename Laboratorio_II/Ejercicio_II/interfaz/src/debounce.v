`timescale 1ms / 100us

module key_debounce #(
    parameter DEBOUNCE_TIME = 1000000  // Tiempo de debounce en ciclos de reloj
)(
    input wire clk,        
    input wire rst_n,      
    input wire key_in,     // Entrada del botón 
    output reg key_pressed // Salida debounced (indica si el botón está presionado)
);

    // Declaración de registros internos
    reg [19:0] counter;    // Contador para medir el tiempo de debounce
    reg key_reg;           // Registro para almacenar el estado anterior del botón

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Cuando el reset es activado (activo en bajo), inicializa los registros
            counter <= 0;          
            key_reg <= 0;          
            key_pressed <= 0;      
        end else begin
            key_reg <= key_in;     // Captura el estado actual del botón

            // Si el estado del botón ha cambiado (indica rebote)
            if (key_reg != key_in) begin
                counter <= 0;      // Reinicia el contador cuando detecta un cambio en la entrada
                key_pressed <= 0;  // Temporalmente desactiva la salida hasta que se estabilice
            end
            // Si el estado del botón no ha cambiado y el contador ha alcanzado el tiempo de debounce
            else if (counter == DEBOUNCE_TIME - 1) begin
                key_pressed <= key_in;  // Estabiliza la salida 
            end
            // Si el estado del botón no ha cambiado pero el contador aún no ha alcanzado el tiempo de debounce
            else begin
                counter <= counter + 1; // Incrementa el contador
            end
        end
    end
endmodule

