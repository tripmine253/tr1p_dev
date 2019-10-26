$searchbase = "LDAP"
$users = Get-ADUser -SearchBase $searchbase -Filter *
$users | % {get-aduser $_.SamAccountName | Unlock-ADAccount }
