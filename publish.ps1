$ErrorActionPreference = "Stop"

# ==========================================
# Obsidian -> Quartz
# Desktop / Laptop Final Publisher
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
# 3. Check patch script
# ==========================================

Write-Host ""
Write-Host "[3/10] 檢查 Canvas Patch..." -ForegroundColor Yellow

if (-not (Test-Path $PatchCanvasScript)) {
    Write-Host ""
    Write-Host "找不到 patch-canvas-page.ps1：" -ForegroundColor Red
    Write-Host $PatchCanvasScript -ForegroundColor Red
    Read-Host "按 Enter 結束"
    exit 1
}

Write-Host "OK：Canvas Patch 已找到" -ForegroundColor Green

# ==========================================
# 4. Check Git clean
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
    Write-Host "為避免覆蓋 Quartz 程式或設定，停止發布。" -ForegroundColor Yellow
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
# 7. Install plugins + Patch Canvas
# ==========================================

Write-Host ""
Write-Host "[7/10] 安裝 Quartz Plugins 並修正 Canvas 附件..." -ForegroundColor Yellow

npx quartz plugin install

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "Quartz plugin install 失敗。" -ForegroundColor Red
    Read-Host "按 Enter 結束"
    exit 1
}

Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force | Out-Null
Unblock-File $PatchCanvasScript -ErrorAction SilentlyContinue

& $PatchCanvasScript

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "Canvas Patch 失敗。" -ForegroundColor Red
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
    Remove-Item "$Quartz\public" -Recurse -Force
}

npx quartz build

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "Quartz Build 失敗。" -ForegroundColor Red
    Read-Host "按 Enter 結束"
    exit 1
}

Write-Host ""
Write-Host "OK：Quartz Build 完成" -ForegroundColor Green

# ==========================================
# 9. Review changes + Commit
# ==========================================

Write-Host ""
Write-Host "[9/10] 檢查網站變更..." -ForegroundColor Yellow

git add -A

$Changes = git status --short

if (-not $Changes) {
    Write-Host ""
    Write-Host "沒有需要發布的變更。" -ForegroundColor Green
    Write-Host "Obsidian 與 Quartz 目前內容相同。" -ForegroundColor Gray
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

$Now = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

git commit -m "Update Obsidian notes $Now"

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "Git commit 失敗。" -ForegroundColor Red
    Read-Host "按 Enter 結束"
    exit 1
}

# ==========================================
# 10. Rebase + Push
# ==========================================

Write-Host ""
Write-Host "[10/10] Push 前再次同步 GitHub..." -ForegroundColor Yellow

git pull --rebase origin main

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "Rebase 失敗。" -ForegroundColor Red
    Write-Host "可能桌機與筆電同時修改相同內容。" -ForegroundColor Yellow
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
# Wait for GitHub Actions for THIS commit
# ==========================================

Write-Host ""
Write-Host "GitHub Actions：" -ForegroundColor Cyan
Write-Host ""

if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    Write-Host "找不到 gh，無法確認部署狀態。" -ForegroundColor Red
    Write-Host "本次不自動開啟網站。" -ForegroundColor Yellow
    Read-Host "按 Enter 關閉"
    exit 1
}

$CommitSHA = (git rev-parse HEAD).Trim()

Write-Host "本次 Commit：" -ForegroundColor Gray
Write-Host $CommitSHA -ForegroundColor DarkGray
Write-Host ""
Write-Host "等待 GitHub Actions 建立本次 Run..." -ForegroundColor Yellow

$RunID = $null

for ($i = 1; $i -le 60; $i++) {

    $RunID = gh run list `
        --commit $CommitSHA `
        --limit 1 `
        --json databaseId `
        --jq '.[0].databaseId' 2>$null

    if ($LASTEXITCODE -eq 0 -and $RunID) {
        $RunID = $RunID.Trim()
        break
    }

    Start-Sleep -Seconds 2
}

if (-not $RunID) {
    Write-Host ""
    Write-Host "找不到本次 Commit 對應的 GitHub Actions Run。" -ForegroundColor Red
    Write-Host "本次不自動開啟網站。" -ForegroundColor Yellow
    Read-Host "按 Enter 關閉"
    exit 1
}

Write-Host ""
Write-Host "找到 GitHub Actions Run：" -ForegroundColor Green
Write-Host "Run ID：$RunID" -ForegroundColor Gray
Write-Host ""
Write-Host "等待 GitHub Pages 部署完成..." -ForegroundColor Yellow
Write-Host ""

gh run watch $RunID --exit-status

$ActionResult = $LASTEXITCODE

Write-Host ""

if ($ActionResult -eq 0) {
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "        GitHub Pages 部署完成！" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "自動開啟最新 Quartz 網站..." -ForegroundColor Cyan

    Start-Process $Website
}
else {
    Write-Host "========================================" -ForegroundColor Red
    Write-Host "        GitHub Actions 部署失敗" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "Run ID：$RunID" -ForegroundColor Yellow
    Write-Host "網站不會自動開啟。" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "查看失敗紀錄：" -ForegroundColor Gray
    Write-Host "gh run view $RunID --log-failed" -ForegroundColor White
}

Write-Host ""
Read-Host "按 Enter 關閉"
