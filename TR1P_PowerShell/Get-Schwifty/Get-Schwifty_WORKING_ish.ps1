#################################################################################
#  Get-Schwifty 1.0  --- MSG Gomez, Timothy D. "Network Defense Manager" 1CD G6 #
#################################################################################
#                                                                               #
#-------------------------------------------------------------------------------#
# Create/Modify Local DB - Records System Serials, Specs, Configuation          #
# settings, TCP/UDP Connection History, Process Monitoring (establishing        #
# baseline for red flags), Resource Monitoring, Local File Changes, Local Logon #
# Failures, Registry Monitoring, Dank Memes, and much much more!!!              #
# ###############################################################################
# #   2.0 is going to be sick, I'm working on writing a broker in python to   # # 
# #   post data to a webserver/SQL                                            # #
# # Comments/Suggestions: timothy.d.gomez.mil@mail.mil                        # #
#################################################################################
$date = (Get-Date).ToUniversalTime().ToString("hh:mm:ssZddMMMyyyy") # ZULU TIME
$today = (Get-Date -Format yyyyMMdd) # 20180519 for comparing install before
$yesterday = (Get-Date).AddDays(-1)
$UploadSharePath = "\\share\g6\IA\DataMiner\"
$StopWatch =  New-Object -TypeName System.Diagnostics.Stopwatch # My superpower is... I can do whatever I want, but only if I feel like it.  - Rick Sanchez

function NewObject # Creates Rick C-137 Custom Object w/ Properties 
{
$clixmlbHashtable = [ordered]@{
        # General Information - Asset Management / Items For Active Directory Attributes / Troubleshooting Props
            "ComputerName" = $null
            "RecordDate" = $null
            "ComputerBrand" = $null
            "ComputerModel" = $null
            "CPU Description" = $null
            "Archatecture" = $null
            "CPU Logical" = $null
            "CPU Physical" = $null
            "SystemRAM" = $null
            "ComputerSerial" = $null # You're Welcome
            "HDD1_SN" = $null # You're Welcome
            "HDD2_SN" = $null # You're Welcome
            "InternalStorage" = @()
            "TPM_Enabled" = $null # May fail depending on PSversion / Not dire that I make it version flexible
            "TPM_Ready" = $null   # May fail depending on PSversion / Not dire that I make it version flexible
            "BIOS_MFR" = $null
            "BIOS_Name" = $null
            "BIOS_Version" = $null
            "BIOS_Results" = @()
        # Operating System Information
            "OperatingSystem" = $null
            "OS_Architecture" = $null
            "OS_Version" = $null
            "EFS Enabled" = $null # Encrypted FileSystem
            "EnvironmentalVars" = @()
            "EnvironmentalVars_HashValue" = $null
            "OS_WMIC_Results" = $null

        # Networking Information 
            "NIC1_Description" = $null
            "NIC1_DHCP_Enabled" = $null
            "NIC1_IPV4" = $null
            "NIC1_IPV6" = $null
            "NIC1_MAC" = $null
            "NIC1_GW" = $null
            "NIC1_Subnet_Mask" = $null
            "GEO_IP_Test_Set" = $null
            "GEO_IP_Data" = $null

        # Security Information 
            "Last24hr_ModFiles" = @() # Going to be looking for oddities -  or maybe something as simple as extensions  exe,bat,ps1,jar
            "ShouldNeverExist" = "nc","netcat","pwn","virus","hacked" # more to follow
            "ProcessLog" = @()
            "ProcessLogArrayOffset" = 0
            "WatchedEventIDs" = $null
            "EventIDLog" = @()

            "BaselineInstalledSoftware" = @()
            "BaselineInstalledArrayOffset" = 0
            "RecentlyInstalledSoftware" = @()
            "BaselineExclusionListPopd" = $false            
            
            "AdminGroupMembers" = @()
            "NetStat" = @()
            "NetStatArrayOffset" = 0 # Used so NetStat Appends to log and doesn't clobber / duplicate data

            "InteractiveLogons" = @()
            "LastReboot" = $null
            
        
        #  System Health
            "ThermalState" = $null
            "PowerState" = $null
        }

    $DBobj = New-Object PSObject -Property $clixmlbHashtable
    return $DBobj
}

function DoFirst # I'm Mr. MeeSeeks Look at me!
{
        LoadProcessDB         
}

function LoadDBFile # OHHHH CAANNN DOOOO
{
    $global:DB = $null
    
    $FileExists = Test-Path -Path C:\Scripts\RickC137_db.clixml
    if ($FileExists -ne $true)
    {
        NewObject | Export-Clixml C:\Scripts\RickC137_db.clixml    
    }
    else
    {
        $global:DB = Import-Clixml -Path C:\Scripts\RickC137_db.clixml
        return $global:DB
    }
}

