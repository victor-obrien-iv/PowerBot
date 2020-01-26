$WinHandle = Get-AU3WinHandle -Title $Emulator
$WinInfo = Get-AU3WinPos $WinHandle
$DefaultWaitTimeSec = 1

function Wait($sec, $randOff) {
    if(!$sec) {
        $sec = $DefaultWaitTimeSec
    }

    if(!$randOff) {
        $sec += Get-Random -Minimum 0.01 -Maximum 0.99
    }
    else {
        $sec += Get-Random -Minimum 0.01 -Maximum $randOff
    }

    Start-Sleep -Seconds $sec
}

function WinActivate {
    Show-AU3WinActivate -WinHandle $WinHandle | Out-Null
}

function Location%($xPercent, $yPercent) {
    $x = $WinInfo.X + $xPercent * $WinInfo.Width
    $y = $WinInfo.Y + $yPercent * $WinInfo.Height
    return @{X=$x; Y=$y}
}

function MoveMouseInRange($minX, $maxX, $minY, $maxY) {
    $xPercent = Get-Random -Minimum $minX -Maximum $maxX
    $yPercent = Get-Random -Minimum $minY -Maximum $maxY
    MoveMouseTo $xPercent $yPercent
}

function MoveMouseTo($xPercent, $yPercent) {
    $point = Location% $xPercent $yPercent
    $active? = Assert-AU3WinActive $Emulator
    
    if($active? -eq 0) {
        Pause "$Emulator is not the active window. Pausing"
        WinActivate
    }

    Move-AU3Mouse $point.X $point.Y | Out-Null
}

function TapInRange($minX, $maxX, $minY, $maxY) {
    MoveMouseInRange $minX $maxX $minY $maxY
    Wait
    Invoke-AU3MouseClick | Out-Null
}
    
function Tap($xPercent, $yPercent) {
    MoveMouseTo $xPercent $yPercent
    Wait
    Invoke-AU3MouseClick | Out-Null
}

function ScrollUp($numClicks) {
    if (!$numClicks) { $numClicks = 1 }
    Invoke-AU3MouseWheel -Direction "up" -NumClicks $numClicks
    "Scroll Up"
}

function ScrollDown($numClicks) {
    if (!$numClicks) { $numClicks = 1 }
    Invoke-AU3MouseWheel -Direction "down" -NumClicks $numClicks
    "Scroll Down"
}



function Get%MousePos {
    param([switch] $delay)

    if ($delay) { Wait 6 0 }
    
    $pos = Get-AU3MousePos
    $x = ($pos.X - $WinInfo.X) / $WinInfo.Width  
    $y = ($pos.Y - $WinInfo.Y) / $WinInfo.Height

    return @{X=$x; Y=$y}
}

function Pause {
    param (
        [String]$message,
        [Switch]$complete,
        [Switch]$alert
    )

    Write-Output $message
    if ($alert) { AlertBeep }
    if ($complete) { CompletionBeep }
    Read-Host -Prompt 'Paused. Press Enter to continue' | Out-Null
}

function InputUint16($message) {
    do {
        try {
            $num = $null
            [uint16]$num = Read-Host -Prompt $message
        } catch {}
    } while ($num -eq $null)

    return $num
}

function SetWindowSize {
    Move-AU3Win $WinHandle -X $WinInfo.X -Y $WinInfo.Y -Width 1555 -Height 905 | Out-Null
    $WinHandle = Get-AU3WinHandle -Title $Emulator
    $WinInfo = Get-AU3WinPos $WinHandle
}

function WaitForImage($img) {
    do {
        Wait
        $check1 = LocateOnScreen $img
        Wait
        $check2 = LocateOnScreen $img
        
    } until ($check1.Result -and $check2.Result)
}

function CompletionBeep {
    if ($Sound) {
        [console]::beep(900,300)
        [console]::beep(900,100)
        [console]::beep(1000,100)
        [console]::beep(1200,400)
    }
}

function AlertBeep {
    if ($Sound) {
        [console]::beep(500,400)
        [console]::beep(700,100)
        [console]::beep(1100,100)
        [console]::beep(700,100)
        [console]::beep(1100,100)
    }
}
