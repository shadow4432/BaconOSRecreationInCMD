@echo off
title BaconOS Simulator
setlocal

:welcome
echo Welcome to BaconOS
echo ===================
echo Type 'help' for a list of commands.
echo.

goto main

:main
set "command="
set /p command="BaconOS> "

if /i "%command%"=="exit" goto :exit
if /i "%command%"=="help" goto :help
if /i "%command%"=="diskcleanup" goto :diskcleanup
if /i "%command%"=="texteditor" goto :texteditor
if /i "%command%"=="calculator" goto :calculator
if /i "%command%"=="cmd" goto :cmd
if /i "%command%"=="filemanager" goto :filemanager
if /i "%command%"=="notes" goto :notes
if /i "%command%"=="guessgame" goto :guessgame

echo Invalid command. Type 'help' for a list of commands.
goto main

:help
echo Available commands:
echo   diskcleanup - Run disk cleanup utility
echo   texteditor - Open the text file editor
echo   calculator - Open a basic calculator
echo   cmd - Open a command prompt interface
echo   filemanager - Open a simple file manager
echo   notes - Open a note-taking app
echo   guessgame - Play a guessing number game
echo   exit - Exit BaconOS
echo.
goto main

:diskcleanup
echo Starting Disk Cleanup...
call :logMessage "Starting Disk Cleanup..."

where cleanmgr >nul 2>nul
if errorlevel 1 (
    echo Disk Cleanup utility not found. Exiting...
    call :logMessage "Disk Cleanup utility not found. Exiting..."
    goto main
)

cleanmgr /sageset:1
cleanmgr /sagerun:1

if %errorlevel% neq 0 (
    echo Disk Cleanup encountered an error. Check the log for details.
    call :logMessage "Disk Cleanup encountered an error."
    goto main
)

echo Disk Cleanup completed successfully.
call :logMessage "Disk Cleanup completed successfully."
goto main

:texteditor
echo Opening Text Editor...
set /p filename="Enter filename (with .txt extension): "
if exist "%filename%" (
    type "%filename%"
) else (
    echo File not found. Creating a new file named %filename%.
)

echo Type your text below (type 'save' to save and exit):
:editloop
set /p text="> "
if /i "%text%"=="save" (
    echo Saving file...
    echo. > "%filename%"
    exit /b 0
) else (
    echo %text% >> "%filename%"
    goto editloop
)

:calculator
echo Opening Basic Calculator...
:calcLoop
set /p expression="Enter calculation (or type 'exit' to quit): "
if /i "%expression%"=="exit" goto :main
set /a result=%expression%
echo Result: %result%
goto calcLoop

:cmd
echo Entering Command Prompt...
cmd
goto main

:filemanager
echo Simple File Manager
echo ===================
echo Available files in current directory:
dir /b
echo.
set /p filename="Enter filename to view (or type 'exit' to leave): "
if /i "%filename%"=="exit" goto main
if exist "%filename%" (
    echo Opening %filename%...
    type "%filename%"
) else (
    echo File not found.
)
goto filemanager

:notes
echo Note-Taking App
echo =================
echo Type your notes below (type 'save' to save and exit):
set /p notefile="Enter notes filename (with .txt extension): "
:notes_loop
set /p note="> "
if /i "%note%"=="save" (
    echo Saving notes to %notefile%...
    echo. > "%notefile%"
    exit /b 0
) else (
    echo %note% >> "%notefile%"
    goto notes_loop
)

:guessgame
echo Welcome to the Guessing Game!
set /a number=%random% %% 100 + 1
set guess=0
echo I'm thinking of a number between 1 and 100. Can you guess it?
:guessLoop
set /p guess="Your guess: "
if "%guess%"=="exit" goto main
if "%guess%"=="%number%" (
    echo Congratulations! You've guessed the number!
    goto main
) else (
    echo Incorrect guess. Try again!
    goto guessLoop
)

:logMessage
set "cleanupLog=%TEMP%\BaconOS_log.txt"
echo %date% %time% - %1 >> "%cleanupLog%"
goto :eof

:exit
echo Exiting BaconOS...
exit /b 0