# Reverses a string.
# Tim Gomez (TR1P)
# 9/16/18
function Reverse-It($1)
{
    $rev = ($1.ToCharArray())
    [array]::Reverse($rev)
    return $rev -join('')
}