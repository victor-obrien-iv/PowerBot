Start-Transcript -OutputDirectory "C:\Users\Victor O'Brien\Documents\PowerBot\Logs"

. $PSScriptRoot\Epic7.ps1 -ExternalControl

LaunchEmulator
LaunchEpic7
ClearLobbyPopups
NavigateTo Arena
AutoArena
NavigateTo Rock #Dragon
AutoRun
# alt F4
Send-AU3Key "!{F4}" | Out-Null
# pause for user confirmation
# powershell quit

Stop-Transcript