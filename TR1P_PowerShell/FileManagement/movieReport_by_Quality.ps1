$SearchFolder = "D:\Movies\"
$DirCrawl = gci -Recurse $SearchFolder
$movieSearch = $DirCrawl | Where-Object {$_.Name -ilike "*.mp4" -or "*.avi" -or "*.mkv" -and !($_.Name -ilike "*.lnk")}
$objShell =  New-Object -ComObject Shell.Application
$MovieDirContainer = @()
$MovieMetaData = @()
foreach( $movieDir in $movieSearch)
{
    $MovieDirContainer += $movieDir.directoryName
}
foreach( $movieFolder in $MovieDirContainer)
{
    $objFolder = $objShell.NameSpace($movieFolder)
    $MovieFolderItems = $objFolder.Items()
    foreach ($file in $MovieFolderItems)
    {
        $CustObj = New-Object PSOBject -Property @{
                "Name" = $null;
                "HRes" = $null;
                "VRes" = $null;
                "Size" = $null;
                "Path" = $null;
                }
                $name = $objFolder.GetDetailsOf($file, 0)
        $CustObj.Name = $name
                $CustObj.Path = $movieFolder
                $hres = $objFolder.GetDetailsOf($file, 308)
        $CustObj.HRes = $hres
                $vres = $objFolder.GetDetailsOf($file, 306)
        $CustObj.VRes = $vres
                $size = $objFolder.GetDetailsOf($file, 1)
        $CustObj.Size = $size
        if ($CustObj.Name -ne $null)
        {
            $MovieMetaData += $CustObj
        }
    }
}
$MovieMetaData | export-csv .\Desktop\movieSearch.csv