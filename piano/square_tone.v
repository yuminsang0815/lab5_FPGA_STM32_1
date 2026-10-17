`timescale 1ns/1ps
module square_tone #(parameter CLK_HZ=50_000_000)(
    input wire clk_50mhz, rst_p,
    input wire [31:0] frequency_hz,
    output reg tone
);
    reg [31:0] count, previous_hz;
    wire [31:0] half_cycles = frequency_hz == 0 ? 1 :
                             CLK_HZ / (2 * frequency_hz);
    always @(posedge clk_50mhz) begin
        if(rst_p) begin count<=0; tone<=0; previous_hz<=0; end
        else if(frequency_hz==0 || frequency_hz!=previous_hz) begin
            count<=0; tone<=0; previous_hz<=frequency_hz;
        end
        else if(count >= half_cycles-1) begin count<=0; tone<=~tone; end
        else count<=count+1;
    end
endmodule
