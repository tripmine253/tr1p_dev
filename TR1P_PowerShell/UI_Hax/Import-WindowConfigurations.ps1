 #: Title       : AutoSize & Position Window Utility
#: Date Created: Wed Mar 6 22:20:00 EST 2013
#: Last Edit   : Thu Mar 28 16:43:00 EST 2013
#: Author      : "Tim Gomez" <timothy.d.gomez.mil@mail.mil>
#: Version     : 4.00
#: Description : Utility script created as a proof of concept IOT expedite a monitoring station's window layout
######################################################################


 
 Add-Type @"
  using System;
  using System.Runtime.InteropServices;
  public class Win32 {

    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool GetWindowRect(IntPtr hWnd, out RECT lpRect);

    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool GetClientRect(IntPtr hWnd, out RECT lpRect);

    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool MoveWindow(IntPtr hWnd, int X, int Y, int nWidth, int nHeight, bool bRepaint);
  }

  public struct RECT {
    public int Left;        // x position of upper-left corner
    public int Top;         // y position of upper-left corner
    public int Right;       // x position of lower-right corner
    public int Bottom;      // y position of lower-right corner
  }

"@





$Global:WinObjProp

function REPOP {
    
$Global:WinObjProp=ConvertFrom-PropertyString "$env:HOMEDRIVE$env:HOMEPATH\Desktop\autowin.ini" | Select-Object -Property ($args)

return $WinObjProp.$args
}

$programTitle=(REPOP WinTitle)
$oldXpos=(REPOP Xpos)
$oldYpos=(REPOP Ypos)
$oldWidth=(REPOP Width)
$oldHeight=(REPOP Height)

# Window Object RECT Created
$global:rcWindow = New-Object RECT


# Grabs window handle for target window
$h = (Get-Process | where {$_.MainWindowTitle -eq $programTitle}).MainWindowHandle

[Win32]::GetWindowRect($h,[ref]$rcWindow)


[Win32]::MoveWindow($h, $oldXpos , $oldYpos, $oldWidth, $oldHeight , $true )