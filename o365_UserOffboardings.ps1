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

Write-Host "[$time] Opening Powershell Remote Session"
Import-PSSession $Session
Connect-MsolService -Credential $UserCredential

.\o365_!OpenShellSession.ps1

$users = @("")

<######
    
    check archiving> enable archiving for the mailbox,
    hide the mailbox from the address list

######>
$data = "ACTIONS/DETAILS"
$errs = "ERRORS"
foreach($u in $users){
    $mailbox = Get-Mailbox -Identity $u
    
    if($mailbox.ArchiveStatus -ne "Active"){

        Enable-Mailbox -Identity $u -Archive -Verbose
        $data += "`r`n+archiving mailbox '$mailbox'"
    }

    #hide the mailbox from the global address list if it listed in the address book
    if($mailbox.HiddenFromAddressListsEnabled -eq $false){
        
        try{
            Set-Mailbox -HiddenFromAddressListsEnabled $true -Identity $u -Verbose 
            $data += "`r`n-hiding '$mailbox' from address lists"
        }catch{  
            $errs += "`r`n-Mailbox '$mailbox' unable to be hidden from the address book. Please check if o365 is synced through dirsync"
        }
        
    }

    $groups = Get-DistributionGroup
    
    foreach($g in $groups){
        $members = Get-DistributionGroupMember -Identity $g.DisplayName
        foreach($m in $members){
            if($mailbox.DisplayName -eq $m.DisplayName){
                Remove-DistributionGroupMember -Identity $g.DisplayName -Member $mailbox.DisplayName -Confirm:$false
                $data += "`r`n-removing user '$mailbox' from '$g'"
            }
        }
    }

}

<######
    
    find the user principle name for the mailbox,
    set the mailbox to a shared mailbox,
    check the licenses for the mailbox and remove them

######>
foreach($u in $users){

     $mailbox = Get-Mailbox -Identity $u
     $UPN = $mailbox.UserPrincipalName
     
     if($mailbox.RecipientType -ne "Shared"){
        Set-Mailbox -Identity $upn -Type Shared -Verbose
        $data += "`r`n+set mailbox '$upn' as shared mailbox"
     }

     $licenses = Get-MsolUser -UserPrincipalName $UPN | select -ExpandProperty licenses
     foreach($license in $licenses){
        Set-MsolUserLicense -UserPrincipalName $UPN -RemoveLicenses $license.AccountSkuId
        $data +="`r`n-removing license '$license' from '$upn'"
     }

}
#$adhidemailbox msExchangeHideFromAddressList

$data
$errs

.\o365_!CloseShellSession.ps1