# ==========================================
# Quartz Obsidian 自動發布腳本
# ==========================================

$ErrorActionPreference = "Stop"

$QuartzPath = "C:\quartz\quartz"
$Source = "G:\我的雲端硬碟\obsidian vault\vault_python_20260816"
$Destination = "$QuartzPath\content\vault_python_20260816"

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "      Quartz Obsidian 自動發布" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# ==========================================
# 確認路徑
# ==========================================

if (-not (Test-Path $QuartzPath)) {
    Write-Host "錯誤：找不到 Quartz 資料夾" -ForegroundColor Red
    Write-Host $QuartzPath
    exit 1
}

if (-not (Test-Path $Source)) {
    Write-Host "錯誤：找不到 Obsidian Vault" -ForegroundColor Red
    Write-Host $Source
    exit 1
}

Set-Location $QuartzPath

# ==========================================
# 1. 同步 Obsidian Vault
# ==========================================

Write-Host "[1/4] 同步 Obsidian Vault..." -ForegroundColor Cyan
Write-Host ""

robocopy $Source $Destination /MIR /XD ".obsidian"

if ($LASTEXITCODE -gt 7) {
    Write-Host ""
    Write-Host "錯誤：Obsidian Vault 同步失敗！" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "同步完成！" -ForegroundColor Green

# ==========================================
# 2. 檢查 Git 變更
# ==========================================

Write-Host ""
Write-Host "[2/4] 檢查 Git 變更..." -ForegroundColor Cyan
Write-Host ""

git add -A

$Changes = git status --short

if ([string]::IsNullOrWhiteSpace($Changes)) {

    Write-Host "沒有任何變更。" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "不需要 Commit，也不需要 Push。" -ForegroundColor Yellow
    Write-Host ""

    exit 0
}

Write-Host "偵測到以下變更：" -ForegroundColor Yellow
Write-Host ""
Write-Host $Changes
Write-Host ""

# ==========================================
# 3. 確認是否發布
# ==========================================

Write-Host "==========================================" -ForegroundColor Cyan
$Confirm = Read-Host "是否發布？ [Y/N]"
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

if ($Confirm -notmatch '^[Yy]$') {

    Write-Host "已取消發布。" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "注意：變更目前已經加入 Git Staging。" -ForegroundColor DarkYellow
    Write-Host "如果要完全取消 staging，可執行：" -ForegroundColor DarkYellow
    Write-Host "git restore --staged ." -ForegroundColor DarkYellow
    Write-Host ""

    exit 0
}

# ==========================================
# 4. Commit + Push
# ==========================================

Write-Host "[3/4] 建立 Git Commit..." -ForegroundColor Cyan
Write-Host ""

$CommitMessage = "Update Obsidian notes $(Get-Date -Format 'yyyy-MM-dd HH:mm')"

git commit -m "$CommitMessage"

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "錯誤：Git Commit 失敗！" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Commit 完成！" -ForegroundColor Green

Write-Host ""
Write-Host "[4/4] Push 到 GitHub..." -ForegroundColor Cyan
Write-Host ""

git push

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "錯誤：GitHub Push 失敗！" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Green
Write-Host "          發布完成！" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
Write-Host ""

Write-Host "GitHub Actions 將自動建立 Quartz 網站。" -ForegroundColor Cyan
Write-Host ""
Write-Host "網站：" -ForegroundColor Cyan
Write-Host "https://gre888.github.io/quartz/" -ForegroundColor White
Write-Host ""
