#setting up default output and input paths
$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
$license_report = "$dir\license_report.csv"

$credential = Get-Credential
Connect-MsolService -Credential $credential

#get all users
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
    $license_check = 0

    foreach($license in $LicenseTypes){
        $license_check = 0

        foreach($userlicense in $user.licenses){
            
            $ul = $userlicense.AccountSkuId
            
            #license match user write 1, else write 0
            #if matches license, write 1
            if($ul -eq $license.AccountSkuId){
                $license_check = 1
            }   
        
        }
        $data += ", $license_check"

    }
    $data | Out-File -Append -FilePath $license_report -NoClobber
}