function ModifyDB # Unleash S.E.A.L Team Ricks 
{
    # Stage the file in memory
    $Global:DB = LoadDBFile
    # Do the easy Stuff First
    $RAMQty = (gwmi -Class Win32_ComputerSystem).TotalPhysicalMemory
    $RAMstats = [string][math]::Round($RAMQty /  1Gb ,2) + " GB"
    $CPUDescription = (gwmi -Class Win32_processor).Name
    $NetInfo = Test-Connection -ComputerName $env:COMPUTERNAME -Count 1 | select IPV4Address, IPV6Address
    $ALL_NICS_IPset = (Get-WmiObject win32_networkadapterconfiguration -ComputerName $env:COMPUTERNAME| select * | ? {$_.IPenabled -eq $true})
    $NIC1_DESCRIPTION = $ALL_NICS_IPset.Description | select -First 1
    $NIC1_IPV4 = $NetInfo.IPV4Address.IPAddressToString
    $NIC1_IPV6 = $NetInfo.IPV6Address.IPAddressToString
    $NIC1_MAC = ($ALL_NICS_IPset.MACAddress)
    $NIC1_SUBNET_MASK =  $ALL_NICS_IPset.IPSubnet[0]
    $NIC1_GW = ($ALL_NICS_IPset.DefaultIPGateway)
    $NIC1_DHCP_ENABLED = $ALL_NICS_IPset.DHCPEnabled
    $HDDSNs = @()
    $HDDsns += (gwmi -Class Win32_physicalmedia | select Tag,SerialNumber | ? {$_.Tag -ilike "*PHYSICALDRIVE*" })
    if ($HDDsns.SerialNumber.count -ge 2){$HDD1_SN = $HDDsns.SerialNumber[0] ; $HDD2_SN = $HDDsns.SerialNumber[1]}
    else{$HDD1_SN = $HDDsns.SerialNumber}
    $Brand = (gwmi -Class Win32_ComputerSystem -ComputerName $env:COMPUTERNAME).Manufacturer
    $Model = (gwmi -Class Win32_ComputerSystem -ComputerName $env:COMPUTERNAME).Model
    $ChassySerial = (gwmi -Class Win32_bios -ComputerName $env:COMPUTERNAME ).serialnumber
    $ComputerSystemData = (gwmi -Class Win32_ComputerSystem) | select -Property ThermalState,UserName,SystemType,NumberOfProcessors,NumberOfLogicalProcessors
    $ThermalState = $ComputerSystemData.ThermalState
    $UserName = $ComputerSystemData.UserName
    $NumProcs = $ComputerSystemData.NumberOfProcessors
    $NumLogProcs = $ComputerSystemData.NumberOfLogicalProcessors
    $Arch = $ComputerSystemData.SystemType
    $TPMStatus = Get-Tpm | select TpmPresent,TpmReady
    $LocalAdmins = gwmi -Class win32_group -Property * -Filter "Name='Administrators'"
    $admins = $LocalAdmins.GetRelated("Win32_UserAccount").Name
    $adminList+=@{Administrators=$admins}
    $TPM_Enabled = $TPMStatus.TpmPresent
    $TPM_Ready = $TPMStatus.TpmReady
    ########################################################################################################################
    # Populate the fields.... 
    ########################################################################################################################

    $Global:DB.RecordDate = $date
    $Global:DB.ComputerName = $env:COMPUTERNAME
    $Global:DB.ComputerBrand = $Brand
    $Global:DB.ComputerModel = $Model
    $Global:DB.ComputerSerial = $ChassySerial
    $Global:DB.HDD1_SN = $HDD1_SN
    $Global:DB.HDD2_SN = $HDD2_SN
    $hddArray = @()
    $HardDiskInventory = (gwmi -Class Win32_LogicalDisk | select DriveType,DeviceID,FreeSpace,Size,VolumeName, @{l="GB_Free";e={[math]::Round($_.FreeSpace / 1Gb,4)}} , @{l="DiskSize";e={[math]::Round($_.Size / 1Gb,4)}}, @{l="Drive";e={$_.DeviceID}} | ? {$_.DriveType -eq 3}| select DeviceID,DiskSize,GB_Free,VolumeName)  
    $HardDiskInventory | % {$hddArray+=@{Drive=$_.DeviceID,@{DiskSize = $_.DiskSize;GB_Free = $_.GB_Free;FreeHDDPercent = ([math]::Round(($_.GB_Free / $_.DiskSize) * 100,2)); VolumeName = $_.VolumeName}}}
    $Global:DB.InternalStorage += $hddArray
    $Global:DB.NIC1_DESCRIPTION = $NIC1_DESCRIPTION
    $Global:DB.NIC1_IPV4 = $NIC1_IPV4
    $Global:DB.NIC1_IPV6 = $NIC1_IPV6
    $Global:DB.NIC1_MAC = $NIC1_MAC
    $Global:DB.NIC1_GW = $NIC1_GW
    $Global:DB.NIC1_SUBNET_MASK = $NIC1_SUBNET_MASK
    $Global:DB.NIC1_DHCP_ENABLED = $NIC1_DHCP_ENABLED    
    $Global:DB.EnvironmentalVars += (wmic environment list brief /format:CSV | ConvertFrom-Csv) | select Name,VariableValue,UserName
    $Global:DB.OS_WMIC_Results = (gwmi -Class Win32_OperatingSystem | select  Caption, OSArchitecture,Version)
    $Global:DB.OperatingSystem = $Global:DB.OS_WMIC_Results.Caption
    $Global:DB.OS_Version = $Global:DB.OS_WMIC_Results.Version
    $Global:DB.OS_Architecture = $Global:DB.OS_WMIC_Results.OSArchitecture    

    $Global:DB.Archatecture = $Arch
    $Global:DB.'CPU Description' =  $CPUDescription
    $Global:DB.'CPU Logical' = $NumLogProcs
    $Global:DB.'CPU Physical' = $NumProcs
    $Global:DB.SystemRAM = $RAMstats
    $Global:DB.TPM_Enabled = $TPMStatus
    $Global:DB.TPM_Ready = $TPM_Ready

    $Global:DB.ThermalState = $ThermalState


    ### Security Information ###
    $Global:DB.LastReboot = (Get-EventLog -LogName System|  Where-Object {$_.EventID -eq 6006 | select -First 1}).TimeWritten
    $adminList = @()
    $WatchedSecurityEventIDs = @{Security = 5024,5025,5027,5028,5029,5030,5032,5033,5034,5035,5037 `
                             ,5058,5059,6400,6401,6402,6403,6404,6405,6406,6407,4608 `
                             ,4609,4616,4621,4610,4611,4614,4622,4697,4612,4615,4618 `
                             ,4816,5038,5056,5057,5060,5061,5062,6281}
    $Global:DB.AdminGroupMembers = $admins

    ###### Translate logonIDs to UserNames
    $interactiveRecordNames = (@{Users = (Show-InteractiveLogonsIDs | % {$uid = $_;Get-UserByLogonID($uid)})}).Users
    $interactiveRecord = @{$date = $interactiveRecordNames}
    $Global:DB.InteractiveLogons += $interactiveRecord

    #  Assemble Installed Software Inventory Per System
    $Global:DB.BaselineInstalledArrayOffset = $Global:DB.BaselineInstalled.Count
    $Global:DB.BaselineInstalledSoftware += Import-Clixml C:\Scripts\baselineinstalled.clixml -Skip $Global:DB.BaselineInstalledArrayOffset
    
    # Last 24 Hour File Writes
    $Global:DB.Last24hr_ModFiles = Import-Clixml C:\Scripts\Last24FileWrites.clixml
    Remove-Item C:\Scripts\Last24FileWrites.clixml

    $Global:DB.NetStatArrayOffset = $Global:DB.NetStat.Count
    $Global:DB.NetStat += Import-Clixml C:\Scripts\netstat.clixml -Skip $Global:DB.NetStatArrayOffset
    $Global:DB.WatchedEventIDs += $WatchedSecurityEventIDs
    $Global:DB.ProcessLog += $Global:processDB
    $Global:DB.ProcessLogArrayOffset = $Global:processDB.DTG.Count
    $Global:DB.ProcessLog += Import-Clixml C:\Scripts\processes.clixml -Skip $Global:DB.ProcessLogArrayOffset
    
}

function UnloadDB # Existance is pain
{
    $Global:DB | Export-Clixml C:\Scripts\RickC137_db.clixml
}

function UploadDB # Archive the local database at the Citadel of Ricks
{
    $destFileName = $UploadSharePath + $targethost + "_Cronenberged" + ".clixml"

    Copy-Item -Path C:\Scripts\RickC137_db.clixml -Destination $destFileName -Force
}
#############################################################
###                PROCESS RELATED OPERATIONS                                  #
#############################################################
function LoadProcessDB # Butter Robot: What is my purpose? Rick: You pass butter... 
{
    ###### Start Job for newly modified file search
    Last24HourFileWrites($yesterday)

    #wait for the process inventory to complete then handle the process objects / DB
    #This while should return true until the process completes
    while ($(
        try
        {
            $global:processDB = $null
            $StopWatch.Start()
            $global:localProcs = gwmi -Class Win32_process -Recurse -ErrorAction Stop
            $date + "`tTASK - Inventory of all processes" | Out-File C:\Scripts\debug.txt -Append -Encoding utf8 
        }
        catch
        {
            $FALSE
        }))
        ###### False condition Task
        {
            start-sleep -seconds 2 
        }
        "I FINISHED LOADING PROCESSES" | Out-Host
            $FileExists = Test-Path -Path C:\Scripts\processes.clixml
            if ($FileExists -ne $true)
            {
                # dump from $global.localprocs
                $global:processDB = New-ProcessLogEntry
                $global:processDB | Export-Clixml C:\Scripts\processes.clixml
                Write-Host "TASK - No Local Log; Created C:\Scripts\processes.clixml "
                $date + "`tTASK - No Local Log; Created C:\Scripts\processes.clixml" | Out-File C:\Scripts\debug.txt -Append -Encoding utf8 
            }
            else
            {
                $global:DB.ProcessLogArrayOffset = $global:DB.ProcessLogArrayOffset.count
                write-host "TASK - Local Log Found; Loaded Local Log, skipped to offset in Main DB to append new record" 
                $date + "`tTASK - Local Log Found; Loaded Local Log, skipped to offset in Main DB to append new record" | Out-File C:\Scripts\debug.txt -Append -Encoding utf8 
                $global:DB.ProcessLog += Import-Clixml -Path C:\Scripts\processes.clixml -Skip $global:DB.ProcessLogArrayOffset
                $global:processDB += New-ProcessLogEntry
                $global:DB.ProcessLog = $global:processDB
                Write-host "TASK - New record Appended to Main DB" | Out-File C:\Scripts\debug.txt -Append -Encoding utf8 
                $date + "`tTASK - New record Appended to Main DB" | Out-File C:\Scripts\debug.txt -Append -Encoding utf8 
                $global:processDB = @()
                $global:processDB = Import-Clixml -Path C:\Scripts\processes.clixml
                Write-host "tTASK - Reloaded ProcessDB with all process records" | Out-File C:\Scripts\debug.txt -Append -Encoding utf8 
                $date + "`tTASK - Reloaded ProcessDB with all process records" | Out-File C:\Scripts\debug.txt -Append -Encoding utf8 
                $global:processDB += New-ProcessLogEntry
                Write-host "TASK - Appended New Record to Local Log" | Out-File C:\Scripts\debug.txt -Append -Encoding utf8 
                $date + "`tTASK - Appended New Record to Local Log" | Out-File C:\Scripts\debug.txt -Append -Encoding utf8 
            }
            UnloadProcessDB
            $StopWatch.Stop()
            write-host "TASK - Unloaded ProcessDB Object and wrote to local disk" | Out-File C:\Scripts\debug.txt -Append -Encoding utf8 
            $date + "`tTASK - Unloaded ProcessDB Object and wrote to local disk" | Out-File C:\Scripts\debug.txt -Append -Encoding utf8 
            write-host "Operation took : " + $StopWatch.Elapsed.Seconds + " seconds to complete" 
            $date + "`tOperation took : " + $StopWatch.Elapsed.Seconds + " seconds to complete"  | Out-File C:\Scripts\debug.txt -Append -Encoding utf8 
}

