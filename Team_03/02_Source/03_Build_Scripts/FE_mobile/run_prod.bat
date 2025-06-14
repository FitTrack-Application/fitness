@echo off
:: run_prod.bat - Chạy Flutter app ở chế độ release

echo Running Flutter app in RELEASE mode...

:: Kiểm tra Flutter đã cài đặt chưa
where flutter >nul 2>nul
if errorlevel 1 (
    echo ❌ Flutter is not installed.
    exit /b 1
)

:: Nếu sử dụng FVM
where fvm >nul 2>nul
if not errorlevel 1 (
    echo ✅ Running with FVM...
    fvm flutter run --release
) else (
    echo ✅ Running with global Flutter...
    flutter run --release
)

echo ✅ Flutter app has been started in release mode.
