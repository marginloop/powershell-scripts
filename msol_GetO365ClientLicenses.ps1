<#
    ...............................
    ...............................
    Connects to the msol service,
    Sets up the input and output paths for data.
    fetches all users for future iteration
    fetches all users for future iteration
    initializes a reference table for human readable csv headers
    initializes headers for license reports and future iteration
    iterates through billed license types and adds license names csv headers
    iterates through total actively billed licenses, preps for csv write
    ...............................
    ...............................

    sets up the main header for the files
    includes the license types, license counts, 
    blank space for comparison calculations,
    and headers for the main license audit.

    loops through each user(email) in office 365;
    [nested]loops through each license type billed;
    [[nested]]loops through each user license, 
        -compares license to billed license,
        -preps a 1 or 0 to output to csv depending on comparison
    output's results to the file
#>

#...............................#...............................
#...............................#...............................

#connects to msol service
Connect-MsolService

#setting up default output and input paths
$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
$LicenseTypes = Get-MsolAccountSku
$Client =$LicenseTypes.AccountName[0]
$license_report = "$dir\$client-LicenseReport_$(Get-Date -Format MM-dd-yyyy).csv"
$debug = $false

#fetch licenses, users, and account name
$users = Get-MsolUser -all

#setting up table reference for user readible licenses
$Sku = @{
    "O365_BUSINESS_ESSENTIALS" = "Business Essentials"
    "OFFICESUBSCRIPTION" = "Office Professional Plus"
    "O365_BUSINESS" = "o365 Business"
    "O365_BUSINESS_PREMIUM" = "O365 Business Premium"
    "EXCHANGE_S_ENTERPRISE" = "Exchange Online Plan 2"
    "EXCHANGEDESKLESS" = "Exchange Online Kiosk"
    "EXCHANGEARCHIVE_ADDON"="Exchange Online Archiving (exchange-P2)"
	"DESKLESSPACK" = "Office 365 (Plan K1)"
	"DESKLESSWOFFPACK" = "Office 365 (Plan K2)"
	"LITEPACK" = "Office 365 (Plan P1)"
	"EXCHANGESTANDARD" = "Exchange Online Plan 1"
	"STANDARDPACK" = "Enterprise Plan E1"
	"STANDARDWOFFPACK" = "Office 365 (Plan E2)"
	"ENTERPRISEPACK" = "Enterprise Plan E3"
	"ENTERPRISEPACKLRG" = "Enterprise Plan E3"
	"ENTERPRISEWITHSCAL" = "Enterprise Plan E4"
	"STANDARDPACK_STUDENT" = "Office 365 (Plan A1) for Students"
	"STANDARDWOFFPACKPACK_STUDENT" = "Office 365 (Plan A2) for Students"
	"ENTERPRISEPACK_STUDENT" = "Office 365 (Plan A3) for Students"
	"ENTERPRISEWITHSCAL_STUDENT" = "Office 365 (Plan A4) for Students"
	"STANDARDPACK_FACULTY" = "Office 365 (Plan A1) for Faculty"
	"STANDARDWOFFPACKPACK_FACULTY" = "Office 365 (Plan A2) for Faculty"
	"ENTERPRISEPACK_FACULTY" = "Office 365 (Plan A3) for Faculty"
	"ENTERPRISEWITHSCAL_FACULTY" = "Office 365 (Plan A4) for Faculty"
	"ENTERPRISEPACK_B_PILOT" = "Office 365 (Enterprise Preview)"
	"STANDARD_B_PILOT" = "Office 365 (Small Business Preview)"
	"VISIOCLIENT" = "Visio Pro Online"
	"POWER_BI_ADDON" = "Office 365 Power BI Addon"
    "POWER_BI_INDIVIDUAL_USE" = "Power BI Individual User"
    "POWER_BI_STANDALONE" = "Power BI Stand Alone"
    "POWER_BI_STANDARD" = "Power-BI standard"
	"PROJECTESSENTIALS" = "Project Lite"
    "PROJECTCLIENT" = "Project Professional"
	"PROJECTONLINE_PLAN_1" = "Project Online"
	"PROJECTONLINE_PLAN_2" = "Project Online and PRO"
	"ECAL_SERVICES" = "ECAL"
    "EMS" = "Enterprise Mobility Suite"
    "RIGHTSMANAGEMENT_ADHOC" = "Windows Azure Rights Management"
    "MCOMEETADV" = "PSTN conferencing"
    "SHAREPOINTSTORAGE" = "SharePoint storage"
    "PLANNERSTANDALONE" = "Planner Standalone"
    "CRMIUR" = "CMRIUR"
    "BI_AZURE_P1" = "Power BI Reporting and Analytics"
    "INTUNE_A" = "Windows Intune Plan A"
	}

#setup Headers for license report
$activeHeader= "Status"
$headers = "DisplayName, UserPrincipalName"

#iterates through each license name and preps the csv header
foreach ($h in $LicenseTypes){
    
    $h = $h.SkuPartNumber
    $headers += "," + $Sku.Item($h)
    $activeHeader +=  "," + $Sku.Item($h)
}

#iterates through total actively billed licenses, 
#preps for csv write
$licensecount = "Active"
foreach ($n in $LicenseTypes.ActiveUnits){
    $n = $n.ToString()
    $licensecount += ",$n"    
}

#...............................#...............................
#...............................#...............................

<#
    sets up the main header for the files
    includes the license types, license counts, 
    blank space for comparison calculations,
    and headers for the main license audit.
#>
"LICENSES"| Out-File -FilePath $license_report 
$activeHeader | Out-File -FilePath $license_report -Append
$licensecount | Out-File -FilePath $license_report -Append
"Assigned(calculated from assigned licenses)" | Out-File -FilePath $license_report -Append
"ASSIGNED LICENSES"| Out-File -FilePath $license_report -Append
$headers | Out-File -FilePath $license_report -Append

<#
    loops through each user(email) in office 365;
    [nested]loops through each license type billed;
    [[nested]]loops through each user license, 
        -compares license to billed license,
        -preps a 1 or 0 to output to csv depending on comparison
    output's results to the file
#>
#user loop
foreach($user in $users){
    $dn = $user.DisplayName
    $dn = $dn -replace ‘,’,''
    $upn = $user.UserPrincipalName
    $data = "$dn, $upn"
    $license_check = 0

    if($debug -eq $true){$compare = "`n`rLicenseTypes:"}
    
    #license type loop
    foreach($license in $LicenseTypes){
        $license_check = 0

        #user license loop
        foreach($userlicense in $user.licenses){
            
            $ul = $userlicense.AccountSkuId

            if($ul -eq $license.AccountSkuId){
                $license_check = 1
            }         
        }
        
        $data += ", $license_check"
        if($debug -eq $true){$compare += ", " + $license.SkuPartNumber}
            
    }
    
    if($debug -eq $true){"$compare `r`nUserData:$data`r`n----"}

    $data | Out-File -Append -FilePath $license_report -NoClobber
}