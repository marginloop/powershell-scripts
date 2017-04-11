#setting up default output and input paths
$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
$license_report = "$dir\license_report.csv"

<#connecting to the credential service
$credential = Get-Credential
Connect-MsolService -Credential $credential
#>
#get the users
$users = Get-MsolUser -all


#setup Header for license report
$headers = "DisplayName, UserPrincipalName"
$LicenseTypes = Get-MsolAccountSku
foreach ($h in $LicenseTypes){
    
    $h = $h.AccountSkuId
    $h = $h.SubString($h.LastIndexOf(":")+1)
    $headers += ", " + $h

}

$headers | Out-File -FilePath $license_report

#looping through each user and checking
foreach($user in $users){
    $dn = $user.DisplayName
    $upn = $user.UserPrincipalName
    $data = "$dn, $upn"
    
    foreach($license in $LicenseTypes){

        foreach($userlicense in $user.licenses){
            
            $ul = $userlicense.AccountSkuId
            $ul = $ul.SubString($ul.LastIndexOf(":")+1)
            #license match user write 1, else write 0
            #if matches license, write 1
            #if no match for license is found write 0
            
            
            $data += ", $license_check"
        
        }
        $data
        "======="
    }
}
