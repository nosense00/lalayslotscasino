# ===============================
# LalaySlots MILLION-PUSH Auto Script
# Author: nosense00
# ===============================

# --- 1. Settings ---
$sourceFolder = "C:\Users\NEC\Downloads"
$filesToInclude = @("lalayslots.html","maroro.jpg","mavincars.jpg","rensrapis.jpg")
$zipName = "lalayslots-full.zip"
$zipPath = Join-Path $sourceFolder $zipName
$repoLocalPath = Join-Path $sourceFolder "lalayslotscasino"
$branch = "main"
$commitMessage = "💥 MILLION PUSH: Update LalaySlots demo (GitHub Pages ready)"

# --- 2. Create ZIP backup ---
$fullPaths = $filesToInclude | ForEach-Object { Join-Path $sourceFolder $_ }
if (Test-Path $zipPath) { Remove-Item $zipPath -Force }
Compress-Archive -Path $fullPaths -DestinationPath $zipPath -Force
Write-Host "✅ ZIP backup created: $zipPath" -ForegroundColor Cyan

# --- 3. Fix image references in HTML ---
$htmlFilePath = Join-Path $sourceFolder "lalayslots.html"
if (Test-Path $htmlFilePath) {
    (Get-Content $htmlFilePath) | ForEach-Object {
        $line = $_
        foreach ($img in $filesToInclude[1..($filesToInclude.Count-1)]) { # skip HTML
            $line = $line -replace "(images/)?$img", $img
        }
        $line
    } | Set-Content $htmlFilePath
    Write-Host "✅ Image references updated in lalayslots.html" -ForegroundColor Green
} else {
    Write-Host "⚠️ HTML file not found!" -ForegroundColor Yellow
}

# --- 4. Clone repo if not exists ---
if (-not (Test-Path $repoLocalPath)) {
    Write-Host "Cloning repository..." -ForegroundColor Cyan
    git clone https://github.com/nosense00/lalayslotscasino.git $repoLocalPath
} else {
    Write-Host "Local repo found." -ForegroundColor Green
}

# --- 5. Change to repo folder ---
Set-Location $repoLocalPath

# --- 6. Copy files + ZIP ---
foreach ($file in $filesToInclude) {
    $src = Join-Path $sourceFolder $file
    if (Test-Path $src) {
        Copy-Item $src -Destination $repoLocalPath -Force
        Write-Host "✅ Copied $file" -ForegroundColor Green
    } else {
        Write-Host "⚠️ Missing: $file" -ForegroundColor Yellow
    }
}
Copy-Item $zipPath -Destination $repoLocalPath -Force
Write-Host "✅ Copied $zipName" -ForegroundColor Green

# --- 7. Git add, commit & push ---
git add .
git commit -m "$commitMessage" --allow-empty
git push origin $branch
Write-Host "`n🎉 All files pushed successfully and GitHub Pages ready!" -ForegroundColor Cyan

# --- 8. Auto-open repo folder ---
Invoke-Item $repoLocalPath
