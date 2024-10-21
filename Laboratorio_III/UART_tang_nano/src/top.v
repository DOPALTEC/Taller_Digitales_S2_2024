module top
(
    input clk,
    input rst_n,
    input [1:0] enable,  
    output [1:0] count,
    output reg count_bit1_reg,
    output reg count_bit0_reg,
    output reg enable_bit1_reg,
    output reg enable_bit0_reg,
    output uart_tx,
    input uart_rx, // Pin de recepción UART
    output [23:0] pixel_color,
    output write_enable
);
    wire slow_clk;
    wire [1:0] key_pressed;
    wire any_key_pressed;
    reg [1:0] count_internal;
    reg key_pressed_prev;

    // Instanciar el módulo clk divider
    clock_divider clk_div_inst (
        .clk(clk),
        .rst_n(rst_n),
        .slow_clk(slow_clk)
    );

    // Instanciar el módulo key debounce
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

    // Instanciar el módulo contador de 2 bits
    counter_2bit counter_inst (
        .clk(slow_clk),
        .rst_n(rst_n),
        .key_pressed(any_key_pressed),
        .count(count_internal)
    );

    assign count = count_internal;

    // Instanciar el módulo UART para enviar datos
    uart uart_inst (
        .clk(clk),
        .rst_n(rst_n),
        .uart_tx(uart_tx),
        .count_bit1_reg(count_bit1_reg),
        .count_bit0_reg(count_bit0_reg),
        .enable_bit1_reg(enable_bit1_reg),
        .enable_bit0_reg(enable_bit0_reg),
        .any_key_pressed(any_key_pressed)
    );

    // Almacenar los datos de la tecla presionada en los registros
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count_bit1_reg <= 1'b0;
            count_bit0_reg <= 1'b0;
            enable_bit1_reg <= 1'b0;
            enable_bit0_reg <= 1'b0;
            key_pressed_prev <= 1'b0;
        end else begin
            key_pressed_prev <= any_key_pressed;
            if (any_key_pressed && !key_pressed_prev) begin
                count_bit1_reg <= count_internal[1];
                count_bit0_reg <= count_internal[0];
                enable_bit1_reg <= enable[1];
                enable_bit0_reg <= enable[0];
            end
        end
    end

    // Instanciar el módulo UART para recibir datos
    wire [2:0] received_color;
    wire data_ready;

    uart_rx rx_inst (
        .clk(clk),
        .rst_n(rst_n),
        .uart_rx(uart_rx),
        .received_color(received_color),
        .data_ready(data_ready)
    );

    // Instanciar el módulo de visualización de la pantalla LCD
    lcd_display lcd_inst (
        .clk(clk),
        .rst_n(rst_n),
        .color_code(received_color),
        .pixel_color(pixel_color),
        .write_enable(write_enable)
    );

endmodule
