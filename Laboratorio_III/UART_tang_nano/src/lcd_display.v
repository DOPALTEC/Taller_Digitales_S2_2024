module lcd_display (
    input wire clk,
    input wire rst_n,
    input wire [2:0] color_code, // Código de color de 0 a 7
    output reg [23:0] pixel_color, // Color RGB para el pixel
    output reg [7:0] data_out, // Datos a enviar a la pantalla
    output reg write_enable // Señal para habilitar la escritura en la pantalla
);
    // Definición de colores
    reg [23:0] colors [0:7]; // Arreglo para almacenar los colores

    initial begin
        colors[0] = 24'hFF0000; // Rojo
        colors[1] = 24'h00FF00; // Verde
        colors[2] = 24'h0000FF; // Azul
        colors[3] = 24'hFFFF00; // Amarillo
        colors[4] = 24'hFF00FF; // Magenta
        colors[5] = 24'h00FFFF; // Cian
        colors[6] = 24'hFFFFFF; // Blanco
        colors[7] = 24'h000000; // Negro
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pixel_color <= 0;
            data_out <= 0;
            write_enable <= 0;
        end else begin
            pixel_color <= colors[color_code]; // Asignar el color correspondiente
            // Aquí podrías incluir lógica para enviar el color a la pantalla
            // Por ejemplo, preparar datos para un framebuffer.
            write_enable <= 1; // Habilitar la escritura en la pantalla
        end
    end
endmodule
