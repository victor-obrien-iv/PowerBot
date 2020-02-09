function AutoArena {
    try {
        TapNPCChallenge
        TapArenaHell
        ArenaLoop -npc
        TapOpponents
        Wait 2

        while ($true) {
            ArenaLoop

            if (TapButton $ArenaRefreshImage -noRetry) {
                TapButton $SecretShopConfirmImage
            }
            else {
                Write-Host "Unknow arena state, retrying"
                NavigateTo Arena
                Wait
                AutoArena
            }
        }
    }
    catch [System.AggregateException] {
        # out of flags
        Write-Host $PSItem.Exception.Message
        # TODO buy flags from the shop
    }

    AndroidBack
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
            if (!$npc -or $scrolledDown) {
                # not in the npc menu or, 
                # we're at the bottom of the list and no fights
                return
            }
            else {
                # scroll down and look for fights
                MoveMouseInRange 0.64 0.77 0.54 0.75
                ScrollDown 3
                $scrolledDown = $true
                Wait 3
            }
            
        }
        else {
            Write-Host "Fight found"
            Fight @psBoundParameters
            $scrolledDown = $false
        }
    }
}

function Fight {
    param (
        [switch]$npc
    )

    MoveMouseTo 0.5 0.5
    WaitForImage $ArenaStartImage
    Write-Host "Fight start"
    TapArenaStart
    Wait

    $outOfFlag = FindButton $InsufficientFlagImage -noRetry

    if ($outOfFlag) {
        throw [System.AggregateException] "Out of flags!"
    }
    else {
        Write-Host "Sufficient flags"
    }

    if ($npc) {
        WaitForImage $ArenaDialogueImage
        TapScreen
    }
    else {
        WaitForImage $ArenaIgnitionImage
    }

    TapAuto

    if ($npc) {
        WaitForImage $ArenaDialogueImage
        TapScreen
        Wait 3
        TapConfirm
    }
    else {
        TapButton $ArenaConfirmImage
    }

    Wait 3
}
