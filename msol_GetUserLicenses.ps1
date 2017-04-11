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

foreach($user in $users){
    $dn = $user.DisplayName
    $upn = $user.UserPrincipalName
    $data = "$dn, $upn"

    foreach($userlicense in $user.licenses){
        
        
        #license match user write 1, else write 0
            
        $ul = $userlicense.AccountSkuId
        $ul = $ul.SubString($ul.LastIndexOf(":")+1)

        <#TODO: LICENSE CHECK
        foreach($license in $LicenseTypes){
            #if matches license, write 1
            #if no match for license is found write 0
        }#>
        
        $data += ", $ul"
        
    }
    $data
    "======="
}




<#
foreach($user in $users){
     $dn = $user.DisplayName
     $upn = $user.UserPrincipalName
     ##$licenses = Get-MsolUser -UserPrincipalName $upn | select -ExpandProperty licenses
     $l = $license.AccountSkuId
     $l = $l.SubString($l.LastIndexOf(":")+1)
     $l = $l.Replace(" ", ",")
     
     "$dn, $upn, $l"| out-file -Append $license_report

}
#>