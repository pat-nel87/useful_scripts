

#FUNCTIONAL WALLPAPER & ICON CHANGING SCRIPT - Put Images & Icons in C:\User\current user \ directory | Then copy and paste everything below this comment into Powershell & hit enter, Voila!#
#DESIGNED TO DO A QUICK WALLPAPER CHANGE, SET DESKTOP SHORTCUTS, CHANGE FIREWALL SETTINGS, INSTALLS CHROME BROWSER, DELETE ANY DEFAULT USERS 

#START,  Shortcut creation

$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$Home\Desktop\yourshortcuthere.lnk")
$Shortcut.TargetPath = "http://insertweblink"
$Shortcut.Iconlocation = "$Home\website_icon.ico"
$Shortcut.Save()

#END, Shortcut Creation

#Changes desktop background
#START, Wallpaper Change
#

$setwallpapersrc = @"
using System.Runtime.InteropServices;
public class wallpaper
{
public const int SetDesktopWallpaper = 20;
public const int UpdateIniFile = 0x01;
public const int SendWinIniChange = 0x02;
[DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
private static extern int SystemParametersInfo (int uAction, int uParam, string lpvParam, int fuWinIni);
public static void SetWallpaper ( string path )
{
SystemParametersInfo( SetDesktopWallpaper, 0, path, UpdateIniFile | SendWinIniChange );
}
# Set source directory for wall paper image below
}
"@
Add-Type -TypeDefinition $setwallpapersrc
[wallpaper]::SetWallpaper("$Home\Your background.png") 

#END, Wallpaper Change

#START, Sharing Settings Changes
#Modifies Advance sharing settings, Network discovery & FIle Printer Sharing Public, Private, Current to on#

netsh advfirewall firewall set rule group="Network Discovery" new enable=Yes
netsh advfirewall firewall set rule group="File and Printer Sharing" new enable=Yes


#END, Sharing Settings Changes

#Modifies Power & Sleep Settings
#START, Power Changes

Powercfg /Change monitor-timeout-ac 0
Powercfg /Change monitor-timeout-dc 0
Powercfg /Change standby-timeout-ac 0
Powercfg /Change standby-timeout-dc 0

#END, Power Changes


#end delete old user
#START chrome install

$LocalTempDir = $env:TEMP; $ChromeInstaller = "ChromeInstaller.exe"; (new-object    System.Net.WebClient).DownloadFile('http://dl.google.com/chrome/install/375.126/chrome_installer.exe', "$LocalTempDir\$ChromeInstaller"); & "$LocalTempDir\$ChromeInstaller" /silent /install; $Process2Monitor =  "ChromeInstaller"; Do { $ProcessesFound = Get-Process | ?{$Process2Monitor -contains $_.Name} | Select-Object -ExpandProperty Name; If ($ProcessesFound) { "Still running: $($ProcessesFound -join ', ')" | Write-Host; Start-Sleep -Seconds 2 } else { rm "$LocalTempDir\$ChromeInstaller" -ErrorAction SilentlyContinue -Verbose } } Until (!$ProcessesFound)

#END chrome install

#deletes temp user
#delete old user TEMPUSER
Start-Process cmd
Sleep 1
$wshell = New-Object -ComObject wscript.shell;
$Wshell.SendKeys('net user TEMPUSER /del')
Sleep 1
$Wshell.SendKeys('~')








