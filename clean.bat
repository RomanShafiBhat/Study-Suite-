@echo off
echo Cleaning StudySuite project...

echo Stopping Gradle daemons...
gradlew --stop

echo Waiting for processes to release files...
timeout /t 3 /nobreak >nul

echo Cleaning project...
gradlew clean

echo Cleaning build cache...
gradlew cleanBuildCache

echo Cleaning Gradle caches (may take time due to locked files)...
if exist "%USERPROFILE%\.gradle\caches" (
    echo Attempting to clean Gradle caches...
    rmdir /s /q "%USERPROFILE%\.gradle\caches" 2>nul
    if exist "%USERPROFILE%\.gradle\caches" (
        echo Some Gradle cache files are locked. They will be cleaned on next restart.
    ) else (
        echo Gradle caches cleaned successfully
    )
)

echo Cleaning Android build cache...
if exist "%USERPROFILE%\.android\build-cache" (
    rmdir /s /q "%USERPROFILE%\.android\build-cache" 2>nul
    echo Android build cache cleaned
)

echo Cleaning project build directories...
if exist "build" (
    rmdir /s /q "build" 2>nul
    echo Project build directory cleaned
)

if exist "app\build" (
    rmdir /s /q "app\build" 2>nul
    echo App build directory cleaned
)

echo Cleaning IDE files...
if exist ".idea" (
    rmdir /s /q ".idea" 2>nul
    echo IntelliJ IDEA files cleaned
)

if exist ".vscode" (
    rmdir /s /q ".vscode" 2>nul
    echo VS Code files cleaned
)

if exist ".snapshots" (
    rmdir /s /q ".snapshots" 2>nul
    echo Snapshot files cleaned
)

echo.
echo Cleanup complete! Some files may remain if they are locked by running processes.
echo If you encounter build issues, restart your computer and run this script again.
echo.
pause
