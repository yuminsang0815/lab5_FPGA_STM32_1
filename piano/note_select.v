`timescale 1ns/1ps
// 버튼 입력에 대응하는 음의 주파수를 선택합니다.
// 보드의 버튼 입력은 안정된 HIGH 활성 신호로 전달합니다.
module note_select(input wire [7:0] key, output reg [31:0] frequency_hz);
    always @* begin
        case(key)
            8'h80: frequency_hz=262;
            8'h40: frequency_hz=294;
            8'h20: frequency_hz=330;
            8'h10: frequency_hz=349;
            8'h08: frequency_hz=392;
            8'h04: frequency_hz=440;
            8'h02: frequency_hz=494;
            8'h01: frequency_hz=523;
            default: frequency_hz=0; // 무입력이나 여러 버튼 입력은 무음
        endcase
    end
endmodule
