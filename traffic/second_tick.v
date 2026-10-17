`timescale 1ns/1ps
// 느린 동작은 새 클록 대신 한 클록 길이의 tick으로 만듭니다.
module second_tick #(parameter CLK_HZ=50_000_000)(
    input wire clk_50mhz, rst_p,
    output wire tick,
    output wire blink
);
    reg [31:0] count;
    assign tick=(count==CLK_HZ-1);
    assign blink=(count < CLK_HZ/2);
    always @(posedge clk_50mhz)
        if(rst_p || tick) count<=0;
        else count<=count+1;
endmodule
