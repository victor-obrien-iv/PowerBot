
function ClearLobbyPopups {
    do {
        $checkin = TapButton $Global:Images.BlueConfirm -noRetry
        if ($checkin) {
            Write-Host "Collect check-in reward"
            Wait
        }

        $supporters = LocateOnScreen $Global:Images.FriendshipPoints
        if ($supporters.Result) {
            Write-Host "Dismiss supporter popup"
            TapScreen
            Wait 4
        }

        $dispatch = TapButton $Global:Images.DispatchTryAgain -noRetry
        if ($dispatch) {
            Write-Host "Send out dispatch mission"
            Wait 4
        }

        $ad = TapButton $Global:Images.DontShowAgainToday -noRetry -untilItDisappears
        if ($ad) {
            Write-Host "Dismiss popup ad"
        }

        # TODO check for the e7 icon, nox may have crashed
        $lanuch = TapButton $Global:Images.Epic7 -noRetry
        if ($lanuch) {
            Write-Host "Epic 7 appears to have crashed, relaunching"
        }

        TapNavigationMenu
        Wait
        $NavMenuOpen = LocateOnScreen $Global:Images.NavigationMenu
    } until ($NavMenuOpen.Result)
}
