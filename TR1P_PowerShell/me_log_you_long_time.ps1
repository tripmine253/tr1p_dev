# MSG Gomez, Tim (tr1p)
# 4/1/2019
# Do Stuff V1
# Sysmon Configuration Deployer
function tr1pmodslog
{
    $logParams = @{"LogID"=$null;"MonTools"=$null}
    $LogReport = New-Object -TypeName PSObject -Property  $logParams
    $LogReport.LogID = "A"
    $LogReport.MonTools = "A"
    $LogReport | Export-Clixml C:\Scripts\tr1pmods.clixml
}

function Test-IsAdmin {
    try {
        $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
        $principal = New-Object Security.Principal.WindowsPrincipal -ArgumentList $identity
        return $principal.IsInRole( [Security.Principal.WindowsBuiltInRole]::Administrator )
    } catch {
        throw "Failed to determine if the current user has elevated privileges. The error was: '{0}'." -f $_
    }
}


if (Test-IsAdmin)
{
    $ThisDir = "C:\Scripts"
    $DirExists = Test-Path -Path $ThisDir
    $FileChecks = "tr1pmods.clixml"
    switch($DirExists){
        $true {$hasFiles = Get-ChildItem -Recurse $ThisDir | ? {$FileChecks -icontains $_.Name;if ($hasFiles.count -gt 0){exit}else{write-host "doing stuff"}}}
        $false {New-Item -Path $ThisDir -type 'Directory' -Force | Out-Null -ErrorAction SilentlyContinue}
    }
        Get-ChildItem -Recurse -Path "\\lab.local\sysvol\lab.local\Policies\{31B2F340-016D-11D2-945F-00C04FB984F9}\Machine\Scripts\Startup" | Copy-Item  -Destination $ThisDir
        Get-ChildItem $ThisDir | Unblock-File
        $copiedFiles = Get-ChildItem "\\lab.local\sysvol\lab.local\Policies\{31B2F340-016D-11D2-945F-00C04FB984F9}\Machine\Scripts\Startup"
        Set-Location $ThisDir
    $archTest = [IntPtr]::Size
    switch($archTest){
    4
        {
            cmd.exe /c "Sysmon.exe -accepteula -i C:\Scripts\sysmonconfig-export.xml"
            cmd.exe /c "Sysmon.exe -accepteula -s"
            }
    8
        {
            cmd.exe /c "Sysmon64.exe -accepteula -i C:\Scripts\sysmonconfig-export.xml"
            cmd.exe /c "Sysmon64.exe -accepteula -s"
        }
    }
    cmd.exe /c 'wevtutil.exe sl Microsoft-Windows-Sysmon/Operational /ca:O:BAG:SYD:(A;;0xf0005;;;SY)(A;;0x5;;;BA)(A;;0x1;;;S-1-5-32-573)(A;;0x1;;;NS)'
    $copiedFiles | % {remove-item $_.FullName -Force; write-host $_.Name " Deleted"}
    tr1pmodslog
    }



    