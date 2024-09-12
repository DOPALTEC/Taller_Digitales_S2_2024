module SPI_Master_TB ();
  
  parameter SPI_MODE = 3; // CPOL = 1, CPHA = 1
  parameter CLKS_PER_HALF_BIT = 4;  // 6.25 MHz
  parameter MAIN_CLK_DELAY = 2;  // 25 MHz

  reg r_Rst_L     = 1'b0;  
  wire w_SPI_Clk;
  reg r_Clk       = 1'b0;
  wire w_SPI_MOSI;

  // Señales específicas del maestro
  reg [7:0] r_Master_TX_Byte = 0;
  reg r_Master_TX_DV = 1'b0;
  wire w_Master_TX_Ready;
  wire r_Master_RX_DV;
  wire [7:0] r_Master_RX_Byte;

  // Generadores de reloj:
  always #(MAIN_CLK_DELAY) r_Clk = ~r_Clk;

  // Instancia del UUT (Unidad Bajo Prueba)
  SPI_Master 
  #(.SPI_MODE(SPI_MODE),
    .CLKS_PER_HALF_BIT(CLKS_PER_HALF_BIT)) SPI_Master_UUT
  (
   // Señales de control y datos,
   .i_Rst_L(r_Rst_L),     // Reset de FPGA
   .i_Clk(r_Clk),         // Reloj de FPGA
   
   // Señales de transmisión (MOSI)
   .i_TX_Byte(r_Master_TX_Byte),     // Byte para transmitir en MOSI
   .i_TX_DV(r_Master_TX_DV),         // Pulso de dato válido con i_TX_Byte
   .o_TX_Ready(w_Master_TX_Ready),   // Señal de que la transmisión está lista para el próximo byte
   
   // Señales de recepción (MISO)
   .o_RX_DV(r_Master_RX_DV),       // Pulso de dato válido (1 ciclo de reloj)
   .o_RX_Byte(r_Master_RX_Byte),   // Byte recibido en MISO

   // Interfaz SPI
   .o_SPI_Clk(w_SPI_Clk),
   .i_SPI_MISO(w_SPI_MOSI),
   .o_SPI_MOSI(w_SPI_MOSI)
   );

  //Funcion (task) encargada de simular el envio de un solo byte desde el maestro al ser referenciada
  task SendSingleByte(input [7:0] data); //Recibe como parametro el dato a enviar
    begin
      @(posedge r_Clk);
      r_Master_TX_Byte <= data; //Le asigna a la transmision el dato que se quiere enviar
      r_Master_TX_DV   <= 1'b1;
      @(posedge r_Clk);
      r_Master_TX_DV <= 1'b0;
      @(posedge w_Master_TX_Ready);
    end
  endtask // SendSingleByte

  initial
    begin
      // Requerido para EDA Playground
      $dumpfile("dump.vcd"); 
      $dumpvars;
      
      repeat(10) @(posedge r_Clk);
      r_Rst_L  = 1'b0;
      repeat(10) @(posedge r_Clk);
      r_Rst_L  = 1'b1;
      
      // Prueba con un solo byte
      SendSingleByte(8'hC1);
      $display("Enviado 0xC1, Recibido 0x%X", r_Master_RX_Byte); 
      
      // Prueba con doble byte
      SendSingleByte(8'hBE);
      $display("Enviado 0xBE, Recibido 0x%X", r_Master_RX_Byte); 
      SendSingleByte(8'hEF);
      $display("Enviado 0xEF, Recibido 0x%X", r_Master_RX_Byte); 
      repeat(10) @(posedge r_Clk);
      $finish();      
    end // initial begin

endmodule // SPI_Master_TB
