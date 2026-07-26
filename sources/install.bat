@echo off
setlocal

powershell.exe -NoProfile -NonInteractive -ExecutionPolicy Bypass -File "%~dp0Install-IntuneSystemTrayV2.ps1"
if errorlevel 1 exit /b %errorlevel%

schtasks.exe /Create /XML "%~dp0StartCompanyPortalSystemtray-v2.xml" /TN "StartCompanyPortalSystemtray" /F
exit /b %errorlevel%
