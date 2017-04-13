#setting up default output and input paths

$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
$outputpath="$dir\output\"
$inputpath="$dir\input\"

<###################
#IMPORTANT:
locations of the imports will be in the location of the script files
SCRIPTFILELOCATION:\input\mailboxes.csv
--mailboxes are referenced by alias
--headers aer: DisplayName
SCRIPTFILELCOATION:\input\users.csv
#--users are referenced by ProxyAddresses
#--headers are: ProxyAddresses
###################>
$groups = import-csv "$inputpath\mailboxes.csv"
$users = import-csv "$inputpath\users.csv"

#for each user add the user to the group with full access rights
foreach($group in $groups){

     $A = $group.DisplayName
     
     foreach($user in $users){
        $u = $user.ProxyAddress
        "$u"
       
        Remove-DistributionGroupMember -Identity "$a" -Member "$u"
        
     }
    
}
