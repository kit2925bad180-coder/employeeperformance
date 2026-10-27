@REM Convenience wrapper for Maven
@echo off
set "LOCAL_MVN=C:\Users\virth\.m2\wrapper\dists\apache-maven-3.9.16\0daed3be3ebd1c706f0e69e8b07c6b73f5cc4ea3dfce72a8d0ec2e849ca2ddb0\bin\mvn.cmd"

where mvn >nul 2>nul
if %ERRORLEVEL% equ 0 (
    mvn %*
) else if exist "%LOCAL_MVN%" (
    call "%LOCAL_MVN%" %*
) else (
    echo [ERROR] Maven not found. Please ensure Maven is installed or added to PATH.
    exit /b 1
)
