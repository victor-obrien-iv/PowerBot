Start-Transcript -OutputDirectory "C:\Users\Victor O'Brien\Documents\PowerBot\Logs"

. $PSScriptRoot\Epic7.ps1 -ExternalControl

LaunchEmulator
LaunchEpic7
ClearLobbyPopups
NavigateTo Arena
AutoArena
NavigateTo Rock # Rock Ghost Dragon Bug
AutoRun
# RollSecretShop 3000 3000000
# BuyEnergy
# NavigateTo Dragon # Ghost Rock Bug
# AutoRun

Send-AU3Key "!{F4}" | Out-Null # alt F4


Stop-Transcript