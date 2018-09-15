$source = 'C:\Users\tr1p\Google Drive'
$destination = 'D:\Fudge\'
$baseDirFull = $source
$filelist = gci -path $basedirFull -Recurse | ? {$_.LastAccessTime -gt $((get-date).Adddays(-2))}

foreach ($item in $filelist)
{
    if ($item.PSIsContainer -eq $false)
    {
        $DestRelPath = $item.FullName.Replace("$baseDirFull\",'')
        $destFile =  "$destination" + "$DestRelPath"
        Write-Host $destFile
        ## create a blank file  and then overwrite it
        $null = New-Item -Path  "$DestFile" -Type File -Force
        Copy-Item -Path  $item.FullName -Destination "$DestFile" -Force
    }
}