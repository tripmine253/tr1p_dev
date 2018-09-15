##############################################################################
# Domain Pro a1.2 --  Ensures Windows Remote Management is running           # 
#               and will permit traffic from trusted sources.                #
# MSG Gomez, Timothy D.                                                      #
# 27 May 2018                                                                #
#                                                                            #
#                                                                            #
#                                                                            #
##############################################################################
$service = Get-Service -Name WinRM -ErrorAction SilentlyContinue
$fwState = Get-Service -Name MpsSvc -ErrorAction SilentlyContinue
$safenets = '1.2.3.0/24,2.3.4.0/24'
Enable-PSRemoting -Force
function FireWallDoubleTap
{
    $fwLOG = "C:\Scripts\" + $env:COMPUTERNAME + "_FW_LOG.txt"
    $EnabledFWzones = Get-NetFirewallProfile | where {$_.Enabled -eq "True"}
    $FWzoneCount = $EnabledFWzones.Name.count
    $index = 0
        foreach ($x in 1..$FWzoneCount)
        {
            $ZoneName = $EnabledFWzones.Name[$index]
            Get-NetFirewallProfile -Name $ZoneName | Set-NetFirewallProfile -DefaultInboundAction Allow -DefaultOutboundAction Allow -AllowLocalFirewallRules True -AllowInboundRules True -LogBlocked True -LogMaxSizeKilobytes 400000 -LogAllowed True -LogFileName $fwLOG -Enabled True
            New-NetFirewallRule -Name WINRM_HTTPS_IN_HTTPS -Profile $ZoneName -DisplayName "Win RM Tr1p-IN HTTPS" -Description "Let me The Hell In" -Enabled True -Direction Inbound -LocalAddress ANY -RemoteAddress $safenets  -Action Allow -LocalPort 5986 -Protocol tcp -Owner "MSG Gomez"
            New-NetFirewallRule -Name WINRM_HTTP_IN_HTTP -Profile $ZoneName -DisplayName "Win RM Tr1p-IN HTTP" -Description "Let me The Hell In" -Enabled True -Direction Inbound -LocalAddress ANY -RemoteAddress $safenets  -Action Allow -LocalPort 5985 -Protocol tcp -Owner "MSG Gomez"
            Set-NetFirewallRule –Name "WINRM-HTTP-In-TCP-PUBLIC" –RemoteAddress Any 
            $index++
        }
}