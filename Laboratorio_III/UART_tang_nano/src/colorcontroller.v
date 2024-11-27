`timescale 1ps/1ps
module color_controller (
    input wire clk,
    input wire byteReady,
    input wire [7:0] dataIn,
    output reg [15:0] current_color
);
    // Color definitions en formato RGB565
    localparam COLOR_RED    = 16'hF800;
    localparam COLOR_GREEN  = 16'h07E0;
    localparam COLOR_BLUE   = 16'h001F;
    localparam COLOR_WHITE  = 16'hFFFF;
    localparam COLOR_BLACK  = 16'h0000;
    localparam COLOR_YELLOW = 16'hFFE0;
    localparam COLOR_PURPLE = 16'hF81F;
    localparam COLOR_CYAN   = 16'h07FF;

    initial begin
        current_color = COLOR_RED;  // Color inicial
    end

    always @(posedge clk) begin
        if (byteReady) begin
            case (dataIn)
                "r", "R": current_color <= COLOR_RED;
                "g", "G": current_color <= COLOR_GREEN;
                "b", "B": current_color <= COLOR_BLUE;
                "w", "W": current_color <= COLOR_WHITE;
                "k", "K": current_color <= COLOR_BLACK;
                "y", "Y": current_color <= COLOR_YELLOW;
                "p", "P": current_color <= COLOR_PURPLE;
                "c", "C": current_color <= COLOR_CYAN;
                default: current_color <= current_color;
            endcase
        end
    end
endmodule
