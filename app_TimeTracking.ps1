$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
$outputpath="$dir\output\"
$inputpath="$dir\input\"

function WriteToFile([string]$Path, [string]$Name, [string]$Data, [string]$Headers){

    #--setup of file name
    $Date =  Get-Date -Format yyyy-MM-dd
    $DateTime= Get-Date
    $File = $Path + $Name + $Date+ ".txt"
    
    #--check output folders
    if(!(Test-Path $Path)){
        
        New-Item -Path $Path -ItemType directory

    }

    #--check creation of file
    if((Test-Path $File)){
        
        Write-Host "`r`n## # ##Adding Data to File" -ForegroundColor Cyan

        #--add data to file
        Write-Host "Data: ${Data}`r`n" -ForegroundColor Cyan
        $Data |Out-File -Append "${File}"       
        
    }else{
        
        Write-Host "`r`n## # ##Creating File" -ForegroundColor Cyan
        New-Item $File -ItemType File  

        Write-Host "`r`n## # ##Adding Data to File" -ForegroundColor Cyan

        if($Headers -ne $null){
            
            Write-Host "Headers: ${Headers}" -ForegroundColor Cyan
            $Headers |Out-File -Append "${File}" 

        }
        
        #--add data to file
        Write-Host "Data: ${Data}`r`n" -ForegroundColor Cyan
        $Data |Out-File -Append "${File}"
    }
    


}



function time{
    while($true){
    $StartDate = Get-Date
    "`r`nstart: $StartDate"
    $Description = Read-Host "ticket number"
    $Description += Read-Host "continue"
    $EndDate = Get-Date
    "end: $EndDate"
    
    $TimeSpent = New-TimeSpan -Start $StartDate -End $EndDate

    $TotalMinutes = $TimeSpent.TotalMinutes
    $h = "Description, TotalMinutes, Start, End"
    $DataString = "${Description}, ${TotalMinutes}, ${StartDate}, ${EndDate}"

    . WriteToFile -Path $outputpath -Name "time_tracking_" -Data $DataString -Headers $h
    }
}



