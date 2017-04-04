#setting up default output and input paths

$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
$outputpath="$dir\output\"
$inputpath="$dir\input\"

$groups = import-csv "$inputpath\mailboxes.csv"
$users = import-csv "$inputpath\users.csv"

foreach($group in $groups){

     $A = $group.Alias

     #for each user add the user to the group with full access rights
     foreach($user in $users){

        Add-MailboxPermission -Identity "$A" -User "$user" -AccessRights FullAccess

     }
    
}