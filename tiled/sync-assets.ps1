Remove-Item '..\assets\assets\images\tiled\*.png'
Copy-Item '*.png' -Destination '..\assets\assets\images\tiled\'
Get-ChildItem '..\assets\assets\images\tiled\*.json' | Foreach-Object { (Get-Content $_.FullName) -replace '\"..\\/..\\/..\\/..\\/tiled\\/', '"' | Set-Content $_.FullName}
Get-ChildItem '..\assets\assets\images\tiled\*.json' | Foreach-Object { (Get-Content $_.FullName) -replace '\.tsx', '.json' | Set-Content $_.FullName}
Get-ChildItem '..\assets\assets\images\tiled\*.json' | Foreach-Object { (Get-Content $_.FullName) | jq -c . | Set-Content "$($_.FullName).mini"}
Remove-Item '..\assets\assets\images\tiled\*.json'
Get-ChildItem '..\assets\assets\images\tiled\*.json.mini' | Rename-Item -NewName {$_.Name -replace '.json.mini', '.json'}
