@echo off
setlocal

if "%~1"=="" (
    echo Usage: manage-services.bat ^<start^|stop^|restart^|status^> [--build]
    echo.
    echo Examples:
    echo   manage-services.bat start
    echo   manage-services.bat start --build
    echo   manage-services.bat stop
    echo   manage-services.bat restart
    echo   manage-services.bat status
    exit /b 1
)

set Action=%~1
set Build=false

if "%~2"=="--build" set Build=true

:: Validate action
if not "%Action%"=="start" if not "%Action%"=="stop" if not "%Action%"=="restart" if not "%Action%"=="status" (
    echo Error: Invalid action '%Action%'. Use start, stop, restart, or status.
    exit /b 1
)

:: Get paths
for %%i in ("%~dp0..\..") do set "ProjectRoot=%%~fi"
set "BackendRoot=%ProjectRoot%\Team_03\02_Source\01_Source_Code\BE\services"

:: Check Docker
docker info >nul 2>&1
if errorlevel 1 (
    echo Error: Docker is not running. Please start Docker Desktop first.
    exit /b 1
)

pushd "%BackendRoot%"

if "%Action%"=="start" (
    echo Starting FitTrack services...
    if "%Build%"=="true" (
        echo Building images...
        docker-compose build
    )
    docker-compose up -d
    echo Services started successfully!
    echo Run 'health-check.bat' to verify service health
) else if "%Action%"=="stop" (
    echo Stopping FitTrack services...
    docker-compose down
    echo Services stopped successfully!
) else if "%Action%"=="restart" (
    echo Restarting FitTrack services...
    docker-compose restart
    echo Services restarted successfully!
) else if "%Action%"=="status" (
    echo FitTrack Services Status:
    echo.
    docker-compose ps
    echo.
    echo Service endpoints:
    echo - Gateway: http://localhost:8080
    echo - Food: http://localhost:8081
    echo - Exercise: http://localhost:8082
    echo - Media: http://localhost:8083
    echo - Statistic: http://localhost:8084
    echo - Embedding: http://localhost:8085
)

popd
