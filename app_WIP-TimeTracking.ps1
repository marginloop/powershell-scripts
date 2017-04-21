$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
$outputpath="$dir\output\"
$inputpath="$dir\input\"

$outcsv = "$dir\time-tracking_$(get-date -format yyyy-MM-dd).csv"

if(!(Test-Path $Path)){
     
    New-Item -Path $outcsv -ItemType directory

}

#main handler
function Invoke-Time {
    
}

#set start_time
#set end_time
#check start_time
#if start_time entry, then write to end_time
function settime{
    

}

#get current time from csv
funtion gettime{
    $incsv = Import-Csv $outcsv
}

#assign desctiption id
#write id in seperate file, with time
#use id until end_time is filled
function setdesc{
    
}

function getdesc{
    $incsv = Import-Csv $outcsv
    $incsv.id

}
#get all descriptions matching id
#output to console

