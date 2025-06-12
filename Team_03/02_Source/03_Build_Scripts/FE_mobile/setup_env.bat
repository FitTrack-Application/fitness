@echo off
:: setup_env.bat - Thiết lập môi trường Flutter trên Windows

echo 🔧 Setting up Flutter...

:: Kiểm tra xem flutter đã được cài đặt chưa
where flutter >nul 2>nul
if errorlevel 1 (
    echo ❌ Flutter is not installed. Please install Flutter first.
    exit /b 1
)

:: Hiển thị phiên bản flutter
flutter --version

:: Kiểm tra FVM
where fvm >nul 2>nul
if not errorlevel 1 (
    echo ✅ FVM is installed. Using FVM to set up Flutter version...
    fvm install
    fvm use
) else (
    echo ⚠️ FVM is not installed. Using global Flutter.
)

:: Tải các dependencies
echo 📦 Installing Flutter packages...
flutter pub get

:: Sao chép .env.example thành .env nếu tồn tại
if exist .env.example (
    copy /Y .env.example .env
    echo 📁 Copied .env.example → .env
) else (
    echo ⚠️ .env.example not found. Skipping .env creation.
)

echo ✅ Environment setup complete.
