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
# [1/5] 同步 Obsidian Vault
# ==========================================

Write-Host "[1/5] 同步 Obsidian Vault..." -ForegroundColor Cyan
Write-Host ""

robocopy $Source $Destination /MIR /XD ".obsidian" /R:2 /W:2

$RobocopyExitCode = $LASTEXITCODE

if ($RobocopyExitCode -gt 7) {

    Write-Host ""
    Write-Host "錯誤：Obsidian Vault 同步失敗！" -ForegroundColor Red
    Write-Host "Robocopy 結束代碼：$RobocopyExitCode" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "同步完成！" -ForegroundColor Green
Write-Host ""

# ==========================================
# [2/5] 自動轉換 Canvas 圖片節點
# ==========================================

Write-Host "[2/5] 處理 Canvas 圖片節點..." -ForegroundColor Cyan
Write-Host ""

$CanvasFiles = @(
    Get-ChildItem `
        -Path $Destination `
        -Recurse `
        -File `
        -Filter "*.canvas"
)

if ($CanvasFiles.Count -eq 0) {

    Write-Host "沒有找到 Canvas 檔案。" -ForegroundColor Yellow
}
else {

    Write-Host "找到 $($CanvasFiles.Count) 個 Canvas 檔案。" -ForegroundColor Green
    Write-Host ""

    foreach ($CanvasFile in $CanvasFiles) {

        Write-Host "處理：$($CanvasFile.FullName)" -ForegroundColor Gray

        try {

            $Canvas = Get-Content `
                -Path $CanvasFile.FullName `
                -Raw `
                -Encoding UTF8 |
                ConvertFrom-Json

            $CanvasChanged = $false
            $ConvertedCount = 0

            foreach ($Node in $Canvas.nodes) {

                if (
                    $Node.type -eq "file" -and
                    $Node.file -match '\.(png|jpg|jpeg|gif|webp)$'
                ) {

                    $ImagePath = (($Node.file -replace '\\', '/') -split '/' | ForEach-Object { [System.Uri]::EscapeDataString($_) }) -join '/'

                    $Node.type = "text"
                    $Node.PSObject.Properties.Remove("file")

                    $Node |
                        Add-Member `
                            -NotePropertyName "text" `
                            -NotePropertyValue "![]($ImagePath)" `
                            -Force

                    $CanvasChanged = $true
                    $ConvertedCount++

                    Write-Host "  已轉換圖片：$ImagePath" -ForegroundColor Green
                }
            }

            if ($CanvasChanged) {

                $CanvasJson = $Canvas | ConvertTo-Json -Depth 100
                $Utf8NoBom = New-Object System.Text.UTF8Encoding($false)

                [System.IO.File]::WriteAllText(
                    $CanvasFile.FullName,
                    $CanvasJson,
                    $Utf8NoBom
                )

                Write-Host "  完成：轉換 $ConvertedCount 個圖片節點。" -ForegroundColor Green
            }
            else {

                Write-Host "  沒有需要轉換的圖片節點。" -ForegroundColor DarkGray
            }
        }
        catch {

            Write-Host ""
            Write-Host "錯誤：Canvas 處理失敗！" -ForegroundColor Red
            Write-Host $CanvasFile.FullName -ForegroundColor Red
            Write-Host $_.Exception.Message -ForegroundColor Red
            exit 1
        }

        Write-Host ""
    }
}

Write-Host "Canvas 圖片節點處理完成！" -ForegroundColor Green
Write-Host ""

# ==========================================
# [3/5] 偵測 Git 變更
# ==========================================

Write-Host "[3/5] 偵測 Git 變更..." -ForegroundColor Cyan
Write-Host ""

git add -A

if ($LASTEXITCODE -ne 0) {

    Write-Host "錯誤：git add 失敗！" -ForegroundColor Red
    exit 1
}

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

    if ($Change.Length -ge 3) {

        $Status = $Change.Substring(0, 2)
        $File = $Change.Substring(3)
    }
    else {

        $Status = $Change
        $File = ""
    }

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
# 詢問是否發布
# ==========================================

$Confirm = Read-Host "是否發布？ [Y/N]"

Write-Host ""

if ($Confirm -notmatch '^[Yy]$') {

    Write-Host "取消發布。" -ForegroundColor Yellow
    Write-Host ""

    git restore --staged .

    Write-Host "已取消 Git Staging。" -ForegroundColor Green
    Write-Host ""
    Write-Host "同步到 content 的檔案會保留，但不會 Commit 或 Push。" -ForegroundColor Yellow
    Write-Host ""
    exit 0
}

# ==========================================
# [4/5] 建立 Git Commit
# ==========================================

Write-Host "[4/5] 建立 Git Commit..." -ForegroundColor Cyan
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
# [5/5] Push 到 GitHub
# ==========================================

Write-Host "[5/5] Push 到 GitHub..." -ForegroundColor Cyan
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
# GitHub Actions 部署狀態
# ==========================================

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "       GitHub Actions 部署狀態" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# ==========================================
# 檢查 GitHub CLI
# ==========================================

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

# ==========================================
# 等待 GitHub Actions 建立
# ==========================================

Write-Host "等待 GitHub Actions 啟動..." -ForegroundColor Cyan
Write-Host ""

$RunId = $null
$CurrentCommit = git rev-parse HEAD

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

            if ($RunObject.headSha -eq $CurrentCommit) {

                $RunId = $RunObject.databaseId
                break
            }
        }
        catch {

            Write-Host "等待 Actions 資料..." -ForegroundColor DarkGray
        }
    }

    Start-Sleep -Seconds 2
}

# ==========================================
# 找不到 Actions
# ==========================================

if ($null -eq $RunId) {

    Write-Host "無法取得最新 GitHub Actions Run。" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "請手動查看：" -ForegroundColor Cyan
    Write-Host "https://github.com/$Repo/actions" -ForegroundColor White
    Write-Host ""

    Start-Process $SiteUrl
    exit 0
}

# ==========================================
# 顯示 Run ID
# ==========================================

Write-Host "GitHub Actions Run ID：" -ForegroundColor Cyan
Write-Host $RunId -ForegroundColor White
Write-Host ""

Write-Host "正在等待 Quartz 部署完成..." -ForegroundColor Cyan
Write-Host ""

# ==========================================
# Watch Actions
# ==========================================

gh run watch $RunId `
    --repo $Repo `
    --compact `
    --exit-status

$ActionsResult = $LASTEXITCODE

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan

if ($ActionsResult -eq 0) {

    Write-Host "       GitHub Actions：成功" -ForegroundColor Green
    Write-Host "       Quartz：部署完成" -ForegroundColor Green
}
else {

    Write-Host "       GitHub Actions：失敗" -ForegroundColor Red
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