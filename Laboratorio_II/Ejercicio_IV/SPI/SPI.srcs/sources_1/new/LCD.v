// 1.14 inch 240x135 SPI LCD TEST for TANG NANO 9K

//PAG 53 SERIAL INTERFACE: Hoja de Datos de ST7789
    //Interfaz de 3 lineas es la utilizada para el Controlador ST7789
        //DCX: Señal de Reloj
        //SDA: Entrada de Datos al Controlador del LCD
        //CSX: Chip Select. Puede ser un parametro que solo valga 1 siempre
        //SDO: Salida de daos del controlador del LCD
//PAG 153 Comandos
    //Muestra unas tablas que indican que si se envía un byte con ese codigo se realiza una determinada operacion
    //Se acceden al activar ciertos valores en 3 señales (D/CX) (WRX) (RDX)
`timescale 1ps/1ps

module LCD(
	input clk, // 27M
	input resetn,

	output ser_tx,
	input ser_rx,

	output lcd_resetn,
	output lcd_clk,
	output lcd_cs,
	output lcd_rs,
	output lcd_data
);

localparam MAX_CMDS = 69;

wire [8:0] init_cmd[MAX_CMDS:0];
//Configuracion para tener el panel lcd listo para mostrar las lineas
assign init_cmd[ 0] = 9'h036;
assign init_cmd[ 1] = 9'h170;
assign init_cmd[ 2] = 9'h03A;
assign init_cmd[ 3] = 9'h105;
assign init_cmd[ 4] = 9'h0B2;
assign init_cmd[ 5] = 9'h10C;
assign init_cmd[ 6] = 9'h10C;
assign init_cmd[ 7] = 9'h100;
assign init_cmd[ 8] = 9'h133;
assign init_cmd[ 9] = 9'h133;
assign init_cmd[10] = 9'h0B7;
assign init_cmd[11] = 9'h135;
assign init_cmd[12] = 9'h0BB;
assign init_cmd[13] = 9'h119;
assign init_cmd[14] = 9'h0C0;
assign init_cmd[15] = 9'h12C;
assign init_cmd[16] = 9'h0C2;
assign init_cmd[17] = 9'h101;
assign init_cmd[18] = 9'h0C3;
assign init_cmd[19] = 9'h112;
assign init_cmd[20] = 9'h0C4;
assign init_cmd[21] = 9'h120;
assign init_cmd[22] = 9'h0C6;
assign init_cmd[23] = 9'h10F;
assign init_cmd[24] = 9'h0D0;
assign init_cmd[25] = 9'h1A4;
assign init_cmd[26] = 9'h1A1;
assign init_cmd[27] = 9'h0E0;
assign init_cmd[28] = 9'h1D0;
assign init_cmd[29] = 9'h104;
assign init_cmd[30] = 9'h10D;
assign init_cmd[31] = 9'h111;
assign init_cmd[32] = 9'h113;
assign init_cmd[33] = 9'h12B;
assign init_cmd[34] = 9'h13F;
assign init_cmd[35] = 9'h154;
assign init_cmd[36] = 9'h14C;
assign init_cmd[37] = 9'h118;
assign init_cmd[38] = 9'h10D;
assign init_cmd[39] = 9'h10B;
assign init_cmd[40] = 9'h11F;
assign init_cmd[41] = 9'h123;
assign init_cmd[42] = 9'h0E1;
assign init_cmd[43] = 9'h1D0;
assign init_cmd[44] = 9'h104;
assign init_cmd[45] = 9'h10C;
assign init_cmd[46] = 9'h111;
assign init_cmd[47] = 9'h113;
assign init_cmd[48] = 9'h12C;
assign init_cmd[49] = 9'h13F;
assign init_cmd[50] = 9'h144;
assign init_cmd[51] = 9'h151;
assign init_cmd[52] = 9'h12F;
assign init_cmd[53] = 9'h11F;
assign init_cmd[54] = 9'h11F;
assign init_cmd[55] = 9'h120;
assign init_cmd[56] = 9'h123;
assign init_cmd[57] = 9'h021;
assign init_cmd[58] = 9'h029;

assign init_cmd[59] = 9'h02A; // columna: Se coloca en la primera columna
assign init_cmd[60] = 9'h100;
assign init_cmd[61] = 9'h128;
assign init_cmd[62] = 9'h101;
assign init_cmd[63] = 9'h117;
assign init_cmd[64] = 9'h02B; // fila: Se coloca en la primera fila
assign init_cmd[65] = 9'h100;
assign init_cmd[66] = 9'h135;
assign init_cmd[67] = 9'h100;
assign init_cmd[68] = 9'h1BB;
assign init_cmd[69] = 9'h02C; // start

localparam INIT_RESET   = 4'b0000; // delay 100ms while reset
localparam INIT_PREPARE = 4'b0001; // delay 200ms after reset
localparam INIT_WAKEUP  = 4'b0010; // write cmd 0x11 MIPI_DCS_EXIT_SLEEP_MODE
localparam INIT_SNOOZE  = 4'b0011; // delay 120ms after wakeup
localparam INIT_WORKING = 4'b0100; // write command & data
localparam INIT_DONE    = 4'b0101; // all done

`ifdef MODELTECH

localparam CNT_100MS = 32'd2700000;
localparam CNT_120MS = 32'd3240000;
localparam CNT_200MS = 32'd5400000;

`else

// speedup for simulation
localparam CNT_100MS = 32'd27;
localparam CNT_120MS = 32'd32;
localparam CNT_200MS = 32'd54;

`endif


reg [ 3:0] init_state;
reg [ 6:0] cmd_index;
reg [31:0] clk_cnt;
reg [ 4:0] bit_loop;

