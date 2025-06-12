@echo off
:: clean.bat - Dọn dẹp build, cache trong Flutter

echo 🧹 Đang dọn dẹp project...

:: Kiểm tra Flutter đã được cài chưa
where flutter >nul 2>nul
if errorlevel 1 (
    echo ❌ Flutter chưa được cài đặt.
    exit /b 1
)

:: Nếu có FVM, dùng FVM để clean
where fvm >nul 2>nul
if not errorlevel 1 (
    echo ✅ Dọn dẹp bằng FVM...
    fvm flutter clean
) else (
    echo ✅ Dọn dẹp bằng Flutter toàn cục...
    flutter clean
)

echo ✅ Dọn dẹp hoàn tất.
