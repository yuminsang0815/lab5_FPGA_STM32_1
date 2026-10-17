# lab5_FPGA_STM32_1

전자전기컴퓨터설계실험Ⅱ STM32_1 주차 FPGA 교재 실습: 피아노(`piano`), 신호등 제어(`traffic`).

- 코드 출처: [Glaysia/ece2_474 `docs/FPGA_additional.md`](https://github.com/Glaysia/ece2_474/blob/v1.1.0/docs/FPGA_additional.md) 3·4번 실습 (TB에 파형 저장만 추가)
- 실험 전 레포트: [reports/pre/01_piano_traffic.md](reports/pre/01_piano_traffic.md)
- 시뮬레이션 로그·파형: [evidence/vscode/](evidence/vscode/)

## 시뮬레이션 실행 (Icarus Verilog + GTKWave)

VS Code: `Ctrl+Shift+P` → `Tasks: Run Task` → `SIM: ...`

터미널:

```
.\run_sim.bat piano wave
.\run_sim.bat traffic wave
```

파형 캡처 다시 만들기: `powershell -ExecutionPolicy Bypass -File .\capture_wave.ps1`
