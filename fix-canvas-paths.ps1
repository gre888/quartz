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

        Write-Host "------------------------------" -ForegroundColor DarkGray
        Write-Host "Node type = $($Node.type)" -ForegroundColor Gray
        Write-Host "Node file = $($Node.file)" -ForegroundColor Gray

        if (-not $Node.file) {
            Write-Host "跳過：沒有 file 欄位" -ForegroundColor DarkGray
            continue
        }

        $OriginalPath = ($Node.file -replace '\\', '/').TrimStart('/')

        Write-Host "OriginalPath = $OriginalPath" -ForegroundColor Gray

        # 只要路徑裡包含 attch/ 就處理
        if ($OriginalPath -notmatch '(^|/)attch/') {
            Write-Host "跳過：不是 attch 附件" -ForegroundColor DarkGray
            continue
        }

        # 如果 attch/ 前面還有其他資料夾，裁成 attch/... 開始
        $AttchIndex = $OriginalPath.IndexOf("attch/")

        if ($AttchIndex -ge 0) {
            $OriginalPath = $OriginalPath.Substring($AttchIndex)
        }

        $Segments = $OriginalPath -split '/'
        $FileName = $Segments[-1]

        # 配合目前 Quartz 實際輸出的附件檔名：
        # Python and Django(...).pdf
        # -> python-and-django(...).pdf
        $SlugFileName = $FileName.ToLowerInvariant() -replace '\s+', '-'

        $WebPath = "$WebVaultRoot/attch/$SlugFileName"

        # ======================================
        # 圖片
        # ======================================
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

            Write-Host "圖片轉換成功：" -ForegroundColor Green
            Write-Host "  $OriginalPath" -ForegroundColor Gray
            Write-Host "  -> $WebPath" -ForegroundColor DarkGray
        }

        # ======================================
        # PDF
        # ======================================
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

            Write-Host "PDF 轉換成功：" -ForegroundColor Cyan
            Write-Host "  $OriginalPath" -ForegroundColor Gray
            Write-Host "  -> $WebPath" -ForegroundColor DarkGray
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
