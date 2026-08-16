$ErrorActionPreference = "Stop"

# ==========================================
# Obsidian -> Quartz
# 桌機 / 筆電雙機發布最終版
#
# 流程：
# 1. 檢查 Vault
# 2. 檢查 Quartz
# 3. 檢查 Git 工作目錄
# 4. Git Pull
# 5. Vault -> Quartz
# 6. 清除 public + Quartz Build
# 7. 檢查變更 + 使用者確認
# 8. Git Commit
# 9. Pull Rebase + Push
# ==========================================

$Vault   = "G:\我的雲端硬碟\obsidian vault\vault_python_20260816"
$Quartz  = "C:\quartz\quartz"
$Target  = "$Quartz\content\vault_python_20260816"
$Public  = "$Quartz\public"
$Website = "https://gre888.github.io/quartz/"

Clear-Host

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "       Obsidian -> Quartz Publisher" -ForegroundColor Cyan
Write-Host "       Desktop / Laptop Final Version" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""


# ==========================================
# 1. 檢查 Vault
# ==========================================

Write-Host "[1/9] 檢查 Google Drive Vault..." -ForegroundColor Yellow

if (-not (Test-Path $Vault)) {

    Write-Host ""
    Write-Host "找不到 Vault：" -ForegroundColor Red
    Write-Host $Vault -ForegroundColor Red
    Write-Host ""
    Write-Host "請確認：" -ForegroundColor Yellow
    Write-Host "1. Google Drive 已啟動"
    Write-Host "2. Google Drive 磁碟代號為 G:"
    Write-Host "3. Vault 路徑正確"

    Read-Host "按 Enter 結束"
    exit 1
}

Write-Host "OK：Vault 已找到" -ForegroundColor Green


# ==========================================
# 2. 檢查 Quartz
# ==========================================

Write-Host ""
Write-Host "[2/9] 檢查 Quartz..." -ForegroundColor Yellow

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
Write-Host "[3/9] 檢查 Git 工作目錄..." -ForegroundColor Yellow

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
# 4. 取得 GitHub 最新版本
# ==========================================

Write-Host ""
Write-Host "[4/9] 取得 GitHub 最新版本..." -ForegroundColor Yellow

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
Write-Host "[5/9] 同步 Obsidian Vault..." -ForegroundColor Yellow

