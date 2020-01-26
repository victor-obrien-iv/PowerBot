function Camp {
    MontInFrontCamp
}

function MontInFrontCamp {
    TapCamp
    TapPopupConfirm
    Wait 5
    TapFrontSpeechBubble
    TapDialogue1
    Wait 10
    TapScreen
    Wait 3
    TapScreen
    TapFrontSpeechBubble
    TapDialogue2
    Wait 10
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

    "Waiting for crossroads ($direction)"

    WaitForImage $img

    "At crossroads"
}

function MoveDirection {
    param(
        [Char]$direction,
        [Uint16]$numTimes,
        [Switch]$camp
    )

    WaitForCrossroads $direction

    if ($camp) {
        "Camping" 
        Camp
        Wait 6
    }

    $s = switch ($direction) {
        'N' { TapNorth }
        'S' { TapSouth }
        'E' { TapEast }
        'W' { TapWest }
    }

    #AndroidScreenShot

    MoveMouseTo 0.5 0.5

    "Moving direction $s"

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
    Pause -alert "Please warp to the center waypoint and resume."
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
    Pause -alert "Please warp to the center waypoint and resume."
    MoveDirection 'N' -camp
    MoveDirection 'E'
    MoveDirection 'N' -numTimes 2
    MoveDirection 'W'
    MoveDirection 'N'
    WaitForCrossroads 'S'
    CompletionBeep
    Wait
    Pause -complete "Raid complete! Please warp to the center waypoint and use the Clear Portal to stop exploring."
}

function RaidExecutionerDevourer {
    TapStart
    MoveDirection 'E' -numTimes 4
    MoveDirection 'N'
    MoveDirection 'E'
    WaitForCrossroads 'W'
    Pause -alert "Please warp to the center waypoint and resume."
    MoveDirection 'W' -camp -numTimes 3
    MoveDirection 'N' -numTimes 3
    MoveDirection 'W'
    WaitForCrossroads 'E'
    CompletionBeep
    Wait
    Pause -complete "Raid complete! Please warp to the center waypoint and use the Clear Portal to stop exploring."
}

function HellRaidDevourer {
    MoveDirection 'W' -numTimes 4
    MoveDirection 'E'
    MoveDirection 'N' -numTimes 2
    MoveDirection 'N' -camp
    WaitForCrossroads 'W'
    Pause -alert "At Devourer Arahaken, press enter after defeating the boss."
    # TODO press auto
    MoveDirection 'E' -numTimes 2
    MoveDirection 'S'
    WaitForCrossroads 'N'
    Pause -alert "Please warp to the center waypoint and resume."
    MoveDirection 'W'
    #wait for fail screen
}

function HellRaidExecutioner {
    MoveDirection 'E'-numTimes 2
    MoveDirection 'N'
    MoveDirection 'S'
    MoveDirection 'E' -numTimes 2
    MoveDirection 'N' -camp
    WaitForCrossroads 'E'
    Pause -alert "At Executioner Karkanis, press enter after defeating the boss."
    MoveDirection 'W'
    MoveDirection 'S'
    MoveDirection 'W'
    MoveDirection 'N'
    MoveDirection 'E'
    WaitForCrossroads 'W'
    Pause -complete "Raid complete! Please warp to the center waypoint and use the Clear Portal to stop exploring."
}

