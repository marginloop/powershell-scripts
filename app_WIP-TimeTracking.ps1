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

    $desc_header = "id,description"
    $defalt_data = "0,0"
    $desc_header | Out-File $desccsv
    $defalt_data | Out-File $desccsv -Append
}

#set start_time
#set end_time
#check start_time
#if start_time entry, then write to end_time
function set-time{
param([string]$description)
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
        $id += 1
        get-time
        $et = $last_line.end_time
        $data = "$id,$et,0"
        $data| out-file $timecsv -Append -Encoding ascii
        Write-Host -ForegroundColor $setcolor "$last_line"
    }
    $description = ""
    
}

#get current time from csv
function get-time{
    $incsv = Import-Csv $timecsv
    $last_line = $incsv| Sort-Object start_time | Select -last 1
    $st = $last_line.start_time
    $gd = Get-Date 

    $ts = New-TimeSpan -Start $st -End $gd
    $tm = $ts.Minutes

    Write-Host -ForegroundColor $getcolor "StartTime: $st`r`nEndTime: $gd`r`nTimeSpent: $tm`r`n"

}

#assign desctiption id
#write id in seperate file, with time
#use id until end_time is filled
function set-description{
param([string]$foreignkey, [string]$description)

    if(($foreignkey -eq $null) -or ($foreignkey -eq " ")-or ($foreignkey -eq "")){
        $last_line = ""
        $incsv = Import-Csv $timecsv
        $last_line = $incsv| Sort-Object start_time | Select -last 1
        [int]$id = $last_line.id

    }else{
        $id = $foreignkey
    }
    if(($description -eq $null) -or ($description -eq " ")-or ($description -eq "")){
        $description = Read-Host "Please Enter a description ($id)"   
    }
    $et = $description
    $data = "${id},-${et}"
    Write-Host -ForegroundColor $setcolor "id:$id`r`nDescription:$et`r`n"
    $data| out-file $desccsv -Append
    $description = ""
    get-description
}

#get all descriptions matching id
#outputs to console
function get-description{
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
        if($row.id -match $id){
            Write-Host -ForegroundColor $getcolor "$($row.description)"
        }
    }
  
    $foreignkey = " "
}

