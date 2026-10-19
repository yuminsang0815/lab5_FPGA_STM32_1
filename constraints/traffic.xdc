# Combo II-DLD S75 (xc7s75fgga484-1) / 신호등 제어 traffic
# 핀 출처: 장비 교재 신호등 실습 핀 표 (p.657~658). 출력 1 = LED 켜짐으로 연결.
# 키패드 선택 스위치를 아래(Button Switch)로, 보드 클록 스위치를 F(50 MHz)로 둔다.

set_property PACKAGE_PIN B6 [get_ports clk_50mhz]
create_clock -name clk_50mhz -period 20.000 [get_ports clk_50mhz]

# 리셋: 키패드 SW_1, 점멸 모드: 키패드 SW_2 (누르고 있는 동안 점멸 모드)
set_property PACKAGE_PIN K4 [get_ports rst_p]
set_property PACKAGE_PIN N8 [get_ports flicker]

# 인덱스 [3]=S(남) [2]=N(북) [1]=W(서) [0]=E(동)
set_property PACKAGE_PIN E16 [get_ports {led_green[3]}]
set_property PACKAGE_PIN C16 [get_ports {led_green[2]}]
set_property PACKAGE_PIN A20 [get_ports {led_green[1]}]
set_property PACKAGE_PIN E11 [get_ports {led_green[0]}]

set_property PACKAGE_PIN L18 [get_ports {led_yellow[3]}]
set_property PACKAGE_PIN A14 [get_ports {led_yellow[2]}]
set_property PACKAGE_PIN C18 [get_ports {led_yellow[1]}]
set_property PACKAGE_PIN D13 [get_ports {led_yellow[0]}]

set_property PACKAGE_PIN B13 [get_ports {led_red[3]}]
set_property PACKAGE_PIN G14 [get_ports {led_red[2]}]
set_property PACKAGE_PIN C17 [get_ports {led_red[1]}]
set_property PACKAGE_PIN C12 [get_ports {led_red[0]}]

# 좌회전 (교재 포트 이름 led_left_o)
set_property PACKAGE_PIN F15 [get_ports {led_left[3]}]
set_property PACKAGE_PIN D15 [get_ports {led_left[2]}]
set_property PACKAGE_PIN C19 [get_ports {led_left[1]}]
set_property PACKAGE_PIN F10 [get_ports {led_left[0]}]

# 보행자
set_property PACKAGE_PIN E19 [get_ports {led_walk_green[3]}]
set_property PACKAGE_PIN F12 [get_ports {led_walk_green[2]}]
set_property PACKAGE_PIN A16 [get_ports {led_walk_green[1]}]
set_property PACKAGE_PIN G11 [get_ports {led_walk_green[0]}]

set_property PACKAGE_PIN A19 [get_ports {led_walk_red[3]}]
set_property PACKAGE_PIN G13 [get_ports {led_walk_red[2]}]
set_property PACKAGE_PIN E18 [get_ports {led_walk_red[1]}]
set_property PACKAGE_PIN C11 [get_ports {led_walk_red[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports {clk_50mhz rst_p flicker led_*}]

set_false_path -from [get_ports {rst_p flicker}]
