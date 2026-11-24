@echo off
title Push IronHome to GitHub for Automated IPA Build
echo =======================================================
echo     IronHome iOS - Automated Cloud IPA Builder
echo =======================================================
echo.
echo This script connects your local project to your GitHub
echo repository so GitHub's free macOS runners will compile
echo and build the IronHome.ipa file automatically.
echo.
set /p REPO_URL="Enter your GitHub Repository URL (e.g. https://github.com/username/IronHome-iOS.git): "

if "%REPO_URL%"=="" (
    echo [ERROR] No repository URL entered. Exiting.
    pause
    exit /b 1
)

echo.
echo [1/3] Adding remote origin...
git remote remove origin >nul 2>&1
git remote add origin %REPO_URL%

echo [2/3] Setting branch to main...
git branch -M main

echo [3/3] Pushing project to GitHub...
git push -u origin main

if %ERRORLEVEL% equ 0 (
    echo.
    echo =======================================================
    echo [SUCCESS] Code pushed to GitHub!
    echo.
    echo Next Steps:
    echo 1. Go to your GitHub repository in your browser.
    echo 2. Click the 'Actions' tab at the top.
    echo 3. Click the running workflow 'Build Sideloadable IPA'.
    echo 4. When done (in ~2 minutes), scroll down to 'Artifacts'
    echo    and download 'IronHome-Sideloadly-IPA.zip'.
    echo 5. Extract the .ipa and drop it into Sideloadly!
    echo =======================================================
) else (
    echo.
    echo [ERROR] Failed to push to GitHub. Please check your URL and credentials.
)
echo.
pause
