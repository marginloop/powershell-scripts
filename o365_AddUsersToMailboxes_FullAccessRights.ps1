#setting up default output and input paths

$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
$outputpath="$dir\output\"
$inputpath="$dir\input\"

###################
#IMPORTANT:
#locations of the imports will be in the location of the script files
# SCRIPTFILELOCATION:\input\mailboxes
#--mailboxes are referenced by alias
# SCRIPTFILELCOATION:\input\users.csv
#--users are referenced by user name/display name
###################
$groups = import-csv "$inputpath\mailboxes.csv"
#$groups = Get-Mailbox -RecipientTypeDetails UserMailbox
$users = import-csv "$inputpath\users.csv"

#for each user add the user to the group with full access rights
$actionstaken = "`r`nACTIONS/DETAILS:"
foreach($group in $groups){

     $A = $group.DisplayName
     
     foreach($user in $users){
        $u = $user.DisplayName
        
        if(($A -like "*pla*") -or ($A -like "*Azure*")){
            "AccessRights not applied for '$A'"
        }else{
            #Add-MailboxPermission -Identity "$A" -User "$u" -AccessRights FullAccess -AutoMapping:$true
            Add-MailboxPermission -Identity "$A" -User "$u" -AccessRights FullAccess -AutoMapping:$false
            $actionstaken += "`r`n-removed automapping for '$u' on mailbox '$A'"
        }

     }
    
}


$actionstaken