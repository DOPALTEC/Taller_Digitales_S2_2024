`timescale 1ns / 1ps

module tb_Complemento_a_2;

reg [3:0] sw;
wire [3:0] led;

TOP_Leds uut(
    .sw(sw),
    .led(led)
);

integer i;

initial begin
    sw = 4'b0000;
    $display("Time\t sw\t led");
    $display("------------------------");


    for (i = 0; i < 16; i = i + 1) begin
        sw = i;
        #10;
        $display("%0dns\t %b\t %b", $time, sw, led);
    end

    $finish;
end
endmodule
