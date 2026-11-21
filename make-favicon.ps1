# ============================================================================
#  make-favicon.ps1 — tạo favicon cho index.html từ một file ảnh PNG
# ============================================================================
#
#  Chạy:   powershell -ExecutionPolicy Bypass -File make-favicon.ps1
#
#  Script làm 4 việc:
#    1. Cắt bỏ phần viền trong suốt quanh ảnh nguồn (icon-source.png)
#    2. Đưa về canvas vuông, chừa 6% padding cho icon không sát mép
#    3. Xuất apple-touch-icon.png (180px) và shiba-icon-512.png (512px)
#    4. Chuyển 2 bản nhỏ thành base64 rồi ghi thẳng vào index.html:
#         - 64px  -> thẻ <link rel="icon">        (favicon trên tab)
#         - 96px  -> CSS .logo .mark              (logo ở nav và footer)
#       Nhờ vậy index.html vẫn là một file chạy độc lập, không cần ảnh rời.
#
#  Muốn đổi icon khác: thay file icon-source.png rồi chạy lại script này.
# ============================================================================

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

$root      = Split-Path -Parent $MyInvocation.MyCommand.Path
$srcPath   = Join-Path $root 'icon-source.png'
$htmlPath  = Join-Path $root 'index.html'

if (-not (Test-Path $srcPath))  { throw "Khong tim thay anh nguon: $srcPath" }
if (-not (Test-Path $htmlPath)) { throw "Khong tim thay index.html: $htmlPath" }

# ---------- 1. Auto-crop vung trong suot ----------
$img = [System.Drawing.Bitmap]::new($srcPath)
Write-Host "Anh nguon: $($img.Width)x$($img.Height)"

