`timescale 1ns / 1ps
module debounce(
    input clk,
    input reset,      
    input wire [1:0] button,  // entrada del botón 
    output reg [1:0] debounced_out
);

    parameter  DEBOUNCE_THRESHOLD = 1000;  // debounce delay
    reg [19:0] counter;  
    reg [1:0] button_stable = 2'b00;    // Reg para almacenar el estado estable
    
    // contador 
    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            counter <= 0;
            button_stable <= 2'b00;  // Inicializar en 0
        end else begin
            if (button != button_stable) begin
                counter <= counter + 1;
                if (counter >= DEBOUNCE_THRESHOLD) begin
                    button_stable <= button;   // Actualizar el estado estable
                    counter <= 0;
                end
            end else begin
                counter <= 0;  // Resetear el contador si button_in está estable
            end
        end
    end
    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            debounced_out <= 0;
        end else begin
            debounced_out <= button_stable;  // Actualizar salida con el valor estable
        end
    end

endmodule
