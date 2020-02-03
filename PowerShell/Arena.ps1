function AutoArena {
    #TapPvEArena

    try {
        # throw [System.AggregateException] "ping"
        TapNPCChallenge
        TapArenaHell
        ArenaLoop -npc
        TapOpponents

        while ($true) {
            ArenaLoop
            # tap arena refresh 
        }
    }
    catch [System.AggregateException] {
        Write-Host $PSItem.Exception.Message
    }
}

function ArenaLoop {
    param (
        [switch]$npc
    )

    # detect defence win popup
    # TapScreen # dismiss defence result popup
    $scrolledDown = $false

    while ($true) {
        $foundFight = TapButton $ArenaFightImage -noRetry

        Wait

        if (!$foundFight) {
            if ($scrolledDown) {
                # we're at the bottom of the list and no fights
                return
            }
            else {
                # scroll down and look for fights
                MoveMouseInRange 0.64 0.77 0.54 0.75
                ScrollDown 5
                $scrolledDown = $true
                Wait
            }
            
        }
        else {
            if ($npc) {
                NPCFight
            }
            else {
                Fight
            }
        }
    }
}

function NPCFight {
    MoveMouseTo 0.5 0.5
    WaitForImage $ArenaStartImage
    Wait
    TapArenaStart

    $outOfFlag = FindButton $InsufficientFlagImage -noRetry

    if ($outOfFlag) {
        throw [System.AggregateException] "Out of flags!"
    }
    else {
        Write-Host "Sufficient flags"
    }
    
    WaitForImage $ArenaDialogueImage
    TapScreen
    TapAuto
    WaitForImage $ArenaDialogueImage
    TapScreen
    Wait 3
    TapConfirm
    Wait 3
}

function Fight {
    MoveMouseTo 0.5 0.5
    WaitForImage $ArenaStartImage
    TapArenaStart
    Wait

    $outOfFlag = FindButton $InsufficientFlagImage -noRetry

    if ($outOfFlag) {
        throw [System.AggregateException] "Out of flags!"
    }
    else {
        Write-Host "Sufficient flags"
    }

    WaitForImage $ArenaIgnitionImage
    TapAuto
    TapButton $ArenaConfirmImage
    Wait 3
}

