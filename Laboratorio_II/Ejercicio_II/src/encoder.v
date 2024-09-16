module encoder (
    input wire [3:0] row,
    input wire [3:0] col,
    output reg [3:0] hex_out,
    output reg key_pressed
);

always @(*) begin
    key_pressed = 1'b0;
    hex_out = 4'h0;
    
    if (row[0] && col[0]) begin hex_out = 4'h1; key_pressed = 1'b1; end
    else if (row[0] && col[1]) begin hex_out = 4'h2; key_pressed = 1'b1; end
    else if (row[0] && col[2]) begin hex_out = 4'h3; key_pressed = 1'b1; end
    else if (row[0] && col[3]) begin hex_out = 4'hA; key_pressed = 1'b1; end
    else if (row[1] && col[0]) begin hex_out = 4'h4; key_pressed = 1'b1; end
    else if (row[1] && col[1]) begin hex_out = 4'h5; key_pressed = 1'b1; end
    else if (row[1] && col[2]) begin hex_out = 4'h6; key_pressed = 1'b1; end
    else if (row[1] && col[3]) begin hex_out = 4'hB; key_pressed = 1'b1; end
    else if (row[2] && col[0]) begin hex_out = 4'h7; key_pressed = 1'b1; end
    else if (row[2] && col[1]) begin hex_out = 4'h8; key_pressed = 1'b1; end
    else if (row[2] && col[2]) begin hex_out = 4'h9; key_pressed = 1'b1; end
    else if (row[2] && col[3]) begin hex_out = 4'hC; key_pressed = 1'b1; end
    else if (row[3] && col[0]) begin hex_out = 4'hE; key_pressed = 1'b1; end
    else if (row[3] && col[1]) begin hex_out = 4'h0; key_pressed = 1'b1; end
    else if (row[3] && col[2]) begin hex_out = 4'hF; key_pressed = 1'b1; end
    else if (row[3] && col[3]) begin hex_out = 4'hD; key_pressed = 1'b1; end
end

endmodule