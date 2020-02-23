function AutoArena {
    $retry = $false
    $gotFlags = $false

    try {
        Wait 2
        TapNPCChallenge
        TapArenaHell
        ArenaLoop -npc
        TapOpponents
        Wait 2

        while ($true) {
            ArenaLoop
            Wait

            if (TapButton $Global:Images.ArenaRefresh -noRetry) {
                TapButton $Global:Images.BlueConfirm
                Wait 2
            }
            else {
                if (!$retry) {
                    $retry = $true
                    Write-Host "Unknow arena state, retrying"
                    NavigateTo Arena
                    Wait
                    AutoArena
                }
                else {
                    break;
                }
            }
        }
    }
    catch [System.AggregateException] {
        # out of flags
        Write-Host $PSItem.Exception.Message

        if (!$gotFlags) {
            TapButton $Global:Images.GreenConfirm
            Wait 2

            $gotFlags = BuyArenaFlags
            if ($gotFlags) {
                Write-Host "Got flags, restarting auto arena"
                NavigateTo Arena
                AutoArena
            }
        }
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
        $foundFight = TapButton $Global:Images.ArenaFight-noRetry

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
            # TODO check for bonus flag and arena promo/demotion 
            $scrolledDown = $false
        }
    }
}

function Fight {
    param (
        [switch]$npc
    )

    MoveMouseTo 0.5 0.5
    WaitForImage $Global:Images.ArenaStart
    TapArenaStart
    Wait

    $outOfFlag = FindButton $Global:Images.GreenConfirm -noRetry

    if ($outOfFlag) {
        throw [System.AggregateException] "Out of flags!"
    }
    else {
        Write-Host "Sufficient flags"
    }

    if ($npc) {
        WaitForImage $Global:Images.ArenaDialogue
        TapScreen
    }
    else {
        WaitForImage $Global:Images.ArenaIgnition
    }

    TapAuto

    if ($npc) {
        WaitForImage $Global:Images.ArenaDialogue
        TapScreen
        Wait 3
        TapConfirm
    }
    else {
        TapButton $Global:Images.GreenConfirm
        Wait
        TapButton $Global:Images.GreenConfirm -noRetry # league promotion 
    }

    Wait 3
}
