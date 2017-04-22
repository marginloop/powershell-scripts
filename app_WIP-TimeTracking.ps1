$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
$outputpath="$dir\output\"
$inputpath="$dir\input\"
$outcsv = "$outputpath\time-tracking_$(get-date -format yyyy-MM-dd).csv"
$getcolor = 'Cyan'
$setcolor = 'Magenta'

if((Test-Path $outcsv) -eq $false){
     
    New-Item -Path $outcsv -ItemType file

}

#main handler
function Invoke-Time {
    
}

#set start_time
#set end_time
#check start_time
#if start_time entry, then write to end_time
function set-time{
    

}

#get current time from csv
function get-time{
    $incsv = Import-Csv $outcsv
    $last_line = $incsv| Sort-Object start_time | Select -last 1
    $st = $last_line.start_time
    $gd = Get-Date 

    $ts = New-TimeSpan -Start $st -End $gd
    $tm = $ts.Minutes
    Write-Host -ForegroundColor $getcolor "StartTime: $st`r`nTimeSpent: $tm"

}

#assign desctiption id
#write id in seperate file, with time
#use id until end_time is filled
function set-desc{
    
}

function get-desc{
    $incsv = Import-Csv $outcsv
    

}
#get all descriptions matching id
#output to console

