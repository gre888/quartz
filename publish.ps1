$ErrorActionPreference = "Stop"

# ==========================================
# Obsidian -> Quartz
# 桌機 / 筆電雙機發布版
# ==========================================

$Vault   = "G:\我的雲端硬碟\obsidian vault\vault_python_20260816"
$Quartz  = "C:\quartz\quartz"
$Target  = "$Quartz\content\vault_python_20260816"
$Website = "https://gre888.github.io/quartz/"

Clear-Host

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "       Obsidian -> Quartz Publisher" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""


# ==========================================
# 1. 檢查 Vault
# ==========================================

Write-Host "[1/8] 檢查 Google Drive Vault..." -ForegroundColor Yellow

if (-not (Test-Path $Vault)) {

    Write-Host ""
    Write-Host "找不到 Vault：" -ForegroundColor Red
    Write-Host $Vault -ForegroundColor Red
    Write-Host ""
    Write-Host "請確認 Google Drive 已啟動，而且磁碟代號為 G:" -ForegroundColor Yellow

    Read-Host "按 Enter 結束"
    exit 1
}

Write-Host "OK：Vault 已找到" -ForegroundColor Green


# ==========================================
# 2. 檢查 Quartz
# ==========================================

Write-Host ""
Write-Host "[2/8] 檢查 Quartz..." -ForegroundColor Yellow

if (-not (Test-Path "$Quartz\.git")) {

    Write-Host ""
    Write-Host "找不到 Quartz Git Repository：" -ForegroundColor Red
    Write-Host $Quartz -ForegroundColor Red

    Read-Host "按 Enter 結束"
    exit 1
}

Set-Location $Quartz

Write-Host "OK：Quartz 已找到" -ForegroundColor Green


# ==========================================
# 3. 檢查 Git 工作目錄
# ==========================================

Write-Host ""
Write-Host "[3/8] 檢查 Git 狀態..." -ForegroundColor Yellow

$BeforeStatus = git status --porcelain

if ($BeforeStatus) {

    Write-Host ""
    Write-Host "Quartz 目前有尚未提交的修改：" -ForegroundColor Red
    Write-Host ""

    git status --short

    Write-Host ""
    Write-Host "為避免覆蓋 Quartz 程式或 Canvas 修改，停止發布。" -ForegroundColor Yellow
    Write-Host ""

    Read-Host "按 Enter 結束"
    exit 1
}

Write-Host "OK：Git 工作目錄乾淨" -ForegroundColor Green


# ==========================================
# 4. 取得 GitHub 最新版本
# ==========================================

Write-Host ""
Write-Host "[4/8] 取得 GitHub 最新版本..." -ForegroundColor Yellow

git pull --rebase origin main

if ($LASTEXITCODE -ne 0) {

    Write-Host ""
    Write-Host "git pull 失敗。" -ForegroundColor Red
    Write-Host "目前停止發布，不會修改網站。" -ForegroundColor Yellow

    Read-Host "按 Enter 結束"
    exit 1
}

Write-Host "OK：已取得 GitHub 最新版本" -ForegroundColor Green


# ==========================================
# 5. Vault -> Quartz
# ==========================================

Write-Host ""
Write-Host "[5/8] 同步 Obsidian Vault..." -ForegroundColor Yellow

if (-not (Test-Path $Target)) {
    New-Item -ItemType Directory -Path $Target -Force | Out-Null
}

robocopy `
    "$Vault" `
    "$Target" `
    /MIR `
    /XD ".obsidian" ".git" `
    /R:2 `
    /W:1 `
    /FFT `
    /COPY:DAT `
    /DCOPY:T

$RoboCode = $LASTEXITCODE

if ($RoboCode -ge 8) {

    Write-Host ""
    Write-Host "Robocopy 發生錯誤：$RoboCode" -ForegroundColor Red

    Read-Host "按 Enter 結束"
    exit 1
}

Write-Host ""
Write-Host "OK：Vault 同步完成" -ForegroundColor Green


# ==========================================
# 6. 顯示變更
# ==========================================

Write-Host ""
Write-Host "[6/8] 檢查網站變更..." -ForegroundColor Yellow

git add -A

$Changes = git status --short

if (-not $Changes) {

    Write-Host ""
    Write-Host "沒有需要發布的變更。" -ForegroundColor Green
    Write-Host "Obsidian 與 Quartz 目前內容相同。" -ForegroundColor Gray
    Write-Host ""

    Read-Host "按 Enter 結束"
    exit 0
}

Write-Host ""
Write-Host "----------------------------------------" -ForegroundColor Cyan
Write-Host "即將發布以下變更：" -ForegroundColor Cyan
Write-Host "----------------------------------------" -ForegroundColor Cyan
Write-Host ""

git status --short

Write-Host ""
Write-Host "M = 修改   A = 新增   D = 刪除" -ForegroundColor Gray
Write-Host ""

$Confirm = Read-Host "確定發布？ (Y/N)"

if ($Confirm -notmatch "^[Yy]$") {

    Write-Host ""
    Write-Host "取消發布。" -ForegroundColor Yellow

    git reset | Out-Null
    git restore --worktree "$Target" 2>$null

    Write-Host "沒有推送到 GitHub。" -ForegroundColor Green

    Read-Host "按 Enter 結束"
    exit 0
}


# ==========================================
# 7. Commit
# ==========================================

Write-Host ""
Write-Host "[7/8] 建立 Git Commit..." -ForegroundColor Yellow

$Now = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

git commit -m "Update Obsidian notes $Now"

if ($LASTEXITCODE -ne 0) {

    Write-Host ""
    Write-Host "Git commit 失敗。" -ForegroundColor Red

    Read-Host "按 Enter 結束"
    exit 1
}


# ==========================================
# Push 前再次同步
# ==========================================

Write-Host ""
Write-Host "檢查另一台電腦是否剛發布新版本..." -ForegroundColor Yellow

git pull --rebase origin main

if ($LASTEXITCODE -ne 0) {

    Write-Host ""
    Write-Host "Rebase 失敗。" -ForegroundColor Red
    Write-Host "可能桌機與筆電同時修改了相同內容。" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "為避免資料被覆蓋，目前不執行 push。" -ForegroundColor Yellow

    Read-Host "按 Enter 結束"
    exit 1
}


# ==========================================
# Push
# ==========================================

Write-Host ""
Write-Host "[8/8] Push 到 GitHub..." -ForegroundColor Yellow

git push origin main

if ($LASTEXITCODE -ne 0) {

    Write-Host ""
    Write-Host "Git push 失敗。" -ForegroundColor Red

    Read-Host "按 Enter 結束"
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "              發布成功！" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green


# ==========================================
# GitHub Actions
# ==========================================

Write-Host ""
Write-Host "GitHub Actions：" -ForegroundColor Cyan
Write-Host ""

if (Get-Command gh -ErrorAction SilentlyContinue) {

    gh run list `
        --workflow "Deploy Quartz to GitHub Pages" `
        --limit 3
}
else {

    Write-Host "找不到 gh，略過 Actions 狀態。" -ForegroundColor Yellow
}


# ==========================================
# 開啟網站
# ==========================================

Write-Host ""

$Open = Read-Host "是否開啟 Quartz 網站？ (Y/N)"

if ($Open -match "^[Yy]$") {
    Start-Process $Website
}

Write-Host ""
Read-Host "按 Enter 關閉"