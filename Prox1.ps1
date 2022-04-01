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

function UpdateDrivers {
        [CmdletBinding()]
        param ()
        if ($env:UserName -eq 'defaultuser0') {
            Write-Host -ForegroundColor Red 'Updating Windows Drivers'
            if (!(Get-Module PSWindowsUpdate -ListAvailable -ErrorAction Ignore)) {
                try {
                    Install-Module PSWindowsUpdate -Force -Scope CurrentUser
                    Import-Module PSWindowsUpdate -Force -Scope Global
                }
                catch {
                    Write-Warning 'Unable to install PSWindowsUpdate Driver Updates'
                }
            }
            if (Get-Module PSWindowsUpdate -ListAvailable -ErrorAction Ignore) {
                Start-Process -WindowStyle Minimized PowerShell.exe -ArgumentList "-Command Install-WindowsUpdate -UpdateType Driver -AcceptAll -IgnoreReboot" -Wait

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
