$site = "http://www.rickandmortytime.com/wiki/Quotes"
$raw_content = Invoke-WebRequest -Uri $site
$parsedQuotes = ($raw_content.AllElements | ? {$_.TagName -eq "p"}).outertext
foreach ($quote in $parsedQuotes)
{
    $quote
    write-host
}