function New-ProcessLogEntry # Rubber baby buggy bumpers!
{
    # Create Hashtable / Change Field Names
    $EntryTime = @{$date = $Global:localProcs}
    $reportObj = $EntryTime.Keys | select @{l="DTG";e={$_}},@{l="Processes";e={$EntryTime.$_}}
    $Global:processDB = $reportObj
    return $Global:processDB
}

function UnloadProcessDB # Butter Robot: Oh my god. Rick: Yeah, welcome to the club pal.
{
    # Create / Update NetStat Record(s)
    $Global:processDB| Export-Clixml C:\Scripts\processes.clixml
}
#///////////////////////////////////////////////////////////////////////////#

#############################################################
###                NETSTAT RELATED OPERATIONS                                  #
#############################################################
function StartNetStatLogFromScratch # Where are my testicles, Summer?
{
    New-NetstatLog
    $Global:NetStatDB | Export-Clixml C:\Scripts\netstat.clixml
    $date + "`tCreated New File NetStat.clixml" | Out-File C:\Scripts\debug.txt -Append -Encoding utf8 
}

function New-NetstatLog # GRASSSSS... tastes bad!
{
    # Create Hashtable / Change Field Names
    $EntryTime = @{(Get-Date) = Show-ActiveConnections}
    $reportObj = $EntryTime.Keys | select @{l="DTG";e={$_}},@{l="NetStat";e={$EntryTime.$_}}
    $Global:netstatDB += $reportObj
}

