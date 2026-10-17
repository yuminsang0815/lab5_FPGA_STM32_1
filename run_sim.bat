@echo off
rem Usage: run_sim.bat piano      (simulate only)
rem        run_sim.bat traffic wave (simulate + open GTKWave)
if "%~1"=="" (
    echo Usage: run_sim.bat [piano^|traffic^|adc] [wave]
    exit /b 1
)
cd /d "%~dp0%~1" || exit /b 1
echo === iverilog compile: %~1 ===
iverilog -g2012 -o %~1.vvp *.v *.sv || exit /b 1
echo === vvp run ===
vvp -n %~1.vvp || exit /b 1
if /i "%~2"=="wave" start "" gtkwave %~1.gtkw
