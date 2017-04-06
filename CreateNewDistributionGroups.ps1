#setting up default output and input paths

$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
$outputpath="$dir\output\"
$inputpath="$dir\input\"

<###################
#IMPORTANT:
#locations of the imports will be in the location of the script files
# SCRIPTFILELOCATION:\input\mailboxes.csv
--headers are: Alias, DisplayName, ProxyAddress
###################>
$file = import-csv "$inputpath\mailboxes.csv"


foreach($f in $file){
     $A = $f.Alias
     $DN = $f.DisplayName
     $PSMTP = $f.ProxyAddress

     New-DistributionGroup -Alias "$A" -DisplayName "$DN" -Name "$DN" -PrimarySmtpAddress "$PSMTP"
}


#Set-DistributionGroup -Identity "$DN" -PrimarySmtpAddress "$PSMTP"