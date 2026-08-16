# ============================================
# Quartz 自動發布腳本
# 流程：
# 1. 進入 Quartz 目錄
# 2. 刪除舊 public
# 3. 重新 Build
# 4. Git add
# 5. Git commit
# 6. Git push
# ============================================

$ErrorActionPreference = "Stop"

# Quartz 專案位置
$QuartzPath = "C:\quartz\quartz"

Write-Host ""
Write-Host "========================================"
Write-Host " Quartz 自動發布開始"
Write-Host "========================================"
Write-Host ""

# 進入 Quartz 專案
Set-Location $QuartzPath

Write-Host "[1/5] 清除舊 public..."

if (Test-Path ".\public") {
    Remove-Item ".\public" -Recurse -Force
    Write-Host "public 已刪除"
}
else {
    Write-Host "public 不存在，跳過"
}

Write-Host ""
Write-Host "[2/5] Quartz Build..."

npx quartz build

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "Quartz Build 失敗！"
    exit 1
}

Write-Host ""
Write-Host "[3/5] Git add..."

git add -A

Write-Host ""
Write-Host "[4/5] Git commit..."

# 檢查是否真的有變更
$Changes = git status --porcelain

if ($Changes) {

    # 自動產生時間
    $Time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    git commit -m "Quartz publish $Time"

    if ($LASTEXITCODE -ne 0) {
        Write-Host ""
        Write-Host "Git commit 失敗！"
        exit 1
    }

}
else {
    Write-Host "沒有 Git 變更，不需要 commit"
}

Write-Host ""
Write-Host "[5/5] Git push..."

git push

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "Git push 失敗！"
    exit 1
}

Write-Host ""
Write-Host "========================================"
Write-Host " Quartz 發布完成"
Write-Host "========================================"
Write-Host ""

Read-Host "按 Enter 關閉"