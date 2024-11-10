

`timescale 1ns / 1ps

/*
 * AXI4-Stream UART
 */
module uart_tx #(parameter DATA_WIDTH=32, parameter prescale=1303)
(
    input wire clk,
    input wire rst,
    input wire locked,

    /*
     * AXI input
     */
    input wire [DATA_WIDTH-1:0] dato_tx,
    input wire transmitir,
    output wire hay_dato_tx,

    /*
     * UART interface
     */
    output wire txd,

    /*
     * Status
     */
    output wire busy
);

reg s_axis_tready_reg = 0;
reg txd_reg = 1;
reg busy_reg = 0;
reg [DATA_WIDTH:0] data_reg = 0;
reg [18:0] prescale_reg = 0;
reg [3:0] bit_cnt = 0;
reg [DATA_WIDTH-1:0] dato_tx_reg = 0;

assign hay_dato_tx = s_axis_tready_reg;
assign txd = txd_reg;
assign busy = busy_reg;

always @(posedge clk) begin
    //if (rst || !locked) begin
    if (rst) begin
        s_axis_tready_reg <= 0;
        txd_reg <= 1;
        prescale_reg <= 0;
        bit_cnt <= 0;
        busy_reg <= 0;
        dato_tx_reg<=0;
    end else begin
        if (prescale_reg > 0) begin
            s_axis_tready_reg <= 0;
            prescale_reg <= prescale_reg - 1;
        end else if (bit_cnt == 0) begin
            s_axis_tready_reg <= 1;
            busy_reg <= 0;

            if (transmitir) begin
                dato_tx_reg <= dato_tx; 
                s_axis_tready_reg <= !s_axis_tready_reg;
                prescale_reg <= (prescale << 3)-1;
                bit_cnt <= DATA_WIDTH+1;
                data_reg <= {1'b1, dato_tx};
                txd_reg <= 0;
                busy_reg <= 1;
            end
        end else begin
            if (bit_cnt > 1) begin
                bit_cnt <= bit_cnt - 1;
                prescale_reg <= (prescale << 3)-1;
                {data_reg, txd_reg} <= {1'b0, data_reg};
            end else if (bit_cnt == 1) begin
                bit_cnt <= bit_cnt - 1;
                prescale_reg <= (prescale << 3);
                txd_reg <= 1;
            end
        end
    end
end

endmodule
