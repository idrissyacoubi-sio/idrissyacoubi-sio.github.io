@echo off
echo Lancement du script de synchronisation automatique...
powershell -ExecutionPolicy Bypass -File "%~dp0auto-push.ps1"
pause
