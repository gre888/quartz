# ==========================================
# Quartz Obsidian 自動發布
# ==========================================

$ErrorActionPreference = "Stop"

# ==========================================
# 基本設定
# ==========================================

$QuartzPath = "C:\quartz\quartz"

$Source = "G:\我的雲端硬碟\obsidian vault\vault_python_20260816"

$Destination = "$QuartzPath\content\vault_python_20260816"

$SiteUrl = "https://gre888.github.io/quartz/"

# ==========================================
# 標題
# ==========================================

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "      Quartz Obsidian 自動發布" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# ==========================================
# 確認 Quartz
# ==========================================

if (-not (Test-Path $QuartzPath)) {

    Write-Host "錯誤：找不到 Quartz 資料夾！" -ForegroundColor Red
    Write-Host $QuartzPath
    exit 1
}

# ==========================================
# 確認 Obsidian Vault
# ==========================================

if (-not (Test-Path $Source)) {

    Write-Host "錯誤：找不到 Obsidian Vault！" -ForegroundColor Red
    Write-Host $Source
    exit 1
}

Set-Location $QuartzPath

# ==========================================
# [1/4] 同步 Obsidian Vault
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
Write-Host ""

# ==========================================
# [2/4] 偵測 Git 變更
# ==========================================

Write-Host "[2/4] 偵測變更..." -ForegroundColor Cyan
Write-Host ""

# 加入 staging
git add -A

# 取得變更
$Changes = @(git status --short)

# ==========================================
# 沒有變更
# ==========================================

if ($Changes.Count -eq 0) {

    Write-Host "沒有偵測到任何變更。" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "不需要 Commit，也不需要 Push。" -ForegroundColor Yellow
    Write-Host ""

    exit 0
}

# ==========================================
# 顯示變更
# ==========================================

Write-Host "偵測到以下變更：" -ForegroundColor Yellow
Write-Host ""

foreach ($Change in $Changes) {

    $Status = $Change.Substring(0,2)
    $File = $Change.Substring(3)

    switch ($Status.Trim()) {

        "M" {
            Write-Host " M  $File" -ForegroundColor Yellow
        }

        "A" {
            Write-Host " A  $File" -ForegroundColor Green
        }

        "D" {
            Write-Host " D  $File" -ForegroundColor Red
        }

        "R" {
            Write-Host " R  $File" -ForegroundColor Magenta
        }

        default {
            Write-Host " $Status  $File"
        }
    }
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "總共 $($Changes.Count) 個檔案變更" -ForegroundColor Yellow
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# ==========================================
# [3/4] 詢問是否發布
# ==========================================

$Confirm = Read-Host "是否發布？ [Y/N]"

Write-Host ""

# ==========================================
# 使用者選擇 N
# ==========================================

if ($Confirm -notmatch '^[Yy]$') {

    Write-Host "取消發布。" -ForegroundColor Yellow
    Write-Host ""

    # 自動取消 staging
    git restore --staged .

    Write-Host "已自動取消 Git Staging。" -ForegroundColor Green
    Write-Host ""
    Write-Host "你的檔案沒有被修改或刪除。" -ForegroundColor Green
    Write-Host ""

    exit 0
}

# ==========================================
# [3/4] Commit
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

# ==========================================
# [4/4] Push
# ==========================================

Write-Host "[4/4] Push 到 GitHub..." -ForegroundColor Cyan
Write-Host ""

git push

if ($LASTEXITCODE -ne 0) {

    Write-Host ""
    Write-Host "錯誤：GitHub Push 失敗！" -ForegroundColor Red
    Write-Host ""
    Write-Host "Commit 已建立，但尚未成功 Push。" -ForegroundColor Yellow
    Write-Host ""
    exit 1
}

# ==========================================
# 完成
# ==========================================

Write-Host ""
Write-Host "==========================================" -ForegroundColor Green
Write-Host "          發布完成！" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
Write-Host ""

Write-Host "GitHub Actions 正在自動建立 Quartz 網站。" -ForegroundColor Cyan
Write-Host ""

Write-Host "網站：" -ForegroundColor Cyan
Write-Host $SiteUrl -ForegroundColor White
Write-Host ""

Write-Host "請等待 GitHub Actions 完成後重新整理網站。" -ForegroundColor DarkGray
Write-Host ""
