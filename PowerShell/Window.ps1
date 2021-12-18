$global:WinHandle = Get-AU3WinHandle -Title $Emulator
$global:WinInfo = Get-AU3WinPos $global:WinHandle
$DefaultWaitTimeSec = 0.05

function Wait($sec, $randOff) {
    if(!$sec) {
        $sec = $DefaultWaitTimeSec
    }

    if(!$randOff) {
        $sec += Get-Random -Minimum 0.01 -Maximum 0.1
    }
    else {
        $sec += Get-Random -Minimum 0.01 -Maximum $randOff
    }

    Start-Sleep -Seconds $sec
}

function WinActivate {
    $global:WinHandle = Get-AU3WinHandle -Title $Emulator
    $global:WinInfo = Get-AU3WinPos $global:WinHandle
    Show-AU3WinActivate -WinHandle $global:WinHandle | Out-Null
}

function Location%($xPercent, $yPercent) {
    $x = $global:WinInfo.X + $xPercent * $global:WinInfo.Width
    $y = $global:WinInfo.Y + $yPercent * $global:WinInfo.Height
    return @{X=$x; Y=$y}
}

function MoveMouseInRange($minX, $maxX, $minY, $maxY) {
    $xPercent = Get-Random -Minimum $minX -Maximum $maxX
    $yPercent = Get-Random -Minimum $minY -Maximum $maxY
    MoveMouseTo $xPercent $yPercent
}

function MoveMouseTo($xPercent, $yPercent) {
    $active? = Assert-AU3WinActive $Emulator
    
    if($active? -eq 0) {
        Pause "$Emulator is not the active window. Pausing"
        WinActivate
    }

    $point = Location% $xPercent $yPercent
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
    Scroll "up" $numClicks
}

function ScrollDown($numClicks) {
    Scroll "down" $numClicks
}

function Scroll($direction, $numClicks) {
    if (!$numClicks) { $numClicks = 1 }

    for ($i = 0; $i -lt $numClicks; $i++) {
        Invoke-AU3MouseWheel -Direction $direction -NumClicks 1
        Wait 0.5 0.15
    }
    
    Write-Host "Scroll $direction"
}

function Get%MousePos {
    param([switch] $delay)

    if ($delay) { Wait 6 0 }
    
    $pos = Get-AU3MousePos
    $x = ($pos.X - $global:WinInfo.X) / $global:WinInfo.Width  
    $y = ($pos.Y - $global:WinInfo.Y) / $global:WinInfo.Height

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
    WinActivate
}

function InputUint16($message) {
    do {
        try {
            $num = $null
            [uint16]$num = Read-Host -Prompt $message
        } catch {}
    } while ($null -eq $num)

    return $num
}

function InputUint32($message) {
    do {
        try {
            $num = $null
            [uint32]$num = Read-Host -Prompt $message
        } catch {}
    } while ($null -eq $num)

    return $num
}

function SetWindowSize {
    Move-AU3Win $global:WinHandle -X $global:WinInfo.X -Y $global:WinInfo.Y -Width 1555 -Height 905 | Out-Null
    $global:WinHandle = Get-AU3WinHandle -Title $Emulator
    $global:WinInfo = Get-AU3WinPos $global:WinHandle
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
