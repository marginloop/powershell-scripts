#setting up default output and input paths

$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
$outputpath="$dir\output\"
$inputpath="$dir\input\"

<###################
#IMPORTANT:
#locations of the imports will be in the location of the script files
# SCRIPTFILELOCATION:\input\mailboxes.csv
#--mailboxes are referenced by alias
###################>
$file = import-csv "$inputpath\mailboxes.csv"

$p = Read-Host -AsSecureString "password"
$domain = Read-host "enter the domain of the email address"

foreach($f in $file){
     $A = $f.Alias
     $DN = $f.DisplayName
     $p = ConvertTo-SecureString -string "ChangeM3!" -AsPlainText -Force
     $upn = "$A@$domain"

     New-RemoteMailbox -Alias '$A' -Name '$DN' -DisplayName '$DN' -UserPrincipalName '$upn' -password $p | out-file -Append ".\output\dlcommands_$(get-date -Format yyyy-MM-dd).txt"
}


#Display name, User name, Password, ou, primary smtp address