@echo off
setlocal

echo ========================================
echo     Building Backend Services
echo ========================================

:: Get paths
for %%i in ("%~dp0..\..\..") do set "ProjectRoot=%%~fi"
set "BackendRoot=%ProjectRoot%\Team_03\02_Source\01_Source_Code\BE\services"

:: Check Docker
docker --version >nul 2>&1
if errorlevel 1 (
    echo Error: Docker is not installed or not running
    exit /b 1
)

:: Build backend services
echo Building backend services...
echo BackendRoot: %BackendRoot%
if not exist "%BackendRoot%" (
    echo Error: Backend directory not found: %BackendRoot%
    exit /b 1
)
if not exist "%BackendRoot%\docker-compose.yml" (
    echo Error: docker-compose.yml not found in: %BackendRoot%
    exit /b 1
)
pushd "%BackendRoot%"
echo Current directory: %CD%

:: Build services
echo Building Docker images...
docker-compose build
if errorlevel 1 (
    echo Backend build failed
    popd
    exit /b 1
)

:: Start services automatically
echo.
echo Starting services...
docker-compose up -d
if errorlevel 1 (
    echo Failed to start services
    popd
    exit /b 1
)

popd

echo.
echo ========================================
echo Backend services built and started successfully!
echo ========================================
echo.
echo Services are starting up, please wait a moment...
echo.
echo Service endpoints:
echo - Gateway: http://localhost:8088
echo - Food: http://localhost:8081  
echo - Exercise: http://localhost:8082
echo - Media: http://localhost:8083
echo - Statistic: http://localhost:8084
echo - Embedding: http://localhost:8085
echo - Keycloak: http://localhost:8888
echo.
echo Run 'health-check.bat' to verify service health
