# === Fix-LalaySlots-v2.ps1 ===
# Auto-fix + auto-backup for LaylayCasinoSlots HTML

$FilePath = "$env:USERPROFILE\Downloads\lalayslots.html"

if (-Not (Test-Path $FilePath)) {
    Write-Host "❌ File not found: $FilePath" -ForegroundColor Red
    exit
}

# --- Make dated backup ---
$timestamp = Get-Date -Format "yyyyMMdd-HHmm"
$BackupFile = "$FilePath.bak.$timestamp"
Copy-Item $FilePath $BackupFile -Force
Write-Host "📂 Backup created: $BackupFile" -ForegroundColor Yellow

# --- Load HTML ---
$html = Get-Content $FilePath -Raw -Encoding UTF8

# --- Inject CSS in <head> if missing ---
$cssFix = @"
<style>
#reel1 img, #reel2 img, #reel3 img {
  width:50px;
  height:50px;
  object-fit:cover;
  display:block;
  margin:auto;
}
</style>
"@

if ($html -notmatch "<style>.*object-fit:cover") {
    $html = $html -replace "(?i)(</head>)", "$cssFix`n`$1"
}

# --- Clean reels: keep only first image per reel ---
foreach ($reel in 1..3) {
    if ($html -match "(?s)(<div id=`"reel$reel`".*?>)(.*?)(</div>)") {
        $content = $Matches[2]

        # Extract first <img>
        if ($content -match "(<img.*?>)") {
            $firstImg = $Matches[1]
            $fixedContent = $firstImg
        } else {
            $fixedContent = ""
        }

        $html = $html -replace [regex]::Escape($Matches[0]), "$($Matches[1])$fixedContent$($Matches[3])"
    }
}

# --- Remove stray <img> outside reels ---
$html = $html -replace "(?s)(?!<div id=`"reel[123]`">).*?<img.*?>", ""

# --- Save back ---
$html | Set-Content $FilePath -Encoding UTF8
Write-Host "✅ LalaySlots FIXED: $FilePath" -ForegroundColor Cyan

# --- Auto-open in default browser ---
Start-Process $FilePath
