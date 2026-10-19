# Combo II-DLD S75 (xc7s75fgga484-1) / ADC (최상위 adc_board)
# 보드 ADC: AD7908 (8채널, 8비트). ch0 = CdS 조도 센서, ch1 = 가변저항.
# 핀 출처: 장비 교재 ADC 핀 구성표, 스위치·LED는 Lab1·Lab3과 같은 핀.

set_property PACKAGE_PIN B6 [get_ports clk_50mhz]
create_clock -name clk_50mhz -period 20.000 [get_ports clk_50mhz]

# 리셋: 키패드 SW_1
set_property PACKAGE_PIN K4 [get_ports rst_p]

# 채널 선택: DIP 스위치 0~2 (모두 OFF = ch0 CdS, 스위치 0만 ON = ch1 가변저항)
set_property PACKAGE_PIN U4 [get_ports {add_sel[0]}]
set_property PACKAGE_PIN V4 [get_ports {add_sel[1]}]
set_property PACKAGE_PIN W1 [get_ports {add_sel[2]}]

# AD7908 SPI: SPI_AD = CS, SPI_DIN = FPGA → ADC, SPI_DOUT = ADC → FPGA, SPI_SCK = SCLK
set_property PACKAGE_PIN H3 [get_ports adc_ncs]
set_property PACKAGE_PIN H5 [get_ports adc_din]
set_property PACKAGE_PIN J6 [get_ports adc_dout]
set_property PACKAGE_PIN H7 [get_ports adc_sclk]

# 변환값 상위 8비트 → LED1(L4) ~ LED8(N5)
set_property PACKAGE_PIN L4 [get_ports {led_out[7]}]
set_property PACKAGE_PIN M4 [get_ports {led_out[6]}]
set_property PACKAGE_PIN M2 [get_ports {led_out[5]}]
set_property PACKAGE_PIN N7 [get_ports {led_out[4]}]
set_property PACKAGE_PIN M7 [get_ports {led_out[3]}]
set_property PACKAGE_PIN M3 [get_ports {led_out[2]}]
set_property PACKAGE_PIN M1 [get_ports {led_out[1]}]
set_property PACKAGE_PIN N5 [get_ports {led_out[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports {clk_50mhz rst_p add_sel[*] adc_* led_out[*]}]

set_false_path -from [get_ports {rst_p add_sel[*] adc_dout}]
