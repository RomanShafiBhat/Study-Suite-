# StudySuite Cleanup Script for PowerShell
Write-Host "🧹 Cleaning StudySuite project..." -ForegroundColor Green

# Stop Gradle daemons
Write-Host "Stopping Gradle daemons..." -ForegroundColor Yellow
& .\gradlew --stop

# Wait for processes to release files
Write-Host "Waiting for processes to release files..." -ForegroundColor Yellow
Start-Sleep -Seconds 3

# Clean project
Write-Host "Cleaning project..." -ForegroundColor Yellow
& .\gradlew clean

# Clean build cache
Write-Host "Cleaning build cache..." -ForegroundColor Yellow
& .\gradlew cleanBuildCache

# Clean project build directories
Write-Host "Cleaning project build directories..." -ForegroundColor Yellow
if (Test-Path "build") {
    Remove-Item -Recurse -Force "build" -ErrorAction SilentlyContinue
    Write-Host "✓ Project build directory cleaned" -ForegroundColor Green
}

if (Test-Path "app\build") {
    Remove-Item -Recurse -Force "app\build" -ErrorAction SilentlyContinue
    Write-Host "✓ App build directory cleaned" -ForegroundColor Green
}

# Clean IDE files
Write-Host "Cleaning IDE files..." -ForegroundColor Yellow
if (Test-Path ".idea") {
    Remove-Item -Recurse -Force ".idea" -ErrorAction SilentlyContinue
    Write-Host "✓ IntelliJ IDEA files cleaned" -ForegroundColor Green
}

if (Test-Path ".vscode") {
    Remove-Item -Recurse -Force ".vscode" -ErrorAction SilentlyContinue
    Write-Host "✓ VS Code files cleaned" -ForegroundColor Green
}

if (Test-Path ".snapshots") {
    Remove-Item -Recurse -Force ".snapshots" -ErrorAction SilentlyContinue
    Write-Host "✓ Snapshot files cleaned" -ForegroundColor Green
}

# Clean Android build cache
Write-Host "Cleaning Android build cache..." -ForegroundColor Yellow
$androidCachePath = "$env:USERPROFILE\.android\build-cache"
if (Test-Path $androidCachePath) {
    Remove-Item -Recurse -Force $androidCachePath -ErrorAction SilentlyContinue
    Write-Host "✓ Android build cache cleaned" -ForegroundColor Green
}

# Clean Gradle caches (handle locked files gracefully)
Write-Host "Cleaning Gradle caches..." -ForegroundColor Yellow
$gradleCachePath = "$env:USERPROFILE\.gradle\caches"
if (Test-Path $gradleCachePath) {
    try {
        Remove-Item -Recurse -Force $gradleCachePath -ErrorAction Stop
        Write-Host "✓ Gradle caches cleaned successfully" -ForegroundColor Green
    } catch {
        Write-Host "⚠ Some Gradle cache files are locked. They will be cleaned on next restart." -ForegroundColor Yellow
        Write-Host "  Locked files: $($_.Exception.Message)" -ForegroundColor Gray
    }
}

# Clean Gradle wrapper cache
Write-Host "Cleaning Gradle wrapper cache..." -ForegroundColor Yellow
$gradleWrapperCachePath = "gradle\wrapper\dists"
if (Test-Path $gradleWrapperCachePath) {
    Remove-Item -Recurse -Force $gradleWrapperCachePath -ErrorAction SilentlyContinue
    Write-Host "✓ Gradle wrapper cache cleaned" -ForegroundColor Green
}

# Clean temporary files
Write-Host "Cleaning temporary files..." -ForegroundColor Yellow
Get-ChildItem -Path . -Include "*.tmp", "*.log", "*.lock" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
Write-Host "✓ Temporary files cleaned" -ForegroundColor Green

Write-Host ""
Write-Host "🎉 Cleanup complete!" -ForegroundColor Green
Write-Host "If you encounter build issues, restart your computer and run this script again." -ForegroundColor Yellow
Write-Host ""
Read-Host "Press Enter to continue"
