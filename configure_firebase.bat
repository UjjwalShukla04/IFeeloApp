@echo off
echo ===================================================
echo   IFeelo Firebase Configuration Helper
echo ===================================================
echo.
echo Step 1: Checking Firebase Login status...
call firebase projects:list >nul 2>&1
if %errorlevel% neq 0 (
    echo You are not logged in. Please log in to Firebase now.
    echo A browser window will open.
    call firebase login
) else (
    echo You are already logged in to Firebase.
)

echo.
echo Step 2: Running FlutterFire Configure...
echo Please select your project and platforms (Android, iOS, Web) when prompted.
"C:\Users\UJJWAL SHUKLA\AppData\Local\Pub\Cache\bin\flutterfire.bat" configure

echo.
echo Configuration complete! You can now run the app.
pause
