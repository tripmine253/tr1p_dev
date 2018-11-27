#: Title       : AutoSize & Position Window Utility
#: Date Created: Wed Mar 6 22:20:00 EST 2013
#: Last Edit   : Thu Jul 20 way passed my bedtime CST 2018
#: Author      : "Tim Gomez" <>
#: Version     : 2.0
#: Description : Utility script created as a proof of concept IOT expedite a monitoring station's window layout
#:               Got annoyed that a co-worker wasted so much time sizing and positioning every week when his box rebooted.
######################################################################
# Config
$SettingsPath = "$env:USERPROFILE\CustomWindowSettings\"
$FileName = "autowindow_settings.clixml"
$FullPath = $SettingsPath + $FileName
[switch]$FilePresent = (test-path -path $FullPath) -or (Test-Path  $SettingsPath)
$settings = @()
$settingsOBJ = $null
$settingObjProps = $null
$settingObjProps = @{
            "programName" = [string]$null; 
            "FilePath" = [string]$null;
            "ArgumentList" = [string]$null;
            'xPos' = [int]$null;
            'yPos' = [int]$null;
            'height' = [int]$null;
            'width' = [int]$null; 
}
switch($FilePresent){
    $false {
                Write-Host "using defaults"
                New-Item -ItemType Directory -Force -Path $SettingsPath
                testprogram
            }
    $true { $FileName = (($FileName -replace ".clixml","") + ("_" + (New-TemporaryFile).BaseName -replace "tmp","") + '.clixml');main}
}
#######################################################################
# Pretty useful for cheezy UI stuff - I'll eventually get around to building this around the right way.....
# Started this tool: Wed Mar 6 22:20:00 EST 2013
# Don't judge...
#######################################################################
function myDOTnetHAX
{
Add-Type @"
using System;
using System.Runtime.InteropServices;
    public class Win32
    {
        [DllImport("user32.dll")]              // https://www.pinvoke.net/default.aspx/user32.getwindowrect
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool GetWindowRect(IntPtr hWnd, out RECT lpRect);

        [DllImport("user32.dll")]             // https://www.pinvoke.net/default.aspx/user32/GetClientRect.html
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool GetClientRect(IntPtr hWnd, out RECT lpRect);

        [DllImport("user32.dll")]            //  https://www.pinvoke.net/default.aspx/user32/MoveWindow.html
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool MoveWindow(IntPtr hWnd, int X, int Y, int nWidth, int nHeight, bool bRepaint);
    }

    public struct RECT
    {
        public int Left;        // x position of upper-left corner
        public int Top;         // y position of upper-left corner
        public int Right;       // x position of lower-right corner
        public int Bottom;      // y position of lower-right corner
    }
    
    public class LogWindowInfo
        {
            public string programName;
            public string MainWindowHandle;
            public int xPos;
            public int yPos;
            public int height;
            public int width;
        }
"@
}
function Controlled-ProgramStart
{
    $procID = Start-Process @launchThis -PassThru 
    return $procID
}
function readyyet
{
    $caption = "Waiting on you..."
    $message = 'Is it where you want it capture "Size" + "Position"?'
    $choices = [System.Management.Automation.Host.ChoiceDescription[]] `
     @("&YES", "&NO")
    [int]$DefaultChoice = 1
    $choiceRTN = $host.ui.PromptForChoice($caption,$message, $choices,$defaultChoice)
    switch($choiceRTN)
     {
        0    { "YES" }
        1    { "NO"  }
     }
}

function Save-WindowSettings($processID)
{
    # Window Object RECT Created
    $global:rcWindow = New-Object RECT
    $settingsOBJ = New-Object -TypeName PSObject -Property $settingObjProps
    # Populate $rcWindow object with data 
    [Win32]::GetWindowRect($processID.mainwindowhandle,[ref]$rcWindow)
    # Capture individual coordinates 
    $settingsOBJ.xPos = $rcWindow.Left
    $settingsOBJ.yPos = $rcWindow.Top
    $settingsOBJ.height = ($rcWindow.Bottom - $rcWindow.Top)
    $settingsOBJ.width = ($rcWindow.Right - $rcWindow.Left)
    $settingsOBJ.programName = $processID.Name
    $settingsOBJ.FilePath = $processID.StartInfo.FileName
    $settingsOBJ.ArgumentList = $processID.StartInfo.Arguments
    return $settingsOBJ
}  

function testprogram
{
    # Test params
    $launchThis = @{}
    $launchThis.Add('FilePath',"C:\Windows\System32\notepad.exe")
    $ArgArray = @("$env:USERPROFILE\Desktop\sample.txt")
    $launchThis.Add('ArgumentList',$ArgArray)
    $processID = Controlled-ProgramStart
    Switch(readyyet){
    "YES" { Save-WindowSettings($processID)| Export-Clixml -Path $FullPath}
    "NO" {Write-Host "get it together"}
    }
}

function main
{
    testprogram
}
