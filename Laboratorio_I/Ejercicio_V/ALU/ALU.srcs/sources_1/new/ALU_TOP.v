`timescale 1ns / 1ps

module ALU_TOP #(parameter N=3) (
    input [N:0] A,
    input [N:0] B,
    input [N:0] ALUControl,
    input ALUFlagIn,
    output reg C,
    output reg zero,
    output reg [N:0] Y
);

always @* begin
    case(ALUControl)
        4'b0000: Y= A&B; //AND
        
        4'b0001: Y= A|B; //OR
        
        4'b0010:  //SUMA COMPLENETO A 2
            {C,Y} = A+B+ALUFlagIn;
        4'b0011:  //INCREMENTO A 1
            if (ALUFlagIn) begin
                {C,Y}=B+4'b0001;
            end
            else begin
                {C,Y}=A+4'b0001;
            end
        4'b0100: //DECREMENTO A 1
            if (ALUFlagIn) begin
                {C,Y}=B-4'b0001;
            end
            else begin
                {C,Y}=A-4'b0001;
            end
        4'b0101: //NOT
            if (ALUFlagIn) begin
                Y=~B;
            end
            else begin
                Y=~A;
            end
    endcase

end
    
    
endmodule
