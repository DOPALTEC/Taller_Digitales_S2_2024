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

    input resetn,
    input ser_rx,
    output lcd_resetn,
    output lcd_clk,
    output lcd_cs,
    output lcd_rs,
    output lcd_data 
);
// spi 
    wire [7:0] uart_data;
    wire byte_ready;
    wire [15:0] color;
//uart transmisión 
    wire slow_clk;
    wire [1:0] key_pressed;
    wire any_key_pressed;
    reg [1:0] count_internal;
    reg key_pressed_prev;

     // Instancia del receptor UART
    uart_receiver #(
        .DELAY_FRAMES(234)
    ) uart_inst1 (
        .clk(clk),
        .ser_rx(ser_rx),
        .dataIn(uart_data),
        .byteReady(byte_ready)
    );

     // Instancia del controlador de color
    color_controller color_inst (
        .clk(clk),
        .byteReady(byte_ready),
        .dataIn(uart_data),
        .current_color(color)
    );

     // Instancia del controlador LCD
    lcd_controller lcd_inst (
        .clk(clk),
        .resetn(resetn),
        .current_color(color),
        .lcd_resetn(lcd_resetn),
        .lcd_clk(lcd_clk),
        .lcd_cs(lcd_cs),
        .lcd_rs(lcd_rs),
        .lcd_data(lcd_data)
    );

    // Instacia del módulo clk divider
    clock_divider clk_div_inst (
        .clk(clk),
        .rst_n(rst_n),
        .slow_clk(slow_clk)
    );

    // Instacia del módulo key debounce
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

    // Instaciar el módulo contador de 2 bits
    counter_2bit counter_inst (
        .clk(slow_clk),
        .rst_n(rst_n),
        .key_pressed(any_key_pressed),
        .count(count_internal)
    );

    assign count = count_internal;
 uart uart_inst2 (
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

endmodule
