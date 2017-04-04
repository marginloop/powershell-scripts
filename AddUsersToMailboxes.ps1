$groups = import-csv C:\Users\cduffy\Documents\WindowsPowerShell\scripts\input\mailboxes.csv
$users = import-csv C:\Users\cduffy\Documents\WindowsPowerShell\scripts\input\users.csv

$p = Read-Host -AsSecureString "password"

foreach($group in $groups){

     $A = $group.Alias

     foreach($user in $users){
        $u = Get-User -Filter {Name -like "*$user*"}
        Add-MailboxPermission -Identity "$A" -User "" -AccessRights FullAccess

     }
    
}


#Display name, User name, Password, ou, primary smtp address