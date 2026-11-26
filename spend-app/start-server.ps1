$ErrorActionPreference = 'Stop'
$port = 8765
$root = $PSScriptRoot

$ips = @()
try {
  $ips = Get-NetIPAddress -AddressFamily IPv4 -ErrorAction Stop |
    Where-Object {
      $_.IPAddress -notlike '127.*' -and
      $_.IPAddress -notlike '169.254.*' -and
      $_.InterfaceAlias -notmatch 'vEthernet|VMware|Virtual|Loopback|WSL|Tailscale'
    } |
    Select-Object -ExpandProperty IPAddress -Unique
} catch { }

Write-Host ''
Write-Host '  Daily Spend - local server' -ForegroundColor Green
Write-Host '  ---------------------------'
Write-Host "  Computer : http://localhost:$port/"
foreach ($ip in $ips) {
  Write-Host "  Phone    : http://${ip}:$port/"
}
Write-Host ''
Write-Host '  Phone and PC must be on the same Wi-Fi.'
Write-Host '  If Windows asks about the firewall, allow private networks.'
Write-Host '  Press Ctrl+C to stop.'
Write-Host ''

Set-Location -LiteralPath $root
if (Get-Command py -ErrorAction SilentlyContinue) {
  py (Join-Path $root 'serve.py') $port
} else {
  python (Join-Path $root 'serve.py') $port
}
