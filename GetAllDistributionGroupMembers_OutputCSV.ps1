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
###################>
$save_file = "$outputpath\mailboxes.csv"

$dg = Get-DistributionGroup

foreach($g in $dg) {

    #get the distribution group members from the group
	$ms = Get-DistributionGroupMember $g.DisplayName

    #check each member in the group and output to csv
    #distribution group, username, email
    foreach($m in $ms)
    {
	
                $dname = $g.DisplayName
                $mname = $m.Name
                $address = $m.PrimarySMTPAddress

				 "$dname, $mname, $address"  | out-file -append $save_file
				 
	}
}