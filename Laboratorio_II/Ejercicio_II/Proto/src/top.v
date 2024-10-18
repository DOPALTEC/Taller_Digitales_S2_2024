`timescale 1ns / 1ps
module top(
    input wire clk,
    input wire rst_n,
    
    // Entradas del teclado
    input wire key_in,      // Entrada del botón (key_in es el input del botón)
    
    // UART interface
    input wire rxd,         // UART RX pin
    output wire txd         // UART TX pin
);

    wire slow_clk;                // Salida del divisor de reloj
    wire debounced_key;           // Salida del debounce (indica si el botón está presionado)
    wire [1:0] count_bit1;        // Contador de 2 bits (parte 1)
    wire [1:0] count_bit0;        // Contador de 2 bits (parte 2)
    wire [3:0] tecla_4bits;       // Señal combinada de los bits del teclado
    wire [7:0] ascii_8bits;       // Salida del conversor (ASCII)
    wire transmitir;              // Señal para iniciar la transmisión UART
    wire busy_tx;                 // Señal de ocupación UART TX
    wire busy_rx;                 // Señal de ocupación UART RX
    wire [7:0] dato_rx;           // Dato recibido por UART RX
    wire hay_dato_tx;             // Señal de dato listo para UART TX
    
    // Divisor de reloj (para generar un clock más lento)
    clock_divider clk_div (
        .clk(clk),
        .rst_n(rst_n),
        .slow_clk(slow_clk)
    );
    
    // Módulo de debounce para el botón (evita falsos pulsos por ruido)
    key_debounce debounce (
        .clk(slow_clk),             // Reloj lento generado por el divisor
        .rst_n(rst_n),
        .key_in(key_in),
        .key_pressed(debounced_key) // Salida estable después del debounce
    );
    
    // Contador de 2 bits para el primer conjunto de bits del teclado
    counter_2bit counter1 (
        .clk(slow_clk),              // Utiliza el reloj lento
        .rst_n(rst_n),
        .key_pressed(debounced_key),  // Enable del contador
        .count(count_bit1)            // Salida de 2 bits
    );
    
    // Contador de 2 bits para el segundo conjunto de bits del teclado
    counter_2bit counter2 (
        .clk(slow_clk),
        .rst_n(rst_n),
        .key_pressed(debounced_key),  // Enable del contador
        .count(count_bit0)            // Salida de 2 bits
    );
    
    // Combinar los bits de los contadores en un bus de 4 bits
    assign tecla_4bits = {count_bit1, count_bit0};
    
    // Instancia del conversor tecla a ASCII
    conversor_tecla_a_ascii conv (
        .tecla_4bits(tecla_4bits),
        .ascii_8bits(ascii_8bits)
    );
    
    // Instancia del UART TX (Transmisión)
    uart_tx #(
        .DATA_WIDTH(8), 
        .prescale(1303)
    ) uart_tx_inst (
        .clk(clk),
        .rst(rst_n),
        .dato_tx(ascii_8bits),    // Entrada del código ASCII generado
        .transmitir(transmitir),  // Señal para comenzar a transmitir
        .hay_dato_tx(hay_dato_tx),
        .txd(txd),
        .busy(busy_tx)
    );

    // Instancia del UART RX (Recepción)
    uart_rx #(
        .DATA_WIDTH(8), 
        .prescale(1303)
    ) uart_rx_inst (
        .clk(clk),
        .rst(rst_n),
        .dato_rx(dato_rx),        // Salida del dato recibido
        .m_axis_tvalid(transmitir),  // Señal de dato recibido para transmisión
        .recibir(!busy_tx),       // Recibe cuando TX no está ocupado
        .rxd(rxd),
        .busy(busy_rx)
    );

endmodule
