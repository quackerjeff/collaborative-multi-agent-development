[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("ui", "api", "worker", "data", "fullstack", "platform")]
    [string]$Type,

    [Parameter(Mandatory = $true, Position = 0)]
    [string]$ProjectName,

    [string]$Dest = (Get-Location).Path,

    [switch]$NoGitInit
)

$ErrorActionPreference = "Stop"

function Fail {
    param([string]$Message)
    throw $Message
}

function Require-Command {
    param([string]$CommandName)
    if (-not (Get-Command $CommandName -ErrorAction SilentlyContinue)) {
        Fail "Required command not found: $CommandName"
    }
}

function Render-Template {
    param(
        [string]$SourcePath,
        [string]$DestinationPath
    )

    $content = Get-Content -Path $SourcePath -Raw
    $content = $content.Replace("__PROJECT_NAME__", $ProjectName)
    $content = $content.Replace("__REPO_TYPE__", $Type)
    $content = $content.Replace("__CMD_LOCATION__", $CmdRoot)
    Set-Content -Path $DestinationPath -Value $content
}

function Get-ProfileEntries {
    $baseManifest = Join-Path $CmdRoot "templates/profiles/base.txt"
    $typeManifest = Join-Path $CmdRoot "templates/profiles/$Type.txt"

    $entries = @()
    foreach ($manifest in @($baseManifest, $typeManifest)) {
        foreach ($line in Get-Content -Path $manifest) {
            $trimmed = $line.Trim()
            if ($trimmed -and -not $trimmed.StartsWith("#")) {
                $entries += $trimmed
            }
        }
    }

    return $entries | Sort-Object -Unique
}

function Copy-ProfileAssets {
    foreach ($relativePath in Get-ProfileEntries) {
        $sourcePath = Join-Path $CmdRoot $relativePath
        if (-not (Test-Path -Path $sourcePath -PathType Leaf)) {
            Fail "Manifest entry does not exist: $relativePath"
        }

        $destinationPath = Join-Path $TargetDir $relativePath
        $destinationParent = Split-Path -Path $destinationPath -Parent
        New-Item -ItemType Directory -Path $destinationParent -Force | Out-Null
        Copy-Item -Path $sourcePath -Destination $destinationPath -Force
    }
}

Require-Command git

$CmdRoot = $env:CMD_LOCATION
if (-not $CmdRoot) {
    Fail "CMD_LOCATION must be set"
}

$CmdRoot = $CmdRoot.TrimEnd('\', '/')

if (-not (Test-Path -Path $CmdRoot -PathType Container)) {
    Fail "CMD_LOCATION does not point to a directory: $CmdRoot"
}

$baseManifestPath = Join-Path $CmdRoot "templates/profiles/base.txt"
if (-not (Test-Path -Path $baseManifestPath -PathType Leaf)) {
    Fail "CMD_LOCATION does not look like a CMD repository: $CmdRoot"
}

New-Item -ItemType Directory -Path $Dest -Force | Out-Null
$TargetDir = Join-Path $Dest $ProjectName
if (Test-Path -Path $TargetDir) {
    Fail "Target already exists: $TargetDir"
}

New-Item -ItemType Directory -Path (Join-Path $TargetDir ".cmd/specs") -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $TargetDir "docs") -Force | Out-Null
Set-Content -Path (Join-Path $TargetDir ".cmd/specs/currentspec.md") -Value ""

Copy-ProfileAssets

$agentsTemplate = Join-Path $CmdRoot "templates/SATELLITE_AGENTS.md"
$agentsOutput = Join-Path $TargetDir "AGENTS.md"
Copy-Item -Path $agentsTemplate -Destination $agentsOutput -Force
$agentsContent = Get-Content -Path $agentsOutput -Raw
$agentsContent = $agentsContent.Replace("<replace-with-canonical-cmd-location>", $CmdRoot)
Set-Content -Path $agentsOutput -Value $agentsContent

Copy-Item -Path (Join-Path $CmdRoot "templates/SYSTEM_CONTEXT.md") -Destination (Join-Path $TargetDir "SYSTEM_CONTEXT.md") -Force
Render-Template -SourcePath (Join-Path $CmdRoot "templates/repo/README.md.tmpl") -DestinationPath (Join-Path $TargetDir "README.md")
Render-Template -SourcePath (Join-Path $CmdRoot "templates/repo/tech.md.tmpl") -DestinationPath (Join-Path $TargetDir "docs/tech.md")
Copy-Item -Path (Join-Path $CmdRoot "templates/repo/gitignore.tmpl") -Destination (Join-Path $TargetDir ".gitignore") -Force

if (-not $NoGitInit.IsPresent) {
    & git -C $TargetDir init | Out-Null
}

Write-Host "Seeded $Type repository at $TargetDir"
Write-Host "Next: replace placeholders in AGENTS.md and SYSTEM_CONTEXT.md"
