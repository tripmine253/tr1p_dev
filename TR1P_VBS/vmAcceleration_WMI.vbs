'Enable VMWare Hardware Acceleration if current platform is a Virtual Machine
Set objWMI = GetObject("winmgmts:")
Set colSettingComp = objWMI.ExecQuery("Select * from Win32_ComputerSystem")
For Each objComputer in colSettingComp
  strModel = Trim(LCase(objComputer.Model))
Next
If InStr(strModel, "VMware") <> 0 Then
  Set objRegistry=GetObject("winmgmts:\\" & strComputer & "\root\default:StdRegProv")
  strKeyPath = "SYSTEM\CurrentControlSet\Control\Video"
  objRegistry.EnumKey HKEY_LOCAL_MACHINE, strKeyPath, arrSubkeysVideoDevices
  For Each objSubkey In arrSubkeysVideoDevices
    subKeysExist = True
    strSubPath = strKeyPath & "\" & objSubkey
    Err.Clear
    val = WshShell.RegRead("HKLM\" & strSubPath & "\0000\Device Description")
    if Err = 0 Then
     if InStr(Trim(LCase(val)),Trim(LCase("VMware SVGA"))) <> 0 Then
       Err.Clear
       WshShell.RegWrite "HKLM\" & strSubPath & "\0000\Acceleration.Level", 0, "REG_DWORD"
	     End If
    End If
  Next
End If