timescale 1ns / 1ps
module sync(
    input clk,
    input async_in,
    output sync_out // salida 
);
    reg sync_ff1, sync_ff2;
    // flip-flops
    always @(posedge clk) begin
        sync_ff1 <= async_in;   
        sync_ff2 <= sync_ff1;   
    end

    assign sync_out = sync_ff2;
endmodule