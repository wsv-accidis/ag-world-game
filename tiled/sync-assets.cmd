@echo off
del /q ..\assets\assets\images\tiled\*.png
copy /y *.png ..\assets\assets\images\tiled\
powershell -NoLogo -NoProfile -Command "Get-ChildItem -Path ..\assets\assets\images\tiled\*.json | Foreach-Object { (Get-Content $_.FullName) -replace '\"..\\/..\\/..\\/..\\/tiled\\/', '\"' | Set-Content $_.FullName}"
powershell -NoLogo -NoProfile -Command "Get-ChildItem -Path ..\assets\assets\images\tiled\*.json | Foreach-Object { (Get-Content $_.FullName) -replace '\.tsx', '.json' | Set-Content $_.FullName}"
