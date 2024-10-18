module sistema_uart_teclado (
    input wire clk,
    input wire rst,
    input wire [3:0] tecla_4bits, // Entrada del teclado
    input wire transmitir,        // Botón para transmitir
    output wire txd,              // Salida UART
    output wire tx_busy           // Estado UART ocupado
);
    
    wire [7:0] ascii_8bits;      // Señal intermedia: código ASCII
    wire hay_dato_tx;            // Indica si hay un dato listo para transmitir

    // Instancia del conversor de tecla a ASCII
    conversor_tecla_a_ascii conversor (
        .tecla_4bits(tecla_4bits),
        .ascii_8bits(ascii_8bits)
    );

    // Instancia de la UART
    uart_tx #(.DATA_WIDTH(8), .prescale(1303)) uart_tx_inst (
        .clk(clk),
        .rst(rst),
        .dato_tx(ascii_8bits),    // El dato a transmitir es el ASCII
        .transmitir(transmitir),  // Transmitir cuando se presiona el botón
        .hay_dato_tx(hay_dato_tx),
        .txd(txd),
        .busy(tx_busy)
    );

endmodule
