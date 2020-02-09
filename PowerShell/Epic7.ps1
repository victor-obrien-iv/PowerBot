. $PSScriptRoot\UserConf.ps1
. $PSScriptRoot\Window.ps1
. $PSScriptRoot\Buttons.ps1
. $PSScriptRoot\Nox.ps1
. $PSScriptRoot\RunPython.ps1
. $PSScriptRoot\Raid.ps1
. $PSScriptRoot\Arena.ps1
. $PSScriptRoot\Shop.ps1

# checkin
# supporters
# dispatch

function NavigateTo($loc) {
    WinActivate
    TapNavigationMenu
    function battle {
        TapInRange 0.8 0.88 0.75 0.87
    }

    function hunt {
        battle
        Wait
        TapInRange 0.425 0.73 0.79 0.94
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

    $loc
}

function AutoRun($maxRuns, $maxLeif) {
    if (!$maxRuns) { $maxRuns = 9999 }
    if (!$maxLeif) { $maxLeif = 0 }

    WinActivate

    $startTime = Get-Date

    for ($i=1; $i -le $maxRuns; $i++) {
        "Run $i :"

        TapStart
        Wait

        # check for insufficient energy
        $noEnergy? = LocateOnScreen $InsufficientEnergyImage

        if ($noEnergy?.Result) {
            if ($maxLeif -gt 0) {
                $maxLeif--
                "Buying energy, $maxLeif leifs left"
                TapBuy
                TapStart
                Wait
            }
            else {
                "Out of Leifs"
                AndroidBack
                Wait
                AndroidBack
                Wait
                AndroidBack
                Wait
                break
            }
        }

        # check for insufficient inventory
        $noInventory? = LocateOnScreen $InsufficientInventoryImage

        if ($noInventory?.Result) {
            Pause "Insufficient inventory, please make space."
            TapStart
        }

        "Running..."
        Wait $MinRunSec 30

        for ($j=1; ; $j++) {
            $done? = LocateOnScreen $StageClearImage

            if ($done?.Result) {
                "Stage Clear detected"
                $numRuns++
                Wait
                TapScreen
                Wait

                do {
                    $popup? = LocateOnScreen $FriendshipIncreaseImage

                    if ($popup?.Result) {
                        "Friendship increase popup"
                        TapScreen
                        Wait
                    }
                } until ($popup?.Result -eq $false)

                TapConfirm
                break
            }

            $failed? = LocateOnScreen $StageFailedImage

            if ($failed?.Result) {
                "Stage Failed, trying again."
                $i--
                break
            }

            Wait 5 5
        }
            
        if ($i -ne $maxRuns) {
            TapTryAgain
            Wait 7

            # check urgent mission TODO

            $selectSupporter? = LocateOnScreen $SelectSupporterImage

            if ($selectSupporter?.Result) {
                "Select supporter menu"
                TapSelectTeam
                Wait
            }
        }
    }

    $endTime = Get-Date
    $time = $endTime - $startTime
    $hours = $time.Hours
    $min = $time.Minutes + $hours * 60
    $sec = $time.Seconds
    $avgMin = [math]::Round($time.TotalMinutes / $numRuns, 2)

    "Completed $numRuns runs in $min minutes and $sec seconds"
    "Average run time was $avgMin minutes"
    
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

    "Welcome to PowerBot:Epic7!"
    $mainMenuActions -join "`n"

    do {
        $number = InputUint16 "Please enter a number 1 to $numActions"
    } until ($number -ge 1 -and $number -le $numActions)

    switch ($number) {
        1 {
            "Dragon hunt"
            $leifs = InputUint16 "Use how many leifs?"
            NavigateTo Dragon
            AutoRun -maxLeif $leifs }
        2 { 
            "Rock hunt"
            $leifs = InputUint16 "Use how many leifs?"
            NavigateTo Rock
            AutoRun -maxLeif $leifs }
        3 {
            "Ghost hunt"
            $leifs = InputUint16 "Use how many leifs?"
            NavigateTo Ghost
            AutoRun -maxLeif $leifs }
        4 {
            "Bug hunt"
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
            $options = @(
                "1. Raid 1/3 - Secretary Vera"
                "2. Raid 2/3 - Juleeve Council & Queen Azumashik"
                "3. Raid 3/3 - Executioner Karkanis & Devourer Arahakan"
                "4. Hell Raid 1/2 - Devourer Arahakan"
                "5. Hell Raid 2/2 - Executioner Karkanis"
            )
            $numOptions = $options.Length

            $options -join "`n"

            do {
                $number = InputUint16 "Please enter a number 1 to $numOptions"
            } until ($number -ge 1 -and $number -le $numOptions)

            WinActivate

            switch ($number) {
                1 {
                    RaidSecretary }
                2 {
                    #NavigateTo Raid
                    #Pause "Select team and press enter."
                    RaidCouncilQueen }
                3 {
                    #NavigateTo Raid
                    #Pause "Select team and press start."
                    RaidExecutionerDevourer }
                4 {
                    #NavigateTo HellRaid # TODO scroll down to hell raid
                    #Pause "Select team and press enter."
                    HellRaidDevourer }
                5 {
                    #NavigateTo HellRaid # TODO scroll down to hell raid
                    #Pause "Select team and press enter."
                    HellRaidExecutioner }
            }
        }
        8 {
            $maxSkystone = InputUint16 "Max amount of Skystone to spend?"
            $maxGold = InputUint32 "Max amount of gold to spend?"

            NavigateTo SecretShop
            RollSecretShop $maxSkystone $maxGold
        }
    }
}

MainMenu