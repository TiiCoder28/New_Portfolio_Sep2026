# Safely synchronise a local checkout with a GitHub branch.
# Example: powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\Sync-Portfolio.ps1 -Branch main
# Requires Git, a configured origin remote, and an existing local checkout of Branch.
param([string]$Branch = 'main')
$ErrorActionPreference = 'Stop'
function Fail([string]$Message) { Write-Error $Message; exit 1 }
$repoRoot = (git rev-parse --show-toplevel 2>$null)
if ($LASTEXITCODE -ne 0 -or -not $repoRoot) { Fail 'This script must run inside a Git repository.' }
Set-Location $repoRoot
$current = (git branch --show-current).Trim()
if ($current -ne $Branch) { Fail "Current branch is '$current'; switch to '$Branch' manually before synchronising." }
$dirty = git status --porcelain --untracked-files=normal
if ($LASTEXITCODE -ne 0) { Fail 'Unable to check working-tree status.' }
if ($dirty) { Fail 'Local changes or untracked files detected. Commit, stash or resolve them manually; no update applied.' }
git fetch origin $Branch
if ($LASTEXITCODE -ne 0) { Fail 'Fetch failed. No local changes applied.' }
git merge-base --is-ancestor HEAD "origin/$Branch"
if ($LASTEXITCODE -ne 0) { Fail 'Local and remote histories diverged; manual review required. No update applied.' }
git merge --ff-only "origin/$Branch"
if ($LASTEXITCODE -ne 0) { Fail 'Fast-forward update failed; manual review required.' }
Write-Host "Updated '$Branch' safely. Vite should detect changed source files."
