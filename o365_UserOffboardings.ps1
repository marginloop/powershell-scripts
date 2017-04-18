
$users = @()

<######
    
    check archiving> enable archiving for the mailbox,
    hide the mailbox from the address list

######>
foreach($u in $users){
    $mailbox = Get-Mailbox -Identity $u
    
    if($mailbox.ArchiveStatus -ne "Active"){

        Enable-Mailbox -Identity $u -Archive -Verbose

    }

    Set-Mailbox -HiddenFromAddressListsEnabled $true -Identity $u -Verbose 
    #$adhidemailbox += "`rSet-ADUser -Identity $u -"

    $groups = Get-DistributionGroup
    foreach($g in $groups){
        $members = Get-DistributionGroupMember -Identity $g.DisplayName
        foreach($m in $members){
            if($mailbox.DisplayName -eq $m.DisplayName){
                Remove-DistributionGroupMember -Identity $g.DisplayName -Member $mailbox.DisplayName -whatif
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
     
     Set-Mailbox -Identity $upn -Type Shared -Verbose

     $license = Get-MsolUser -UserPrincipalName $UPN | select -ExpandProperty licenses
     Set-MsolUserLicense -UserPrincipalName $UPN -RemoveLicenses $license.AccountSkuId -Verbose
}
#$adhidemailbox