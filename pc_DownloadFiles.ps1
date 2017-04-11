<#=============

    this script utilizes a function to download files from specified $URL 
    and outputs the files to the directory in which the script is ran

===============#>

$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
$outputpath="$dir"
$inputpath="$dir\input\"

$log = "$dir\DownloadFiles$(Get-Date -Format mm-dd-yyyy).txt"
<#=============

    This section is used in case authentication is needed for the site the download takes place on

===============#>
#$url = "URLwithSite"
#if($cr -eq " "){
#    $cr = Get-Credential -Credential sandyd@ucfinc.com
#}
#$wr = Invoke-WebRequest $url -Credential $cr
#$wr.Content

<#=============

   This section is the main download function

===============#>

function Download-File(){
Param([string]$url, [string]$output)
    
    $start_time = Get-Date

    $out = "$dir\$output"
    
    if(test-path $out){

        "[$(Get-Date -Format MM-dd-yy HHmm)] ${output} already downloaded"
    }else{
        "[$(Get-Date -Format MM-dd-yy HHmm)] starting download for ${output}"

        $wc = New-Object System.Net.WebClient
        $wc.DownloadFile($url, $out)

        "[$(Get-Date -Format MM-dd-yy HHmm)] completing download for ${output}"
    }
    
}


<#=============

    This section is the area where download links may be placed

===============#>
#example
#Download-file -url "https://download.gimp.org/mirror/pub/gimp/v2.8/windows/gimp-2.8.20-setup.exe" -output "gimp-2.8.20.exe"