function NetStatLog # And that's why I always say, shum-shum-schlippety-dop!
{
    LoadNetStatDB
    New-NetstatLog
    UnloadNetStatDB
    # ????
    # Profit
}

function LoadNetStatDB # Sometimes science is more art than science, Morty
{
    $global:netstatDB = $null
    $FileExists = Test-Path -Path C:\Scripts\netstat.clixml
    if ($FileExists -ne $true)
    {
        StartNetStatLogFromScratch
    }
    else
    {
        $global:netstatDB += Import-Clixml -Path C:\Scripts\netstat.clixml
        return $global:netstatDB
    }
}

function Show-ActiveConnections # Gotta Get that Szechuan Sauce!!!!
{
    # Massage the data collected by Get-NetworkStatistics
    $global:ALLcon =  Get-NetworkStatistics
    $global:EST_LIST_ONLY = $ALLcon | ? {($_.State -ne  $null) -and ($_.State -eq "ESTABLISHED") -or ($_.State -eq "LISTENING") }
    $conArray = @()
    foreach ($con in $global:EST_LIST_ONLY)
    {
        foreach ($procName in $global:localProcs)
        {
            if ($con.PID -eq $procName.ParentProcessId)
            {
                $con.ProcessOwner = $procName.UserName
                $DNSname = [NET.DNS]::GetHostByAddress(($con.RemoteAddress).ToString()) | Out-Default -ErrorAction SilentlyContinue
                $con.RemoteResolved = $DNSname.HostName
                $con.ProcessPath = $procName.Path
                $con.CommandLine = $procName.CommandLine
                $step0BuildFilterString = '"' + "ProcessId = " + "`'" + $con.PID + "`'`""
                $step1forPIDSelect = "Get-CimInstance " + "win32_Process" + " -Filter " + "$step0BuildFilterString"
                $step2forPIDSelect = Invoke-expression $step1forPIDSelect
                $step3forUserSelect = (Invoke-CimMethod -InputObject $step2forPIDSelect -MethodName GetOwner).User
                $con.ProcessOwner = $step3forUserSelect
            }
        }
        $conArray+=$con
    }
        return $conArray
} 

