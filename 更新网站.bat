@echo off
setlocal enabledelayedexpansion
title Update and Push

cd /d "%~dp0"

echo ========================================
echo   Update Prices and Push to Website
echo ========================================
echo.

if not exist "prices.txt" (echo prices.txt not found & pause & exit /b 1)

set /a n=0
for /f "tokens=2 delims=:" %%v in ('type "prices.txt"') do (
    set /a n+=1
    if !n!==1 set "P1=%%v"
    if !n!==2 set "P2=%%v"
    if !n!==3 set "CONTACT=%%v"
)

set "P1=%P1: =%"
set "P2=%P2: =%"
set "CONTACT=%CONTACT: =%"
if "%P1%"=="" set "P1=15"
if "%P2%"=="" set "P2=49"
if "%CONTACT%"=="" set "CONTACT=weixin youxiuxiu"

echo Price 1: %P1%
echo Price 2: %P2%
echo Contact: %CONTACT%
echo.

if not exist "node.exe" (echo node.exe not found & pause & exit /b 1)

node -e "var fs=require('fs');var p1=%P1%;var p2=%P2%;var c='%CONTACT%';var h=fs.readFileSync('index_template.html','utf8');h=h.replace(/{{P1}}/g,p1).replace(/{{P2}}/g,p2).replace(/{{CONTACT}}/g,c);fs.writeFileSync('index.html',h);console.log('Updated: '+p1+' / '+p2);"

echo.
echo Pushing...
git add index.html >nul 2>&1
git commit -m "update" >nul 2>&1
for /f "delims=" %%t in ('gh auth token 2^>nul') do set "TK=%%t"
git push https://!TK!@github.com/youyanxiaojing-sys/lobster-shop.git master >nul 2>&1
if !errorlevel! equ 0 (echo Done!) else (echo Push failed)
pause
