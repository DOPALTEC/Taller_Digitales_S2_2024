`timescale 1ns / 1ps

module MUX_4_1_tb;

    parameter N=3;
    
    reg [N-1:0] IN_1;
    reg [N-1:0] IN_2;
    reg [N-1:0] IN_3;
    reg [N-1:0] IN_4;
    reg [1:0] sel;
    
    wire [N-1:0] OUT;
    
MUX_4_1 #(.N(N)) DUT(
    .IN_1(IN_1),
    .IN_2(IN_2),
    .IN_3(IN_3),
    .IN_4(IN_4),
    .sel(sel),
    .OUT(OUT)
);

initial begin
    sel=0;
    IN_1=0;
    IN_2=0;
    IN_3=0;
    IN_4=0;
    repeat(50) begin
        sel=$random;
        IN_1=$random;
        IN_2=$random;
        IN_3=$random;
        IN_4=$random;
        #20;
  
    end



end

endmodule
