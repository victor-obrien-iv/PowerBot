
# user paramerters (you need to set these)
$Emulator = "NoxPlayer"
$EmulatorPath = "D:\Program Files\Nox\bin\Nox.exe"
$Sound = $true

# the directory where bot finds detection images
$ImageDir = "$PSScriptRoot\..\Images"

# these are the images the bot needs to detect game state
$Global:Images = @{
    ArenaDialogue = "$imageDir\ArenaDialogue.png"
    ArenaIgnition = "$imageDir\ArenaIgnition.png"
    ArenaFight= "$imageDir\ArenaFight.png"
    ArenaRefresh = "$imageDir\ArenaRefresh.png"
    ArenaStart = "$imageDir\ArenaStart.png"
    Auto = "$imageDir\Auto.png"
    BlueConfirm = "$imageDir\BlueConfirm.png"
    BrownConfirm = "$imageDir\BrownConfirm.png"
    CovenantBookmarks = "$imageDir\Bookmarks.png"
    DispatchTryAgain = "$imageDir\DispatchTryAgain.png"
    Epic7 = "$imageDir\Epic7.png"
    FriendshipBuy = "$imageDir\FriendshipBuy.png"
    FriendshipIncrease = "$ImageDir\FriendshipIncrease.png"
    FriendshipPoints= "$imageDir\FriendshipPoints.png"
    GreenConfirm = "$imageDir\GreenConfirm.png"
    Hunt = "$imageDir\Hunt.png"
    InsufficientEnergy = "$ImageDir\InsufficientEnergy.png"
    InsufficientInventory = "$ImageDir\InsufficientInventory.png"
    ManageTeam = "$imageDir\ManageTeam.png"
    MysticMedals = "$imageDir\Medals.png"
    NavigationMenu = "$imageDir\NavigationMenu.png"
    SelectSupporter = "$ImageDir\SelectSupporter.png"
    ShopConquestPoints = "$imageDir\ShopConquestPoints.png"
    ShopFriendship = "$imageDir\ShopFriendship.png"
    StageClear = "$ImageDir\StageClear.png"
    StageFailed = "$ImageDir\StageFailed.png"
}

# check that all files exist
foreach ($i in $Global:Images.GetEnumerator()) {
    $abort = $false
    $exists = [System.IO.File]::Exists($i.Value)

    if (!$exists) {
        Write-Error "Fatal, image does not exist: $($i.Value)"
        $abort = $true
    }

    if ($abort) {
        Exit-PSSession
    }
}
