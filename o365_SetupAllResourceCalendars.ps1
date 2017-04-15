#setting up default output and input paths
$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
$outputpath="$dir\output\"
$inputpath="$dir\input\"


#Main Working Code
#grab all mailboxes with the type Room, and Equipment
$mailboxes = Get-Mailbox -RecipientTypeDetails RoomMailbox, EquipmentMailbox

#for each mailbox, 
foreach($mailbox in $mailboxes){

     $m = $mailbox.DisplayName
     Set-CalendarProcessing -Identity $m -AutomateProcessing AutoAccept -DeleteSubject $False -AddOrganizerToSubject $False
     Get-CalendarProcessing -Identity $m | Select Identity, AutomateProcessing, DeleteSubject, AddOrganizerToSubject
}

