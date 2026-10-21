# Vivado Simulator(XSim) GUI에서 테스트벤치를 끝까지 실행하고 파형을 표시합니다 (캡처용).
# xsim tb_behav -gui -tclbatch vivado_wave.tcl 로 실행하며, 설계 이름은 환경 변수 WAVE_NAME으로 받습니다.
set name $::env(WAVE_NAME)
switch $name {
    piano   { add_wave {/tb/clk} {/tb/rst} {/tb/key} {/tb/dut/frequency_hz} {/tb/dut/u_tone/half_cycles} {/tb/piezo} }
    traffic { add_wave {/tb/clk} {/tb/rst} {/tb/flicker} {/tb/dut/tick} {/tb/dut/blink} {/tb/dut/direction} {/tb/dut/phase} {/tb/red} {/tb/yellow} {/tb/green} {/tb/wr} {/tb/wg} }
    adc     { add_wave {/tb/clk} {/tb/rst} {/tb/channel} {/tb/cs_n} {/tb/sclk} {/tb/mosi} {/tb/miso} {/tb/dut/u_serial/bit_index} {/tb/received_command} {/tb/valid} {/tb/sample} {/tb/led} }
}
# $finish 직전까지만 실행해 소스 창 대신 파형 창이 앞에 남게 한다
switch $name { piano { run 4795ns } traffic { run 2185ns } adc { run 2015ns } }
foreach w [get_waves *] { catch { set_property radix unsigned $w } }
foreach w {key red yellow green wr wg received_command sample led} { catch { set_property radix hex [get_waves $w] } }
