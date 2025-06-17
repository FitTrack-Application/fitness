@echo off
:: build_apk.bat - Build APK ở chế độ release

echo Building APK release...

:: Chuyển đến thư mục chứa pubspec.yaml
cd /d "%~dp0..\..\01_Source_Code\FE\mobile"

:: Kiểm tra lại xem pubspec.yaml có tồn tại không
if not exist "pubspec.yaml" (
    echo pubspec.yaml not found! Make sure you are in the Flutter project root.
    exit /b 1
)

:: Kiểm tra Flutter đã cài đặt chưa
where flutter >nul 2>nul
if errorlevel 1 (
    echo Flutter is not installed.
    exit /b 1
)

:: Nếu sử dụng FVM
where fvm >nul 2>nul
if not errorlevel 1 (
    echo Building with FVM...
    fvm flutter build apk --release
) else (
    echo Building with global Flutter...
    flutter build apk --release
)

if exist build\app\outputs\flutter-apk\app-release.apk (
    echo APK has been successfully built: build\app\outputs\flutter-apk\app-release.apk
) else (
    echo Build APK failed.
    exit /b 1
)
