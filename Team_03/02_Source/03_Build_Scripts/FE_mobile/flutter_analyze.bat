@echo off
:: flutter_analyze.bat - Phân tích mã nguồn Flutter

echo 🔍 Analyzing code with flutter analyze...

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
    fvm flutter analyze
) else (
    echo ✅ Running with global Flutter...
    flutter analyze
)

if errorlevel 1 (
    echo ❌ Analysis found errors.
    exit /b 1
) else (
    echo ✅ Analysis complete. No errors found.
)
