function AndroidScreenShot {
    Send-AU3Key "^0" | Out-Null # ctrl + 0, take screen shot
}

function AndroidBack {
    # hotkey alt left
    Send-AU3Key "!{LEFT}" | Out-Null
}

function LaunchEmulator {
    Invoke-Item $EmulatorPath
    
    do {
        Wait 1
        WinActivate
    } until ($WinHandle -ne 0)
    
    WaitForImage $Epic7Image
    TapButton $Epic7Image
}

function LaunchEpic7 {
    WaitForImage $Epic7Image
    TapButton $Epic7Image
}