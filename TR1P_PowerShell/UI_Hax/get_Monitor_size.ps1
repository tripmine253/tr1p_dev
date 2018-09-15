function get-monitorSize 
{
    Add-Type -AssemblyName System.Windows.Forms
    $w = [System.Windows.Forms.Screen]::AllScreens.Get(0).Bounds.Width
    $h = [System.Windows.Forms.Screen]::AllScreens.Get(0).Bounds.Height
    $vals = @{'Width' = $w;'Height' = $h}
    return $vals
}