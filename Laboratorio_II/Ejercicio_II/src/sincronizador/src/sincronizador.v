`timescale 1ms / 100us

module sincronizador (
  input  [1:0] external_in,  // Entrada externa de 2 bits
  input  [1:0] counter_out,
  input  clk, 
  input  rst, 
  output reg [3:0] Q
);

  always @(posedge clk) begin
    if (!rst) begin
      Q <= 4'b0000;  // Reinicia la salida Q a 0
    end else begin
      // Q es una concatenación del contador y la entrada externa
      Q <= {counter_out[1], counter_out[0], external_in[1], external_in[0]};
    end
  end

endmodule
