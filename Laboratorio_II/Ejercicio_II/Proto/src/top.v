module top (
    input clk,
    input rst_n,
    input [1:0] enable,  
    output [1:0] count,
    output reg count_bit1_reg,
    output reg count_bit0_reg,
    output reg enable_bit1_reg,
    output reg enable_bit0_reg,
    output txd   // Salida UART (TX)
);
    wire slow_clk;
    wire [1:0] key_pressed;
    wire any_key_pressed;
    reg [1:0] count_internal;
    reg key_pressed_prev;

    // Señales para UART y conversor
    wire [3:0] tecla_4bits;
    wire [7:0] ascii_8bits;
    reg transmitir;  // Señal para iniciar la transmisión UART
    wire hay_dato_tx;
    wire uart_busy;

    // Instancia del módulo clock_divider
    clock_divider clk_div_inst (
        .clk(clk),
        .rst_n(rst_n),
        .slow_clk(slow_clk)
    );

    // Instancia del módulo key_debounce para ambos botones
    key_debounce key_debounce_0 (
        .clk(clk),
        .rst_n(rst_n),
        .key_in(enable[0]),
        .key_pressed(key_pressed[0])
    );

    key_debounce key_debounce_1 (
        .clk(clk),
        .rst_n(rst_n),
        .key_in(enable[1]),
        .key_pressed(key_pressed[1])
    );

    assign any_key_pressed = key_pressed[0] | key_pressed[1];

    // Instancia del módulo counter_2bit
    counter_2bit counter_inst (
        .clk(slow_clk),
        .rst_n(rst_n),
        .key_pressed(any_key_pressed),
        .count(count_internal)
    );

    assign count = count_internal;

    // Almacenar los datos de la tecla presionada en los registros
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count_bit1_reg <= 1'b0;
            count_bit0_reg <= 1'b0;
            enable_bit1_reg <= 1'b0;
            enable_bit0_reg <= 1'b0;
            key_pressed_prev <= 1'b0;
            transmitir <= 1'b0;  // Inicializar señal de transmisión en bajo
        end else begin
            key_pressed_prev <= any_key_pressed;
            if (any_key_pressed && !key_pressed_prev) begin
                count_bit1_reg <= count_internal[1];
                count_bit0_reg <= count_internal[0];
                enable_bit1_reg <= enable[1];
                enable_bit0_reg <= enable[0];
                transmitir <= 1'b1;  // Iniciar transmisión cuando hay nueva tecla presionada
            end else begin
                transmitir <= 1'b0;  // Desactivar transmisión
            end
        end
    end

    // Concatenar los bits de las teclas para formar la entrada de 4 bits
    assign tecla_4bits = {enable_bit1_reg, enable_bit0_reg, count_bit1_reg, count_bit0_reg};

    // Instancia del módulo conversor_tecla_a_ascii
    conversor_tecla_a_ascii conversor_inst (
        .tecla_4bits(tecla_4bits),
        .ascii_8bits(ascii_8bits)
    );

    // Instancia del módulo UART (uart_tx)
    uart_tx uart_tx_inst (
        .clk(clk),
        .rst(rst_n),
        .dato_tx(ascii_8bits),  // Dato ASCII generado por el conversor
        .transmitir(transmitir), // Iniciar la transmisión cuando se presiona una tecla
        .hay_dato_tx(hay_dato_tx),
        .txd(txd),               // Salida UART
        .busy(uart_busy)          // Estado de la UART
    );

endmodule
