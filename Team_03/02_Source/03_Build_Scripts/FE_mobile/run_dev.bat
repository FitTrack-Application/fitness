@echo off
:: run_dev.bat - Chạy Flutter app ở chế độ phát triển (debug)

echo Running Flutter app in DEBUG mode...

:: Kiểm tra Flutter đã cài đặt chưa
where flutter >nul 2>nul
if errorlevel 1 (
    echo Flutter is not installed.
    exit /b 1
)

:: Nếu sử dụng FVM
where fvm >nul 2>nul
if not errorlevel 1 (
    echo ✅ Running with FVM...
    fvm flutter run
) else (
    echo ✅ Running with global Flutter...
    flutter run
)

echo ✅ Flutter app has been started.
