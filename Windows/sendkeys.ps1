
Write-Host "Powershell Send keys..."
$WShell = New-Object -Com "Wscript.shell"; while(1) {$WShell.SendKeys("{ScrollLOCK}"); sleep 5}
