function Zip-Files(
        [Parameter(Position=0, Mandatory=$true, ValueFromPipeline=$false)]
        [string] $zipfilename,
        [Parameter(Position=1, Mandatory=$true, ValueFromPipeline=$false)]
        [string] $sourcedir,
        [Parameter(Position=2, Mandatory=$false, ValueFromPipeline=$false)]
        [bool] $overwrite)

{
   Add-Type -Assembly System.IO.Compression.FileSystem
   $compressionLevel = [System.IO.Compression.CompressionLevel]::Optimal

    if ($overwrite -eq $true )
    {
        if (Test-Path $zipfilename)
        {
            Remove-Item $zipfilename
        }
    }

    [System.IO.Compression.ZipFile]::CreateFromDirectory($sourcedir, $zipfilename, $compressionLevel, $false)
}

$folder = 'C:\Scripts\ZipMe'
$outfileName =  $env:computername + "_log.zip" 
$Destination = "C:\Scripts\" + $outfileName
Zip-Files -sourcedir $folder -zipfilename $outfileName 
