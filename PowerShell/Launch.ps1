Start-Transcript -OutputDirectory "C:\Users\Victor O'Brien\Documents\PowerBot\Logs"

. $PSScriptRoot\Epic7.ps1 -ExternalControl

LaunchEmulator
LaunchEpic7
ClearLobbyPopups
NavigateTo Rock #Dragon
AutoRun
NavigateTo Arena
AutoArena
# alt F4
Send-AU3Key "^0" | Out-Null
# pause for user confirmation
# powershell quit

Stop-Transcript