reg [15:0] pixel_cnt; //Contador que muestra el numero de pixeles mostrados en pantalla, cuenta todos los pixeles de la LCD, 240x135=32400 pixeles en total
reg [15:0] grilla_cnt; //Contador extra, al llegar a 30 pixeles, se reinicia, la suma de filas genera la columna de un color de ancho 30p 

reg lcd_cs_r;
reg lcd_rs_r;
reg lcd_reset_r;

reg [7:0] spi_data;

assign lcd_resetn = lcd_reset_r;
assign lcd_clk    = ~clk;
assign lcd_cs     = lcd_cs_r;
assign lcd_rs     = lcd_rs_r;
assign lcd_data   = spi_data[7]; // MSB



// gen color bar

//wire [15:0] pixel = (pixel_cnt >= 21600) ? 16'hF800 : //Si el contador de pixeles es mayor o igual a 21600 se asigna el color rojo (hF800)
					//(pixel_cnt >= 10800) ? 16'h07E0 : 16'h001F; //Si el contador es menor a 21600 pero mayor a 10800 se asigna verde (h07E0)
					//Si el contador de pixeles es menor a 10800 es azul (h001F)
//Se debe hacer máquina de estados que revise cada ciclo de reloj si se cambia la configuracion de colores
//si lo que se recibe en el receptor de la comunicacion spi entre pc y fpga es 1 se aplica la primera config y analogamente con la segunda
wire [15:0] pixel = (grilla_cnt<=30)? 16'hF800 : 16'h001F; //Por cada par de  grilla de ancho 30 son 4050*2 pixeles



always@(posedge clk or negedge resetn) begin
	if (~resetn) begin
		clk_cnt <= 0;
		cmd_index <= 0;
		init_state <= INIT_RESET;

		lcd_cs_r <= 1;
		lcd_rs_r <= 1;
		lcd_reset_r <= 0;
		spi_data <= 8'hFF;
		bit_loop <= 0;

		pixel_cnt <= 0;
		grilla_cnt<=0;
	end else begin

		case (init_state)

			INIT_RESET : begin
				if (clk_cnt == CNT_100MS) begin
					clk_cnt <= 0;
					init_state <= INIT_PREPARE;
					lcd_reset_r <= 1;
				end else begin
					clk_cnt <= clk_cnt + 1;
				end
			end

			INIT_PREPARE : begin
				if (clk_cnt == CNT_200MS) begin
					clk_cnt <= 0;
					init_state <= INIT_WAKEUP;
				end else begin
					clk_cnt <= clk_cnt + 1;
				end
			end

			INIT_WAKEUP : begin
				if (bit_loop == 0) begin
					// start
					lcd_cs_r <= 0;
					lcd_rs_r <= 0;
					spi_data <= 8'h11; // exit sleep
					bit_loop <= bit_loop + 1;
				end else if (bit_loop == 8) begin
					// end
					lcd_cs_r <= 1;
					lcd_rs_r <= 1;
					bit_loop <= 0;
					init_state <= INIT_SNOOZE;
				end else begin
					// loop
					spi_data <= { spi_data[6:0], 1'b1 };
					bit_loop <= bit_loop + 1;
				end
			end

			INIT_SNOOZE : begin
				if (clk_cnt == CNT_120MS) begin
					clk_cnt <= 0;
					init_state <= INIT_WORKING;
				end else begin
					clk_cnt <= clk_cnt + 1;
				end
			end

			INIT_WORKING : begin
				if (cmd_index == MAX_CMDS + 1) begin
					init_state <= INIT_DONE;
				end else begin
					if (bit_loop == 0) begin
						// start
						lcd_cs_r <= 0;
						lcd_rs_r <= init_cmd[cmd_index][8];
						spi_data <= init_cmd[cmd_index][7:0];
						bit_loop <= bit_loop + 1;
					end else if (bit_loop == 8) begin
						// end
						lcd_cs_r <= 1;
						lcd_rs_r <= 1;
						bit_loop <= 0;
						cmd_index <= cmd_index + 1; // next command
					end else begin
						// loop
						spi_data <= { spi_data[6:0], 1'b1 };
						bit_loop <= bit_loop + 1;
					end
				end
			end

			INIT_DONE : begin
				if (pixel_cnt == 32400) begin
					; // stop
				end else begin
					if (bit_loop == 0) begin
						// start
						lcd_cs_r <= 0;
						lcd_rs_r <= 1;
//						spi_data <= 8'hF8; // RED
						spi_data <= pixel[15:8];
						bit_loop <= bit_loop + 1;
					end else if (bit_loop == 8) begin
						// next byte
//						spi_data <= 8'h00; // RED
						spi_data <= pixel[7:0];
						bit_loop <= bit_loop + 1;
					end else if (bit_loop == 16) begin
						// end
						lcd_cs_r <= 1;
						lcd_rs_r <= 1;
						bit_loop <= 0;
						pixel_cnt <= pixel_cnt + 1; //Pasa al siguiente pixel
						if(grilla_cnt==60) begin //Si aun no se ha terminado el patron: primer color, segundo color en una fila de 60 pixeles
						//continua rellenando
						  grilla_cnt<=0; //Si ya se termino la pareja de colores en una fila de 60 pixeles, se reinicia
						  //Cada 4 veces que se rellenen parejas de 30 pixeles de dos colores distintos, pasa a la siguiente fila
						  //Para ir rellenando poco a poco las columnas
						end
						else begin
						  grilla_cnt <= grilla_cnt+1;
						end
					
					end else begin
						// loop
						spi_data <= { spi_data[6:0], 1'b1 };
						bit_loop <= bit_loop + 1;
					end
				end
			end

		endcase

	end
end

endmodule
