@echo off
set PATH=D:\Dev\Flutter\bin;%PATH%
rmdir /s /q build
xcopy assets\* build\web\* /e /q
rem flutter build web --wasm
flutter build web