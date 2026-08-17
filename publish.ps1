$ErrorActionPreference = "Stop"

# ==========================================
# Obsidian -> Quartz
# Desktop / Laptop Final Publisher
#
# Flow:
# 1. Check Vault
# 2. Check Quartz
# 3. Check Git clean
# 4. Pull latest
# 5. Mirror Vault -> content
# 6. Install Quartz plugins
# 7. Patch Canvas PDF/image attachment paths
# 8. Clean public + Build
# 9. Review changes + Commit + Rebase + Push
# 10. Show GitHub Actions + Open site
# ==========================================

$Vault   = "G:\我的雲端硬碟\obsidian vault\vault_python_20260816"
$Quartz  = "C:\quartz\quartz"
$Target  = "$Quartz\content\vault_python_20260816"
$Website = "https://gre888.github.io/quartz/"

$PatchCanvasScript = "$Quartz\patch-canvas-page.ps1"

Clear-Host

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "       Obsidian -> Quartz Publisher" -ForegroundColor Cyan
Write-Host "       Desktop / Laptop Final Version" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""


# ==========================================
# 1. Check Vault
# ==========================================

Write-Host "[1/10] 檢查 Google Drive Vault..." -ForegroundColor Yellow

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
# 2. Check Quartz
# ==========================================

Write-Host ""
Write-Host "[2/10] 檢查 Quartz..." -ForegroundColor Yellow

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
# 3. Check required patch script
# ==========================================

Write-Host ""
Write-Host "[3/10] 檢查 Canvas Patch..." -ForegroundColor Yellow

if (-not (Test-Path $PatchCanvasScript)) {

    Write-Host ""
    Write-Host "找不到 patch-canvas-page.ps1：" -ForegroundColor Red
    Write-Host $PatchCanvasScript -ForegroundColor Red
    Write-Host ""
    Write-Host "Canvas PDF / 圖片路徑需要這支腳本才能正確發布。" -ForegroundColor Yellow

    Read-Host "按 Enter 結束"
    exit 1
}

Write-Host "OK：Canvas Patch 已找到" -ForegroundColor Green


# ==========================================
# 4. Check Git working tree
# ==========================================

Write-Host ""
Write-Host "[4/10] 檢查 Git 工作目錄..." -ForegroundColor Yellow

$BeforeStatus = git status --porcelain

if ($BeforeStatus) {

    Write-Host ""
    Write-Host "Quartz 目前有尚未提交的修改：" -ForegroundColor Red
    Write-Host ""

    git status --short

    Write-Host ""
    Write-Host "為避免覆蓋 Quartz 程式、設定或 Canvas 修改，停止發布。" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "請先處理上面的 Git 修改，再重新執行 publish.ps1。" -ForegroundColor Yellow

    Read-Host "按 Enter 結束"
    exit 1
}

Write-Host "OK：Git 工作目錄乾淨" -ForegroundColor Green


# ==========================================
# 5. Pull latest
# ==========================================

Write-Host ""
Write-Host "[5/10] 取得 GitHub 最新版本..." -ForegroundColor Yellow

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
# 6. Vault -> Quartz
# ==========================================

Write-Host ""
Write-Host "[6/10] 同步 Obsidian Vault..." -ForegroundColor Yellow

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
# 7. Install Quartz plugins + Patch Canvas
# ==========================================

Write-Host ""
Write-Host "[7/10] 安裝 Quartz Plugins 並修正 Canvas 附件路徑..." -ForegroundColor Yellow

Write-Host ""
Write-Host "執行：npx quartz plugin install" -ForegroundColor Gray

npx quartz plugin install

if ($LASTEXITCODE -ne 0) {

    Write-Host ""
    Write-Host "Quartz plugin install 失敗。" -ForegroundColor Red

    Read-Host "按 Enter 結束"
    exit 1
}

Write-Host ""
Write-Host "執行 Canvas Patch..." -ForegroundColor Gray

