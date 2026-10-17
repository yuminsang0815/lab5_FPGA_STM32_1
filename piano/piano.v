`timescale 1ns/1ps
module piano #(parameter CLK_HZ=50_000_000)(
    input wire clk_50mhz, rst_p,
    input wire [7:0] key,
    output wire piezo
);
    wire [31:0] frequency_hz;
    note_select u_note(key, frequency_hz);
    square_tone #(.CLK_HZ(CLK_HZ)) u_tone(clk_50mhz,rst_p,frequency_hz,piezo);
endmodule
