`timescale 1ns / 1ps

module ctrl_UART #(
    parameter palabra = 32,  // Tama�o por defecto de la palabra
    parameter N = 16         // Tama�o por defecto de addr2
)(
    // Entradas
    input wire [palabra-1:0] ctrl,    // Entrada de control
    input wire [palabra-1:0] data,    // Entrada de datos

    // Salidas
    output reg [palabra-1:0] IN2_data,    // Salida de datos IN2
    output reg WR2_data,                  // Se�al de escritura para datos
    output reg [palabra-1:0] IN2_ctrl,    // Salida de control IN2
    output reg WR2_ctrl,                  // Se�al de escritura para control

    // Direcci�n de salida
    output reg [N-1:0] addr2              // Salida de direcci�n
);

    //A�adir L�gica de control 
    always @(*) begin

        IN2_data <= data;              // Pasar los datos directamente a IN2_data
        WR2_data <= ctrl[0];           // Control de escritura desde el bit 0 de ctrl

        IN2_ctrl <= ctrl;              // Pasar el valor de ctrl a IN2_ctrl
        WR2_ctrl <= ctrl[1];           // Control de escritura basado en el bit 1 de ctrl

        addr2 <= data[N-1:0];          // La direcci�n se obtiene de los N bits inferiores de data
    end

endmodule