$rect   = [System.Drawing.Rectangle]::new(0, 0, $img.Width, $img.Height)
$data   = $img.LockBits($rect, [System.Drawing.Imaging.ImageLockMode]::ReadOnly,
                        [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$stride = $data.Stride
$bytes  = New-Object byte[] ($stride * $img.Height)
[System.Runtime.InteropServices.Marshal]::Copy($data.Scan0, $bytes, 0, $bytes.Length)
$img.UnlockBits($data)

$minX = $img.Width; $minY = $img.Height; $maxX = -1; $maxY = -1
for ($y = 0; $y -lt $img.Height; $y++) {
  $rowBase = $y * $stride
  for ($x = 0; $x -lt $img.Width; $x++) {
    if ($bytes[$rowBase + $x * 4 + 3] -gt 12) {   # alpha > 12 thi coi la co noi dung
      if ($x -lt $minX) { $minX = $x }
      if ($x -gt $maxX) { $maxX = $x }
      if ($y -lt $minY) { $minY = $y }
      if ($y -gt $maxY) { $maxY = $y }
    }
  }
}
if ($maxX -lt 0) { throw "Anh nguon trong suot hoan toan" }

# ---------- 2. Canvas vuong + padding ----------
$cw   = $maxX - $minX + 1
$ch   = $maxY - $minY + 1
$side = [int]([math]::Max($cw, $ch) * 1.06)
$offX = [int](($side - $cw) / 2)
$offY = [int](($side - $ch) / 2)
Write-Host "Da cat vien: ${cw}x${ch}  ->  canvas vuong ${side}x${side}"

$square = [System.Drawing.Bitmap]::new($side, $side, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$g = [System.Drawing.Graphics]::FromImage($square)
$g.Clear([System.Drawing.Color]::Transparent)
$g.DrawImage($img,
  [System.Drawing.Rectangle]::new($offX, $offY, $cw, $ch),
  [System.Drawing.Rectangle]::new($minX, $minY, $cw, $ch),
  [System.Drawing.GraphicsUnit]::Pixel)
$g.Dispose()
$img.Dispose()

# ---------- 3. Xuat cac kich thuoc ----------
function Save-Resized {
  param($bmp, [int]$size, [string]$path)
  $o  = [System.Drawing.Bitmap]::new($size, $size, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
  $gg = [System.Drawing.Graphics]::FromImage($o)
  $gg.Clear([System.Drawing.Color]::Transparent)
  $gg.InterpolationMode    = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $gg.PixelOffsetMode      = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
  $gg.SmoothingMode        = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
  $gg.CompositingQuality   = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
  $gg.DrawImage($bmp, [System.Drawing.Rectangle]::new(0, 0, $size, $size))
  $gg.Dispose()
  $o.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
  $o.Dispose()
  Write-Host ("  {0,3}px -> {1} ({2} KB)" -f $size,
    [System.IO.Path]::GetFileName($path),
    [math]::Round((Get-Item $path).Length / 1KB, 1))
}

Save-Resized $square 180 (Join-Path $root 'apple-touch-icon.png')
Save-Resized $square 512 (Join-Path $root 'shiba-icon-512.png')

function Get-Base64 {
  param($bmp, [int]$size)
  $tmp = Join-Path $root "tmp-$size.png"
  Save-Resized $bmp $size $tmp
  $b = [Convert]::ToBase64String([IO.File]::ReadAllBytes($tmp))
  Remove-Item $tmp -Force
  return $b
}

$favB64 = Get-Base64 $square 64    # favicon tren tab
$logoB64 = Get-Base64 $square 96   # logo o nav (38px) va footer (34px), du net cho man retina
$square.Dispose()

# ---------- 4. Nhung base64 vao index.html ----------
$html = [IO.File]::ReadAllText($htmlPath)

$favPattern = '(<link rel="icon" type="image/png" sizes="64x64" href="data:image/png;base64,)[^"]*(">)'
if ($html -notmatch $favPattern) { throw 'Khong tim thay the <link rel="icon"> trong index.html' }
$html = [regex]::Replace($html, $favPattern, "`${1}$favB64`${2}")

$logoPattern = '(background:url\(data:image/png;base64,)[^)]*(\) center/contain no-repeat)'
if ($html -notmatch $logoPattern) { throw 'Khong tim thay CSS .logo .mark trong index.html' }
$html = [regex]::Replace($html, $logoPattern, "`${1}$logoB64`${2}")

[IO.File]::WriteAllText($htmlPath, $html, (New-Object System.Text.UTF8Encoding($false)))
Write-Host "Da nhung favicon 64px  (base64 $($favB64.Length) ky tu)"
Write-Host "Da nhung logo    96px  (base64 $($logoB64.Length) ky tu)"

# ---------- Kiem tra lai: doc nguoc tu index.html, giai ma, mo bang System.Drawing ----------
$final = [IO.File]::ReadAllText($htmlPath)
$checks = @{
  'favicon' = [regex]::Match($final, 'rel="icon"[^>]*base64,(?<b>[A-Za-z0-9+/=]+)"')
  'logo'    = [regex]::Match($final, 'background:url\(data:image/png;base64,(?<b>[A-Za-z0-9+/=]+)\)')
}
foreach ($name in 'favicon', 'logo') {
  $m2 = $checks[$name]
  if (-not $m2.Success) { throw "Kiem tra that bai: khong doc lai duoc $name" }
  $raw = [Convert]::FromBase64String($m2.Groups['b'].Value)
  $ms  = New-Object System.IO.MemoryStream($raw, 0, $raw.Length)
  $v   = [System.Drawing.Image]::FromStream($ms)
  Write-Host ("Kiem tra {0,-8}: {1}x{2}, {3} byte -> OK" -f $name, $v.Width, $v.Height, $raw.Length)
  $v.Dispose(); $ms.Dispose()
}
if ($final -match '__FAVICON_B64__|__LOGO_B64__') { throw 'Van con placeholder chua duoc thay' }
Write-Host "index.html: $([math]::Round((Get-Item $htmlPath).Length / 1KB, 1)) KB"
