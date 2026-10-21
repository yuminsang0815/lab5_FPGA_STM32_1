# Vivado GUI XSim 파형 창을 띄워 evidence/vivado/<설계>_wave.png로 저장합니다.
# 사용법: powershell -ExecutionPolicy Bypass -File tools\capture_vivado_wave.ps1 piano [대기초]
param([Parameter(Mandatory = $true)][string]$Name, [int]$WaitSec = 100)

Add-Type -AssemblyName System.Drawing
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class W {
    [DllImport("user32.dll")] public static extern bool SetProcessDPIAware();
    [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr h);
    [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr h, int n);
    [DllImport("user32.dll")] public static extern bool GetWindowRect(IntPtr h, out RECT r);
    [DllImport("user32.dll")] public static extern bool PrintWindow(IntPtr h, IntPtr hdc, uint flags);
    [DllImport("user32.dll")] public static extern bool SetCursorPos(int x, int y);
    [DllImport("user32.dll")] public static extern void mouse_event(uint f, uint dx, uint dy, uint d, UIntPtr e);
    [DllImport("user32.dll")] public static extern void keybd_event(byte vk, byte scan, uint flags, UIntPtr extra);
    public struct RECT { public int Left, Top, Right, Bottom; }
}
"@
[W]::SetProcessDPIAware() | Out-Null
$root = Split-Path $PSScriptRoot -Parent
$ev = Join-Path $root 'evidence\vivado'
New-Item -ItemType Directory -Force $ev | Out-Null
$work = Join-Path $env:TEMP "vivado_wave_$Name"; New-Item -ItemType Directory -Force $work | Out-Null

$before = @(Get-Process | ForEach-Object Id)
# tools/vivado_build.tcl이 만든 행동 시뮬레이션 스냅샷(tb_behav)을 Vivado Simulator GUI로 연다
$simdir = Join-Path $root "vivado\$Name\$Name.sim\sim_1\behav\xsim"
$env:WAVE_NAME = $Name
$env:PATH = "C:\AMDDesignTools\2026.1\Vivado\bin;$env:PATH"
Start-Process -FilePath 'cmd.exe' -WorkingDirectory $simdir `
    -ArgumentList '/c', 'xsim', 'tb_behav', '-gui', '-tclbatch', ((Join-Path $PSScriptRoot 'vivado_wave.tcl') -replace '\\', '/')
Start-Sleep -Seconds $WaitSec
$p = Get-Process | Where-Object { $_.MainWindowTitle -match 'Vivado|tb_behav' -and $before -notcontains $_.Id } | Select-Object -First 1
if (-not $p) { Write-Error 'Vivado window not found'; exit 1 }
$h = $p.MainWindowHandle
[W]::ShowWindow($h, 3) | Out-Null
# Alt 키를 눌렀다 떼면 다른 프로그램 창도 앞으로 가져올 수 있다 (Windows 포커스 제한 우회)
[W]::keybd_event(0x12, 0, 0, [UIntPtr]::Zero); [W]::keybd_event(0x12, 0, 2, [UIntPtr]::Zero)
[W]::SetForegroundWindow($h) | Out-Null
Start-Sleep -Seconds 3
# 파형 탭(Untitled 1)을 더블클릭해 창 전체로 키우고, 파형 영역을 클릭한 뒤 Ctrl+0(Zoom Fit)
$r0 = New-Object W+RECT; [W]::GetWindowRect($h, [ref]$r0) | Out-Null
function Click([int]$x, [int]$y, [int]$n = 1) {
    [W]::SetCursorPos($r0.Left + $x, $r0.Top + $y) | Out-Null
    for ($i = 0; $i -lt $n; $i++) { [W]::mouse_event(2, 0, 0, 0, [UIntPtr]::Zero); [W]::mouse_event(4, 0, 0, 0, [UIntPtr]::Zero); Start-Sleep -Milliseconds 80 }
}
Click 1537 307 2; Start-Sleep -Seconds 2
Click 1700 900 1; Start-Sleep -Milliseconds 500
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.SendKeys]::SendWait('^0'); Start-Sleep -Seconds 2
[W]::SetCursorPos($r0.Left + 5, $r0.Top + 5) | Out-Null
$r = New-Object W+RECT; [W]::GetWindowRect($h, [ref]$r) | Out-Null
$bmp = New-Object System.Drawing.Bitmap ($r.Right - $r.Left), ($r.Bottom - $r.Top)
$g = [System.Drawing.Graphics]::FromImage($bmp)
# 창 자체를 그리게 해서, 다른 창에 가려져 있어도 Vivado 화면만 저장
$hdc = $g.GetHdc(); $ok = [W]::PrintWindow($h, $hdc, 2); $g.ReleaseHdc($hdc)
if (-not $ok) { $g.CopyFromScreen($r.Left, $r.Top, 0, 0, $bmp.Size) }
$out = Join-Path $ev "${Name}_wave.png"
$bmp.Save($out, [System.Drawing.Imaging.ImageFormat]::Png); $g.Dispose(); $bmp.Dispose()
Write-Host "saved $out ($($p.MainWindowTitle))"
Get-Process | Where-Object { $before -notcontains $_.Id -and $_.ProcessName -match 'vivado|java|xsim|xsimk|loader' } | Stop-Process -Force -ErrorAction SilentlyContinue
