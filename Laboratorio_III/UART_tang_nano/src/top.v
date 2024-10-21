module top_viejo (
    input clk,
    input rst_n,
    input [1:0] enable,  
    output [1:0] count,
    output reg count_bit1_reg,
    output reg count_bit0_reg,
    output reg enable_bit1_reg,
    output reg enable_bit0_reg,
    output uart_tx,
    input uart_rx,  // Entrada para UART RX
    output ser_tx,   // Salida para UART TX
    output lcd_resetn,
    output lcd_clk,
    output lcd_cs,
    output lcd_rs,
    output lcd_data
);

    wire slow_clk;
    wire [1:0] key_pressed;
    wire any_key_pressed;
    wire [2:0] received_color; // Color recibido del módulo uart_rx
    wire data_ready; // Señal de que hay datos listos
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

    // Instanciar el módulo uart_tx
    uart_tx uart_tx_inst (
        .clk(clk),
        .rst_n(rst_n),
        .uart_tx(uart_tx),
        .count_bit1_reg(count_bit1_reg),
        .count_bit0_reg(count_bit0_reg),
        .enable_bit1_reg(enable_bit1_reg),
        .enable_bit0_reg(enable_bit0_reg),
        .any_key_pressed(any_key_pressed)
    );

    // Instanciar el módulo uart_rx
    uart_rx uart_rx_inst (
        .clk(clk),
        .rst_n(rst_n),
        .uart_rx(uart_rx),
        .received_color(received_color),
        .data_ready(data_ready)
    );

    // Instanciar el módulo lcd114_test
    lcd114_test lcd_inst (
        .clk(clk), // Utiliza el reloj de entrada
        .resetn(rst_n),
        .key_value(received_color), // Enviar el color recibido al LCD
        .ser_tx(ser_tx), // Salida para el transmisor UART
        .ser_rx(uart_rx), // Recepción UART (opcional)
        .lcd_resetn(lcd_resetn),
        .lcd_clk(lcd_clk),
        .lcd_cs(lcd_cs),
        .lcd_rs(lcd_rs),
        .lcd_data(lcd_data)
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

endmodule

