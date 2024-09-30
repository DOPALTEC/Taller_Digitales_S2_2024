`timescale 1ms / 100us

module decoder_2to4_tb;
    
    // Entradas
    reg [1:0] in;
    
    // Salidas
    wire [3:0] out;
    
    // Instanciar el módulo que se va a probar
    decoder_2to4 uut (
        .in(in),
        .out(out)
    );

    // Procedimiento de prueba
    initial begin
        // Imprimir encabezado
        $display("Tiempo\t in\t out");
        
        // Monitorizar cambios en las señales
        $monitor("%d\t %b\t %b", $time, in, out);
        
        // Casos de prueba
        in = 2'b00; //out = 4'b1110
        #1;         
        
        in = 2'b01; //out = 4'b1101
        #1;
        
        in = 2'b10; //out = 4'b1011
        #1;
        
        in = 2'b11; //out = 4'b0111
        #1;
        
        // Finalizar simulación
        $finish;
    end
endmodule
