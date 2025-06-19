@echo off

echo Checking requirements...

:: Check Docker (most important)
docker --version >nul 2>&1
if errorlevel 1 (
    echo ✗ Docker not found - Install Docker Desktop
    exit /b 1
) else (
    echo ✓ Docker
)

:: Check Java (for backend)
java -version >nul 2>&1
if errorlevel 1 (
    echo ✗ Java not found - Install from https://adoptium.net/
    exit /b 1
) else (
    echo ✓ Java
)

:: Check Node.js (for admin dashboard)
node --version >nul 2>&1
if errorlevel 1 (
    echo ✗ Node.js not found - Install from https://nodejs.org/
    exit /b 1
) else (
    echo ✓ Node.js
)

echo.
echo All requirements met! Run: build-backend.bat

