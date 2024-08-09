`timescale 1ns / 1ps

module ALU_TOP_TB;
    parameter N = 3;

    reg [N:0] A;
    reg [N:0] B;
    reg [N:0] ALUControl;
    reg ALUFlagIn;
    
    wire C;
    wire Z;
    wire [N:0] Y;

    ALU_TOP #(N) uut (
        .A(A), 
        .B(B), 
        .ALUControl(ALUControl), 
        .ALUFlagIn(ALUFlagIn), 
        .C(C), 
        .Z(Z), 
        .Y(Y)
    );

    initial begin
        //Inicializar
        A = 0;
        B = 0;
        ALUControl = 0;
        ALUFlagIn = 0;

        // AND
        A = $random % 4;
        B = $random % 4;
        ALUControl = 4'b0000;
        #10;

        // OR
        A = $random % 4;
        B = $random % 4;
        ALUControl = 4'b0001;
        #10;

        // SUMA COMPLEMETO A 2
        A = $random % 4;
        B = $random % 4;
        ALUFlagIn = $random % 2;
        ALUControl = 4'b0010;
        #10;

        // INCREMENTO A 1
        A = $random % 4;
        B = $random % 4;
        ALUFlagIn = $random % 2;
        ALUControl = 4'b0011;
        #10;

        // DECREMENTO A 1
        A = $random % 4;
        B = $random % 4;
        ALUFlagIn = $random % 2;
        ALUControl = 4'b0100;
        #10;

        // NOT
        A = $random % 4;
        B = $random % 4;
        ALUFlagIn = $random % 2;
        ALUControl = 4'b0101;
        #10;

        // RESTA COMPLEMENTO A 2
        A = $random % 4;
        B = $random % 4;
        ALUFlagIn = $random % 2;
        ALUControl = 4'b0110;
        #10;

        // XOR 
        A = $random % 4;
        B = $random % 4;
        ALUControl = 4'b0111;
        #10;

        // CORRIMIENTO IZQ
        A = $random % 4;
        B = $random % 4;
        ALUFlagIn = $random % 2;
        ALUControl = 4'b1000;
        #10;

        // CORRIMIENTO DER
        A = $random % 4;
        B = $random % 4;
        ALUFlagIn = $random % 2;
        ALUControl = 4'b1001;
        #10;

        $finish;
    end
      
endmodule
