// En el módulo top
wire slow_clk;

clock_divider clk_div_inst (
    .clk(clk),
    .reset(reset),
    .slow_clk(slow_clk)
);

counter counter_inst (
    .clk(slow_clk),  // Usa el reloj dividido
    .reset(reset),
    .enable(enable),
    .count(count)
);
