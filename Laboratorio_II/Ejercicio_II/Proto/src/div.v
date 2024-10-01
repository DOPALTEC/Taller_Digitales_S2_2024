`timescale 1ms / 100us

module clock_divider (
    input clk,           
    input rst_n,         
    output reg slow_clk  
);

    reg [24:0] counter;  // Ajusta el ancho de bits para la velocidad deseada

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            counter <= 0;  // Si reset está activo (bajo), reiniciar el contador
        else
            counter <= counter + 1;  // Incrementar el contador en cada ciclo de reloj
    end

    // Bloque para dividir la frecuencia del reloj
    // Cuando el contador alcanza un valor específico, invierte slow_clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            slow_clk <= 0;  // Reiniciar el slow_clk cuando el reset está activo (bajo)
        else if (counter == 25_000_000) begin  // Cuando el contador alcanza el valor 
            slow_clk <= ~slow_clk;  // Invertir el estado de slow_clk para dividir la frecuencia del reloj
        end
    end

endmodule
