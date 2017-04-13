$UserCredential = Get-Credential
$global:Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection

Write-Host "## # ##Opening Powershell Remote Session"
Import-PSSession $Session
Connect-MsolService -Credential $UserCredential

$time = Get-Date
$time.DateTime