$ErrorActionPreference = "Stop"

# ==========================================
# Quartz Canvas Page Patch
#
# Obsidian Canvas 附件固定寫成：
#   attch/filename.ext
#
# Quartz 實際附件位於：
#   content/vault_python_20260816/attch/
#
# 本 Patch 會修正 canvas-page renderer，
# 讓圖片 / PDF 都指向正確的 Quartz slug。
# ==========================================

$QuartzRoot = "C:\quartz\quartz"

$Targets = @(
    "$QuartzRoot\node_modules\@quartz-community\canvas-page\dist\components\index.js",
    "$QuartzRoot\node_modules\@quartz-community\canvas-page\dist\index.js"
)

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " Quartz Canvas Page Patch" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
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
        Write-Host "找不到檔案，停止 Patch。" -ForegroundColor Red
        exit 1
    }

    $Content = Get-Content $Target -Raw -Encoding UTF8

    if (
        $Content.Contains('const normalizedFile = node.file.replace(/\\/g, "/");') -and
        $Content.Contains('normalizedFile.startsWith("attch/")')
    ) {
        Write-Host "已經 Patch，跳過。" -ForegroundColor Green
        Write-Host ""
        continue
    }

    if (-not $Content.Contains($OldCode)) {
        Write-Host "找不到預期的原始程式：" -ForegroundColor Red
        Write-Host $OldCode -ForegroundColor DarkGray
        Write-Host ""
        Write-Host "canvas-page 套件版本可能已變更，為避免破壞檔案，停止執行。" -ForegroundColor Yellow
        exit 1
    }

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
