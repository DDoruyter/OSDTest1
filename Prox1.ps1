<#
 # Description : Script to Run Cloud Image
 # Created : 31/03/2031 by Daimy
 #>

# Start van de image
Write-Host "=========================================================================" -ForegroundColor Red
Write-Host "====================== Proxsys OSDCLOUD Deployment ======================" -ForegroundColor Red
Write-Host "=========================================================================" -ForegroundColor Red
Write-Host "========================== Starting Imaging ZTI =========================" -ForegroundColor Red
Write-Host "================== Edition - 21H2 == Build - By Daimy ===================" -ForegroundColor Red
Write-Host "=========================================================================" -ForegroundColor Red
Start-Sleep -Seconds 5

# OSDCLOUD Module updaten...
Write-Host  -ForegroundColor Red "Importing..."
Import-Module OSD -Force

# OSDCLOUD ZTI koppelen
Write-Host  -ForegroundColor Red "Start OSDCloud"
Start-OSDCloud -OSLanguage nl-nl -OSVersion 'Windows 10' -OSBuild 21H2 -OSEdition Pro -OSlicense Enterprise -Firmware -ZTI

# Windows autopilot koppelen
Write-Host  -ForegroundColor Red "Start Connecting Autopilot" 
Install-Script -name Get-WindowsAutopilotInfo -Force
Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned
Install-Module AutopilotOOBE -Force -Verbose
Import-Module AutopilotOOBE -Force
Start-AutopilotOOBE -Title 'j&s-soft Autopilot registration' -Assign -PostAction Restart
Get-WindowsAutoPilotInfo -Online

#Opnieuw opstarten
Write-Host  -ForegroundColor Red "Restarting in 10 seconds!"
Start-Sleep -Seconds 10
wpeutil reboot
