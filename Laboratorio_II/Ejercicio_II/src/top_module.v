module hex_keyboard_interface (
    input wire clk_in,
    input wire reset,
    input wire [3:0] key_cols,
    output wire [3:0] key_rows,
    output wire [3:0] hex_out,
    output wire key_pressed
);

wire clk_divided;
wire [1:0] count;
wire [3:0] decoded_rows;
wire [3:0] debounced_cols;
wire [3:0] hex_internal;
wire key_pressed_internal;

clock_divider div (
    .clk_in(clk_in),
    .reset(reset),
    .clk_out(clk_divided)
);

two_bit_counter counter (
    .clk(clk_divided),
    .reset(reset),
    .count(count)
);

decoder_2to4 row_decoder (
    .in(count),
    .out(decoded_rows)
);

assign key_rows = ~decoded_rows;  // Active low

genvar i;
generate
    for (i = 0; i < 4; i = i + 1) begin : debounce_cols
        debouncer deb (
            .clk(clk_divided),
            .key_in(key_cols[i]),
            .key_out(debounced_cols[i])
        );
    end
endgenerate

encoder enc (
    .row(decoded_rows),
    .col(debounced_cols),
    .hex_out(hex_internal),
    .key_pressed(key_pressed_internal)
);

output_register out_reg (
    .clk(clk_divided),
    .reset(reset),
    .hex_in(hex_internal),
    .key_pressed_in(key_pressed_internal),
    .hex_out(hex_out),
    .key_pressed_out(key_pressed)
);

endmodule