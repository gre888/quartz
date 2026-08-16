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

$Repo = "gre888/quartz"

$WorkflowName = "Deploy Quartz to GitHub Pages"

# ==========================================
# 標題
# ==========================================

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "      Quartz Obsidian 自動發布" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# ==========================================
# 確認路徑
# ==========================================

if (-not (Test-Path $QuartzPath)) {

    Write-Host "錯誤：找不到 Quartz 資料夾！" -ForegroundColor Red
    Write-Host $QuartzPath
    exit 1
}

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

git add -A

$Changes = @(git status --short)

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

if ($Confirm -notmatch '^[Yy]$') {

    Write-Host "取消發布。" -ForegroundColor Yellow
    Write-Host ""

    git restore --staged .

    Write-Host "已自動取消 Git Staging。" -ForegroundColor Green
    Write-Host ""
    Write-Host "你的檔案沒有被修改或刪除。" -ForegroundColor Green
    Write-Host ""

    exit 0
}

# ==========================================
# Commit
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

Write-Host ""
Write-Host "GitHub Push 成功！" -ForegroundColor Green
Write-Host ""

# ==========================================
# GitHub Actions 狀態
# ==========================================

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "       GitHub Actions 部署狀態" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# ------------------------------------------
# 檢查 GitHub CLI
# ------------------------------------------

$GhCommand = Get-Command gh -ErrorAction SilentlyContinue

if ($null -eq $GhCommand) {

    Write-Host "找不到 GitHub CLI (gh)。" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "因此無法在 PowerShell 中直接取得 Actions 狀態。" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "請手動查看：" -ForegroundColor Cyan
    Write-Host "https://github.com/$Repo/actions" -ForegroundColor White
    Write-Host ""

    Start-Process $SiteUrl

    Write-Host "已開啟網站。" -ForegroundColor Green
    Write-Host ""

    exit 0
}

# ------------------------------------------
# 等待 GitHub Actions 建立
# ------------------------------------------

Write-Host "等待 GitHub Actions 啟動..." -ForegroundColor Cyan
Write-Host ""

$RunId = $null

for ($i = 1; $i -le 15; $i++) {

    $Run = gh run list `
        --repo $Repo `
        --workflow "$WorkflowName" `
        --branch main `
        --limit 1 `
        --json databaseId,headSha,status,conclusion `
        --jq '.[0]'

    if ($LASTEXITCODE -eq 0 -and $Run) {

        try {

            $RunObject = $Run | ConvertFrom-Json

            if ($RunObject.headSha -eq (git rev-parse HEAD)) {

                $RunId = $RunObject.databaseId
                break
            }

        }
        catch {
        }
    }

    Start-Sleep -Seconds 2
}

# ------------------------------------------
# 找不到 Actions
# ------------------------------------------

if ($null -eq $RunId) {

    Write-Host "無法取得最新 GitHub Actions Run。" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "請手動查看：" -ForegroundColor Cyan
    Write-Host "https://github.com/$Repo/actions" -ForegroundColor White
    Write-Host ""

    Start-Process $SiteUrl

    exit 0
}

# ------------------------------------------
# 顯示 Run ID
# ------------------------------------------

Write-Host "GitHub Actions Run ID：" -ForegroundColor Cyan
Write-Host $RunId -ForegroundColor White
Write-Host ""

Write-Host "正在等待 Quartz 部署完成..." -ForegroundColor Cyan
Write-Host ""

# ------------------------------------------
# Watch Actions
# ------------------------------------------

gh run watch $RunId `
    --repo $Repo `
    --compact `
    --exit-status

$ActionsResult = $LASTEXITCODE

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan

if ($ActionsResult -eq 0) {

    Write-Host "       GitHub Actions：成功 ✓" -ForegroundColor Green
    Write-Host "       Quartz：部署完成 ✓" -ForegroundColor Green

}
else {

    Write-Host "       GitHub Actions：失敗 ✗" -ForegroundColor Red
    Write-Host ""
    Write-Host "請查看 Actions 詳細錯誤：" -ForegroundColor Yellow
    Write-Host "https://github.com/$Repo/actions" -ForegroundColor White
}

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# ==========================================
# 自動開啟網站
# ==========================================

Write-Host "網站：" -ForegroundColor Cyan
Write-Host $SiteUrl -ForegroundColor White
Write-Host ""

Write-Host "正在開啟網站..." -ForegroundColor Cyan

Start-Process $SiteUrl

Write-Host ""
Write-Host "==========================================" -ForegroundColor Green
Write-Host "          發布流程完成！" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
Write-Host ""
