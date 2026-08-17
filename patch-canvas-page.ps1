$ErrorActionPreference = "Stop"

# ==========================================
# Quartz Canvas Page Patch
# Compiled JS Exact Patch Version
#
# 目標：
# 1. 支援編譯後實際變數 slug2
# 2. 將 attch/... 補成 vault_python_20260816/attch/...
# 3. PDF href 強制改成 /quartz/${fileSlug}
# 4. Patch 後自動驗證，失敗就 exit 1
# ==========================================

$QuartzRoot = $PSScriptRoot

$Targets = @(
    (Join-Path $QuartzRoot ".quartz/plugins/canvas-page/dist/components/index.js"),
    (Join-Path $QuartzRoot ".quartz/plugins/canvas-page/dist/index.js"),
    (Join-Path $QuartzRoot "node_modules/@quartz-community/canvas-page/dist/components/index.js"),
    (Join-Path $QuartzRoot "node_modules/@quartz-community/canvas-page/dist/index.js")
)

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " Quartz Canvas Compiled JS Patch" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "QuartzRoot：" -ForegroundColor Gray
Write-Host $QuartzRoot -ForegroundColor DarkGray
Write-Host ""

$PatchedFiles = 0

foreach ($Target in $Targets) {

    Write-Host "----------------------------------------" -ForegroundColor DarkGray
    Write-Host "處理：" -ForegroundColor Yellow
    Write-Host $Target -ForegroundColor Gray

    if (-not (Test-Path $Target)) {
        Write-Host "找不到檔案。" -ForegroundColor Red
        exit 1
    }

    $Content = Get-Content $Target -Raw -Encoding UTF8
    $OriginalContent = $Content

    # ======================================
    # Patch A
    # fileSlug 區塊
    # ======================================

    $OldOriginal = 'const fileSlug = slugifyFilePath(node.file);'

    $OldPreviousPatch = @'
const normalizedFile = node.file.replace(/\\/g, "/");
const rawFileSlug = slugifyFilePath(normalizedFile);
const vaultRoot = slug.split("/")[0];
const fileSlug = normalizedFile.startsWith("attch/")
  ? `${vaultRoot}/${rawFileSlug}`
  : rawFileSlug;
'@

    $NewFileSlugBlock = @'
const normalizedFile = node.file.replace(/\\/g, "/");
const rawFileSlug = slugifyFilePath(normalizedFile);
const vaultRoot = slug2.split("/")[0];
const fileSlug = normalizedFile.startsWith("attch/")
  ? `${vaultRoot}/${rawFileSlug}`
  : rawFileSlug;
const isPdf = /\.pdf$/i.test(node.file);
const resolvedFileHref = isPdf
  ? `/quartz/${fileSlug}`
  : resolveRelative(slug2, fileSlug);
'@

    if ($Content.Contains($OldPreviousPatch)) {

        $Content = $Content.Replace(
            $OldPreviousPatch,
            $NewFileSlugBlock
        )

        Write-Host "已把舊版 fileSlug Patch 升級為 slug2 + PDF absolute URL。" -ForegroundColor Green

    }
    elseif ($Content.Contains($OldOriginal)) {

        $Content = $Content.Replace(
            $OldOriginal,
            $NewFileSlugBlock
        )

        Write-Host "已加入 fileSlug + slug2 + PDF absolute URL。" -ForegroundColor Green

    }
    elseif (
        $Content.Contains('const vaultRoot = slug2.split("/")[0];') -and
        $Content.Contains('const resolvedFileHref = isPdf') -and
        $Content.Contains('? `/quartz/${fileSlug}`')
    ) {

        Write-Host "fileSlug Patch 已存在。" -ForegroundColor Gray

    }
    else {

        Write-Host ""
        Write-Host "找不到可辨識的 fileSlug 區塊。" -ForegroundColor Red
        Write-Host "停止，避免誤改。" -ForegroundColor Yellow

        Select-String `
            -Path $Target `
            -Pattern "normalizedFile|fileSlug|slugifyFilePath|slug2" `
            -Context 2,3

        exit 1
    }

    # ======================================
    # Patch B
    # 編譯後實際 href：
    # href: resolveRelative(slug2, fileSlug)
    # 改成：
    # href: resolvedFileHref
    # ======================================

    $HrefPattern = 'href:\s*resolveRelative\(slug2,\s*fileSlug\)'

    $HrefCountBefore = ([regex]::Matches(
        $Content,
        $HrefPattern
    )).Count

    if ($HrefCountBefore -gt 0) {

        $Content = [regex]::Replace(
            $Content,
            $HrefPattern,
            'href: resolvedFileHref'
        )

        Write-Host "已修改 href：$HrefCountBefore 處。" -ForegroundColor Green

    }
    elseif ($Content.Contains('href: resolvedFileHref')) {

        Write-Host "href Patch 已存在。" -ForegroundColor Gray

    }
    else {

        Write-Host ""
        Write-Host "找不到 href: resolveRelative(slug2, fileSlug)。" -ForegroundColor Red
        Write-Host "停止，避免 Patch 不完整。" -ForegroundColor Yellow

        Select-String `
            -Path $Target `
            -Pattern "href:|resolveRelative\(slug2|fileSlug" `
            -Context 1,2

        exit 1
    }

    # ======================================
    # 寫回
    # ======================================

    if ($Content -ne $OriginalContent) {

        $Backup = "$Target.before-exact-patch"

        if (-not (Test-Path $Backup)) {
            Copy-Item $Target $Backup -Force
        }

        $Utf8NoBom = New-Object System.Text.UTF8Encoding($false)

        [System.IO.File]::WriteAllText(
            $Target,
            $Content,
            $Utf8NoBom
        )

        $PatchedFiles++

        Write-Host "檔案已寫入。" -ForegroundColor Green
    }
    else {
        Write-Host "檔案內容已是目標狀態。" -ForegroundColor Gray
    }

    # ======================================
    # Patch 後驗證
    # ======================================

    $Verify = Get-Content $Target -Raw -Encoding UTF8

    $Checks = @{
        "vaultRoot 使用 slug2" =
            $Verify.Contains('const vaultRoot = slug2.split("/")[0];')

        "PDF absolute URL" =
            $Verify.Contains('? `/quartz/${fileSlug}`')

        "resolvedFileHref 存在" =
            $Verify.Contains('const resolvedFileHref = isPdf')

        "舊 href 已移除" =
            -not [regex]::IsMatch(
                $Verify,
                'href:\s*resolveRelative\(slug2,\s*fileSlug\)'
            )

        "新 href 存在" =
            $Verify.Contains('href: resolvedFileHref')
    }

    Write-Host ""
    Write-Host "驗證：" -ForegroundColor Cyan

    $Failed = $false

    foreach ($Name in $Checks.Keys) {

        if ($Checks[$Name]) {
            Write-Host "  OK  $Name" -ForegroundColor Green
        }
        else {
            Write-Host "  FAIL $Name" -ForegroundColor Red
            $Failed = $true
        }
    }

    if ($Failed) {
        Write-Host ""
        Write-Host "Patch 驗證失敗，停止。" -ForegroundColor Red
        exit 1
    }

    Write-Host ""
}

Write-Host "========================================" -ForegroundColor Green
Write-Host " Canvas Compiled JS Patch 完成" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "修改檔案數：$PatchedFiles" -ForegroundColor Green
Write-Host ""
Write-Host "預期 Canvas PDF href：" -ForegroundColor Cyan
Write-Host '/quartz/vault_python_20260816/attch/python-and-django(...).pdf' -ForegroundColor Gray
Write-Host ""
