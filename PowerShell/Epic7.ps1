[CmdletBinding()]
param (
    [Parameter()]
    [switch]
    $ExternalControl
)

. $PSScriptRoot\UserConf.ps1
. $PSScriptRoot\Window.ps1
. $PSScriptRoot\Buttons.ps1
. $PSScriptRoot\Nox.ps1
. $PSScriptRoot\RunPython.ps1
. $PSScriptRoot\Raid.ps1
. $PSScriptRoot\Arena.ps1
. $PSScriptRoot\Shop.ps1
. $PSScriptRoot\Daily.ps1

# checkin
# supporters
# dispatch

function NavigateTo($loc) {
    WinActivate

    
    do {
        TapNavigationMenu
        Wait
        $NavMenuOpen = LocateOnScreen $NavigationMenuImage
    } until ($NavMenuOpen.Result)

    function battle {
        TapInRange 0.8 0.88 0.75 0.87
    }

    function hunt {
        battle
        Wait
        # TapInRange 0.425 0.73 0.79 0.94
        $foundHuntButton = TapButton $HuntImage -untilItDisappears

        if (!$foundHuntButton) { 
            Write-Host "Not in the battle menu? Retrying"
            NavigateTo $loc 
        }
    }

    function huntSelect11($x1, $x2, $y1, $y2) {
        hunt
        Wait
        TapInRange $x1 $x2 $y1 $y2
        Wait
        ScrollDown
        TapSelectTeam
        Wait 3
    }

    function labyrinth {
        battle
        Wait
        TapInRange 0.77 0.99 0.225 0.4
    }

    function raid {
        labyrinth
        Wait 2
        MoveMouseInRange 0.58 0.74 0.22 0.7
        ScrollDown
        Wait
        TapInRange 0.585 0.735 0.765 0.96
    }
    function lobby {
        TapInRange 0.825 0.91 0.92 0.97
    }

    switch ($loc) {
        SecretShop {
            lobby
            TapSecretShop
        }
        Hero { 
            TapInRange 0.9 0.98 0.15 0.265 }
        Shop { 
            TapInRange 0.7 0.78 0.3 0.4 }
        PetHouse { 
            TapInRange 0.8 0.88 0.3 0.4 }
        Guild { 
            TapInRange 0.8 0.88 0.45 0.555 }
        Reputation { 
            TapInRange 0.7 0.78 0.6 0.7 }
        Summon { 
            TapInRange 0.8 0.88 0.6 0.7 }
        Arena { 
            TapInRange 0.7 0.78 0.75 0.87 
            TapPvEArena
        }
        Battle { 
            battle }
        Adventure {
            TapInRange 0.9 0.98 0.75 0.87 }
        Sanctuary {
            TapInRange 0.7 0.8 0.92 0.97 }
        Lobby {
            lobby }
    
        SpiritAlter {
            battle
            Wait
            TapInRange 0.425 0.73 0.225 0.4
        }
        Abyss {
            battle
            Wait
            TapInRange 0.425 0.73 0.505 0.68
        }
        Hunt {
            hunt
        }
        Labyrinth {
            labyrinth }
        AutoTower { 
            battle
            Wait
            TapInRange 0.77 0.99 0.505 0.68
        }
        HallOfTrials {
            battle
            Wait
            TapInRange 0.77 0.99 0.79 0.96
        }

        Dragon {
            huntSelect11 0.58 0.735 0.25 0.47 }
        Rock {
            huntSelect11 0.58 0.735 0.52 0.74 }
        Ghost {
            huntSelect11 0.58 0.735 0.79 0.99 }
        Bug {
            huntSelect11 0.58 0.735 0.76 0.99 }

        Raid {
            raid 
            TapInRange 0.53 0.69 0.51 0.6 
            TapSelectTeam
        }
        HellRaid {
            raid 
            MoveMouseInRange 0.53 0.69 0.51 0.6
            ScrollDown
            TapSelectTeam
        }
    }

    Write-Host $loc
}

