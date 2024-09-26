
`timescale 1ns / 1ps
module debounce(
    input clk,
    input reset,      
    input wire [1:0] button,  // entrada del botón 
    output reg [1:0] debounced_out
);

reg [7:0] shift_reg;
    parameter  DEBOUNCE_THRESHOLD = 1;  // debounce delay

always @(posedge clk) begin
    shift_reg <= {shift_reg[6:0], key_in};
    if (shift_reg == 8'b11111111)
        key_out <= 1'b1;
    else if (shift_reg == 8'b00000000)
        key_out <= 1'b0;
end
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
