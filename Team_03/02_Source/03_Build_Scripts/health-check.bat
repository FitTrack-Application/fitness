@echo off
setlocal enabledelayedexpansion

echo ========================================
echo     FitTrack Services Health Check
echo ========================================

:: Service endpoints
set Services[0]=Gateway:http://localhost:8080/actuator/health
set Services[1]=Food:http://localhost:8081/actuator/health
set Services[2]=Exercise:http://localhost:8082/actuator/health
set Services[3]=Media:http://localhost:8083/actuator/health
set Services[4]=Statistic:http://localhost:8084/actuator/health
set Services[5]=Embedding:http://localhost:8085/health

set HealthyCount=0
set TotalServices=6

:: Check each service
for /l %%i in (0,1,5) do (
    call :CheckService "!Services[%%i]!"
)

:: Docker status
echo.
echo Docker containers:
for %%i in ("%~dp0..\..") do set "ProjectRoot=%%~fi"
pushd "%ProjectRoot%\Team_03\02_Source\01_Source_Code\BE\services"
docker-compose ps
popd

:: Summary
echo.
echo ========================================
echo Services healthy: %HealthyCount%/%TotalServices%
echo ========================================

if %HealthyCount% EQU %TotalServices% (
    echo All services are healthy!
    exit /b 0
) else (
    echo Some services are not healthy
    exit /b 1
)

:CheckService
set ServiceInfo=%~1
for /f "tokens=1,* delims=:" %%a in ("%ServiceInfo%") do (
    set ServiceName=%%a
    set HealthUrl=%%b
)

echo Checking %ServiceName%...
curl -s -f "%HealthUrl%" >nul 2>&1
if errorlevel 1 (
    echo   Status: UNHEALTHY
) else (
    echo   Status: HEALTHY
    set /a HealthyCount+=1
)
exit /b 0
