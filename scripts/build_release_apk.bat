@echo off
setlocal enabledelayedexpansion

REM Build a release APK with code obfuscation and split debug info mapping.
REM Outputs APK(s) under android\app\build\outputs\apk\release\ and symbols under build\symbols.

REM Ensure we run from the repo root even if script is double-clicked.
cd /d "%~dp0.."

REM Create a stable output folder for split-debug-info files (keeps tree clean and CI-friendly)
set SYMBOLS_ROOT=build\symbols
if not exist "%SYMBOLS_ROOT%" mkdir "%SYMBOLS_ROOT%"

REM Compute a dated subfolder for mapping to avoid overwriting older symbol files (optional)
for /f "tokens=1-3 delims=/ " %%a in ("%date%") do (
  set YYYY=%%c
  set MM=%%a
  set DD=%%b
)
for /f "tokens=1-2 delims=: " %%a in ("%time%") do (
  set HH=%%a
  set MIN=%%b
)
set TIMESTAMP=%YYYY%-%MM%-%DD%_%HH%-%MIN%
set SYMBOLS_DIR=%SYMBOLS_ROOT%\%TIMESTAMP%
if not exist "%SYMBOLS_DIR%" mkdir "%SYMBOLS_DIR%"

REM Invoke flutter build with obfuscation and split-debug-info
where flutter >nul 2>&1
if errorlevel 1 (
  echo [ERROR] Flutter is not on PATH. Please install or add to PATH, then re-run.
  exit /b 1
)

echo Building release APKs per ABI...
flutter build apk --release --obfuscate --split-debug-info="%SYMBOLS_DIR%" --split-per-abi
set ERR=%ERRORLEVEL%

if not %ERR%==0 (
  echo [ERROR] Build failed with exit code %ERR%.
  exit /b %ERR%
)

echo.
echo Build complete.
echo APK(s): android\app\build\outputs\apk\release\
echo Symbols directory: %SYMBOLS_DIR%

endlocal
exit /b 0
