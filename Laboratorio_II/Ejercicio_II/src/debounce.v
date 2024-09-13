module debounce(
    input wire clk,
    input wire rst,
    input wire key_in,
    output reg key_out
);
    reg [19:0] cnt;  // Counter for debouncing

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cnt <= 0;
            key_out <= 0;
        end else begin
            if (key_in) begin
                if (cnt < 20'd1000000)  // Adjust count for debounce time
                    cnt <= cnt + 1;
                else
                    key_out <= 1;
            end else begin
                cnt <= 0;
                key_out <= 0;
            end
        end
    end
endmodule

