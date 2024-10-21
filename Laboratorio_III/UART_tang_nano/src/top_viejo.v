module top_viejo
    (
    input clk,
    input rst_n,
    input [1:0] enable,  
    output [1:0] count,
    output reg count_bit1_reg,
    output reg count_bit0_reg,
    output reg enable_bit1_reg,
    output reg enable_bit0_reg,
    output uart_tx
);
    wire slow_clk;
    wire [1:0] key_pressed;
    wire any_key_pressed;
    reg [1:0] count_internal;
    reg key_pressed_prev;

    // Instaciar el módulo clk divider
    clock_divider clk_div_inst (
        .clk(clk),
        .rst_n(rst_n),
        .slow_clk(slow_clk)
    );

    // Instaciar el módulo key debounce
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

    // // Instaciar el módulo contador de 2 bits
    counter_2bit counter_inst (
        .clk(slow_clk),
        .rst_n(rst_n),
        .key_pressed(any_key_pressed),
        .count(count_internal)
    );

    assign count = count_internal;
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

endmodule
