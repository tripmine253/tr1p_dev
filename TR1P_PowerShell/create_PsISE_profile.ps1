$GomezProfile = @'
#set WSL env var
$global:WSLHome = (get-childitem -Recurse -Path "$env:LOCALAPPDATA\Packages\" `
    | Where-Object {$_.FullName -ilike "*CanonicalGroupLimited.Ubuntu18.04*\LocalState\rootfs"} | Select -First 1).FullName
#base64 encoder blah blah    
function b64enc {
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true,
                   Position=0)]
        $Input)
    $bytes = [System.Text.Encoding]::Unicode.GetBytes($input)
    $b64enc = [convert]::ToBase64String($bytes)
    return $b64enc
}
#handy timestamps
function timeStamps
{
    $date = get-date 
    $global:12hours = $date.AddHours(-12)
    $global:18hours = $date.AddHours(-18)
    $global:24hours = $date.AddHours(-24)
    $global:UTC = (Get-Date).ToUniversalTime().ToString("hh:mm:ssZddMMMyyyy") # ZULU TIME

}
# pull in exch modules
function LoadExchMods
{
    $creds = Get-Credential
    $ExchangeSession = New-PSSession -ConnectionUri http://YOUR.SERVER.SUX/PowerShell -ConfigurationName Microsoft.Exchange -Authentication Kerberos -Credential $creds -ErrorAction Continue
    Import-PSSession $ExchangeSession -AllowClobber -ErrorAction Continue
}
function LoadAD
{
    Import-Module ActiveDirectory -ErrorAction SilentlyContinue
}

### Show-InteractiveLogonsIDs | % {Get-UserByLogonID($_)}
function Show-InteractiveLogonsIDs() # VERY UGLY
{
    Param(
    [Parameter(    
    ValueFromPipeline=$True,
    ValueFromPipelineByPropertyName = $True)]
    [string]$ComputerName=$env:COMPUTERNAME)

    $interactiveSessionIDs = (gwmi -ComputerName $ComputerName -Namespace "root\cimv2" -Query "SELECT LogonId FROM Win32_logonSession WHERE LogonType = 2").logonId

    return $interactiveSessionIDs
}

function Get-UserByLogonID($ID)
{
    $Props = @{
    LogonName = $null
    LogonID = $null
    }
    $container = @()
    $LogonName = $null
    $LogonID  = $null
    $SessionUserNames =  gwmi -Class Win32_LoggedOnUSer
    foreach ($x in $SessionUserNames)
    {
        $WastedTime = New-Object PSObject -Property $Props
        $findme = $x.Antecedent + $x.Dependent
        $findme = ($findme -split ',' -split '"')[4,6]
        $WastedTime.LogonName = $findme[0]
        $WastedTime.LogonID = $findme[1]
        $container += $WastedTime
    }
    if ($container.LogonId -icontains $ID)
    {
        $i = $container.LogonId.IndexOf($ID)
        return $container[$i].LogonName
        
    }
}
function Reverse-It($1)
{
    $rev = ($1.ToCharArray())
    [array]::Reverse($rev)
    return $rev -join('')
}
'@
$isValid = $profile | Test-Path
Clear-Host
if (!($profile |Split-Path -Parent | Test-Path))
{
    New-Item -ItemType Directory -Path "$env:USERPROFILE\Documents\WindowsPowerShell"
}
elseif (!($isValid))
{
    New-Item -ItemType File -Path "$env:USERPROFILE\Documents\WindowsPowerShell\Microsoft.PowerShellISE_profile.ps1"
    $GomezProfile | Out-File -FilePath $profile
}
else
{
    Clear-Host
    Write-Host Profile Exists
}
