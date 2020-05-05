
# user paramerters (you need to set these)
$Emulator = "NoxPlayer"
$EmulatorPath = "D:\Program Files\Nox\bin\Nox.exe"
$Sound = $true

# the directory where bot finds detection images
$imageDir = "$PSScriptRoot\..\Images"

# these are the images the bot needs to detect game state
$Global:Images = @{
    ArenaDialogue = "$imageDir\ArenaDialogue.png"
    ArenaIgnition = "$imageDir\ArenaIgnition.png"
    ArenaFight = "$imageDir\ArenaFight.png"
    ArenaRefresh = "$imageDir\ArenaRefresh.png"
    ArenaStart = "$imageDir\ArenaStart.png"
    Auto = "$imageDir\Auto.png"
    BlueConfirm = "$imageDir\BlueConfirm.png"
    BrownConfirm = "$imageDir\BrownConfirm.png"
    ConquestBuy = "$imageDir\ConquestBuy.png"
    CovenantBookmarks = "$imageDir\Bookmarks.png"
    Checked = "$imageDir\Checked.png"
    DispatchTryAgain = "$imageDir\DispatchTryAgain.png"
    DontShowAgainToday = "$imageDir\DontShowAgainToday.png"
    Epic7 = "$imageDir\Epic7.png"
    FriendshipBuy = "$imageDir\FriendshipBuy.png"
    FriendshipIncrease = "$imageDir\FriendshipIncrease.png"
    FriendshipPoints = "$imageDir\FriendshipPoints.png"
    GreenConfirm = "$imageDir\GreenConfirm.png"
    Hunt = "$imageDir\Hunt.png"
    InsufficientEnergy = "$imageDir\InsufficientEnergy.png"
    InsufficientInventory = "$imageDir\InsufficientInventory.png"
    Lobby = "$imageDir\Lobby.png"
    ManageTeam = "$imageDir\ManageTeam.png"
    MysticMedals = "$imageDir\Medals.png"
    NavigationMenu = "$imageDir\NavigationMenu.png"
    RunComplete = "$imageDir\RunComplete.png"
    ReceiveReward = "$imageDir\ReceiveReward.png"
    SelectSupporter = "$imageDir\SelectSupporter.png"
    ShopBuy = "$imageDir\ShopBuy.png"
    ShopConquestPoints = "$imageDir\ShopConquestPoints.png"
    ShopFriendship = "$imageDir\ShopFriendship.png"
    StageClear = "$imageDir\StageClear.png"
    StageFailed = "$imageDir\StageFailed.png"
    Unchecked = "$imageDir\Unchecked.png"
}

# check that all files exist
$abort = $false
foreach ($i in $Global:Images.GetEnumerator()) {
    $exists = [System.IO.File]::Exists($i.Value)
    if (!$exists) {
        Write-Error "Fatal, image does not exist: $($i.Value)"
        $abort = $true
    }
}
if ($abort) {
    Read-Host 'One or more errors occured'
    Write-Error 'One or more errors occured' -ErrorAction Stop
}
