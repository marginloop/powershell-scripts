$errors= @("650","651", "653", "654", "656","657", "0", "115", "657", "611", "652", "6900")
#pull log files from last 30 days for application and system
$winevents = Get-WinEvent -FilterHashTable @{LogName='Application','System'; StartTime=(Get-Date).AddDays(-30)} -ErrorAction SilentlyContinue 

#select objects from win events and sort by Message, export to csv

$eventlog_temp = "$env:USERPROFILE\EventLog_temp.csv"
$winevents | Select-Object TimeCreated,LogName,ProviderName,Id,LevelDisplayName,Message | Sort Message | Export-Csv -Path $eventlog_temp -Encoding ascii -NoTypeInformation

$eventlog = Import-CSV $eventlog_temp

#remove duplcates from a csv and export to event log
$eventlog_final = "$env:USERPROFILE\EventLog_$(hostname)_$(Get-Date -Format yyyy-MM-dd).csv"

#sort through the events by message
$eventlog | Group-Object Message| ForEach-Object{
    $data = $_.group | Sort-Object Message | Select -last 1
    foreach($id in $errors){
        
        if($data.Id -eq $id){
            $data.Id + " " +$id
            
            $data | export-csv -append -path $eventlog_final -NoTypeInformation -Verbose
        }
    }

}