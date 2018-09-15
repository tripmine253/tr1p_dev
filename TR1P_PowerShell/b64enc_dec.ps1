function b64enc {
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true,
                   Position=0)]
        $Input)
$bytes = [System.Text.Encoding]::Unicode.GetBytes($input)
$b64enc = [convert]::ToBase64String($bytes)
return $b64enc
}
function b64dec {
Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true,
                   Position=0)]
        $Input)
$b64dec = [convert]::FromBase64String($input)
$ascii = [System.Text.Encoding]::Unicode.GetChars($b64dec)
return $ascii.ToString()
}