function Set-OutlookAppointment{
Param([string]$workorder,[string]$phonenumber,[string]$client,
[string]$user,[string]$subject,[string]$starttime, [string]$details)

    ##begin outlook appointment check
    if($workorder -eq ""){$workorder = Read-Host "workorder"}
    if($phonenumber -eq ""){$phonenumber = Read-Host "phonenumber"}
    if($client -eq ""){$client = Read-Host "client"}
    if($user -eq ""){$user = Read-Host "user"}
    if($subject -eq ""){$subject = Read-Host "subject"}
    if($starttime -eq ""){$starttime = Read-Host "start time(MM/DD/YYYY HH:MM)"}

    ##initialize outlook
    $outlook = new-object -com Outlook.Application
    $calendar = $outlook.Session.folders.Item(1).Folders.Item("Calendar")
    $appt = $calendar.Items.Add(1) # == olAppointmentItem

    #start time check
    if($starttime -eq ""){$starttime = $appt.Start}
    else{$appt.Start = [datetime]"${starttime}"}

    $subject = "[$workorder] $phonenumber $client"+":"+"$user--$subject"
    $details = "starttime:$starttime
workorder:$workorder
phonenumber:$phonenumber
client:$client
user:$user
subject:$subject"

    $appt.Subject = "${subject}"
    $appt.Body = "${details}"

    $appt.Save()

}