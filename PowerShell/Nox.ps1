
function AndroidScreenShot {
    Send-AU3Key "^0" | Out-Null # ctrl + 0, take screen shot
}

function AndroidBack {
    # hotkey alt left
    Send-AU3Key "!{LEFT}" | Out-Null
}