
function ClearLobbyPopups {
    do {
        $checkin = TapButton $BlueConfirm -noRetry
        if ($checkin) {
            Write-Host "Collect check-in reward"
            Wait
        }

        $supporters = LocateOnScreen $FriendshipPointsImage
        if ($supporters) {
            Write-Host "Dismiss supporter popup"
            TapScreen
            Wait 4
        }

        $dispatch = TapButton $DispatchTryAgainImage -noRetry
        if ($dispatch) {
            Write-Host "Send out dispatch mission"
            Wait 4
        }

        # TODO check for the e7 icon, nox may have crashed

        TapNavigationMenu
        Wait
        $NavMenuOpen = LocateOnScreen $NavigationMenuImage
    } until ($NavMenuOpen.Result)
}
