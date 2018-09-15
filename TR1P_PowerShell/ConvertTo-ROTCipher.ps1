function ConvertTo-ROTCipher
{
<#
.SYNOPSIS
Easy Mode Rot5,13,18,47 Encoder/Decoder
MSG Gomez, Timothy D. 1CD - Network Defense Manager
.DESCRIPTION
I needed a method of encoding/decoding these commond rotation ciphers.
.PARAMETER rot5
Switch to select ROT Cipher 5
Rot5 handles 0-9
.PARAMETER rot13
Switch to select ROT Cipher 13
Rot13 handles a-zA-Z
.PARAMETER rot18
Switch to select ROT Cipher 18
Rot18 is handles 0-9,a-z,A-Z
.PARAMETER rot47
Switch to select ROT Cipher 47
Rot47 is handles ASCII 32-126, leaves spaces as space (better idea?)
.PARAMETER rotString
The string which needs to be encoded or decode.
.EXAMPLE
PS > ConvertTo-ROTCipher -rot5 "12345"
67890
.EXAMPLE
ConvertTo-ROTCipher -rot13 "C3Po"
P3Cb
.EXAMPLE
PS > ConvertTo-ROTCipher -rot18 "OMG Get 4 Life TiMmy"
BZTTrg9YvsrGvZzl
.EXAMPLE
PS >  ConvertTo-ROTCipher -rot47 'get_schwifty !@i/\/h3rE'''
86E0D49H:7EJ Po:^-^9bCtV
.LINK
shiftedtoCAPS@gmail.com
https://bitbucket.org/tr1p/newschoolwarez.git
#>
	[CmdletBinding()] param(
		[Parameter(Mandatory = $False)]
		[switch]
        $rot47 = $False,
        [switch]
		$rot18 = $false,
		[switch]
		$rot13 = $false,
		[switch]
		$rot5 = $false,
		[string]
		$rotstring = $null
	)
    function rot47 ($rotstring)
    {
        $rotstring.ToCharArray() | ForEach-Object {
			if ((([int]$_ -ge 33) -and ([int]$_ -le 79)))
			{
				$string += [char]([int]$_ + 47);
			}
			elseif ((([int]$_ -ge 80) -and ([int]$_ -le 126)))
			{
				$string += [char]([int]$_ - 47);
			}
            elseif (([int]$_ -eq 32))
            {
                $string += [char]([int]$_ + 0);
            }
            else
            {
                write-host "Does not work, deal with it?"
            }
		}
		$string
    }
	function rot18 ($rotstring)
	{
		$rotstring.ToCharArray() | ForEach-Object {
			if ((([int]$_ -ge 97) -and ([int]$_ -le 109)) -or (([int]$_ -ge 65) -and ([int]$_ -le 77)))
			{
				$string += [char]([int]$_ + 13);
			}
			elseif ((([int]$_ -ge 110) -and ([int]$_ -le 122)) -or (([int]$_ -ge 78) -and ([int]$_ -le 90)))
			{
				$string += [char]([int]$_ - 13);
			}
			elseif (([int]$_ -ge 47) -and ([int]$_ -le 52))
			{
				$string += [char]([int]$_ + 5)
			}
			elseif (([int]$_ -ge 53) -and ([int]$_ -le 57))
			{
				$string += [char]([int]$_ - 5)
			}
		}
		$string
	}
	function rot13 ($rotstring)
	{
		$rotstring.ToCharArray() | ForEach-Object {
			if ((([int]$_ -ge 97) -and ([int]$_ -le 109)) -or (([int]$_ -ge 65) -and ([int]$_ -le 77)))
			{
				$string += [char]([int]$_ + 13);
			}
			elseif ((([int]$_ -ge 110) -and ([int]$_ -le 122)) -or (([int]$_ -ge 78) -and ([int]$_ -le 90)))
			{
				$string += [char]([int]$_ - 13);
			}
			else
			{
				$string += [char][int]$_
			}
		}
		$string
	}
	function rot5 ($rotstring)
	{
		$rotstring.ToCharArray() | ForEach-Object {
			if (([int]$_ -ge 47) -and ([int]$_ -le 52))
			{
				$string += [char]([int]$_ + 5)
			}
			elseif (([int]$_ -ge 53) -and ([int]$_ -le 57))
			{
				$string += [char]([int]$_ - 5)
			}
			else
			{
				$string += [char][int]$_
			}
		}
		$string
	}
	if ($rot47 -eq $true)
	{
		rot47 ($rotstring)
    }
	elseif ($rot18 -eq $true)
	{
		rot18 ($rotstring)
	}
	elseif ($rot13 -eq $true)
	{
		rot13 ($rotstring)
	}
	elseif ($rot5 -eq $true)
	{
		rot5 ($rotstring)
	}
	else
	{
		Get-Help ConvertTo-ROTCipher
	}
}

