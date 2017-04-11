
#pull log files from last 30 days for application and system
$winevents = Get-WinEvent -FilterHashTable @{LogName='Application','System'; Level=2; StartTime=(Get-Date).AddDays(-30)} -ErrorAction SilentlyContinue 

#select objects from win events and sort by Message, export to csv

$eventlog_temp = 'c:\EventLog_TEMP.csv'
$winevents | Select-Object TimeCreated,LogName,ProviderName,Id,LevelDisplayName,Message | Sort Message | Export-Csv -Path $eventlog_temp -Encoding ascii -NoTypeInformation

$eventlog = Import-CSV $eventlog_temp

#remove duplcates from a csv and export to event log
$eventlog_final = "c:\EventLog_$(hostname)_$(Get-Date -Format yyyy-MM-dd).csv"

#sort through the events by message
$eventlog | Group-Object Message| ForEach-Object{
    $data = $_.group | Sort-Object Message | Select -last 1 |export-csv -append -path $eventlog_final -NoTypeInformation
}

