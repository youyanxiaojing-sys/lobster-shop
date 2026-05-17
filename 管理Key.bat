@echo off
chcp 65001 >nul
title API Key Manager
set "STORE=%~dp0key_pool.txt"
if not exist "%STORE%" (
    echo sk-xxxxxxxxxxxx [AVAILABLE] > "%STORE%"
    echo Key pool file created: key_pool.txt
    echo Please edit it with your API keys.
    pause
    exit /b 0
)
echo ========================================
echo   API Key Manager
echo ========================================
echo.
echo [1] List available keys
echo [2] Get next key (mark as SOLD)
echo [3] Add new key
echo [4] Show delivery message template
echo.
set /p CHOICE="> "

if "%CHOICE%"=="1" goto list
if "%CHOICE%"=="2" goto get
if "%CHOICE%"=="3" goto add
if "%CHOICE%"=="4" goto message
goto end

:list
echo.
echo Available keys:
findstr /c:"AVAILABLE" "%STORE%" 2>nul
if %errorlevel% neq 0 echo No available keys!
echo.
pause
goto end

:get
echo.
set KEY=
for /f "usebackq tokens=1 delims= " %%k in (`findstr /c:"AVAILABLE" "%STORE%" 2^>nul`) do (
    set "KEY=%%k"
    goto found
)
echo No available keys! Please add more.
pause
goto end

:found
echo Key: %KEY%
powershell -Command "(Get-Content '%STORE%' -Raw) -replace '%KEY% \[AVAILABLE\]', '%KEY% [SOLD]' | Set-Content '%STORE%'"
echo Marked as SOLD.
echo.
echo === Delivery Message (copy this to buyer) ===
echo.
echo Your DeepSeek API Key: %KEY%
echo.
echo How to use:
echo 1. Download the installer package
echo 2. Put the key into api_key.txt in the installer folder
echo 3. Run run.bat as admin
echo 4. You're done!
echo.
echo If you have any questions, message me.
echo ===========================================
echo.
pause
goto end

:add
echo.
echo Paste new API Key (sk-xxx):
set /p NEWKEY="> "
if "%NEWKEY%"=="" goto end
echo %NEWKEY% [AVAILABLE] >> "%STORE%"
echo Key added.
echo.
pause
goto end

:message
echo.
echo === Generic Delivery Message ===
echo.
echo Here is your DeepSeek API Key:
echo sk-xxxxx  (replace with actual key)
echo.
echo Quick Start:
echo 1. Save this key somewhere safe
echo 2. Download the LongXia installer
echo 3. Double-click run.bat → follow the prompts
echo 4. Paste your key when asked
echo 5. Done! AI assistant is ready at http://127.0.0.1:18789
echo.
echo Need help? Just message me.
echo ===========================================
echo.
pause
goto end

:end