function Get-NetworkStatistics # Birdperson believes he could arrange that
{
    # Reused code to support the legacy systems, plus I was too lazy to rewrite it 
    <#
    .SYNOPSIS
	    Display current TCP/IP connections for local or remote system

    .FUNCTIONALITY
        Computers

    .DESCRIPTION
	    Display current TCP/IP connections for local or remote system.  Includes the process ID (PID) and process name for each connection.
	    If the port is not yet established, the port number is shown as an asterisk (*).	
	
    .PARAMETER ProcessName
	    Gets connections by the name of the process. The default value is '*'.
	
    .PARAMETER Port
	    The port number of the local computer or remote computer. The default value is '*'.

    .PARAMETER Address
	    Gets connections by the IP address of the connection, local or remote. Wildcard is supported. The default value is '*'.

    .PARAMETER Protocol
	    The name of the protocol (TCP or UDP). The default value is '*' (all)
	
    .PARAMETER State
	    Indicates the state of a TCP connection. The possible states are as follows:
		
	    Closed       - The TCP connection is closed. 
	    Close_Wait   - The local endpoint of the TCP connection is waiting for a connection termination request from the local user. 
	    Closing      - The local endpoint of the TCP connection is waiting for an acknowledgement of the connection termination request sent previously. 
	    Delete_Tcb   - The transmission control buffer (TCB) for the TCP connection is being deleted. 
	    Established  - The TCP handshake is complete. The connection has been established and data can be sent. 
	    Fin_Wait_1   - The local endpoint of the TCP connection is waiting for a connection termination request from the remote endpoint or for an acknowledgement of the connection termination request sent previously. 
	    Fin_Wait_2   - The local endpoint of the TCP connection is waiting for a connection termination request from the remote endpoint. 
	    Last_Ack     - The local endpoint of the TCP connection is waiting for the final acknowledgement of the connection termination request sent previously. 
	    Listen       - The local endpoint of the TCP connection is listening for a connection request from any remote endpoint. 
	    Syn_Received - The local endpoint of the TCP connection has sent and received a connection request and is waiting for an acknowledgment. 
	    Syn_Sent     - The local endpoint of the TCP connection has sent the remote endpoint a segment header with the synchronize (SYN) control bit set and is waiting for a matching connection request. 
	    Time_Wait    - The local endpoint of the TCP connection is waiting for enough time to pass to ensure that the remote endpoint received the acknowledgement of its connection termination request. 
	    Unknown      - The TCP connection state is unknown.
	
	    Values are based on the TcpState Enumeration:
	    http://msdn.microsoft.com/en-us/library/system.net.networkinformation.tcpstate%28VS.85%29.aspx
        
        Cookie Monster - modified these to match netstat output per here:
        http://support.microsoft.com/kb/137984

    .PARAMETER ComputerName
        If defined, run this command on a remote system via WMI.  \\computername\c$\netstat.txt is created on that system and the results returned here

    .PARAMETER ShowHostNames
        If specified, will attempt to resolve local and remote addresses.

    .PARAMETER tempFile
        Temporary file to store results on remote system.  Must be relative to remote system (not a file share).  Default is "C:\netstat.txt"

    .PARAMETER AddressFamily
        Filter by IP Address family: IPv4, IPv6, or the default, * (both).

        If specified, we display any result where both the localaddress and the remoteaddress is in the address family.

    .EXAMPLE
	    Get-NetworkStatistics | Format-Table

    .EXAMPLE
	    Get-NetworkStatistics iexplore -computername k-it-thin-02 -ShowHostNames | Format-Table

    .EXAMPLE
	    Get-NetworkStatistics -ProcessName md* -Protocol tcp

    .EXAMPLE
	    Get-NetworkStatistics -Address 192* -State LISTENING

    .EXAMPLE
	    Get-NetworkStatistics -State LISTENING -Protocol tcp

    .EXAMPLE
        Get-NetworkStatistics -Computername Computer1, Computer2

    .EXAMPLE
        'Computer1', 'Computer2' | Get-NetworkStatistics

    .OUTPUTS
	    System.Management.Automation.PSObject

    .NOTES
	    Author: Shay Levy, code butchered by Cookie Monster
	    Shay's Blog: http://PowerShay.com
        Cookie Monster's Blog: http://ramblingcookiemonster.github.io/

    .LINK
        http://gallery.technet.microsoft.com/scriptcenter/Get-NetworkStatistics-66057d71
    #>	
	[OutputType('System.Management.Automation.PSObject')]
	[CmdletBinding()]
	param(
		
		[Parameter(Position=0)]
		[System.String]$ProcessName='*',
		
		[Parameter(Position=1)]
		[System.String]$Address='*',		
		
		[Parameter(Position=2)]
		$Port='*',

		[Parameter(Position=3,
                   ValueFromPipeline = $True,
                   ValueFromPipelineByPropertyName = $True)]
        [System.String[]]$ComputerName=$env:COMPUTERNAME,

		[ValidateSet('*','tcp','udp')]
		[System.String]$Protocol='*',

		[ValidateSet('*','Closed','Close_Wait','Closing','Delete_Tcb','DeleteTcb','Established','Fin_Wait_1','Fin_Wait_2','Last_Ack','Listening','Syn_Received','Syn_Sent','Time_Wait','Unknown')]
		[System.String]$State='*',

        [switch]$ShowHostnames,
        
        [switch]$ShowProcessNames = $true,	

        [System.String]$TempFile = "C:\Scripts\netstat.temp",

        [validateset('*','IPv4','IPv6')]
        [string]$AddressFamily = '*'
	)
    
	begin{
        #Define properties
            $properties = 'ComputerName','Protocol','LocalAddress','LocalPort','RemoteAddress',"RemoteResolved",'RemotePort','State','ProcessName','PID','ProcessOwner','ProcessPath','CommandLine'

        #store hostnames in array for quick lookup
            $dnsCache = @{}
            
	}
	
	process{

        foreach($Computer in $ComputerName) {

            #Collect processes
            if($ShowProcessNames){
                Try {
                    $processes = Get-Process -ComputerName $Computer -ErrorAction stop  | select name, id
                }
                Catch {
                    Write-warning "Could not run Get-Process -computername $Computer.  Verify permissions and connectivity.  Defaulting to no ShowProcessNames"
                    $ShowProcessNames = $false
                }
            }
	    
            #Handle remote systems
                if($Computer -ne $env:COMPUTERNAME){

                    #define command
                        [string]$cmd = "cmd /c c:\windows\system32\netstat.exe -ano >> $tempFile"
            
                    #define remote file path - computername, drive, folder path
                        $remoteTempFile = "\\{0}\{1}`${2}" -f "$Computer", (split-path $tempFile -qualifier).TrimEnd(":"), (Split-Path $tempFile -noqualifier)

                    #delete previous results
                        Try{
                            $null = Invoke-WmiMethod -class Win32_process -name Create -ArgumentList "cmd /c del $tempFile" -ComputerName $Computer -ErrorAction stop
                        }
                        Catch{
                            Write-Warning "Could not invoke create win32_process on $Computer to delete $tempfile"
                        }

                    #run command
                        Try{
                            $processID = (Invoke-WmiMethod -class Win32_process -name Create -ArgumentList $cmd -ComputerName $Computer -ErrorAction stop).processid
                        }
                        Catch{
                            #If we didn't run netstat, break everything off
                            Throw $_
                            Break
                        }

                    #wait for process to complete
                        while (
                            #This while should return true until the process completes
                                $(
                                    try{
                                        get-process -id $processid -computername $Computer -ErrorAction Stop
                                    }
                                    catch{
                                        $FALSE
                                    }
                                )
                        ) {
                            start-sleep -seconds 2 
                        }
            
                    #gather results
                        if(test-path $remoteTempFile){
                    
                            Try {
                                $results = Get-Content $remoteTempFile | Select-String -Pattern '\s+(TCP|UDP)'
                            }
                            Catch {
                                Throw "Could not get content from $remoteTempFile for results"
                                Break
                            }

                            Remove-Item $remoteTempFile -force

                        }
                        else{
                            Throw "'$tempFile' on $Computer converted to '$remoteTempFile'.  This path is not accessible from your system."
                            Break
                        }
                }
                else{
                    #gather results on local PC
                        $results = netstat -ano | Select-String -Pattern '\s+(TCP|UDP)'
                }

            #initialize counter for progress
                $totalCount = $results.count
                $count = 0
    
            #Loop through each line of results    
	            foreach($result in $results) {
            
    	            $item = $result.line.split(' ',[System.StringSplitOptions]::RemoveEmptyEntries)
    
    	            if($item[1] -notmatch '^\[::'){
                    
                        #parse the netstat line for local address and port
    	                    if (($la = $item[1] -as [ipaddress]).AddressFamily -eq 'InterNetworkV6'){
    	                        $localAddress = $la.IPAddressToString
    	                        $localPort = $item[1].split('\]:')[-1]
    	                    }
    	                    else {
    	                        $localAddress = $item[1].split(':')[0]
    	                        $localPort = $item[1].split(':')[-1]
    	                    }
                    
                        #parse the netstat line for remote address and port
    	                    if (($ra = $item[2] -as [ipaddress]).AddressFamily -eq 'InterNetworkV6'){
    	                        $remoteAddress = $ra.IPAddressToString
    	                        $remotePort = $item[2].split('\]:')[-1]
    	                    }
    	                    else {
    	                        $remoteAddress = $item[2].split(':')[0]
    	                        $remotePort = $item[2].split(':')[-1]
    	                    }

                        #Filter IPv4/IPv6 if specified
                            if($AddressFamily -ne "*")
                            {
                                if($AddressFamily -eq 'IPv4' -and $localAddress -match ':' -and $remoteAddress -match ':|\*' )
                                {
                                    #Both are IPv6, or ipv6 and listening, skip
                                    Write-Verbose "Filtered by AddressFamily:`n$result"
                                    continue
                                }
                                elseif($AddressFamily -eq 'IPv6' -and $localAddress -notmatch ':' -and ( $remoteAddress -notmatch ':' -or $remoteAddress -match '*' ) )
                                {
                                    #Both are IPv4, or ipv4 and listening, skip
                                    Write-Verbose "Filtered by AddressFamily:`n$result"
                                    continue
                                }
                            }
    	    		
                        #parse the netstat line for other properties
    	    		        $procId = $item[-1]
    	    		        $proto = $item[0]
    	    		        $status = if($item[0] -eq 'tcp') {$item[3]} else {$null}	

                        #Filter the object
		    		        if($remotePort -notlike $Port -and $localPort -notlike $Port){
                                write-verbose "remote $Remoteport local $localport port $port"
                                Write-Verbose "Filtered by Port:`n$result"
                                continue
		    		        }

		    		        if($remoteAddress -notlike $Address -and $localAddress -notlike $Address){
                                Write-Verbose "Filtered by Address:`n$result"
                                continue
		    		        }
    	    			     
    	    			    if($status -notlike $State){
                                Write-Verbose "Filtered by State:`n$result"
                                continue
		    		        }

    	    			    if($proto -notlike $Protocol){
                                Write-Verbose "Filtered by Protocol:`n$result"
                                continue
		    		        }
                   
                        #Display progress bar prior to getting process name or host name
                            Write-Progress  -Activity "Resolving host and process names"`
                                -Status "Resolving process ID $procId with remote address $remoteAddress and local address $localAddress"`
                                -PercentComplete (( $count / $totalCount ) * 100)
    	    		
                        #If we are running showprocessnames, get the matching name
                            if($ShowProcessNames -or $PSBoundParameters.ContainsKey -eq 'ProcessName'){
                        
                                #handle case where process spun up in the time between running get-process and running netstat
                                if($procName = $processes | Where {$_.id -eq $procId} | select -ExpandProperty name ){ }
                                else {$procName = "Unknown"}

                            }
                            else{$procName = "NA"}

		    		        if($procName -notlike $ProcessName){
                                Write-Verbose "Filtered by ProcessName:`n$result"
                                continue
		    		        }
    	    						
                        #if the showhostnames switch is specified, try to map IP to hostname
                            if($showHostnames){
                                $tmpAddress = $null
                                try{
                                    if($remoteAddress -eq "127.0.0.1" -or $remoteAddress -eq "0.0.0.0"){
                                        $remoteAddress = $Computer
                                    }
                                    elseif($remoteAddress -match "\w"){
                                        
                                        #check with dns cache first
                                            if ($dnsCache.containskey( $remoteAddress)) {
                                                $remoteAddress = $dnsCache[$remoteAddress]
                                                write-verbose "using cached REMOTE '$remoteAddress'"
                                            }
                                            else{
                                                #if address isn't in the cache, resolve it and add it
                                                    $tmpAddress = $remoteAddress
                                                    $remoteAddress = [System.Net.DNS]::GetHostByAddress("$remoteAddress").hostname
                                                    $dnsCache.add($tmpAddress, $remoteAddress)
                                                    write-verbose "using non cached REMOTE '$remoteAddress`t$tmpAddress"
                                            }
                                    }
                                }
                                catch{ }

                                try{

                                    if($localAddress -eq "127.0.0.1" -or $localAddress -eq "0.0.0.0"){
                                        $localAddress = $Computer
                                    }
                                    elseif($localAddress -match "\w"){
                                        #check with dns cache first
                                            if($dnsCache.containskey($localAddress)){
                                                $localAddress = $dnsCache[$localAddress]
                                                write-verbose "using cached LOCAL '$localAddress'"
                                            }
                                            else{
                                                #if address isn't in the cache, resolve it and add it
                                                    $tmpAddress = $localAddress
                                                    $localAddress = [System.Net.DNS]::GetHostByAddress("$localAddress").hostname
                                                    $dnsCache.add($localAddress, $tmpAddress)
                                                    write-verbose "using non cached LOCAL '$localAddress'`t'$tmpAddress'"
                                            }
                                    }
                                }
                                catch{ }
                            }
    
    	    		    #Write the object	
    	    		        New-Object -TypeName PSObject -Property @{
		    		            ComputerName = $Computer
                                PID = $procId
		    		            ProcessName = $procName
		    		            Protocol = $proto
		    		            LocalAddress = $localAddress
		    		            LocalPort = $localPort
		    		            RemoteAddress =$remoteAddress
		    		            RemotePort = $remotePort
		    		            State = $status
		    	            } | Select-Object -Property $properties								

                        #Increment the progress counter
                            $count++
                    }
                }
        }
    }
} 

