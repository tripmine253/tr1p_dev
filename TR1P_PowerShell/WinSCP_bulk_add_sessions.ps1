$PPKpath = "PATH/To/File"
$localStartPath = "PATH/To/File"
$remoteStartPath = "PATH/To/File"
$pathtoWinSCPini = "PATH/To/File"
$targetFile = "Path/To/File.csv"
$targets = gc $targetFile | ConvertFrom-Csv

function urlencoded($1)
{
    $Encode = [System.Web.HttpUtility]::UrlEncode($1) 
    return $Encode
}

foreach ($record in $targets)
{
    $newConfig = @()
    $sessionName = $record.SessionName
    $sessionIP = $record.SessionIP
    $sessionUser = $record.SessionUser
    $newConfig.Add("[Sessions\$sessionName]")
    $newConfig.Add("HostName=$sessionIP")
    $newConfig.Add("UserName=$sessionUser")
    $newConfig.Add("PublicKeyFile=$PPKpath")
    $newConfig.Add("LocalDirectory=" + "$(urlencoded($localStartPath))")
    $newConfig.Add("RemoteDirectory="+ "$(urlencoded($remoteStartPath))")
    $newConfig -join "\n" | Out-File $pathtoWinSCPini -Append
    "\n" | Out-File $pathtoWinSCPini -Append
}
