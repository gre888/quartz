param(
    [Parameter(Mandatory = $false)]
    [string]$Target = "./content/vault_python_20260816",

    [Parameter(Mandatory = $false)]
    [string]$WebVaultRoot = "/quartz/vault_python_20260816"
)

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " Quartz Canvas Attachment Path Fixer" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Target: $Target" -ForegroundColor Gray
Write-Host "Web root: $WebVaultRoot" -ForegroundColor Gray
Write-Host ""

if (-not (Test-Path $Target)) {
    Write-Host "找不到 Target：" -ForegroundColor Red
    Write-Host $Target -ForegroundColor Red
    exit 1
}

function Convert-ToQuartzSlug {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Name
    )

    # 依目前 Quartz 實際輸出：
    # Python and Django(...).pdf
    # -> python-and-django(...).pdf
    #
    # 英文轉小寫、連續空白轉成 "-"
    $Slug = $Name.ToLowerInvariant()
    $Slug = $Slug -replace '\s+', '-'

    return $Slug
}

$CanvasFiles = @(
    Get-ChildItem `
        -Path $Target `
        -Recurse `
        -File `
        -Filter "*.canvas"
)

if ($CanvasFiles.Count -eq 0) {
    Write-Host "沒有找到 Canvas 檔案。" -ForegroundColor Gray
    exit 0
}

Write-Host "找到 $($CanvasFiles.Count) 個 Canvas 檔案。" -ForegroundColor Green

$TotalConverted = 0

foreach ($CanvasFile in $CanvasFiles) {

    Write-Host ""
    Write-Host "處理：" -ForegroundColor Gray
    Write-Host $CanvasFile.FullName -ForegroundColor DarkGray

    $Raw = Get-Content `
        -Path $CanvasFile.FullName `
        -Raw `
        -Encoding UTF8

    $Canvas = $Raw | ConvertFrom-Json
    $Changed = $false

    foreach ($Node in $Canvas.nodes) {

        if ($Node.type -ne "file" -or -not $Node.file) {
            continue
        }

        $OriginalPath = ($Node.file -replace '\\', '/').TrimStart('/')

        # 目前你的附件都從 Vault 根目錄的 attch/ 取用。
        # 不碰其他相對路徑，避免誤轉一般 Canvas file node。
        if ($OriginalPath -notmatch '^attch/') {
            continue
        }

        $Segments = $OriginalPath -split '/'
        $FileName = $Segments[-1]
        $DirSegments = @()

        if ($Segments.Count -gt 1) {
            $DirSegments = $Segments[0..($Segments.Count - 2)]
        }

        $SlugFileName = Convert-ToQuartzSlug -Name $FileName

        $WebSegments = @()
        $WebSegments += $WebVaultRoot.TrimEnd('/')

        if ($DirSegments.Count -gt 0) {
            $WebSegments += ($DirSegments -join '/')
        }

        $WebSegments += $SlugFileName
        $WebPath = ($WebSegments -join '/')

        # 圖片 -> Markdown 圖片
        if ($OriginalPath -match '\.(png|jpg|jpeg|gif|webp|svg)$') {

            $Node.type = "text"
            $Node.PSObject.Properties.Remove("file")

            $Node |
                Add-Member `
                    -NotePropertyName "text" `
                    -NotePropertyValue "![]($WebPath)" `
                    -Force

            $Changed = $true
            $TotalConverted++

            Write-Host "  圖片：$OriginalPath" -ForegroundColor Green
            Write-Host "       -> $WebPath" -ForegroundColor DarkGray
        }

        # PDF -> Markdown 可點擊連結
        elseif ($OriginalPath -match '\.pdf$') {

            $Node.type = "text"
            $Node.PSObject.Properties.Remove("file")

            $Node |
                Add-Member `
                    -NotePropertyName "text" `
                    -NotePropertyValue "[開啟 PDF：$FileName]($WebPath)" `
                    -Force

            $Changed = $true
            $TotalConverted++

            Write-Host "  PDF：$OriginalPath" -ForegroundColor Cyan
            Write-Host "       -> $WebPath" -ForegroundColor DarkGray
        }
    }

    if ($Changed) {

        $Json = $Canvas | ConvertTo-Json -Depth 100
        $Utf8NoBom = New-Object System.Text.UTF8Encoding($false)

        [System.IO.File]::WriteAllText(
            $CanvasFile.FullName,
            $Json,
            $Utf8NoBom
        )

        Write-Host "  OK：Canvas 已轉換" -ForegroundColor Green
    }
    else {
        Write-Host "  無需轉換" -ForegroundColor DarkGray
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Canvas 路徑處理完成，共轉換 $TotalConverted 個附件節點。" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
