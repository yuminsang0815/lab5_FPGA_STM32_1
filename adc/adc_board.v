`timescale 1ns/1ps
// 보드 시연용 최상위: adc의 sample[11:0], data_valid는 보드 핀이 없으므로 내부에 두고
// 채널 선택(DIP 스위치), AD7908 SPI 4선, LED 8개만 밖으로 연결합니다.
module adc_board(
    input wire clk_50mhz, rst_p,
    input wire [2:0] add_sel,
    output wire adc_sclk, adc_ncs, adc_din,
    input wire adc_dout,
    output wire [7:0] led_out
);
    wire [11:0] sample;
    wire data_valid;
    adc u_adc(clk_50mhz, rst_p, add_sel, adc_sclk, adc_ncs, adc_din, adc_dout,
              sample, data_valid, led_out);
endmodule
