module image_processor (
    input wire clk,
    input wire imageReady,
    input wire [15:0] pixelDataIn,
    output reg [15:0] pixelData,
    output reg pixelReady
);

    reg [13:0] pixelIndex = 0;

    always @(posedge clk) begin
        if (imageReady) begin
            pixelData <= pixelDataIn;
            pixelReady <= 1;
            pixelIndex <= pixelIndex + 1;
            
            if (pixelIndex == 16383) begin
                pixelIndex <= 0;
            end
        end else begin
            pixelReady <= 0;
        end
    end
endmodule
