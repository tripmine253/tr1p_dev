$DockProcessName = 'Tr1p_banner_app'
# made this a long time ago to sue the appbar api to reserve space on the screen to shove a custom class banner.
# totally viable to use for a .Net type "Conky" hud.
# nostalgia
Add-Type -Language CSharpVersion3 @"
using System;
using System.Runtime.InteropServices;

public static class WindowDockUtil
{

    #region Public Methods

    /// <summary>
    /// Docks the window to the top of the screen.
    /// </summary>
    /// <param name="hWnd">The window handle.</param>
    public static void Dock( IntPtr hWnd )
    {

        if ( hWnd == IntPtr.Zero ) {
            return;
        }   // if

        ulong windowLong = GetWindowLong( hWnd, GWL_STYLE );
        windowLong &= ~WS_BORDER;
        windowLong &= ~WS_CAPTION;
        windowLong &= ~WS_THICKFRAME;

        SetWindowLong( hWnd, GWL_STYLE, windowLong );

        var abd = new APPBARDATA( );
        abd.cbSize = Marshal.SizeOf( abd );
        abd.hWnd = hWnd;
        abd.uCallbackMessage = RegisterWindowMessage( "AppBarMessage" );

        // Create AppBar
        SHAppBarMessage( ABMsg.ABM_NEW, ref abd );

        // Get the Window's size
        RECT wc = new RECT( );
        if ( !GetWindowRect( hWnd, ref wc ) ) {
            return;
        }   // if

        int screenWidth = GetSystemMetrics( SM_CXSCREEN );
        int screenHeight = GetSystemMetrics( SM_CYSCREEN );
        int borderWidth = GetSystemMetrics( SM_CXSIZEFRAME );

        // Set the app bar to dock to the right
        abd.uEdge = ABEdge.ABE_TOP;
        
        abd.rc.left = 0;

        abd.rc.top = 0;
        
        abd.rc.bottom = 38;
        
        abd.rc.right = screenWidth;
        
        

        // Set AppBar Size
        SHAppBarMessage( ABMsg.ABM_SETPOS, ref abd );

        // Move Window to New Position
        MoveWindow( abd.hWnd, abd.rc.left, abd.rc.top, abd.rc.right - abd.rc.left, abd.rc.bottom - abd.rc.top, true );

    }

    ///// <summary>
    ///// Removes the window from the side of the screen.
    ///// </summary>
    ///// <param name="hWnd">The handle.</param>
    //public static void UndockWindow( IntPtr hWnd )
    //{

    //    if ( hWnd == IntPtr.Zero ) {
    //        return;
    //    }   // if

    //    var abd = new APPBARDATA( );
    //    abd.cbSize = Marshal.SizeOf( abd );
    //    abd.hWnd = hWnd;

    //    // Remove AppBar
    //    SHAppBarMessage( ABMsg.ABM_REMOVE, ref abd );

    //    // How should I store state between Dock and Undock?
    //    ulong windowLong = GetWindowLong( hWnd, GWL_STYLE );
    //    windowLong |= WS_BORDER;
    //    windowLong |= WS_CAPTION;

    //    SetWindowLong( hWnd, GWL_STYLE, windowLong );

    //}

    #endregion

    #region Interop

    #region AppBar

    [StructLayout( LayoutKind.Sequential )]
    private struct APPBARDATA
    {
        public int cbSize;
        public IntPtr hWnd;
        public int uCallbackMessage;
        public ABEdge uEdge;
        public RECT rc;
        public IntPtr lParam;
    }

    private enum ABMsg : int
    {
        ABM_NEW = 0,
        ABM_REMOVE = 1,
        ABM_QUERYPOS = 2,
        ABM_SETPOS = 3,
        ABM_GETSTATE = 4,
        ABM_GETTASKBARPOS = 5,
        ABM_ACTIVATE = 6,
        ABM_GETAUTOHIDEBAR = 7,
        ABM_SETAUTOHIDEBAR = 8,
        ABM_WINDOWPOSCHANGED = 9,
        ABM_SETSTATE = 10
    }

    private enum ABNotify : int
    {
        ABN_STATECHANGE = 0,
        ABN_POSCHANGED = 1,
        ABN_FULLSCREENAPP = 2,
        ABN_WINDOWARRANGE = 3
    }

    private enum ABEdge : int
    {
        ABE_LEFT = 0,
        ABE_TOP = 1,
        ABE_RIGHT = 2,
        ABE_BOTTOM = 3
    }

    [DllImport( "Shell32", CallingConvention = CallingConvention.StdCall )]
    private static extern uint SHAppBarMessage( ABMsg dwMessage, ref APPBARDATA pData );

    #endregion

    #region Window Management

    [DllImport( "User32" )]
    private static extern int RegisterWindowMessage( string msg );

    [DllImport( "User32" )]
    private static extern IntPtr FindWindow( string lpClassName, string lpWindowName );

