`timescale 1ns / 1ps

module MUX_4_1_tb;

    //instancias con parametro de 4 bits
    parameter N0 = 4;
    reg [N0-1:0] IN0_1, IN0_2, IN0_3, IN0_4;
    reg [1:0] sel0;
    wire [N0-1:0] OUT0;

    MUX_4_1 #(.N(N0)) DUT0(
        .IN_1(IN0_1),
        .IN_2(IN0_2),
        .IN_3(IN0_3),
        .IN_4(IN0_4),
        .sel(sel0),
        .OUT(OUT0)
    );

    //instancias con parametro de 8 bits
    parameter N1=8;
    reg [N1-1:0] IN1_1, IN1_2, IN1_3, IN1_4;
    reg [1:0] sel1;
    wire [N1-1:0] OUT1;

    MUX_4_1 #(.N(N1)) DUT1(
        .IN_1(IN1_1),
        .IN_2(IN1_2),
        .IN_3(IN1_3),
        .IN_4(IN1_4),
        .sel(sel1),
        .OUT(OUT1)
    );

    //Instancias con parametro de 16 bits
    parameter N2=16;
    reg [N2-1:0] IN2_1, IN2_2, IN2_3, IN2_4;
    reg [1:0] sel2;
    wire [N2-1:0] OUT2;

    MUX_4_1 #(.N(N2)) DUT2 (
        .IN_1(IN2_1),
        .IN_2(IN2_2),
        .IN_3(IN2_3),
        .IN_4(IN2_4),
        .sel(sel2),
        .OUT(OUT2)
    );

    initial begin
        //Para 4bits
        sel0 = 0;
        IN0_1 = 0;
        IN0_2 = 0;
        IN0_3 = 0;
        IN0_4 = 0;
        
        //Para 8bits
        sel1 = 0;
        IN1_1 = 0;
        IN1_2 = 0;
        IN1_3 = 0;
        IN1_4 = 0;
        
        //Para 16 bits
        sel2 = 0;
        IN2_1 = 0;
        IN2_2 = 0;
        IN2_3 = 0;
        IN2_4 = 0;
        
        
        //Para 4bits
        repeat(50) begin
            sel0 = $random;
            IN0_1 = $random;
            IN0_2 = $random;
            IN0_3 = $random;
            IN0_4 = $random;
            #20;
            
            if (sel0 == 2'b00 && OUT0 != IN0_1) begin
                $display("Fallo en el Testbench (N0=4): Selector: %b, IN0_1: %b, Output: %b", sel0, IN0_1, OUT0);
            end
            else if (sel0 == 2'b01 && OUT0 != IN0_2) begin
                $display("Fallo en el Testbench (N0=4): Selector: %b, IN0_2: %b, Output: %b", sel0, IN0_2, OUT0);
            end
            else if (sel0 == 2'b10 && OUT0 != IN0_3) begin
                $display("Fallo en el Testbench (N0=4): Selector: %b, IN0_3: %b, Output: %b", sel0, IN0_3, OUT0);
            end
            else if (sel0 == 2'b11 && OUT0 != IN0_4) begin
                $display("Fallo en el Testbench (N0=4): Selector: %b, IN0_4: %b, Output: %b", sel0, IN0_4, OUT0);
            end
            else begin
                $display("Iteracion Completada Correctamente (N0=4)");
            end
        end

        sel0 = 0;
        IN0_1 = 0;
        IN0_2 = 0;
        IN0_3 = 0;
        IN0_4 = 0;
        //Para 8bits
        repeat(50) begin
            sel1 = $random;
            IN1_1 = $random;
            IN1_2 = $random;
            IN1_3 = $random;
            IN1_4 = $random;
            #20;
            
            if (sel1 == 2'b00 && OUT1 != IN1_1) begin
                $display("Fallo en el Testbench (N1=8): Selector: %b, IN1_1: %b, Output: %b", sel1, IN1_1, OUT1);
            end
            else if (sel1 == 2'b01 && OUT1 != IN1_2) begin
                $display("Fallo en el Testbench (N1=8): Selector: %b, IN1_2: %b, Output: %b", sel1, IN1_2, OUT1);
            end
            else if (sel1 == 2'b10 && OUT1 != IN1_3) begin
                $display("Fallo en el Testbench (N1=8): Selector: %b, IN1_3: %b, Output: %b", sel1, IN1_3, OUT1);
            end
            else if (sel1 == 2'b11 && OUT1 != IN1_4) begin
                $display("Fallo en el Testbench (N1=8): Selector: %b, IN1_4: %b, Output: %b", sel1, IN1_4, OUT1);
            end
            else begin
                $display("Iteracion Completada Correctamente (N1=8)");
            end
        end
        
        sel1 = 0;
        IN1_1 = 0;
        IN1_2 = 0;
        IN1_3 = 0;
        IN1_4 = 0;
        
        //Para 16bits
        repeat(50) begin
            sel2 = $random;
            IN2_1 = $random;
            IN2_2 = $random;
            IN2_3 = $random;
            IN2_4 = $random;
            #20;
            
            if (sel2 == 2'b00 && OUT2 != IN2_1) begin
                $display("Fallo en el Testbench (N2=16): Selector: %b, IN2_1: %b, Output: %b", sel2, IN2_1, OUT2);
            end
            else if (sel2 == 2'b01 && OUT2 != IN2_2) begin
                $display("Fallo en el Testbench (N2=16): Selector: %b, IN2_2: %b, Output: %b", sel2, IN2_2, OUT2);
            end
            else if (sel2 == 2'b10 && OUT2 != IN2_3) begin
                $display("Fallo en el Testbench (N2=16): Selector: %b, IN2_3: %b, Output: %b", sel2, IN2_3, OUT2);
            end
            else if (sel2 == 2'b11 && OUT2 != IN2_4) begin
                $display("Fallo en el Testbench (N2=16): Selector: %b, IN2_4: %b, Output: %b", sel2, IN2_4, OUT2);
            end
            else begin
                $display("Iteracion Completada Correctamente (N2=16)");
            end
        end
    end

    initial begin
        // Run simulation for 3000ns
        #3000;
        $finish;
    end

endmodule
