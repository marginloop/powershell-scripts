Write-Host "## # ##Closing Powershell Remote Session"
Remove-PSSession $global:Session
Get-date