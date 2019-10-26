# 
# Tr1p-SetADUserPassword
# 
# MSG Gomez, Timothy D.
# 1CD G6 CND
# 5 JAN 2019
# Pretty basic password reset script for AD
# USAGE: Tr1p-SetADUserPassword -FileName "PATH\FILE.TXT"

$upper = 2
$lower = 2
$special = 2
$numbers = 2
$required_Length =  15
$r = $(33..126)
$specialChars = @()
$(33..47) | % {$specialChars+=[char]$_}
$(58..64) | % {$specialChars+=[char]$_}

function new-random16charstring
{
    $thepass = @()
    do
    { 
        $thepass+= [char]$($r | get-random)
    }
    while ( $thepass.count -lt $required_Length)
    $is_correctLength = $thepass -join ''
    return $is_correctLength
}
function hasEnoughCharacters([string]$candidate)
{
    if ($candidate.Length -eq $required_Length)
    {
        return $true
    }
}

function hasEnoughSpecial([string]$candidate)
{
    
    $count = 0
    $candidate -split '' | %{if ($specialChars -contains $_){$count++}}
    if ($count -ge $special)
    {
        return $true
    }
    else
    {
        return $false
    }
}
function hasEnoughUpper([string]$candidate)
{
    
    $count = 0
    $candidate -split '' | %{if ($_ -cmatch "[A-Z]"){$count++}}
    if ($count -ge $upper)
    {
        return $true
    }
    else
    {
        return $false
    }
}

function hasEnoughLower([string]$candidate)
{
    
    $count = 0
    $candidate -split '' | %{if ($_ -cmatch "[a-z]"){$count++}}
    if ($count -ge $lower)
    {
        return $true
    }
    else
    {
        return $false
    }
}
function hasEnoughNumbers([string]$candidate)
{
    
    $count = 0
    $candidate -split '' | %{if ($_ -cmatch "[0-9]"){$count++}}
    if ($count -ge $numbers)
    {
        return $true
    }
    else
    {
        return $false
    }
}

function Tr1p-RandoValidPassword{
    do {
        $p = new-random16charstring
    }
    until((hasEnoughCharacters($p)) -and (hasEnoughLower($p)) -and (hasEnoughUpper($p)) -and (hasEnoughNumbers($p)) -and (hasEnoughSpecial($p))){
    }
    return $p | ConvertTo-SecureString -AsPlainText -Force
}

function Tr1p-SetADUserPassword
{
[CmdletBinding()]
    Param($FileName)
    $resetList = get-content $FileName
    $credentials = Get-Credential -Message "Enter credentials with sufficient privs"
    foreach ($user in $resetList)
    {
        write-host "Reset Password : " $user
        try {
		get-aduser -identity $user | set-adaccountpassword -newpassword (Tr1p-RandoValidPassword)[1] -reset
        }
        catch {}
        if ($? -ne 0) {write-host "$user does not exist or something else went wrong"}
    }
}