`timescale 1ns/1ps
// 각 방향에서 0~10초는 초록, 11~12초는 노랑입니다.
module traffic_sequence(
    input wire clk_50mhz,rst_p,tick,flicker,
    output reg [1:0] direction,
    output reg [3:0] phase
);
    always @(posedge clk_50mhz) begin
        if(rst_p || flicker) begin direction<=0; phase<=0; end
        else if(tick)
            if(phase==12) begin phase<=0; direction<=direction+1'b1; end
            else phase<=phase+1'b1;
    end
endmodule
