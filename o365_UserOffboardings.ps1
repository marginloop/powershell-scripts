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

$users = @("")

<######
    
    check archiving> enable archiving for the mailbox,
    hide the mailbox from the address list

######>
$data = "ACTIONS/DETAILS"
$errs = "ERRORS"
foreach($u in $users){
    
    $mailbox = Get-Mailbox -Identity $u
    Write-Host "[$(Get-Date)] Checking Mailbox Identity $u"

    if($mailbox.ArchiveStatus -ne "Active"){
        Write-Host "[$(Get-Date)] Archiving Mailbox"
        Enable-Mailbox -Identity $u -Archive
        $data += "`r`n+archiving mailbox '$mailbox'"
    }else{
        "[$(Get-Date)] Verified Mailbox Archived"
    }

    #hide the mailbox from the global address list if it listed in the address book
    if($mailbox.HiddenFromAddressListsEnabled -eq $false){
        
        try{
            "[$(Get-Date)] Hidding mailbox from address lists"
            Set-Mailbox -HiddenFromAddressListsEnabled $true -Identity $u | Out-Null
            $data += "`r`n-hiding '$mailbox' from address lists"
        }catch{  
            $errs += "`r`n-Mailbox '$mailbox' unable to be hidden from the address book. Please check if o365 is synced through dirsync"
        }
        
    }

    "[$(Get-Date)] removing $u from distribution groups"
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

    "[$(Get-Date)] setting $u as shared mailbox"
    $UPN = $mailbox.UserPrincipalName
     if($mailbox.RecipientType -ne "Shared"){
        Set-Mailbox -Identity $upn -Type Shared
        $data += "`r`n+set mailbox '$upn' as shared mailbox"
     }

     "[$(Get-Date)] removing licenses from $u" 
     $licenses = Get-MsolUser -UserPrincipalName $UPN | select -ExpandProperty licenses
     foreach($license in $licenses){
        Set-MsolUserLicense -UserPrincipalName $UPN -RemoveLicenses $license.AccountSkuId
        $data +="`r`n-removing license '$($license.AccountSku.SkuPartNumber)' from '$upn'"
     }

     if($mailbox.FowardingAddress -ne $null){
        Set-Mailbox -ForwardingAddress $null -DeliverToMailboxAndForward $false
     }

}

<######
    
    find the user principle name for the mailbox,
    set the mailbox to a shared mailbox,
    check the licenses for the mailbox and remove them

######>


$data
$errs

#.\o365_!CloseShellSession.ps1