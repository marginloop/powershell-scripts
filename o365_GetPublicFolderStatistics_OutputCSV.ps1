#seting up file output/input
$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
$outputpath="$dir\output\"
$inputpath="$dir\input\"

#create .csv for session/date
#--setup of csv name
$date =  Get-Date -Format dd-MM-y
$company = Read-Host "Please Enter the Companie's Acronym"
$company = $company.ToUpper()
$csv = "$outputpath\+$company+_MailPublicFolder_$date.csv"

#--creation of csv
Write-Host "--Creating CSV"
New-Item $csv -ItemType File

#get public folder's and subfolder's information and export Name, Size 
Write-Host "--Processing Public Folder Statistics" 

##
$output_format_table = Get-MailPublicFolder | Select-Object Name, EmailAddresses
##
#$output_format_table = Get-PublicFolderStatistics | Select-Object -Property Name, FolderPath, TotalItemSize, MailboxOwnerID

Write-Host "-Finished Processing Public Folder Statistics" 
$output_format_table | Export-Csv -path $csv -NoTypeInformation
Write-Host "--Output Written to "$csv
