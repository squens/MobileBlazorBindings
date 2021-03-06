<#
.SYNOPSIS
    Gets the path to the nbgv CLI tool, installing it if necessary.
#>
Param(
)

$existingTool = Get-Command "nbgv" -ErrorAction SilentlyContinue
if ($existingTool) {
    return $existingTool.Path
}

if ($env:AGENT_TEMPDIRECTORY) {
    $toolInstallDir = "$env:AGENT_TEMPDIRECTORY/$env:BUILD_BUILDID"
} else {
    $toolInstallDir = "$PSScriptRoot/../obj/tools"
}

$toolPath = "$toolInstallDir/nbgv"
if (!(Test-Path $toolInstallDir)) { New-Item -Path $toolInstallDir -ItemType Directory | Out-Null }

if (!(Get-Command $toolPath -ErrorAction SilentlyContinue)) {
    Write-Host "Installing nbgv to $toolInstallDir"
    dotnet tool install --tool-path "$toolInstallDir" nbgv --configfile "$PSScriptRoot/justnugetorg.nuget.config" | Out-Null
}

# Normalize the path on the way out.
return (Get-Command $toolPath).Path
