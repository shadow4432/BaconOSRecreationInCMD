@echo off
setlocal

REM Define variables
set "cleanupLog=%TEMP%\disk_cleanup.log"
set "cleanupOptions=/sageset:1 /sagerun:1"

REM Function to log messages
:logMessage
echo %date% %time% - %1 >> "%cleanupLog%"
goto :eof

REM Start the cleanup process
echo Starting Disk Cleanup...
call :logMessage "Starting Disk Cleanup..."

REM Check if Disk Cleanup is available
where cleanmgr >nul 2>nul
if errorlevel 1 (
    echo Disk Cleanup utility not found. Exiting...
    call :logMessage "Disk Cleanup utility not found. Exiting..."
    exit /b 1
)

REM Run Disk Cleanup with specified options
cleanmgr %cleanupOptions%

REM Check if the cleanup was successful
if %errorlevel% neq 0 (
    echo Disk Cleanup encountered an error. Check the log for details.
    call :logMessage "Disk Cleanup encountered an error."
    exit /b %errorlevel%
)

echo Disk Cleanup completed successfully.
call :logMessage "Disk Cleanup completed successfully."

exit /b 0