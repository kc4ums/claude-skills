@echo off
title kc4ums/claude-skills - Skill Installer
echo.
echo Fetching installer from GitHub...
del "%TEMP%\ccinstall.ps1" 2>nul
powershell -ExecutionPolicy Bypass -Command "iwr 'https://raw.githubusercontent.com/kc4ums/claude-skills/main/install.ps1' -OutFile '%TEMP%\ccinstall.ps1'"
powershell -ExecutionPolicy Bypass -File "%TEMP%\ccinstall.ps1"
pause