# 只針對目前 PowerShell process 放行未簽署腳本。
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force | Out-Null

Unblock-File $PatchCanvasScript -ErrorAction SilentlyContinue

& $PatchCanvasScript

if ($LASTEXITCODE -ne 0) {

    Write-Host ""
    Write-Host "Canvas Patch 失敗。" -ForegroundColor Red
    Write-Host "停止發布，避免產生錯誤 PDF / 圖片連結。" -ForegroundColor Yellow

    Read-Host "按 Enter 結束"
    exit 1
}

Write-Host ""
Write-Host "OK：Canvas 附件路徑修正完成" -ForegroundColor Green


# ==========================================
# 8. Clean public + Build
# ==========================================

Write-Host ""
Write-Host "[8/10] 清除 public 並 Build Quartz..." -ForegroundColor Yellow

if (Test-Path "$Quartz\public") {

    Write-Host "清除舊 public..." -ForegroundColor Gray

    Remove-Item `
        "$Quartz\public" `
        -Recurse `
        -Force
}

Write-Host ""
Write-Host "開始 Quartz Build..." -ForegroundColor Gray

npx quartz build

if ($LASTEXITCODE -ne 0) {

    Write-Host ""
    Write-Host "Quartz Build 失敗。" -ForegroundColor Red
    Write-Host "不會 Commit / Push。" -ForegroundColor Yellow

    Read-Host "按 Enter 結束"
    exit 1
}

Write-Host ""
Write-Host "OK：Quartz Build 完成" -ForegroundColor Green


# Optional PDF output check
Write-Host ""
Write-Host "PDF 輸出檢查：" -ForegroundColor Cyan

$PdfFiles = @(
    Get-ChildItem `
        "$Quartz\public" `
        -Recurse `
        -File `
        -Filter "*.pdf" `
        -ErrorAction SilentlyContinue
)

if ($PdfFiles.Count -gt 0) {

    $PdfFiles |
        Select-Object FullName |
        Format-Table -AutoSize
}
else {

    Write-Host "目前 public 沒有 PDF。" -ForegroundColor Gray
}


# ==========================================
# 9. Review changes + Commit
# ==========================================

Write-Host ""
Write-Host "[9/10] 檢查網站變更..." -ForegroundColor Yellow

git add -A

$Changes = git status --short

if (-not $Changes) {

    Write-Host ""
    Write-Host "沒有需要發布的 Git 變更。" -ForegroundColor Green
    Write-Host "Obsidian 與 Quartz content 目前相同。" -ForegroundColor Gray
    Write-Host ""
    Write-Host "網站仍已完成本機 Build。" -ForegroundColor Gray

    Write-Host ""
    Write-Host "自動開啟 Quartz 網站..." -ForegroundColor Cyan
    Start-Process $Website

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

    # 還原 content，避免 /MIR 同步結果殘留在 Quartz 工作目錄。
    git restore --worktree "$Target" 2>$null

    Write-Host "沒有推送到 GitHub。" -ForegroundColor Green

    Read-Host "按 Enter 結束"
    exit 0
}


$Now = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

git commit -m "Update Obsidian notes $Now"

if ($LASTEXITCODE -ne 0) {

    Write-Host ""
    Write-Host "Git commit 失敗。" -ForegroundColor Red

    Read-Host "按 Enter 結束"
    exit 1
}


# ==========================================
# 10. Rebase + Push + Actions + Open site
# ==========================================

Write-Host ""
Write-Host "[10/10] Push 前再次同步 GitHub..." -ForegroundColor Yellow

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

Write-Host ""
Write-Host "Push 到 GitHub..." -ForegroundColor Yellow

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
# Open website automatically
# ==========================================

Write-Host ""
Write-Host "自動開啟 Quartz 網站..." -ForegroundColor Cyan

Start-Process $Website

Write-Host ""
Read-Host "按 Enter 關閉"
