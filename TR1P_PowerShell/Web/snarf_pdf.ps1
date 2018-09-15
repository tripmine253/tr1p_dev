function aweful-downloader
{
    #fix this 
    # wow , I wrote shitty scripts back then...
    $storageDir="$null"
    $gankFile="$null"
    $userAgent = [Microsoft.PowerShell.Commands.PSUserAgent]::Chrome
    $webClient = New-Object System.Net.WebClient
    $newList='http://base.site.snarf'
    $results = Invoke-WebRequest "$newList" -UserAgent $userAgent
    $resultTemp += $results.ParsedHtml.links
    $urlString = $results.Links | Select-Object href | % {$newList + $_.href}
    $gankFile=@()
    $gankFile += $urlString | foreach {$pageData = Invoke-WebRequest "$_" -UserAgent $userAgent;$pageData.parsedhtml.links } `
      | select url,href | ? {($_.href -match "pdf") -or ($_.href -match "chm") -or ($_.href -match "zip") -or ($_.href -match "7z") `
      -or ($_.href -match "rar")} 
}