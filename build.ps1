Write-Host "Building customcommands.kbplugin..." -ForegroundColor Cyan

# Remove old files if they exist
if (Test-Path "customcommands.zip") {
    Remove-Item "customcommands.zip" -Force
}
if (Test-Path "customcommands.kbplugin") {
    Remove-Item "customcommands.kbplugin" -Force
}

# Create the ZIP archive
Compress-Archive -Path common,server,plugin.json,README.md -DestinationPath customcommands.zip -Force

# Rename to .kbplugin
Move-Item -Path customcommands.zip -Destination customcommands.kbplugin -Force

Write-Host "Successfully created customcommands.kbplugin" -ForegroundColor Green
