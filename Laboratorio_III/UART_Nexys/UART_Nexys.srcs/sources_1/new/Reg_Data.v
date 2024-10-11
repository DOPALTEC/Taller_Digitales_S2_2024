module Reg_Data #(parameter Palabra=32) (
    input wire [Palabra-1:0] IN1,       // Entrada 1 de 32 bits
    input wire [Palabra-1:0] IN2,       // Entrada 2 de 32 bits
    input wire addr1,            // L�nea de direcci�n para IN1
    input wire addr2,            // L�nea de direcci�n para IN2
    input wire WR1,              // Bit de escritura para IN1
    input wire WR2,              // Bit de escritura para IN2
    input wire hold_ctrl,        // Control para seleccionar el registro
    output reg [Palabra-1:0] OUT        // Salida de 32 bits
);

    // Registro para almacenar los datos
    reg [Palabra-1:0] register1 = 0;    // Registro 1
    reg [Palabra-1:0] register2 = 0;    // Registro 2

    always @(*) begin
        // Inicializamos la salida
        OUT = 0;

        // Almacenamos DATO en el registro correspondiente
        if (hold_ctrl) begin
            // Cuando hold_ctrl es 1, utilizamos IN2
            if (addr2 && WR2) begin
                register2[7:0] = IN2[7:0]; // Solo almacenamos los bits 0-7
            end
            OUT = register2; // Proporcionamos la salida del registro 2
        end else begin
            // Cuando hold_ctrl es 0, utilizamos IN1
            if (!addr1 && WR1) begin
                register1[7:0] = IN1[7:0]; // Solo almacenamos los bits 0-7
            end
            OUT = register1; // Proporcionamos la salida del registro 1
        end
    end

endmodule
