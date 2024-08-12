`timescale 1ns / 1ps

module ALU_tb;
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

    reg [31:0] seed; 
    reg [N:0] expected_Y;
    reg expected_C;
    reg expected_Z;
    integer i;  

    initial begin
        seed = 32'hDFADAEAF;
        
        A = 0;
        B = 0;
        ALUControl = 0;
        ALUFlagIn = 0;

        for (i = 0; i < 10; i = i + 1) begin
            A = $random(seed) % 16;
            B = $random(seed) % 16;
            ALUFlagIn = $random(seed) % 2;
            ALUControl = i;

            #10;
            expected_C = 1'bx;
            

            case (ALUControl)
                4'b0000: expected_Y = A & B;  // AND
                4'b0001: expected_Y = A | B;  // OR
                4'b0010: {expected_C, expected_Y} = A + B + ALUFlagIn;  // SUMA
                
                4'b0011:  // INCREMENTO
                if(ALUFlagIn) begin
                    {expected_C, expected_Y} = B + 1; 
                end else begin
                    {expected_C, expected_Y} = A + 1; 
                end
                
                4'b0100: // DECREMENTO
                if(ALUFlagIn) begin
                    {expected_C, expected_Y} = B - 1; 
                end else begin
                    {expected_C, expected_Y} = A - 1; 
                end

                4'b0101:  // NOT
                if(ALUFlagIn) begin
                    expected_Y = ~B; 
                end else begin
                    expected_Y = ~A; 
                end
                
                4'b0110: {expected_C, expected_Y} = A - B + ALUFlagIn;  // RESTA

                4'b0111: expected_Y = A ^ B;  // XOR

                4'b1000:  // CORRIMIENTO IZQ
                if (ALUFlagIn) begin
                    if (B > N) begin
                        expected_C = ALUFlagIn;
                    end else begin
                        expected_C = A[N+1-B];
                    end 
                    expected_Y = (A << B) | ({(N+1){1'b1}} >> ((N+1)-B));
                end else begin
                    if (B > N) begin
                        expected_C = ALUFlagIn;
                    end else begin
                        expected_C = A[N+1-B];
                    end  
                    expected_Y = A << B;
                end

                4'b1001:  // CORRIMIENTO DER
                if (ALUFlagIn) begin
                    if (B > N) begin
                        expected_C = ALUFlagIn;
                    end else begin
                        expected_C = A[N+1-B];
                    end 
                    expected_Y = (A >> B) | ({(N+1){1'b1}} << ((N+1)-B));
                end else begin
                    if (B > N) begin
                        expected_C = ALUFlagIn;
                    end else begin
                        expected_C = A[N+1-B];
                    end 
                    expected_Y = A >> B;
                end

                default: expected_Y = 0;
            endcase

            expected_Z = (expected_Y == 0);

            // Comparación y mensajes de error
            if (Y !== expected_Y || C !== expected_C || Z !== expected_Z) begin
                $display("Error: ALUControl=%b, A=%b, B=%b, ALUFlagIn=%b, Esperado: Y=%b, C=%b, Z=%b, Obtenido: Y=%b, C=%b, Z=%b", 
                    ALUControl, A, B, ALUFlagIn, expected_Y, expected_C, expected_Z, Y, C, Z);
            end else begin
                $display("Operación Exitosa: ALUControl=%b, A=%b, B=%b, ALUFlagIn=%b, Y=%b, C=%b, Z=%b", 
                    ALUControl, A, B, ALUFlagIn, Y, C, Z);
            end
        end

        $finish;
    end
      
endmodule
