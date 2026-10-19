`timescale 1ns/1ps
// 16비트 직렬 송수신. 클록은 HIGH 대기.
// [보드 수정] AD7908은 DIN을 SCLK 하강 에지에서 읽고(셋업 10 ns, 홀드 수 ns),
// DOUT을 SCLK 하강 에지에서 내보낸다(첫 비트는 CS 하강에서 나옴).
// 따라서 DIN(mosi)은 상승 에지에서 다음 비트로 바꿔 하강 에지에서 안정되게 하고,
// DOUT(miso)은 하강 에지 직전에 읽는다. (원본: 하강 에지에서 mosi 변경, 상승 에지에서 수신)
module serial_frame16 #(parameter HALF_CYCLES=25)(
    input wire clk_50mhz,rst_p,start,
    input wire [15:0] tx_word,
    input wire miso,
    output reg sclk,cs_n,mosi,busy,done,
    output reg [15:0] rx_word
);
    reg [31:0] count;
    reg [4:0] bit_index;
    reg [15:0] tx_latched;
    always @(posedge clk_50mhz) begin
        if(rst_p) begin
            sclk<=1; cs_n<=1; mosi<=0; busy<=0; done<=0;
            count<=0; bit_index<=15; tx_latched<=0; rx_word<=0;
        end else begin
            done<=0;
            if(!busy) begin
                if(start) begin
                    cs_n<=0; busy<=1; count<=0; bit_index<=15;
                    tx_latched<=tx_word; rx_word<=0; mosi<=tx_word[15];
                end
            end else if(count==HALF_CYCLES-1) begin
                count<=0;
                if(sclk) begin
                    sclk<=0;                              // ADC가 이 하강 에지에서 mosi를 읽음
                    rx_word<={rx_word[14:0],miso};        // 하강 에지 직전의 DOUT 비트 수신
                end else begin
                    sclk<=1;
                    if(bit_index==0) begin busy<=0; cs_n<=1; done<=1; end
                    else begin
                        bit_index<=bit_index-1'b1;
                        mosi<=tx_latched[bit_index-1'b1]; // 상승 에지에서 다음 명령 비트 준비
                    end
                end
            end else count<=count+1;
        end
    end
endmodule
