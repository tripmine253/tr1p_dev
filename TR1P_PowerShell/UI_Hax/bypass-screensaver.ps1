$wsh = New-Object -ComObject WScript.Shell

function Start-OverRideScreenSaver {
    $wsh.SendKeys("{F15}")
}



while (1 -eq 1 ){
    Start-OverRideScreenSaver
    sleep 1
    Start-OverRideScreenSaver
    sleep 1
}