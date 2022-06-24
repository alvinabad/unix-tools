# Disable Windows sleep

Run in powershell
```
$WShell = New-Object -Com "Wscript.shell"; while(1) {$WShell.SendKeys("{ScrollLOCK}"); sleep 5}
```
