`timescale 1ps/1ps
module lcd_controller (
    input wire clk,
    input wire resetn,
    input wire [7:0] uart_data,
    input wire byte_ready,
    output wire lcd_resetn,
    
    output wire lcd_clk,
    output wire lcd_cs,
    output wire lcd_rs,
    output wire lcd_data
);

    
    localparam MAX_CMDS = 69;
    wire [8:0] init_cmd[MAX_CMDS:0];
    
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

    assign init_cmd[59] = 9'h02A; // column
    assign init_cmd[60] = 9'h100;
    assign init_cmd[61] = 9'h128;
    assign init_cmd[62] = 9'h101;
    assign init_cmd[63] = 9'h117;
    assign init_cmd[64] = 9'h02B; // row
    assign init_cmd[65] = 9'h100;
    assign init_cmd[66] = 9'h135;
    assign init_cmd[67] = 9'h100;
    assign init_cmd[68] = 9'h1BB;
    assign init_cmd[69] = 9'h02C; // start

    localparam INIT_RESET   = 4'b0000;
    localparam INIT_PREPARE = 4'b0001;
    localparam INIT_WAKEUP  = 4'b0010;
    localparam INIT_SNOOZE  = 4'b0011;
    localparam INIT_WORKING = 4'b0100;
    localparam INIT_DONE    = 4'b0101;
    

    `ifdef MODELTECH
        localparam CNT_100MS = 32'd2700000;
        localparam CNT_120MS = 32'd3240000;
        localparam CNT_200MS = 32'd5400000;
    `else
        localparam CNT_100MS = 32'd27;
        localparam CNT_120MS = 32'd32;
        localparam CNT_200MS = 32'd54;
    `endif

    reg [ 3:0] init_state;
    reg [ 6:0] cmd_index;
    reg [31:0] clk_cnt;
    reg [ 4:0] bit_loop;
    reg [15:0] pixel_cnt;
    reg lcd_cs_r;
    reg lcd_rs_r;
    reg lcd_reset_r;
    reg [7:0] spi_data;
    reg state;
    reg [15:0] pixel_data;
    reg [7:0] first_byte;

    assign lcd_resetn = lcd_reset_r;
    assign lcd_clk    = ~clk;
    assign lcd_cs     = lcd_cs_r;
    assign lcd_rs     = lcd_rs_r;
    assign lcd_data   = spi_data[7];

    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            state <= 0;
            pixel_data <= 16'h0000;
        end else if (byte_ready) begin
            if (!state) begin
                first_byte <= uart_data;
                state <= 1;
            end else begin
                pixel_data <= {first_byte, uart_data};
                state <= 0;
            end
        end
    end

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
        end else begin
            case (init_state)
                INIT_RESET: begin
                    if (clk_cnt == CNT_100MS) begin
                        clk_cnt <= 0;
                        init_state <= INIT_PREPARE;
                        lcd_reset_r <= 1;
                    end else begin
                        clk_cnt <= clk_cnt + 1;
                    end
                end
                
                 INIT_PREPARE: begin
                if (clk_cnt == CNT_200MS) begin
                    clk_cnt <= 0;
                    init_state <= INIT_WAKEUP;
                end else begin
                    clk_cnt <= clk_cnt + 1;
                end
            end
            
            INIT_WAKEUP: begin
                if (bit_loop == 0) begin
                    lcd_cs_r <= 0;
                    lcd_rs_r <= 0;
                    spi_data <= 8'h11;
                    bit_loop <= bit_loop + 1;
                end else if (bit_loop == 8) begin
                    lcd_cs_r <= 1;
                    lcd_rs_r <= 1;
                    bit_loop <= 0;
                    init_state <= INIT_SNOOZE;
                end else begin
                    spi_data <= { spi_data[6:0], 1'b1 };
                    bit_loop <= bit_loop + 1;
                end
            end
            
            INIT_SNOOZE: begin
                if (clk_cnt == CNT_120MS) begin
                    clk_cnt <= 0;
                    init_state <= INIT_WORKING;
                end else begin
                    clk_cnt <= clk_cnt + 1;
                end
            end
            
            INIT_WORKING: begin
                if (cmd_index == MAX_CMDS + 1) begin
                    init_state <= INIT_DONE;
                end else begin
                    if (bit_loop == 0) begin
                        lcd_cs_r <= 0;
                        lcd_rs_r <= init_cmd[cmd_index][8];
                        spi_data <= init_cmd[cmd_index][7:0];
                        bit_loop <= bit_loop + 1;
                    end else if (bit_loop == 8) begin
                        lcd_cs_r <= 1;
                        lcd_rs_r <= 1;
                        bit_loop <= 0;
                        cmd_index <= cmd_index + 1;
                    end else begin
                        spi_data <= { spi_data[6:0], 1'b1 };
                        bit_loop <= bit_loop + 1;
                    end
                end
            end
                
            INIT_DONE: begin
                if (pixel_cnt == 32400) begin
                    pixel_cnt <= 0;
                end else begin
                    if (bit_loop == 0) begin
                        lcd_cs_r <= 0;
                        lcd_rs_r <= 1;
                        spi_data <= pixel_data[15:8];
                        bit_loop <= bit_loop + 1;
                    end else if (bit_loop == 8) begin
                        spi_data <= pixel_data[7:0];
                        bit_loop <= bit_loop + 1;
                    end else if (bit_loop == 16) begin
                        lcd_cs_r <= 1;
                        lcd_rs_r <= 1;
                        bit_loop <= 0;
                        pixel_cnt <= pixel_cnt + 1;
                    end else begin
                        spi_data <= {spi_data[6:0], 1'b1};
                        bit_loop <= bit_loop + 1;
                    end
                end
            end
                default: begin
                    // Reset a un estado seguro
                    init_state <= INIT_RESET;
                    lcd_cs_r <= 1;
                    lcd_rs_r <= 1;
                    lcd_reset_r <= 0;
                    spi_data <= 8'hFF;
                    bit_loop <= 0;
                    pixel_cnt <= 0;
                    clk_cnt <= 0;
                    cmd_index <= 0;
                end
            endcase
        end
    end
endmodule