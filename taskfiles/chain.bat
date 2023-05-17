@echo off

if "%~1"=="" (
    echo "Usage: with_vcvars.bat <scriptname> <scriptname>"
    exit /b 1
)

if "%~2"=="" (
    echo "Usage: with_vcvars.bat <scriptname> <scriptname>"
    exit /b 1
)

echo Step 1:
call "%~1"

echo Step 2:
call "%~2"
