
#setup the save file
$save_file = "C:\Users\cduffy\Documents\WindowsPowerShell\scripts\sunrise-mfg_members.csv"

$dg = Get-DistributionGroup

foreach($g in $dg) {

    #get the distribution group members from the group
	$ms = Get-DistributionGroupMember $g.DisplayName

    #check each member in the group and output to csv
    #distribution group, username, email
    foreach($m in $ms)
    {
		#If($g.DisplayName -match "SunriseMFG")
			#{
                $dname = $g.DisplayName
                $mname = $m.Name
                $address = $m.PrimarySMTPAddress

				 "$dname, $mname, $address"  | out-file -append $save_file
			#}
	}
}