    [DllImport( "User32" )]
    private static extern bool MoveWindow( IntPtr hWnd, int x, int y, int cx, int cy, bool repaint );

    [DllImport( "User32" )]
    private static extern bool GetWindowRect( IntPtr hWnd, ref RECT rect );

    [StructLayout( LayoutKind.Sequential )]
    private struct RECT
    {
        public int left;
        public int top;
        public int right;
        public int bottom;
    }

    [DllImport( "User32" )]
    private static extern int GetSystemMetrics( int Index );

    private const int SM_CXSCREEN = 0;
    private const int SM_CYSCREEN = 1;
    private const int SM_CXSIZEFRAME = 32;

    #endregion

    #region GetWindowLong/SetWindowLong

    [DllImport( "User32", EntryPoint = "SetWindowLongPtr" )]
    private static extern ulong SetWindowLong64( IntPtr hWnd, int nIndex, ulong dwNewLong );

    [DllImport( "User32", EntryPoint = "GetWindowLongPtr" )]
    private static extern ulong GetWindowLong64( IntPtr hWnd, int nIndex );

    [DllImport( "User32", EntryPoint = "SetWindowLong" )]
    private static extern uint SetWindowLong32( IntPtr hWnd, int nIndex, uint dwNewLong );

    [DllImport( "User32", EntryPoint = "SetWindowLong" )]
    private static extern uint GetWindowLong32( IntPtr hWnd, int nIndex );

    private const int GWL_WNDPROC =    ( -4 );
    private const int GWL_HINSTANCE =  ( -6 );
    private const int GWL_HWNDPARENT = ( -8 );
    private const int GWL_STYLE =      ( -16 );
    private const int GWL_EXSTYLE =    ( -20 );
    private const int GWL_USERDATA =   ( -21 );
    private const int GWL_ID =         ( -12 );

    private static ulong GetWindowLong( IntPtr hWnd, int nIndex )
    {
        if ( IntPtr.Size == 4 ) {
            return GetWindowLong32( hWnd, nIndex );
        }   // if
        else if ( IntPtr.Size == 8 ) {
            return GetWindowLong64( hWnd, nIndex );
        }   // else if
        else {
            throw new NotSupportedException( "Unsupported platform." );
        }   // else
    }

    private static ulong SetWindowLong( IntPtr hWnd, int nIndex, ulong dwNewLong )
    {
        if ( IntPtr.Size == 4 ) {
            return SetWindowLong32( hWnd, nIndex, (uint)dwNewLong );
        }   // if
        else if ( IntPtr.Size == 8 ) {
            return SetWindowLong64( hWnd, nIndex, dwNewLong );
        }   // else if
        else {
            throw new NotSupportedException( "Unsupported platform." );
        }   // else
    }

    #endregion

    #region Window Styles

    private const ulong WS_OVERLAPPED = 0x0000;
    private const ulong WS_POPUP = 0x80000000;
    private const ulong WS_CHILD = 0x40000000;
    private const ulong WS_MINIMIZE = 0x20000000;
    private const ulong WS_VISIBLE = 0x10000000;
    private const ulong WS_DISABLED = 0x8000000;
    private const ulong WS_CLIPSIBLINGS = 0x4000000;
    private const ulong WS_CLIPCHILDREN = 0x2000000;
    private const ulong WS_MAXIMIZE = 0x1000000;
    private const ulong WS_BORDER = 0x800000;
    private const ulong WS_DLGFRAME = 0x400000;
    private const ulong WS_VSCROLL = 0x200000;
    private const ulong WS_HSCROLL = 0x100000;
    private const ulong WS_SYSMENU = 0x80000;
    private const ulong WS_THICKFRAME = 0x40000;
    private const ulong WS_GROUP = 0x20000;
    private const ulong WS_TABSTOP = 0x10000;
    private const ulong WS_MINIMIZEBOX = 0x20000;
    private const ulong WS_MAXIMIZEBOX = 0x10000;
    private const ulong WS_CAPTION = WS_BORDER | WS_DLGFRAME;
    private const ulong WS_TILED = WS_OVERLAPPED;
    private const ulong WS_ICONIC = WS_MINIMIZE;
    private const ulong WS_SIZEBOX = WS_THICKFRAME;
    private const ulong WS_TILEDWINDOW = WS_OVERLAPPEDWINDOW;
    private const ulong WS_OVERLAPPEDWINDOW = WS_OVERLAPPED | WS_CAPTION | WS_SYSMENU | WS_THICKFRAME | WS_MINIMIZEBOX | WS_MAXIMIZEBOX;
    private const ulong WS_POPUPWINDOW = WS_POPUP | WS_BORDER | WS_SYSMENU;
    private const ulong WS_CHILDWINDOW = WS_CHILD;

    #endregion

    #endregion

}   // class
"@


if ($DockProcess = Get-Process $DockProcessName -ea 0) {
   [WindowDockUtil]::Dock($DockProcess.MainWindowHandle)
}
else {
    Write-Warning "Cannot find the $DockProcessName process."
}
