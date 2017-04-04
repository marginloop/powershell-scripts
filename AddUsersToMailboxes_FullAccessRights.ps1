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
$users = import-csv "$inputpath\users.csv"

#for each user add the user to the group with full access rights
foreach($group in $groups){

     $A = $group.Alias

     foreach($user in $users){

        Add-MailboxPermission -Identity "$A" -User "$user" -AccessRights FullAccess

     }
    
}