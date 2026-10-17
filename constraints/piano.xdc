# Combo II-DLD S75 (xc7s75fgga484-1) / 피아노 piano
# 키패드 선택 스위치를 PUSH SWITCH(버튼 모드, OFF/아래)로 두고, PIEZO ENABLE 스위치를 ON으로 둔다.
# 키패드 버튼은 누르면 HIGH (Lab2 키패드 실습과 같은 극성).
# 핀 출처: Lab2 키패드 실습(extra.xdc), Lab3 피에조 실습(lab3_piezo.xdc)

# 50 MHz 메인 클록 (보드 클록 선택 스위치를 F = 50 MHz로)
set_property PACKAGE_PIN B6 [get_ports clk_50mhz]
create_clock -name clk_50mhz -period 20.000 [get_ports clk_50mhz]

# 리셋: 키패드 * 버튼
set_property PACKAGE_PIN L7 [get_ports rst_p]

# 음 키: 키패드 1~8 → 도 레 미 파 솔 라 시 도 (key[7] = 8'h80 = 도)
set_property PACKAGE_PIN K4 [get_ports {key[7]}]
set_property PACKAGE_PIN N8 [get_ports {key[6]}]
set_property PACKAGE_PIN N4 [get_ports {key[5]}]
set_property PACKAGE_PIN N1 [get_ports {key[4]}]
set_property PACKAGE_PIN P6 [get_ports {key[3]}]
set_property PACKAGE_PIN N6 [get_ports {key[2]}]
set_property PACKAGE_PIN L5 [get_ports {key[1]}]
set_property PACKAGE_PIN J2 [get_ports {key[0]}]

# 피에조 출력
set_property PACKAGE_PIN Y21 [get_ports piezo]

set_property IOSTANDARD LVCMOS33 [get_ports {clk_50mhz rst_p key[*] piezo}]

# 버튼은 클록과 무관하게 바뀌는 비동기 입력
set_false_path -from [get_ports {rst_p key[*]}]
