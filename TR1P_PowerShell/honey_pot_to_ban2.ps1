# Created by: Gomez, Timothy D.
#             MSG/USA
#             III Corps G6 CND
#       Date: 23OCT2019
#       Description: rough mechanics of something potentially cool.
#       Opens listening socket, whatever connects gets a local rule applying an inbound block from the remote address.
$userConfigs = @{
    "manualMode" = "True";
    "HoneyPort" = 1090;
    "RuleName" = "HoneyPot2Ban";
    "ManualModeOutPath" = $env:USERPROFILE+"\Desktop\";
    "OutFileName" = "goaway.ps1";
    "CheckFirewall" = "True";
    "ModifyAllZones" = "False";
    "DefaultInboundAction" = "Allow";
    "DefaultOutboundAction" = "Allow";
    "AllowLocalFirewallRules" = "True";
    "AllowInboundRules" = "True";
    "LogBlocked" = "True";
    "LogMaxSizeKilobytes" = "400000";
    "LogAllowed" = "True";
    "LogFileName" = "FireWall_Log_HoneyPot.txt";
    "RuleEnabled" =  "True";
    "ZoneName" = "Public";
    }
$SettingsObj = [PSCustomObject]$userConfigs

 
function FireWallDoubleTap
{
[CmdletBinding()]
Param([Parameter(
Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
    $CheckFirewall,
    $ModifyAllZones,
    $DefaultInboundAction,
    $DefaultOutboundAction,
    $allowLocalFirewallRules,
    $AllowInboundRules,
    $LogBlocked,
    $LogMaxSizeKilobytes,
    $LogAllowed,
    $LogFileName,
    $RuleEnabled,
    $ZoneName,
    $RuleName,
    $remoteIPconnected,
    $ManualMode,
    $ManualModeOutPath,
    $OutFileName,
    $HoneyPort
    )
    #$fwState = Get-Service -Name "MpsSvc" -ErrorAction SilentlyContinue
    $EnabledFWzones = Get-NetFirewallProfile | where {$_.Enabled -eq "True"}
    if (($ModifyAllZones -eq "True") -and ($ManualMode -eq "False"))
    {
        foreach ($ZoneName in $EnabledFWzones.Name)
            {
                Get-NetFirewallProfile -Name $ZoneName | Set-NetFirewallProfile -DefaultInboundAction $DefaultInboundAction -DefaultOutboundAction $DefaultOutboundAction -AllowLocalFirewallRules $allowLocalFirewallRules -AllowInboundRules $AllowInboundRules -LogBlocked $LogBlocked -LogMaxSizeKilobytes $LogMaxSizeKilobytes -LogAllowed $LogAllowed -LogFileName $LogFileName -Enabled $RuleEnabled
                $cmdOutput = 'New-NetFirewallRule -Name '+$RuleName+' -Profile '+$ZoneName+' -DisplayName '+'"HoneyPot to Ban"'+' -Description '+"'amscray!'"+' -Enabled '+$RuleEnabled+' -Direction Inbound -LocalAddress ANY -RemoteAddress '+$remoteIPconnected +'-Action Block -LocalPort Any -Protocol Any -Owner "MSG Gomez"'
            }
            
        }
    elseif (($ModifyAllZones -eq "False") -and ($ManualMode -eq "True"))
    {
                $cmdOutput = "Get-NetFirewallProfile -Name $ZoneName" + ' | Set-NetFirewallProfile -DefaultInboundAction '+$DefaultInboundAction+' -DefaultOutboundAction '+$DefaultOutboundAction+' -AllowLocalFirewallRules '+$allowLocalFirewallRules+'-AllowInboundRules '+$AllowInboundRules+' -LogBlocked'+ $LogBlocked+' -LogMaxSizeKilobytes'+ $LogMaxSizeKilobytes+' -LogAllowed '+$LogAllowed+' -LogFileName '+$LogFileName+' -Enabled '+$RuleEnabled
                $cmdOutput | Out-File -Encoding utf8 -FilePath $ManualModeOutPath\$OutFileName -Append
                $cmdOutput = 'New-NetFirewallRule -Name '+$RuleName+' -Profile '+$ZoneName+' -DisplayName '+'"HoneyPot to Ban"'+' -Description '+ "'amscray!'"+' -Enabled '+$RuleEnabled+' -Direction Inbound -LocalAddress ANY -RemoteAddress '+$remoteIPconnected +'-Action Block -LocalPort Any -Protocol Any -Owner "MSG Gomez"'
                $cmdoutput | Out-File -Encoding utf8 -FilePath $ManualModeOutPath\$OutFileName -Append
    }
    elseif (($ModifyAllZones -eq "False") -and ($ManualMode -eq "False"))
    {
        Get-NetFirewallProfile -Name $ZoneName | Set-NetFirewallProfile -DefaultInboundAction $DefaultInboundAction -DefaultOutboundAction $DefaultOutboundAction -AllowLocalFirewallRules $allowLocalFirewallRules -AllowInboundRules $AllowInboundRules -LogBlocked $LogBlocked -LogMaxSizeKilobytes $LogMaxSizeKilobytes -LogAllowed $LogAllowed -LogFileName $LogFileName -Enabled $RuleEnabled
        New-NetFirewallRule -Name $RuleName -Profile $ZoneName -DisplayName "HoneyPot to Ban" -Description 'amscray!' -Enabled $RuleEnabled -Direction Inbound -LocalAddress ANY -RemoteAddress $remoteIPconnected -Action Block -LocalPort Any -Protocol Any -Owner "MSG Gomez"
    }
}
function Tr1p-HoneyPot2Ban
{

try {
$listener = [System.Net.Sockets.TcpListener]$SettingsObj.HoneyPort
$listener.Start()

$honeyPot  = $listener.AcceptSocketAsync()
while($true)
{

if ($honeyPot.Status.ToString() -ne "RanToCompletion")
{
   sleep -Milliseconds 500
       
}
    $remoteIPconnected = ($honeypot.Result.RemoteEndPoint -split':')[0]
    Write-Host -ForegroundColor Yellow -BackgroundColor Black "--- Stranger Danger ---"
    write-host -ForegroundColor Gray "$remoteIPConnected  " -BackgroundColor Black -NoNewline 
    Write-Host -ForegroundColor DarkGray -BackgroundColor Black "Attempted Connection"
    Write-Host -ForegroundColor DarkRed -BackgroundColor White "Droppeth the Ban Hammer"
    FireWallDoubleTap  @userConfigs -remoteIPconnected $remoteIPconnected
    $honeypot.close
    $listener.Stop()
    break
    
 }
 }
catch{
Write-Error $_
$honeyPot.close
$listener.Stop()

}

finally{
}
#restart job
}

Tr1p-HoneyPot2Ban 
<#$userAction = Read-Host -Prompt "Display firewall rule generator? `tY or N"

switch($userAction){
Y {notepad C:\Users\tr1p\Desktop\goaway.cmd}
N {exit}
default {exit}
#>