function AutoRun($maxRuns, $maxLeif) {
    if (!$maxRuns) { $maxRuns = 9999 }
    if (!$maxLeif) { $maxLeif = 0 }

    WinActivate

    $startTime = Get-Date

    for ($i=1; $i -le $maxRuns; $i++) {
        do {
            $selectSupporter = LocateOnScreen $SelectSupporterImage
            if ($selectSupporter.Result) {
                Write-Host "Select supporter menu"
                TapSelectTeam
                Wait
            }

            $ready = LocateOnScreen $ManageTeamImage
        } until ($ready.Result)

        Write-Host "Run $i :"

        TapStart
        Wait

        # check for insufficient energy
        $noEnergy = LocateOnScreen $InsufficientEnergyImage
        if ($noEnergy.Result) {
            if ($maxLeif -gt 0) {
                $maxLeif--
                Write-Host "Buying energy, $maxLeif leifs left"
                TapBuy
                TapStart
                Wait
            }
            else {
                Write-Host "Out of Leifs"
                AndroidBack
                Wait
                AndroidBack
                Wait
                AndroidBack
                Wait
                AndroidBack
                break
            }
        }

        # check for insufficient inventory
        $noInventory = LocateOnScreen $InsufficientInventoryImage
        if ($noInventory.Result) {
            Pause "Insufficient inventory, please make space."
            TapStart
        }

        # check if auto is turned on

        Write-Host "Running..."
        Wait $MinRunSec 30

        for ($j=1; ; $j++) {
            $done? = LocateOnScreen $StageClearImage

            if ($done?.Result) {
                Write-Host "Stage Clear detected"
                $numRuns++
                Wait
                TapScreen
                Wait

                do {
                    $popup? = LocateOnScreen $FriendshipIncreaseImage

                    if ($popup?.Result) {
                        Write-Host "Friendship increase popup"
                        TapScreen
                        Wait
                    }
                } until ($popup?.Result -eq $false)

                TapConfirm
                break
            }

            $failed? = LocateOnScreen $StageFailedImage

            if ($failed?.Result) {
                Write-Host "Stage Failed, trying again."
                $i--
                break
            }

            Wait 5 5
        }
            
        if ($i -ne $maxRuns) {
            TapTryAgain
            Wait 4

            # check urgent mission TODO
        }
    }

    $endTime = Get-Date
    $time = $endTime - $startTime
    $hours = $time.Hours
    $min = $time.Minutes + $hours * 60
    $sec = $time.Seconds
    $avgMin = [math]::Round($time.TotalMinutes / $numRuns, 2)

    Write-Host "Completed $numRuns runs in $min minutes and $sec seconds"
    Write-Host "Average run time was $avgMin minutes"
    
    AndroidBack
    Wait
    AndroidBack
}

$mainMenuActions = @(
    "1. Wyvern Hunt"
    "2. Golem Hunt"
    "3. Banshee Hunt"
    "4. Azimanak Hunt"
    "5. Auto Run"
    "6. Arena"
    "7. Labyrinth"
    "8. Secret Shop"
)
$numActions = $mainMenuActions.Length

function MainMenu($energy) {
    SetWindowSize

    Write-Host "Welcome to PowerBot:Epic7!"
    $mainMenuActions -join "`n" | Write-Host

    do {
        $number = InputUint16 "Please enter a number 1 to $numActions"
    } until ($number -ge 1 -and $number -le $numActions)

    switch ($number) {
        1 {
            Write-Host "Dragon hunt"
            $leifs = InputUint16 "Use how many leifs?"
            NavigateTo Dragon
            AutoRun -maxLeif $leifs }
        2 { 
            Write-Host "Rock hunt"
            $leifs = InputUint16 "Use how many leifs?"
            NavigateTo Rock
            AutoRun -maxLeif $leifs }
        3 {
            Write-Host "Ghost hunt"
            $leifs = InputUint16 "Use how many leifs?"
            NavigateTo Ghost
            AutoRun -maxLeif $leifs }
        4 {
            Write-Host "Bug hunt"
            $leifs = InputUint16 "How much energy?"
            NavigateTo Bug
            AutoRun -maxLeif $leifs }
        5 {
            $num = InputUint16 "How many times?"
            AutoRun -maxRuns $num }
        6 {
            NavigateTo Arena
            AutoArena }
        7 {
            AutoRaid }
        8 {
            $maxSkystone = InputUint16 "Max amount of Skystone to spend?"
            $maxGold = InputUint32 "Max amount of gold to spend?"

            NavigateTo SecretShop
            RollSecretShop $maxSkystone $maxGold
        }
    }
}

if (!$ExternalControl) {
    # pass control to the user
    MainMenu
}