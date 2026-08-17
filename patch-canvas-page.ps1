$ErrorActionPreference = "Stop"

# ==========================================
# Quartz Canvas Page Patch - Cross Platform
#
# Windows 本機：
#   C:\quartz\quartz\patch-canvas-page.ps1
#
# GitHub Actions：
#   /home/runner/work/quartz/quartz/patch-canvas-page.ps1
#
# 使用 $PSScriptRoot 自動取得 Quartz 專案根目錄，
# 不再寫死 C:\quartz\quartz。
# ==========================================

$QuartzRoot = $PSScriptRoot

$Targets = @(
    (Join-Path $QuartzRoot "node_modules/@quartz-community/canvas-page/dist/components/index.js"),
    (Join-Path $QuartzRoot "node_modules/@quartz-community/canvas-page/dist/index.js")
)

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " Quartz Canvas Page Patch" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "QuartzRoot：" -ForegroundColor Gray
Write-Host $QuartzRoot -ForegroundColor DarkGray
Write-Host ""

$OldCode = 'const fileSlug = slugifyFilePath(node.file);'

$NewCode = @'
const normalizedFile = node.file.replace(/\\/g, "/");
const rawFileSlug = slugifyFilePath(normalizedFile);
const vaultRoot = slug.split("/")[0];
const fileSlug = normalizedFile.startsWith("attch/")
  ? `${vaultRoot}/${rawFileSlug}`
  : rawFileSlug;
'@

$PatchedCount = 0

foreach ($Target in $Targets) {

    Write-Host "檢查：" -ForegroundColor Yellow
    Write-Host $Target -ForegroundColor Gray

    if (-not (Test-Path $Target)) {

        Write-Host ""
        Write-Host "找不到檔案：" -ForegroundColor Red
        Write-Host $Target -ForegroundColor Red
        Write-Host ""
        Write-Host "列出 canvas-page dist 內容供除錯：" -ForegroundColor Yellow

        $CanvasDist = Join-Path $QuartzRoot "node_modules/@quartz-community/canvas-page/dist"

        if (Test-Path $CanvasDist) {
            Get-ChildItem $CanvasDist -Recurse -File |
                Select-Object FullName
        }
        else {
            Write-Host "連 canvas-page/dist 都不存在。" -ForegroundColor Red
        }

        exit 1
    }

    $Content = Get-Content $Target -Raw -Encoding UTF8

    # 已經 Patch 過則跳過
    if (
        $Content.Contains('const normalizedFile = node.file.replace(/\\/g, "/");') -and
        $Content.Contains('normalizedFile.startsWith("attch/")')
    ) {

        Write-Host "已經 Patch，跳過。" -ForegroundColor Green
        Write-Host ""
        continue
    }

    if (-not $Content.Contains($OldCode)) {

        Write-Host ""
        Write-Host "找不到預期的原始程式：" -ForegroundColor Red
        Write-Host $OldCode -ForegroundColor DarkGray
        Write-Host ""
        Write-Host "canvas-page 套件內容可能已變更，停止 Patch。" -ForegroundColor Yellow

        # 顯示可能相關的行，方便 GitHub Actions log 除錯
        Write-Host ""
        Write-Host "搜尋 fileSlug：" -ForegroundColor Cyan

        Select-String `
            -Path $Target `
            -Pattern "fileSlug|slugifyFilePath|resolveRelative" `
            -Context 1,2

        exit 1
    }

    # 本機備份；node_modules 不會進 Git
    $Backup = "$Target.before-canvas-patch"

    if (-not (Test-Path $Backup)) {
        Copy-Item $Target $Backup -Force
        Write-Host "已建立備份：" -ForegroundColor DarkGray
        Write-Host $Backup -ForegroundColor DarkGray
    }

    $NewContent = $Content.Replace($OldCode, $NewCode)

    $Utf8NoBom = New-Object System.Text.UTF8Encoding($false)

    [System.IO.File]::WriteAllText(
        $Target,
        $NewContent,
        $Utf8NoBom
    )

    $PatchedCount++

    Write-Host "Patch 完成。" -ForegroundColor Green
    Write-Host ""
}

Write-Host "========================================" -ForegroundColor Green
Write-Host " Canvas Patch 完成" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

if ($PatchedCount -gt 0) {
    Write-Host "本次修改檔案數：$PatchedCount" -ForegroundColor Green
}
else {
    Write-Host "所有目標檔案都已經 Patch。" -ForegroundColor Gray
}

Write-Host ""
Write-Host "附件規則：" -ForegroundColor Cyan
Write-Host "attch/xxx.ext" -ForegroundColor Gray
Write-Host "        ↓"
Write-Host "vault_python_20260816/attch/<Quartz slug>" -ForegroundColor Gray
Write-Host ""
