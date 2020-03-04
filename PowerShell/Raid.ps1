
function AutoRaid {
    $options = @(
        "1. Raid 1/3 - Secretary Vera"
        "2. Raid 2/3 - Juleeve Council & Queen Azumashik"
        "3. Raid 3/3 - Executioner Karkanis & Devourer Arahakan"
        "4. Hell Raid 1/2 - Devourer Arahakan"
        "5. Hell Raid 2/2 - Executioner Karkanis"
    )
    $numOptions = $options.Length

    $options -join "`n" | Write-Host

    do {
        $number = InputUint16 "Please enter a number 1 to $numOptions"
    } until ($number -ge 1 -and $number -le $numOptions)

    WinActivate

    $startTime = Get-Date
    function ready {
        do {
            $ready = DetectImage $Global:Images.ManageTeam 
        } until ($ready)

        Pause "Select team and press enter." -alert
        TapStart
        $startTime = Get-Date
    }

    switch ($number) { # TODO check that auto is on
        1 {
            # NavigateTo Raid
            # ready
            RaidSecretary }
        2 {
            # NavigateTo Raid
            # ready
            RaidCouncilQueen }
        3 {
            # NavigateTo Raid
            # ready
            RaidExecutionerDevourer }
        4 {
            # NavigateTo HellRaid
            # ready
            HellRaidDevourer }
        5 {
            # NavigateTo HellRaid
            # ready
            HellRaidExecutioner }
    }

    $endTime = Get-Date
    $time = $endTime - $startTime
    $hours = $time.Hours
    $min = $time.Minutes + $hours * 60
    $sec = $time.Seconds

    Write-Host "This raid run took $min minutes and $sec seconds."
}

function Camp {
    # MontInFrontCamp
    # MontIseriaCamp
    # KayronInBackCamp
    Pause "Camp" -alert 
}

function MontInFrontCamp {
    TapCamp
    TapPopupConfirm
    Wait 5
    TapFrontSpeechBubble
    TapDialogue1
    Wait 12
    TapScreen
    Wait 3
    TapScreen
    TapFrontSpeechBubble
    TapDialogue2
    Wait 12
    TapScreen
    Wait 3
    TapScreen
}

function KayronInBackCamp {
    TapCamp
    TapPopupConfirm
    Wait 5
    TapBackSpeechBubble
    TapDialogue1
    Wait 12
    TapScreen
    Wait 3
    TapScreen
    TapBackSpeechBubble
    TapDialogue2
    Wait 12
    TapScreen
    Wait 3
    TapScreen
}

function MontIseriaCamp {
    TapCamp
    TapPopupConfirm
    Wait 5
    TapBackSpeechBubble
    TapDialogue1
    Wait 12
    TapScreen
    Wait 3
    TapScreen
    TapDialogue1
    Wait 12
    TapScreen
    Wait 3
    TapScreen
}



function WaitForCrossroads($direction) {
    $img = switch ($direction) {
        'N' { "$ImageDir\North.png" }
        'S' { "$ImageDir\South.png" }
        'E' { "$ImageDir\East.png" }
        'W' { "$ImageDir\West.png" }
    }

    Write-Host "Waiting for crossroads ($direction)"

    WaitForImage $img

    Write-Host "At crossroads"
}

function MoveDirection {
    param(
        [Char]$direction,
        [Uint16]$numTimes,
        [Switch]$camp
    )

    WaitForCrossroads $direction

    if ($camp) {
        Write-Host "Camping" 
        Camp
        WaitForCrossroads $direction
    }

    $s = switch ($direction) {
        'N' { TapNorth }
        'S' { TapSouth }
        'E' { TapEast }
        'W' { TapWest }
    }

    #AndroidScreenShot

    MoveMouseTo 0.5 0.5

    Write-Host "Moving direction $s"

    if ($numTimes -gt 1) { MoveDirection $direction ($numTimes - 1) }
}

function RaidSecretary {
    TapStart
    MoveDirection 'W'
    MoveDirection 'S'
    MoveDirection 'W'
    MoveDirection 'S' -numTimes 2
    MoveDirection 'E' -camp
    WaitForCrossroads 'W'
    Pause "Please warp to the center waypoint and resume." -alert 
    MoveDirection 'E'
    MoveDirection 'S'
    MoveDirection 'E'
    MoveDirection 'S'
    MoveDirection 'E'
    #wait for fail screen
}

function RaidCouncilQueen {
    TapStart
    MoveDirection 'E'
    MoveDirection 'S'
    MoveDirection 'E'
    MoveDirection 'S'
    MoveDirection 'E'
    MoveDirection 'S'
    WaitForCrossroads 'N'
    Pause "Please warp to the center waypoint and resume." -alert 
    MoveDirection 'N' -camp
    MoveDirection 'E'
    MoveDirection 'N' -numTimes 2
    MoveDirection 'W'
    MoveDirection 'N'
    WaitForCrossroads 'S'
    CompletionBeep
    Wait
    Pause "Raid complete! Please warp to the center waypoint and use the Clear Portal to stop exploring." -complete
}

function RaidExecutionerDevourer {
    TapStart
    MoveDirection 'E' -numTimes 4
    MoveDirection 'N'
    MoveDirection 'E'
    WaitForCrossroads 'W'
    Pause "Please warp to the center waypoint and resume." -alert 
    MoveDirection 'W' -camp -numTimes 3
    MoveDirection 'N' -numTimes 3
    MoveDirection 'W'
    WaitForCrossroads 'E'
    CompletionBeep
    Wait
    Pause "Raid complete! Please warp to the center waypoint and use the Clear Portal to stop exploring." -complete 
}

function HellRaidDevourer {
    MoveDirection 'W' -numTimes 4
    MoveDirection 'E'
    MoveDirection 'N' -numTimes 2
    MoveDirection 'N' -camp
    WaitForCrossroads 'W'
    Pause "At Devourer Arahaken, press enter after defeating the boss." -alert
    # TODO press auto
    MoveDirection 'E' -numTimes 2
    MoveDirection 'S'
    WaitForCrossroads 'N'
    Pause "Please warp to the center waypoint and resume." -alert
    MoveDirection 'E'
    # wait for fail screen
}

function HellRaidExecutioner {
    MoveDirection 'E'-numTimes 2
    MoveDirection 'N'
    MoveDirection 'S'
    MoveDirection 'E' -numTimes 2
    MoveDirection 'N' -camp
    WaitForCrossroads 'E'
    Pause "At Executioner Karkanis, press enter after defeating the boss." -alert
    MoveDirection 'W'
    MoveDirection 'S'
    MoveDirection 'W'
    MoveDirection 'N'
    MoveDirection 'E'
    WaitForCrossroads 'W'
    Pause "Raid complete! Please warp to the center waypoint and use the Clear Portal to stop exploring." -complete
}

