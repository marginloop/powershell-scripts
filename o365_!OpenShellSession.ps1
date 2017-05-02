<#
  Get login credentials for office 365
  pass the login to a global session
  starts the powershell remote session
#>
#Get login credentials for office 365
$UserCredential = Get-Credential
$global:Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection

#starts the powershell remote session
$time = Get-Date
Write-Host "[$time] opening remote session "
Import-PSSession $Session