function UnloadNetStatDB # Wubba Lubba Dub Dub
{
    # Create / Update NetStat Record(s)
    $Global:netstatDB| Export-Clixml C:\Scripts\netstat.clixml
}
#///////////////////////////////////////////////////////////////////////////#

#############################################################
###     BASELINE SOFTWARE INVENTORY RELATED OPERATIONS                #
#############################################################
function StartBaseLineInstalledFromScratch # 
{
    New-BaselineInstalledLog
    $Global:BaselineInstalledDB | Export-Clixml C:\Scripts\baselineInstalled.clixml
    write-host "Created New File"
}

function New-BaselineInstalledLog # 
{
    #$InstalledSoftwareRegKey = "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall"
    #$reg = [Microsoft.Win32.Registrykey]::OpenRemoteBaseKey('LocalMachine', $env:COMPUTERNAME)
    #$regkey = $reg.OpenSubKey($InstalledSoftwareRegKey)
    #$subkeys = $regkey.GetSubKeyNames()
    $InstallList = get-wmiobject -query "SELECT * FROM Win32_Product" -computername $env:COMPUTERNAME | 
        sort-object Vendor | select-object PSComputerName,Vendor,Name,Version,Caption,Description,InstallDate,InstallLocation,InstallSource,PackageName
    # Create Hashtable / Change Field Names
    $EntryTime = @{(Get-Date) = $InstallList}
    $reportObj = $EntryTime.Keys | select @{l="DTG";e={$_}},@{l="SoftwareInventory";e={$EntryTime.$_}}
    $Global:BaselineInstalledDB += $reportObj
}

