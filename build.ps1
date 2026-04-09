$ErrorActionPreference = 'Stop'

$projectPath = Join-Path $PSScriptRoot 'CS2AdminTool/CS2AdminTool.csproj'
$projectDir = Split-Path $projectPath -Parent
$projectBinPath = Join-Path $projectDir 'bin'
$projectObjPath = Join-Path $projectDir 'obj'
$distPath = Join-Path $PSScriptRoot 'dist'
$publishPath = Join-Path $distPath 'publish'

$rids = @('linux-x64', 'linux-arm64', 'win-x64')

Write-Host 'Cleaning previous builds...'
if (Test-Path $publishPath) {
    Remove-Item $publishPath -Recurse -Force
}
if (Test-Path $projectBinPath) {
    Remove-Item $projectBinPath -Recurse -Force
}
if (Test-Path $projectObjPath) {
    Remove-Item $projectObjPath -Recurse -Force
}
if (-not (Test-Path $distPath)) {
    New-Item -Path $distPath -ItemType Directory | Out-Null
}
New-Item -Path $publishPath -ItemType Directory -Force | Out-Null

Write-Host 'Publishing application...'
dotnet clean $projectPath -c Release
if ($LASTEXITCODE -ne 0) {
    throw "dotnet clean failed with exit code $LASTEXITCODE"
}

foreach ($rid in $rids) {
    $ridPublishPath = Join-Path $publishPath $rid
    dotnet publish $projectPath -c Release -r $rid --self-contained true -o $ridPublishPath /p:PublishSingleFile=true /p:IncludeNativeLibrariesForSelfExtract=true
    if ($LASTEXITCODE -ne 0) {
        throw "dotnet publish for $rid failed with exit code $LASTEXITCODE"
    }

    $zipPath = Join-Path $distPath "CS2AdminTool-$rid.zip"
    if (Test-Path $zipPath) {
        Remove-Item $zipPath -Force
    }

    Compress-Archive -Path "$ridPublishPath/*" -DestinationPath $zipPath -Force
    Write-Host "Created artifact: $zipPath"
}

Write-Host "Build complete. Artifacts are in: $distPath"
