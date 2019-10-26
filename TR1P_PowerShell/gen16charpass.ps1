# missing policy compliance handling, but not a bad example of the RNG API
param( 
[int] $len = 16,
[string] $chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_!@#$%^&*()_"
)
$bytes = new-object "System.Byte[]" $len
$rnd = new-object System.Security.Cryptography.RNGCryptoServiceProvider
$rnd.GetBytes($bytes)
$result = ""
for( $i=0; $i -lt $len; $i++ )
{
$result += $chars[ $bytes[$i] % $chars.Length ]    
}
$result