function BaselineInstalledLog #
{
    LoadBaselineInstalledDB
    New-BaselineInstalledLog
    UnloadBaselineInstalledDB
    # ????
    # Profit
}

function UnloadBaselineInstalledDB # 
{
    # Create / Update NetStat Record(s)
    $Global:BaselineInstalledDB| Export-Clixml C:\Scripts\baselineInstalled.clixml
}
#///////////////////////////////////////////////////////////////////////////#

#############################################################
###     LAST 24 HOUR FILE MODIFICATIONS RELATED OPERATIONS             #
#############################################################
function Last24HourFileWrites($yesterday)
{
    $source="c:\" #location of starting directory
    $files=@("*.*")
    Start-Job -Name "LookForMegaSeeds" -ScriptBlock { 
        $filecheck = Get-ChildItem -recurse ($source) -include ($files) -File | Where-Object {$_.PSParentPath -notlike "*Program Files*" -and $_.PSParentPath -notlike "*Windows*"}
        $filecheck | Export-Clixml C:\Scripts\Last24FileWrites.clixml
    }
}
#///////////////////////////////////////////////////////////////////////////#

#############################################################
###     LAST 24 HOUR FILE MODIFICATIONS RELATED OPERATIONS             #
#############################################################
function Show-InteractiveLogonsIDs() #  Show-InteractiveLogonsIDs | % {Get-UserByLogonID($_)}
{
    Param(
    [Parameter(    
    ValueFromPipeline=$True,
    ValueFromPipelineByPropertyName = $True)]
    [string]$ComputerName=$env:COMPUTERNAME)

    $interactiveSessionIDs = (gwmi -ComputerName $ComputerName -Namespace "root\cimv2" -Query "SELECT LogonId FROM Win32_logonSession WHERE LogonType = 2").logonId

    return $interactiveSessionIDs
}

function Get-UserByLogonID($ID) # Get-UserByLogonID("24482400")
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
#///////////////////////////////////////////////////////////////////////////#

#############################################################
###     LAST 24 HOUR FILE MODIFICATIONS RELATED OPERATIONS             #
#############################################################
function ResourceLog
{
    # Not implemented yet
    continue
}
#///////////////////////////////////////////////////////////////////////////#

function Get-Schwifty # Obviously What you're here for..... I'm Mr. Bulldog
{
    # Setup Global DB objects       $Global:DB     $global:LocalProcsDB
    Begin
    {
        DoFirst
        LoadDBFile
    }

    Process
    {
       NetStatLog
       BaselineInstalledLog
       Last24HourFileWrites($yesterday)
    }

    End
    {
        ModifyDB # Update Object Properties
        UnloadDB # Write DB File to Disk
        UploadDB # Upload to FileShare for analysis
    }
}


Get-Schwifty