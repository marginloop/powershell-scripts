$users = @()

<######
    
    enable archiving for the mailbox,
    hide the mailbox from the address list

######>
foreach($u in $users){
    
    Enable-Mailbox -Identity $u -Archive
    Set-Mailbox -HiddenFromAddressListsEnabled $true -Identity $u

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
     Set-MsolUserLicense -UserPrincipalName $UPN -RemoveLicenses $license.AccountSkuId
}