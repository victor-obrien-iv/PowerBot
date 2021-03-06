﻿function AndroidScreenShot {
    Send-AU3Key "^0" | Out-Null # ctrl + 0, take screen shot
}

function AndroidBack {
    # hotkey alt left
    Send-AU3Key "!{LEFT}" | Out-Null
}

function LaunchEmulator {
    WinActivate
    if ($global:WinHandle -ne 0) {
        Send-AU3Key "!{F4}"| Out-Null # kill nox if it is already open
        Wait
    }

    Invoke-Item $EmulatorPath
    Write-Host "Loading Nox" -NoNewline
    
    do {
        Wait 1
        WinActivate
        Write-Host "." -NoNewline
    } until ($global:WinHandle -ne 0)

    Write-Host " Complete!"  
}

function LaunchEpic7 {
    Write-Host "Waiting for Epic 7 icon"
    TapImage $Global:Images.Epic7 | Out-Null
    Write-Host "Found, launching"
}