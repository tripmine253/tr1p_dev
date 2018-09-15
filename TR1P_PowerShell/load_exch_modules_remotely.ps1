
function LoadExchMods
{
    $creds = Get-Credential
    $ExchangeSession = New-PSSession -ConnectionUri http://exchsite/PowerShell -ConfigurationName Microsoft.Exchange -Authentication Kerberos -Credential $creds -ErrorAction Continue
    Import-PSSession $ExchangeSession -AllowClobber -ErrorAction Continue
}