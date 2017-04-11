#setting up default output and input paths
$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
$license_report = "$dir\license_report_$(Get-Date -Format MM-dd-yyyy).csv"
$debug = $false
$credential = Get-Credential
Connect-MsolService -Credential $credential

#get all users
$users = Get-MsolUser -all

#setting up table reference for user readible licenses
$Sku = @{
    "O365_BUSINESS_ESSENTIALS" = "Business Essentials"
    "OFFICESUBSCRIPTION" = "Office Professional Plus"
    "O365_BUSINESS" = "o365 Business"
    "EXCHANGE_S_ENTERPRISE" = "Exchange Online Plan 2"
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

#setup Header for license report
$headers = "DisplayName, UserPrincipalName"
$LicenseTypes = Get-MsolAccountSku
foreach ($h in $LicenseTypes){
    
    $h = $h.SkuPartNumber
    $headers += "," + $Sku.Item($h)
}

#
#output headers to file
#
$headers | Out-File -FilePath $license_report

#looping through each user and checking
foreach($user in $users){
    $dn = $user.DisplayName
    $upn = $user.UserPrincipalName
    $data = "$dn, $upn"
    $license_check = 0

    if($debug -eq $true){$compare = "DomainName, UserPrincipalName"}

    #loop through each license in the licenses types
    foreach($license in $LicenseTypes){
        
        #perform a license check for each license in the users licenses
        $license_check = 0
        foreach($userlicense in $user.licenses){
            
            $ul = $userlicense.AccountSkuId
            
            #license match user write 1, keep default value of 0 for license
            #if matches license, write 1
            if($ul -eq $license.AccountSkuId){
                $license_check = 1
            }   
        
        }
        
        $data += ", $license_check"
        if($debug -eq $true){$compare += ", " + $license.AccountSkuID}
        

    }
    
    if($debug -eq $true){
        $compare
        $data
    }

    #
    #output data proceccessed from license checks to file
    #
    $data | Out-File -Append -FilePath $license_report -NoClobber
}
