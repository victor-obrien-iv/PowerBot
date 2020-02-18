
function RollSecretShop($maxSkyStone, $maxGold) {
    $markCost = 184000
    $medalCost = 280000
    $skyStone = $maxSkyStone
    $gold = $maxGold
    function find {
        Param(
        [Parameter(ParameterSetName='-medals',Mandatory=$false)][Switch]$medals,
        [Parameter(ParameterSetName='-marks',Mandatory=$false)][Switch]$marks
        )

        $img = if($medals) {
            $Global:Images.MysticMedals
        }
        else {
            $Global:Images.CovenantBookmarks
        }

        $box = FindButton $img

        if ($box) {
            buy $box
            Wait
            TapBuy

            return $true
        }
        else {
            return $false
        }
    }
    function buy ($box) {
        $leftPercent = 0.835
        $rightPercent = 0.965
        $left = (Location% $leftPercent 0).X
        $right = (Location% $rightPercent 0).X 
        $x = Get-Random -Minimum $left -Maximum $right
        $y = Get-Random -Minimum ($box.top + $box.height * 0.6) -Maximum ($box.top + $box.height)
    
        Move-AU3Mouse $x $y | Out-Null
        Invoke-AU3MouseClick | Out-Null
    }

    $medalsAcquired = 0
    $marksAcquired = 0

    while ($true) {
        Wait

        if (find -marks) {
            $gold -= $markCost
            $marksAcquired += 5
            Write-Host "Bought Mystic Medals!"
        }
        if (find -medals) {
            $gold -= $medalCost
            $medalsAcquired += 50
            Write-Host "Bought Covenant Bookmarks!"
        }

        MoveMouseInRange 0.52 0.82 0.165 0.73
        ScrollDown | Out-Null
        Wait

        
        if (find -marks) {
            $gold -= $markCost
            $marksAcquired += 5
            Write-Host "Bought Covenant Bookmarks!"
        }
        if (find -medals) {
            $gold -= $medalCost
            $medalsAcquired += 50
            Write-Host "Bought Mystic Medals!"
        }
        

        if ($gold -le $medalCost -or $skyStone -lt 3) { break }

        do {
            TapRefresh
            wait 0.4 0.25
            $confirmBox = FindButton $Global:Images.BlueConfirm
        } until ($null -ne $confirmBox)

        
        do {
            TapRefreshConfirm
            $confirmBox = FindButton $Global:Images.BlueConfirm
        } until ($null -eq $confirmBox)

        $skyStone -= 3
        Write-Host "$skyStone Skystone left"
    }

    $goldSpent = $maxGold - $gold
    $skystoneSpent = $maxSkyStone - $skyStone

    CompletionBeep
    Write-Host "Secret Shopping complete!"
    Write-Host "Spent $goldSpent gold and $skystoneSpent Skystones"
    Write-Host "Acquired $marksAcquired covenant bookmarks and $medalsAcquired mystic medals"
}

function BuyArenaFlags {
    # NavigateTo Shop
    # MoveMouseInRange 0.81 0.97 0.27 0.65
    # Wait 2
    # ScrollDown
    # Wait

    # $found = TapButton $Global:Images.ShopFriendship -noRetry
    # if (!$found) {
    #     Write-Host "Could not find friendship shop, retrying"
    #     BuyArenaFlags
    # }

    # TapInRange 0.67 0.79 0.61 0.65 # tap buy friendship energy
    TapInRange 0.67 0.79 0.79 0.84 # tab buy friendship flags

    $buy = TapButton $Global:Images.FriendshipBuy -noRetry
    if (!$buy) {
        Write-Host "No flags to buy"
        return $false
    }
    else {
        Write-Host "Purchased arena flags"
        return $true
    }
}
