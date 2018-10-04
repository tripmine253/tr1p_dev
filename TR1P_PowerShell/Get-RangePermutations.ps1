# MSG Gomez, Timothy D.
# 10-04-2018
# Permutation Tools



Function Get-StringPermutation {
    [cmdletbinding()]
    Param(
        [parameter(ValueFromPipeline=$True)]
        [string]$String = 'the'
    )
    Begin {
        Function New-Anagram { 
            Param([int]$NewSize)              
            If ($NewSize -eq 1) {
                return
            }
            For ($i=0;$i -lt $NewSize; $i++) { 
                New-Anagram  -NewSize ($NewSize - 1)
                If ($NewSize -eq 2) {
                    New-Object PSObject -Property @{
                        Permutation = $stringBuilder.ToString()                  
                    }
                }
                Move-Left -NewSize $NewSize
            }
        }
        Function Move-Left {
            Param([int]$NewSize)        
            $z = 0
            $position = ($Size - $NewSize)
            [char]$temp = $stringBuilder[$position]           
            For ($z=($position+1);$z -lt $Size; $z++) {
                $stringBuilder[($z-1)] = $stringBuilder[$z]               
            }
            $stringBuilder[($z-1)] = $temp
        }
    }
    Process {
        $size = $String.length
        $stringBuilder = New-Object System.Text.StringBuilder -ArgumentList $String
        New-Anagram -NewSize $Size
    }
    End {}
}
function Get-RangePermutations
{
    Param(
        [int]$start = 0,
        [int]$rangeLimit = 0)
        $set = $start..$n -join ''
    Get-StringPermutation -String $set
}