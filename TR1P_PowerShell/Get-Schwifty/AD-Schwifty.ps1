#################################################################################
#  AD-Schwifty 1.0  --- MSG Gomez, Timothy D. "Network Defense Manager" 1CD G6  #
#################################################################################
#                                                                               #
#-------------------------------------------------------------------------------#
# Sets Recorded System Serials, Specs, Configuation in AD for the collected     #
# computer object. Useful for HD, asset management and Tenant Security Plan     #
# updates                                                                       #
#                                                                               #
# ###############################################################################
# # Yes, I know SCCM can do a lot of this, but it was not working when I made # # 
# # this                                                                      # #
# # Comments/Suggestions: timothy.d.gomez.mil@mail.mil                        # #
#################################################################################

cd C:\Scripts\MegaSeeds
function UpdateADProperties($i)
{
    $ComputerName = $i.ComputerName
    $NIC1_IPv4_Addy = $i.NIC1_IPV4
    $NIC1_MAC = $i.NIC1_MAC
    $CompSN = "SN:" + $i.ComputerSerial
    $HDD_1_SN = $i.HDD1_SN
    if ($HDD_2_SN -ne $null){$HDD_2_SN = $i.HDD2_SN.Replace(" ","")}
    $Location = $null
    switch ($NIC1_IPv4_Addy)
    {
        {$NIC1_IPv4_Addy -ilike "range.*" } {$Location = "SiteX Clients -- 0/24 DATA/VOICE VLAN 59/58"}                   # Notes 
        {$NIC1_IPv4_Addy -ilike "range.*"  } {$Location = "SiteX DCGS-A Clients -- 0/24 DATA VLAN 59" }                   # Notes 
        {$NIC1_IPv4_Addy -ilike "range.*"  } {$Location = "SiteX DCGS-A Clients -- 0/24 VOICE VLAN 58" }                  # Notes
        {$NIC1_IPv4_Addy -ilike "range.*"  } {$Location = "SiteX Clients -- 0/24 DATA VLAN 59" }                          # Notes
        {$NIC1_IPv4_Addy -ilike "range.*"  } {$Location = "SiteX Servers -- 0/24 DATA/VOICE VLAN 59/58" }                 # Notes
        {$NIC1_IPv4_Addy -ilike "range.*" } {$Location = "SiteX Clients -- 0/24 DATA VLAN 59" }                           # Notes
        {$NIC1_IPv4_Addy -ilike "range.*" } {$Location = "SiteX Clients -- 0/24 VOICE VLAN 58" }                          # Notes
        {$NIC1_IPv4_Addy -ilike "range.*" } {$Location = "SiteX (Bldg # ) --  0/24 DATA/VOICE VLAN 59/58" }               # Notes
        {$NIC1_IPv4_Addy -ilike "range.*" } {$Location = "SiteX Servers -- 0/24 DATA/VOICE VLAN 59/58" }                  # Notes
        {$NIC1_IPv4_Addy -ilike "range.*" } {$Location = "SiteX (Bldg #)  -- 0/24 DATA VLAN 59" }                         # Notes
        {$NIC1_IPv4_Addy -ilike "range.*" } {$Location = "SiteX DCGS-A / CPOF -- 0/24 DATA VLAN 59" }                     # Notes
        {$NIC1_IPv4_Addy -ilike "range.*" } {$Location = "SiteX NETOPS MGMT -- 128/25 VOICE VLAN 58" }                    # Notes
         default                                {$Location = "**** UNKNOWN ****";"***StrangerDanger***   " + $NIC1_IPv4_Addy | Out-File C:\Scripts\MegaSeeds\StrangerDanger.txt}
    }
    $Brand = $i.ComputerBrand
    $Model = $i.ComputerModel 
    $CompSN = "SN:" + $i.ComputerSerial
    $NIC1_IPv4_Addy = $i.NIC1_IPV4
    $NIC1_MAC = $i.NIC1_MAC
    $HDD_1_SN = "HDD_1_SN:" + $i.HDD1_SN
    if ($i.HDD2_SN -ne $null) {$HDD_2_SN = "HDD_2_SN:" + $i.HDD2_SN}

    $detailsString = $Brand.Replace(" ","") + ", " + $Model.Replace(" ","") + ", "  + $CompSN.Replace(" ","") +", " + $NIC1_IPv4_Addy + ", " + $NIC1_MAC + ", " + $HDD_1_SN.Replace(" ","")
    if ($ComputerName -ne $null)
    {
        Write-Host "Setting  " $ComputerName
        $ADComputerOBJ = (get-adcomputer -identity $ComputerName -Properties * -ErrorAction SilentlyContinue)
        $oldDescription =  $ADComputerOBJ.Description
        $ComputerName | Out-File .\log.txt -Encoding utf8 -Append
        $oldDescription | Out-File .\log.txt -Encoding utf8 -Append
        $newDescription = "$detailsString ###"
        $ADComputerOBJ.Description = $newDescription
        $ADComputerOBJ.Location = $Location
        return Set-ADComputer -Instance $ADComputerOBJ
    }
    else
    {
        continue
    }
}

foreach ($item in gci)
{
    $i = $null 
    try { $i = Import-Clixml $item }
    catch {sleep -Milliseconds 20 }
    UpdateADProperties($i)
}

#### Test Set
#$i = Import-Clixml c:\Scripts\MegaSeeds\S1CD3BCT82CP5_Cronenberged.clixml
#UpdateADProperties($i)