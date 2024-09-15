module top(
    input clk,
    input reset,
    input button_in,
    output [7:0] count_out
);

    wire debounced_button;
    wire sync_button;

    // Instanciar el módulo debounce
    debounce debounce_inst (
        .clk(clk),
        .reset(reset),
        .button_in(button_in),
        .debounced_out(debounced_out)
    );

    // Instanciar el módulo sync
    sync sync_inst (
        .clk(clk),
        .async_in(debounced_out),
        .sync_out(sync_out)
    );

    // Instanciar el módulo counter
    contador contador_inst (
        .clk(clk),
        .reset(reset),  // Active low reset
        .en(sync_out),  // Contar solo cuando el botón está sincronizado
        .q(count_out)
    );

endmodule
