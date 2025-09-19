# --- UTF-8 Fixer for LalaySlots HTML ---
# 1. Path to your HTML file
$htmlFile = "C:\Users\NEC\Downloads\lalayslots.html"

# 2. Backup original file
$backupFile = $htmlFile + ".bak"
Copy-Item $htmlFile $backupFile -Force
Write-Host "📂 Backup created:" $backupFile -ForegroundColor Yellow

# 3. Read file as ANSI/Default
$content = Get-Content $htmlFile -Raw -Encoding Default

# 4. Save back as UTF-8 without BOM
Set-Content -Path $htmlFile -Value $content -Encoding UTF8
Write-Host "✅ Converted to UTF-8 encoding (without BOM)" -ForegroundColor Green

# 5. Quick check
if ((Get-Content $htmlFile -Raw -Encoding UTF8) -match "🎰|•") {
    Write-Host "🎉 Emojis and bullets should now display correctly!" -ForegroundColor Cyan
} else {
    Write-Host "⚠️ Double-check in browser, maybe manual edit pa" -ForegroundColor Red
}
