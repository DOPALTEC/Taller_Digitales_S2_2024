`timescale 1ns / 1ps

module top(
    input clk, // Reloj Interno de la FPGA TangNano 9k es de 27MHz
	input resetn,

	output ser_tx,
	input ser_rx,
	output [3:0] led,
	
	output rx_listo //Led
	
    );



reg [7:0] color_config;

reg rx_ctrl;  // Declarar rx_ctrl como un registro interno

wire [15:0] prescale;
assign prescale = 16'd351; 

// Asignación continua o dentro de un bloque always
always @(posedge clk or negedge resetn) begin
    if (!resetn) begin
        rx_ctrl <= 1'b1;  // Valor de reset por defecto
    end else begin
        rx_ctrl <= 1'b0;  // Se activa rx_ctrl en funcionamiento normal
    end
end

uart #(
    .DATA_WIDTH(8)
) uart_pc(
    .clk(clk), //Pin 52 en la Tang
    .rst(resetn), //Pin 4 en la Tang
    .s_axis_tdata(),
    .s_axis_tvalid(),
    .s_axis_tready(),
    .m_axis_tdata(color_config), //Valor recibido desde la PC mediante rx
    .m_axis_tvalid(rx_listo), //Indica que es valido recibir datos, cuando esta 
    //senial esta en alto se puede activar m_axis_tready
    .m_axis_tready(rx_ctrl), //Bit de control para aceptar lo que se recibe de PC
    //SE DEBE APAGAR CUANDO NO SE QUIEREN RECIBIR
    .rxd(ser_rx), //pin 18 en la Tang
    .txd(ser_tx), //pin 17 en la Tang
    .tx_busy(),
    .rx_busy(),
    .rx_overrun_error(),
    .rx_frame_error(),
    .prescale(prescale)
);
assign led = color_config[3:0];

endmodule