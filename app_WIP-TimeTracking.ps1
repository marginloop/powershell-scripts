$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
$outputpath="$dir\output"
$inputpath="$dir\input"
$timecsv = "$outputpath\time-tracking_TimeTable_$(get-date -format yyyy-MM-dd).csv"
$desccsv = "$outputpath\time-tracking_DescTable_$(get-date -format yyyy-MM-dd).csv"
$getcolor = 'Cyan'
$setcolor = 'Magenta'

if((Test-Path $timecsv) -eq $false){
     
    New-Item -Path $timecsv -ItemType file

    $time_header = "id, start_time, end_time"
    $default_data = "1,$(get-date),0"
    $time_header | Out-File $timecsv
    $default_data | Out-File $timecsv -Append

}

if((Test-Path $desccsv) -eq $false){
    New-Item -Path $desccsv -ItemType file

    $desc_header = "id, description"
    $defalt_data = "0,0,0"
    $desc_header | Out-File $desccsv
    $defalt_data | Out-File $desccsv -Append
}

#main handler
function Invoke-Time {
    
}

#set start_time
#set end_time
#check start_time
#if start_time entry, then write to end_time
function set-time{
    $last_line = ""
    $incsv = Import-Csv $timecsv
    $last_line = $incsv| Sort-Object start_time | Select -last 1
    [int]$id = $last_line.id
    $gd = Get-Date

    if($last_line.end_time -eq 0){
        #assign value, #export csv
        $last_line.end_time = $gd 
        $incsv | Export-Csv $timecsv -NoTypeInformation
        set-time           
    }else{

        get-time
        $id += 1
        $et = $last_line.end_time
        $data = "$id,$et,0"
        $data| out-file $timecsv -Append -NoClobber -Encoding ascii
        Write-Host -ForegroundColor $setcolor "$last_line"
    }
    
}

#get current time from csv
function get-time{
    $incsv = Import-Csv $timecsv
    $last_line = $incsv| Sort-Object start_time | Select -last 1
    $st = $last_line.start_time
    $gd = Get-Date 

    $ts = New-TimeSpan -Start $st -End $gd
    $tm = $ts.Minutes
    try{
    Write-Host -ForegroundColor $getcolor "StartTime: $st`r`nEndTime: $gd`r`nTimeSpent: $tm`r`n"
    }catch{}
}

#assign desctiption id
#write id in seperate file, with time
#use id until end_time is filled
function set-desc{
    
}

function get-desc{
param([string]$foreignkey)

    if(($foreignkey -eq $null) -or ($foreignkey -eq " ")-or ($foreignkey -eq "")){
        $last_line = ""
        $incsv = Import-Csv $timecsv
        $last_line = $incsv| Sort-Object start_time | Select -last 1
        [int]$id = $last_line.id

    }else{
        $id = $foreignkey
    }

    $incsv = Import-Csv $desccsv

    foreach($row in $incsv){
        if($row.id -eq $id){
            #assign value, #export csv
            Write-Host -ForegroundColor $getcolor $row
        }else{
            "No matches found for id '$id'"
        }
    }
  
    $foreignkey = " "
}
#get all descriptions matching id
#output to console

