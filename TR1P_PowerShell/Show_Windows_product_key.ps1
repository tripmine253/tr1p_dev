﻿# leaks legit productkey
<#
Computer     : .
Caption      : Microsoft Windows 10 Pro     
CSDVersion   :
OSArch       : 64-bit
BuildNumber  : 18362
RegisteredTo :
ProductID    : 00330-xxxxx-85215-xxxxx
ProductKey   : ?????-?????-7????-?????-H3TM5
#>
param ($targets = ".")
$hklm = 2147483650
$regPath = "Software\Microsoft\Windows NT\CurrentVersion"
$regValue = "DigitalProductId4"
Foreach ($target in $targets) {
    $productKey = $null
    $win32os = $null
    $wmi = [WMIClass]"\\$target\root\default:stdRegProv"
    $data = $wmi.GetBinaryValue($hklm,$regPath,$regValue)
    $binArray = ($data.uValue)[52..66]
    $charsArray = "B","C","D","E","F","G","H","J","K","M","P","Q","R","T","V","W","X","Y","2","3","4","5","6","7","8","9"
    ## decrypt base24 encoded binary data to characters. 
    For ($i = 24; $i -ge 0; $i--) {
        $k = 0
        For ($j = 14; $j -ge 0; $j--) {
            $k = $k * 256 -bxor $binArray[$j]
            $binArray[$j] = [math]::truncate($k / 24)
            $k = $k % 24
        }
        $productKey = $charsArray[$k] + $productKey
        If (($i % 5 -eq 0) -and ($i -ne 0)) {
            $productKey = "-" + $productKey
        }
    }
    $win32os = Get-WmiObject Win32_OperatingSystem -computer $target
    $obj = New-Object Object
    $obj | Add-Member Noteproperty Computer -value $target
    $obj | Add-Member Noteproperty Caption -value $win32os.Caption
    $obj | Add-Member Noteproperty CSDVersion -value $win32os.CSDVersion
    $obj | Add-Member Noteproperty OSArch -value $win32os.OSArchitecture
    $obj | Add-Member Noteproperty BuildNumber -value $win32os.BuildNumber
    $obj | Add-Member Noteproperty RegisteredTo -value $win32os.RegisteredUser
    $obj | Add-Member Noteproperty ProductID -value $win32os.SerialNumber
    $obj | Add-Member Noteproperty ProductKey -value $productkey
    $obj
}