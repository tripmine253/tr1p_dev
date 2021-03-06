$Unpin_Names = @("Mail","Weather","Calendar","Photos","Cortana","Phone Companion","Groove Music","Xbox","Movies & TV","Microsoft Solitaire Collection","Money","Get Office","OneNote","News","Skype Video")
ForEach ($name in $Unpin_Names) {    
    $obj = (New-Object -Com Shell.Application).Namespace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | ? {$_.Name -eq $Name}
    if( $obj -ne $null ){
        ($obj).Verbs() | ? {$_.Name.Replace('&','') -match "Unpin from Start"} | %{$_.DoIt()}
    }
}

$Unpin_Names = @("Store","Microsoft Edge")
ForEach ($name in $Unpin_Names) {    
    $obj = (New-Object -Com Shell.Application).Namespace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | ? {$_.Name -eq $Name}
    if( $obj -ne $null ){
        ($obj).Verbs() | ? {$_.Name.Replace('&','') -like "*Unpin*"} | %{$_.DoIt()}
    }
}

#'$Unpin_Names = @("OneDrive")
#ForEach ($name in $Unpin_Names) {
#    ((New-Object -Com Shell.Application).Namespace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | ? {$_.Name -eq $Name}).Verbs() | ? {$_.Name.Replace('&','') -like "*Uninstall*"} | %{$_.DoIt()}
#}

$regPath = "HKLM:\Software\Policies\Microsoft\Windows\CloudContent"

If (!(Test-Path $regPath)) {
    New-Item $regPath -Force
}

New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\CloudContent" -Name "DisableWindowsConsumerFeatures" -PropertyType DWORD -Value 1 -Force

# Commented out packages were blocked from removal by the operating system
#$AppPackagesToRemove = @("BioEnrollment","CloudExperienceHost","Cortana","immersivecontrolpanel","MicrosoftEdge","XboxGameCallableUI","XboxIdentityProvider","ContentDeliveryManager","ContactSupport","MiracastView","PurchaseDialog")
$AppPackagesToRemove = @("BingNews","BingWeather","Getstarted","BingFinanace","XboxApp","WindowsCamera","WindowsStore","ZuneMusic","Photos","SkypeApp","ZuneVideo","WindowsPhone","WindowsMap","Office.Sway","Office.OneNote","MicrosoftOfficeHub","MicrosoftSolitaireCollection","ConnectivityStore","BingSports","3DBuilder")
ForEach ($App in $AppPackagesToRemove) {
    Get-AppxPackage | ? {$_.Name -like "*$App*"} | Remove-AppxPackage
}

$regPath = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System"

New-ItemProperty -Path $regPath -Name "EnableFirstLogonAnimation" -Value 0 -PropertyType DWord -Force

# Disanle Windows 10 Fast User Switching (added 2017-07-27 for TFS bug #8326
<#
New-ItemProperty -Path $regPath -Name "HideFastUserSwitching" -Value 1 -PropertyType DWord -Force

$regPath = "HKLM:\Software\Policies\Microsoft\WindowsStore"

If (!(Test-Path $regPath)) {
    New-Item $regPath
}

New-ItemProperty -Path $regPath -Name "DisableStoreApps" -Value 1 -PropertyType DWord -Force
New-ItemProperty -Path $regPath -Name "RemoveWindowsStore" -Value 1 -PropertyType DWord -Force

$regPath = "HKLM:\Software\Policies\Microsoft\Windows\CredentialsDelegation"

If (!(Test-Path $regPath)) {
    New-Item $regPath
}

New-ItemProperty -Path $regPath -Name "AllowDefaultCredentials" -Value 1 -PropertyType DWord -Force
New-ItemProperty -Path $regPath -Name "ConcatenateDefaults_AllowDefault" -Value 1 -PropertyType DWord -Force

$regPath = "HKLM:\System\CurrentControlSet\Control\Session Manager\Power"

If (!(Test-Path $regPath)) {
    New-Item $regPath
}

New-ItemProperty -Path $regPath -Name "HiberbootEnabled" -Value 0 -PropertyType DWord -Force

$regPath = "HKLM:\Software\Policies\Microsoft\Windows\CredentialsDelegation\AllowDefaultCredentials"

If (!(Test-Path $regPath)) {
    New-Item $regPath
}
#>