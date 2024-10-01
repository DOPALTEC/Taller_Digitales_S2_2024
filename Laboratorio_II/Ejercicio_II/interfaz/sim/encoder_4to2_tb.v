`timescale 1ns / 1ps

module tb_encoder_4to2;

    // Declarar señales
    reg [3:0] in2;        // Entrada de 4 bits
    wire [1:0] out2;      // Salida de 2 bits

    // Instanciar el módulo a probar
    encoder_4to2 uut (
        .in2(in2),
        .out2(out2)
    );

    initial begin
        // Monitorear los cambios en las señales
        $monitor("Tiempo: %0t | in2 = %b | out2 = %b", $time, in2, out2);

        // Inicializar la entrada
        in2 = 4'b1110;  //out2 = 2'b00
        #10;

        in2 = 4'b1101;  // out2 = 2'b01
        #10;

        in2 = 4'b1011;  // out2 = 2'b10
        #10;

        in2 = 4'b0111;  // out2 = 2'b11
        #10;

        // Finalizar la simulación
        $finish;
    end

endmodule
