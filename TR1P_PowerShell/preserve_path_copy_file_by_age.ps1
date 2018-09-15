$source = 'C:\Users\tr1p\Google Drive'
$destination = 'X:\Fudge\'
$baseDirFull = $source
#$baseDirName = ($basedirFull -split '\\')[-1]
#$baseDirDepth = $basedirFull.Split('\\').Count
$filelist = gci -path $basedirFull -Recurse | ? {$_.LastAccessTime -gt $((get-date).Adddays(-2))}

foreach ($item in $filelist)
{
    if ($item.PSIsContainer -eq $false)
    {
        $DestRelPath = $item.FullName.Replace("$baseDirFull\",'')
        $destFile =  $destination + $DestRelPath
        Write-Host $destFile
    }
}

<#
## create a blank file  and then overwrite it
$null = New-Item -Path  $DestFile -Type File -Force
Copy-Item -Path  $_.FullName -Destination $DestFile -Force
#>