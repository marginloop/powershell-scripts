#setting up default output and input paths

$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
$outputpath="$dir\output\"
$inputpath="$dir\input\"

$file = import-csv "$inputpath\mailboxes.csv"

foreach($f in $file){

     $DN = $f.DisplayName

     #Set-MsolUserLicense -UserPrincipalName "$upn" -AddLicenses "EXCHANGE_S_ENTERPRISE" | out-file -Append "$output\dlcommands_$(get-date -Format yyyy-MM-dd).txt"
     Set-Mailbox -Identity $DN -Type Shared -Verbose

}