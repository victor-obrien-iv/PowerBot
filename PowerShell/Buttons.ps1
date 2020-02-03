function FindButton($img) {
    $loc = LocateOnScreen($img)
    
    if ($loc.Result) {
        $list = $loc.Output.Split([Environment]::NewLine)

        foreach ($line in $list) {
            if ($line -match "Box") {
                $nums = $line.Split(" ")
                $box = @{}
                $box["left"] = [int]($nums[0] -replace '\D+(\d+)\D+','$1')
                $box["top"] = [int]($nums[1] -replace '\D+(\d+)\D+','$1')
                $box["width"] = [int]($nums[2] -replace '\D+(\d+)\D+','$1')
                $box["height"] = [int]($nums[3] -replace '\D+(\d+)\D+','$1')

                return $box
            }
        }
    }
    else { return $null }
}

function TapButton {
    param (
        [string]$img,
        [switch]$noRetry
    )
    $box = FindButton $img

    if ($box) {
        [int]$minX = $box.left + ($box.width / 10)
        [int]$maxX = $box.left + $box.width - ($box.width / 10)
        [int]$minY = $box.top + ($box.height / 10)
        [int]$maxY = $box.top + $box.height - ($box.height / 10)
        $x = Get-Random -Minimum $minX -Maximum $maxX
        $y = Get-Random -Minimum $minY -Maximum $maxY
        
        Move-AU3Mouse $x $y | Out-Null
        Invoke-AU3MouseClick | Out-Null

        return $true
    }
    else {
        if (!$noRetry) {
            Wait 3
            return TapButton $img
        }
        else {
            return $false
        }
    }
}

function TapConfirm {
    TapInRange 0.85 0.97 0.89 0.95
    "Confirm"
}

function TapPopupConfirm {
    TapInRange 0.505 0.65 0.65 0.705
    "Popup confirm"
}

function TapTryAgain {
    TapInRange 0.85 0.97 0.89 0.95
    "Try again"
}

function TapSelectTeam {
    TapInRange 0.795 0.975 0.885 0.95
    "Select Team"
}

function TapStart {
    TapInRange 0.74 0.97 0.89 0.95
    "Start"
}

function TapBuy {
    TapInRange 0.47 0.66 0.69 0.75
    "Buy"
}

function LobbyWakeScreen {
    # avoid any buttons and the pop-up ad
    TapInRange 0.82 0.985 0.4 0.79
    "Wake Screen, Lobby"
}

function TapScreen {
    TapInRange 0.4 0.6 0.4 0.6
    "Dismiss popup"
}

function TapOpponents {
    TapInRange 0.8 0.98 0.14 0.24
    "Arena -> Opponents"
}

function TapNPCChallenge {
    TapInRange 0.8 0.98 0.28 0.36
    "Arena -> NPC Challenge"
}

function TapArenaHell {
    TapInRange 0.69 0.75 0.175 0.205
    "Arena -> NPC Challenge -> Hell"
}

function TapNavigationMenu {
    TapInRange 0.955 0.98 0.06 0.1 # tap the navigation menu
    "Open menu"
}

function TapCamp {
    TapInRange 0.105 0.135 0.905 0.96
    "Camp"
}

function TapFrontSpeechBubble {
    TapInRange 0.3 0.325 0.535 0.57
    "Front position character speech bubble"
}

function TapBackSpeechBubble {
    TapInRange 0.67 0.7 0.685 0.71
    "Back position character speech bubble"
}

function TapTopSpeechBubble {
    TapInRange 0.255 0.28 0.68 0.715
    "Top position character speech bubble"
}

function TapBotSpeechBubble {
    TapInRange 0.64 0.665 0.565 0.595
    "Bottom position character speech bubble"
}

function TapDialogue1 {
    TapInRange 0.565 0.91 0.35 0.425
    "Dialogue 1"
}

function TapDialogue2 {
    TapInRange 0.565 0.91 0.475 0.55
    "Dialogue 2"
}

function TapNorth {
    TapInRange 0.08 0.11 0.34 0.4
    "North"
}

function TapSouth {
    TapInRange 0.88 0.915 0.685 0.75
    "South"
}

function TapEast {
    TapInRange 0.88 0.915 0.34 0.4
    "East"
}

function TapWest {
    TapInRange 0.08 0.11 0.685 0.75
    "West"
}

function TapSecretShop {
    TapInRange 0.42 0.47 0.21 0.33
    "Open secret shop"
}

function TapRefresh {
    TapInRange 0.0605 0.28 0.89 0.945
    "Refresh secret shop"
}

function TapRefreshConfirm {
    TapInRange 0.51 0.65 0.6 0.645
    "Confirm refresh"
}

function TapArenaStart {
    TapInRange 0.585 0.76 0.89 0.95
    "Arena start"
}

function TapPvEArena {
    TapInRange 0.16 0.81 0.26 0.52
    "PvE Arena"
}

function TapAuto {
    TapInRange 0.865 0.89 0.055 0.1
    "Toggle auto"
}