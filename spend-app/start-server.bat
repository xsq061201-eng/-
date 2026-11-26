@echo off
title Daily Spend - local server
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0start-server.ps1"
echo.
echo Server stopped.
pause
