# lab5_FPGA_STM32_1

전자전기컴퓨터설계실험Ⅱ STM32_1 주차 FPGA 교재 실습: 피아노(`piano`), 신호등 제어(`traffic`), ADC(`adc`).

- 코드 출처: [Glaysia/ece2_474 `docs/FPGA_additional.md`](https://github.com/Glaysia/ece2_474/blob/v1.1.0/docs/FPGA_additional.md) 3·4·7번 실습 (TB에 파형 저장만 추가)
- 실험 전 레포트: [reports/pre/01_piano_traffic_adc.md](reports/pre/01_piano_traffic_adc.md)
- 시뮬레이션 로그·파형: [evidence/vscode/](evidence/vscode/)

## 시뮬레이션 실행 (Icarus Verilog + GTKWave)

VS Code: `Ctrl+Shift+P` → `Tasks: Run Task` → `SIM: ...`

터미널:

```
.\run_sim.bat piano wave
.\run_sim.bat traffic wave
.\run_sim.bat adc wave
```

파형 캡처 다시 만들기: `powershell -ExecutionPolicy Bypass -File .\capture_wave.ps1`

## Vivado (시뮬레이션 → 합성 → 구현 → 비트스트림)

```
vivado -mode batch -source tools/vivado_build.tcl -tclargs piano
vivado -mode batch -source tools/vivado_build.tcl -tclargs traffic
vivado -mode batch -source tools/vivado_build.tcl -tclargs adc
```

결과 프로젝트 `vivado/<설계>/<설계>.xpr`를 GUI로 열고 Open Hardware Manager → Program Device로 `vivado/<설계>/<설계>.runs/impl_1/<최상위>.bit`(ADC는 `adc_board.bit`)를 다운로드한다. 핀 제약은 [constraints/](constraints/).
