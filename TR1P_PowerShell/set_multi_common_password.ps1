 #this is not advisable btw.
 $list_of_service_accounts = $env:userprofile + "\Desktop\change_service_account_pass_bulk.txt"
 $newPassword = Read-Host -AsSecureString -Prompt "Enter Policy Compliant Password"
 if (!(Test-Path $list_of_service_accounts)){
 pass
 }
 foreach($service_account in $(get-content -LiteralPath $list_of_service_accounts)){
    try {
        get-aduser $service_account | Set-ADAccountPassword -NewPassword $newPassword -reset 
    }
    catch {
        Write-Host $Error[1]
    }
}
 