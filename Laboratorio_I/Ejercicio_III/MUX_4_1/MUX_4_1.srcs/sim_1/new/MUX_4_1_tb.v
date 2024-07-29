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
    //Para 4 bits
    repeat(50) begin
        sel=$random;
        IN_1=$random;
        IN_2=$random;
        IN_3=$random;
        IN_4=$random;
        #20;
        
        if (sel == 2'b00 && OUT != IN_1) begin
            $display("Fallo en el Testbench: Selector: %b, IN_1: %b, Output: %b", sel, IN_1, OUT);
        end
        else if (sel == 2'b01 && OUT != IN_2) begin
            $display("Fallo en el Testbench: Selector: %b, IN_2: %b, Output: %b", sel, IN_2, OUT);
        end
        else if (sel == 2'b10 && OUT != IN_3) begin
            $display("Fallo en el Testbench: Selector: %b, IN_3: %b, Output: %b", sel, IN_3, OUT);
        end
        else if (sel == 2'b11 && OUT != IN_4) begin
            $display("Fallo en el Testbench: Selector: %b, IN_4: %b, Output: %b", sel, IN_4, OUT);
        end
        else begin
            $display("Iteracion Completada Correctamente");
        end
    end
    //Para 8 bits
    
    
    

end

endmodule
