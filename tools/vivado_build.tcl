# Vivado 프로젝트 생성 → 행동 시뮬레이션(XSim) → 합성 → 구현 → 비트스트림 생성
# 사용법 (lab4_FPGA_STM32_0 폴더에서):
#   vivado -mode batch -source tools/vivado_build.tcl -tclargs piano
#   vivado -mode batch -source tools/vivado_build.tcl -tclargs traffic
# 결과: vivado/<이름>/<이름>.xpr (GUI로 열 수 있는 프로젝트)
#       vivado/<이름>/<이름>.runs/impl_1/<이름>.bit

set name [lindex $argv 0]
if {$name ni {piano traffic adc}} {
    error "usage: -tclargs piano | traffic | adc"
}
set root [file normalize [file join [file dirname [info script]] ..]]
set part xc7s75fgga484-1

create_project $name [file join $root vivado $name] -part $part -force

# 설계 소스와 최상위 모듈
add_files -norecurse [glob [file join $root $name *.v]]
# 보드용 최상위: ADC는 sample·data_valid를 내부에 두는 adc_board 사용
set top [expr {$name eq "adc" ? "adc_board" : $name}]
set_property top $top [get_filesets sources_1]

# 시뮬레이션 소스 (SystemVerilog 테스트벤치, 최상위 tb)
add_files -fileset sim_1 -norecurse [glob [file join $root $name tb_*.sv]]
set_property top tb [get_filesets sim_1]
set_property -name xsim.simulate.runtime -value all -objects [get_filesets sim_1]

# 핀 제약
add_files -fileset constrs_1 -norecurse [file join $root constraints $name.xdc]

# 1) 행동 시뮬레이션: 스크립트만 만든 뒤 compile → elaborate → simulate를 전체 경로로 실행
launch_simulation -scripts_only
set simdir [file join $root vivado $name $name.sim sim_1 behav xsim]
set simlog [file join $root vivado $name xsim_simulate.log]
cd $simdir
foreach step {compile elaborate simulate} {
    set rc [catch {exec cmd.exe /c [file nativename [file join $simdir $step.bat]] 2>@1} out]
    if {$step eq "simulate"} {
        set fh [open $simlog w]; puts $fh $out; close $fh
    }
    if {$rc} { puts $out; error "xsim $step failed" }
}
cd $root
if {![regexp {PASS [^\n]*} $out pass]} { error "testbench did not print PASS" }
puts "XSIM_$pass"

# 2) 합성 → 구현 → 비트스트림
launch_runs synth_1 -jobs 4
wait_on_run synth_1
if {[get_property PROGRESS [get_runs synth_1]] ne "100%"} { error "synthesis failed" }
launch_runs impl_1 -to_step write_bitstream -jobs 4
wait_on_run impl_1
if {[get_property PROGRESS [get_runs impl_1]] ne "100%"} { error "implementation failed" }

set bit [file join $root vivado $name $name.runs impl_1 $top.bit]
puts "BITSTREAM_OK $bit"
close_project
