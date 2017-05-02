$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
$outputpath="$dir\output"
$inputpath="$dir\input"
$timecsv = "$outputpath\time-tracking_TimeTable_$(get-date -format yyyy-MM-dd).csv"
$desccsv = "$outputpath\time-tracking_DescTable_$(get-date -format yyyy-MM-dd).csv"
$getcolor = 'Cyan'
$setcolor = 'Magenta'

#creates the csv dependencies
if((Test-Path $timecsv) -eq $false){
     
    New-Item -Path $timecsv -ItemType file

    $time_header = "id, start_time, end_time"
    $default_data = "1,$(get-date),0"
    $time_header | Out-File $timecsv
    $default_data | Out-File $timecsv -Append

}
if((Test-Path $desccsv) -eq $false){
    New-Item -Path $desccsv -ItemType file

    $desc_header = "id,time_stamp,description,type"
    $desc_header | Out-File $desccsv

}

<#
    get the last time entry of the timecsv
    check the last line for the end time
    if there is no end time it sets the time and 
    starts the next time entry
#>
function set-time{
param([string]$description)
    
    #get the last time entry of the timecsv
    $last_line = ""
    $incsv = Import-Csv $timecsv
    $last_line = $incsv| Sort-Object start_time | Select -last 1
    [int]$id = $last_line.id
    $gd = Get-Date

    #checks the last line for the end time,
    #if there is no end time it sets the time and starts the next time entry
    if($last_line.end_time -eq 0){
        $last_line.end_time = $gd 
        $incsv | Export-Csv $timecsv -NoTypeInformation
        set-time           
    }else{
        $id += 1
        get-description
        get-time
        $et = $last_line.end_time
        $data = "$id,$et,0"
        $data| out-file $timecsv -Append -Encoding ascii
        Write-Host -ForegroundColor $setcolor "$last_line"
    }

    $description = ""
 
}

<#
    get the last time entry from the timecsv
    calculate the current time spent in minutes
    writes to console
#>
function get-time{
    #get the last time entry from the timecsv
    $incsv = Import-Csv $timecsv
    $last_line = $incsv| Sort-Object start_time | Select -last 1
    $st = $last_line.start_time
    $gd = Get-Date 

    #calculate the current time spent in minutes
    $ts = New-TimeSpan -Start $st -End $gd
    $tm = $ts.Minutes

    #writes to console
    Write-Host -ForegroundColor $getcolor "StartTime: $st`r`nEndTime: $gd`r`nTimeSpent: $tm`r`n"

}

<#
    assign description id
    write id in seperate file, with time
    use id until end_time is filled
#>
function set-description{
param([string]$description, [string]$foreignkey, [switch]$loop)
    $time_stamp = Get-Date
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
    $data = "${id},${time_stamp},-${et}"
    Write-Host -ForegroundColor $setcolor "id:$id`r`nDescription:$et`r`n"
    $data| out-file $desccsv -Append
    $description = ""
    get-description

    if($loop){
        set-description -loop
    }
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
            $checkid = $true
        }else{
            $checkid = $false
        }
    }

    if($checkid -eq $false){
         Write-Host -ForegroundColor $getcolor "no description found for id '$id'`r`nset a description using 'set-description'"
    }
  
    $foreignkey = " "
}

Set-Alias -name st set-time
Set-Alias -name gt get-time
Set-Alias -Name sd set-description
Set-Alias -Name gd get-description