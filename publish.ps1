# ==========================================
# Quartz Obsidian 自動發布腳本
# ==========================================

$ErrorActionPreference = "Stop"

$QuartzPath = "C:\quartz\quartz"
$Source = "G:\我的雲端硬碟\obsidian vault\vault_python_20260816"
$Destination = "$QuartzPath\content\vault_python_20260816"

Write-Host ""
Write-Host "=========================================="
Write-Host "      Quartz Obsidian 自動發布"
Write-Host "=========================================="
Write-Host ""

# 確認 Quartz
if (-not (Test-Path $QuartzPath)) {
    Write-Host "錯誤：找不到 Quartz 資料夾" -ForegroundColor Red
    exit 1
}

# 確認 Obsidian Vault
if (-not (Test-Path $Source)) {
    Write-Host "錯誤：找不到 Obsidian Vault" -ForegroundColor Red
    Write-Host $Source
    exit 1
}

Set-Location $QuartzPath

# 1. 同步 Obsidian Vault
Write-Host "[1/4] 同步 Obsidian Vault..." -ForegroundColor Cyan

robocopy $Source $Destination /MIR /XD ".obsidian"

if ($LASTEXITCODE -gt 7) {
    Write-Host "錯誤：同步失敗" -ForegroundColor Red
    exit 1
}

Write-Host "同步完成！" -ForegroundColor Green

# 2. Git Status
Write-Host ""
Write-Host "[2/4] 檢查 Git 狀態..." -ForegroundColor Cyan

git status

# 3. Git Commit
Write-Host ""
Write-Host "[3/4] 建立 Git Commit..." -ForegroundColor Cyan

git add .

$GitStatus = git status --porcelain

if ([string]::IsNullOrWhiteSpace($GitStatus)) {
    Write-Host "沒有新的變更，不需要 Commit。" -ForegroundColor Yellow
}
else {
    $CommitMessage = "Update Obsidian notes $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
    git commit -m $CommitMessage
    Write-Host "Commit 完成！" -ForegroundColor Green
}

# 4. GitHub Push
Write-Host ""
Write-Host "[4/4] Push 到 GitHub..." -ForegroundColor Cyan

git push

if ($LASTEXITCODE -ne 0) {
    Write-Host "GitHub Push 失敗！" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "=========================================="
Write-Host "          發布完成！"
Write-Host "=========================================="
Write-Host ""
