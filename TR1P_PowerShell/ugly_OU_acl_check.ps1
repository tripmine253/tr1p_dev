cd AD:\OU=PATH
$filePath = "$env:USERPROFILE\Desktop\acl.csv"
$record = @()
$ACLOBJ = (Get-Acl).access | select IdentityReference,ActiveDirectoryRights,AccessControlType,IsInherited
foreach ($item in $ACLOBJ)
{
    $inquiry = $item | select AccessControlType,IsInherited,IdentityReference,ActiveDirectoryRights
    $exp =  $inquiry | select -ExpandProperty ActiveDirectoryRights
    $recordLine = $inquiry,$exp.ActiveDirectoryRights 
    $record += $recordLine
    $recordLine | ConvertTo-Csv -NoTypeInformation | out-file $filePath -Encoding utf8 -Append
}
$record | ft -AutoSize