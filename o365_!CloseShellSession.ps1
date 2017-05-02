$time = Get-Date
Write-Host "[$time] Closing Powershell Remote Session"
Remove-PSSession $global:Session
Get-date