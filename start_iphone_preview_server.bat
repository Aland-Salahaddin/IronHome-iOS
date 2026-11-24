@echo off
title IronHome iPhone Wi-Fi Server
echo =======================================================
echo     IronHome - iPhone Instant Wi-Fi Preview / PWA
echo =======================================================
echo.
echo Make sure your iPhone is connected to the same Wi-Fi network.
echo.
echo Open Safari on your iPhone and visit:
echo      http://192.168.1.7:8080
echo.
echo Once opened:
echo 1. Tap the Share button (square with arrow pointing up).
echo 2. Tap "Add to Home Screen".
echo 3. The IronHome app will appear on your iPhone screen!
echo    It works offline and never expires!
echo =======================================================
echo.
cd /d "%~dp0\preview"
npx --yes serve -p 8080
pause
