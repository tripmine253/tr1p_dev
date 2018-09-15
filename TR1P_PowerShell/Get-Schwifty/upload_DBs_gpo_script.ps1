$morty = Import-Clixml C:\Scripts\morty.clixml
Remove-Item C:\Scripts\morty.clixml
$SharePath = "\\sharedrive\g6\IA\DataMiner"
New-PSDrive -Name DataMiner -PSProvider FileSystem -Root $SharePath -Description "I Drop Shit Here"
do { sleep -Seconds 1}
while (!(Test-path -Path DataMiner:\ -IsValid))


function UploadDB # Archive the local database at the Citadel of Ricks
{
    $destFileName = $env:COMPUTERNAME + "_Cronenberged" + ".clixml"    
    cd DataMiner:\MegaSeeds
    Copy-Item -Path C:\Scripts\RickC137_db.clixml -Destination .\$destFileName -Force
    
    if(($BanHammer).Count -gt 0)
    {
        cd DataMiner:\TheSnitch\
        Copy-Item -Path C:\Scripts\*snitched* -Destination .\ -Force
        Remove-PSDrive DataMiner
    }

}

UploadDB # Upload to FileShare for analysis