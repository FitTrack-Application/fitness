@echo off
REM ==============================================
REM BUILD SCRIPT FOR FLUTTER PROJECT (WINDOWS)
REM ==============================================

REM Set working directory to project root
cd Team_03\02_Source\01_Source_Code\FE\mobile

REM Check Flutter version
flutter --version

REM Get dependencies
flutter pub get

REM Clean previous builds
flutter clean

REM Build APK (release)
flutter build apk --release

REM Output path: build\app\outputs\flutter-apk\app-release.apk

pause