if (-not (Test-Path $Target)) {

    Write-Host "建立 Quartz Vault 目錄..." -ForegroundColor Gray

    New-Item `
        -ItemType Directory `
        -Path $Target `
        -Force | Out-Null
}


# /MIR 非常重要
#
# Obsidian 新增 -> Quartz 新增
# Obsidian 修改 -> Quartz 修改
# Obsidian 刪除 -> Quartz 刪除
#
# 排除：
# .obsidian
# .git

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


# Robocopy：
# 0~7 都不算嚴重錯誤
# >=8 才視為失敗

if ($RoboCode -ge 8) {

    Write-Host ""
    Write-Host "Robocopy 發生錯誤：$RoboCode" -ForegroundColor Red

    Read-Host "按 Enter 結束"
    exit 1
}

Write-Host ""
Write-Host "OK：Vault 同步完成" -ForegroundColor Green


# ==========================================
# 6. 清除舊 public + Quartz Build
# ==========================================

Write-Host ""
Write-Host "[6/9] 清除舊 public..." -ForegroundColor Yellow


# ------------------------------------------
# 刪除舊 public
#
# 避免已經從 Obsidian 刪除的頁面
# 仍然殘留在之前的 Build 結果
# ------------------------------------------

if (Test-Path $Public) {

    Write-Host "發現舊 public，正在完整刪除..." -ForegroundColor Gray

    try {

        Remove-Item `
            $Public `
            -Recurse `
            -Force `
            -ErrorAction Stop

    }
    catch {

        Write-Host ""
        Write-Host "public 刪除失敗。" -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor Red
        Write-Host ""
        Write-Host "請確認目前沒有其他程式正在使用 public 目錄。" -ForegroundColor Yellow

        Read-Host "按 Enter 結束"
        exit 1
    }

    Write-Host "OK：舊 public 已完整刪除" -ForegroundColor Green

}
else {

    Write-Host "public 不存在，不需要清除。" -ForegroundColor Gray
}


# ------------------------------------------
# Quartz Build
# ------------------------------------------

Write-Host ""
Write-Host "開始 Quartz Build..." -ForegroundColor Yellow
Write-Host ""

npx quartz build

if ($LASTEXITCODE -ne 0) {

    Write-Host ""
    Write-Host "========================================" -ForegroundColor Red
    Write-Host "          Quartz Build 失敗" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "目前停止發布。" -ForegroundColor Yellow
    Write-Host "不會 Commit。" -ForegroundColor Yellow
    Write-Host "不會 Push 到 GitHub。" -ForegroundColor Yellow

    Read-Host "按 Enter 結束"
    exit 1
}


# 額外確認 public 確實產生

if (-not (Test-Path $Public)) {

    Write-Host ""
    Write-Host "Quartz Build 沒有產生 public 目錄。" -ForegroundColor Red
    Write-Host "為安全起見停止發布。" -ForegroundColor Yellow

    Read-Host "按 Enter 結束"
    exit 1
}

Write-Host ""
Write-Host "OK：Quartz Build 成功" -ForegroundColor Green


# ==========================================
# 7. 檢查網站變更
# ==========================================

Write-Host ""
Write-Host "[7/9] 檢查網站變更..." -ForegroundColor Yellow

git add -A

$Changes = git status --short


# ------------------------------------------
# 沒有 Git 變更
# ------------------------------------------

if (-not $Changes) {

    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "          沒有需要發布的變更" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Obsidian 與 Quartz GitHub 內容目前相同。" -ForegroundColor Gray
    Write-Host ""

    Read-Host "按 Enter 結束"
    exit 0
}


# ------------------------------------------
# 顯示即將 Commit 的內容
# ------------------------------------------

Write-Host ""
Write-Host "----------------------------------------" -ForegroundColor Cyan
Write-Host "即將發布以下變更：" -ForegroundColor Cyan
Write-Host "----------------------------------------" -ForegroundColor Cyan
Write-Host ""

git status --short

Write-Host ""
Write-Host "----------------------------------------" -ForegroundColor Gray
Write-Host "M = 修改" -ForegroundColor Gray
Write-Host "A = 新增" -ForegroundColor Gray
Write-Host "D = 刪除" -ForegroundColor Gray
Write-Host "?? = 尚未追蹤的新檔案" -ForegroundColor Gray
Write-Host "----------------------------------------" -ForegroundColor Gray
Write-Host ""

$Confirm = Read-Host "確定發布到 GitHub？ (Y/N)"


# ==========================================
# 使用者取消
# ==========================================

if ($Confirm -notmatch "^[Yy]$") {

    Write-Host ""
    Write-Host "取消發布。" -ForegroundColor Yellow

    # 取消 git add
    git reset | Out-Null

    # 將 Target 恢復成目前 HEAD 的版本
    # 避免 Quartz content 留下尚未 Commit 的修改
    git restore --worktree "$Target" 2>$null

    Write-Host ""
    Write-Host "沒有 Commit。" -ForegroundColor Green
    Write-Host "沒有 Push 到 GitHub。" -ForegroundColor Green
    Write-Host ""
    Write-Host "注意：Obsidian Vault 本身完全不會被修改。" -ForegroundColor Gray

    Read-Host "按 Enter 結束"
    exit 0
}


# ==========================================
# 8. Git Commit
# ==========================================

Write-Host ""
Write-Host "[8/9] 建立 Git Commit..." -ForegroundColor Yellow

$Now = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

git commit -m "Update Obsidian notes $Now"

if ($LASTEXITCODE -ne 0) {

    Write-Host ""
    Write-Host "Git commit 失敗。" -ForegroundColor Red
    Write-Host "不會 Push 到 GitHub。" -ForegroundColor Yellow

    Read-Host "按 Enter 結束"
    exit 1
}

Write-Host ""
Write-Host "OK：Commit 建立完成" -ForegroundColor Green


# ==========================================
# 9. Push 前再次同步 + Push
# ==========================================

Write-Host ""
Write-Host "[9/9] Push 前檢查另一台電腦..." -ForegroundColor Yellow


# ------------------------------------------
# 防止桌機與筆電同時發布
#
# 如果另一台電腦在剛才操作期間
# 已經 Push 新 Commit
# 這裡會先抓回來
# ------------------------------------------

git pull --rebase origin main

if ($LASTEXITCODE -ne 0) {

    Write-Host ""
    Write-Host "========================================" -ForegroundColor Red
    Write-Host "            Rebase 失敗" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "可能原因：" -ForegroundColor Yellow
    Write-Host "桌機與筆電同時修改了相同內容。" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "為避免資料被覆蓋，目前不執行 push。" -ForegroundColor Yellow

    Read-Host "按 Enter 結束"
    exit 1
}

Write-Host "OK：GitHub 版本確認完成" -ForegroundColor Green


# ------------------------------------------
# Push
# ------------------------------------------

Write-Host ""
Write-Host "Push 到 GitHub..." -ForegroundColor Yellow

git push origin main

if ($LASTEXITCODE -ne 0) {

    Write-Host ""
    Write-Host "Git push 失敗。" -ForegroundColor Red

    Read-Host "按 Enter 結束"
    exit 1
}


# ==========================================
# 發布成功
# ==========================================

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "              發布成功！" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

Write-Host "完成流程：" -ForegroundColor Cyan
Write-Host ""
Write-Host "Obsidian Vault" -ForegroundColor Gray
Write-Host "      ↓"
Write-Host "Quartz content" -ForegroundColor Gray
Write-Host "      ↓"
Write-Host "清除舊 public" -ForegroundColor Gray
Write-Host "      ↓"
Write-Host "Quartz Build" -ForegroundColor Gray
Write-Host "      ↓"
Write-Host "Git Commit" -ForegroundColor Gray
Write-Host "      ↓"
Write-Host "GitHub Push" -ForegroundColor Gray
Write-Host "      ↓"
Write-Host "GitHub Actions" -ForegroundColor Gray
Write-Host "      ↓"
Write-Host "GitHub Pages" -ForegroundColor Gray


# ==========================================
# GitHub Actions
# ==========================================

Write-Host ""
Write-Host "----------------------------------------" -ForegroundColor Cyan
Write-Host "GitHub Actions 狀態" -ForegroundColor Cyan
Write-Host "----------------------------------------" -ForegroundColor Cyan
Write-Host ""

if (Get-Command gh -ErrorAction SilentlyContinue) {

    gh run list `
        --workflow "Deploy Quartz to GitHub Pages" `
        --limit 3

}
else {

    Write-Host "找不到 GitHub CLI (gh)。" -ForegroundColor Yellow
    Write-Host "略過 GitHub Actions 狀態。" -ForegroundColor Gray
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