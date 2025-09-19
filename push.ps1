# ==============================
# LalaySlots One-Click Git Push
# ==============================
$projectPath = "C:\Users\NEC\Downloads\lalayslotscasino"
$message = "Auto push from PowerShell - update LalaySlots 🎰"

# Go to project folder
Set-Location $projectPath

# Stage all changes
git add .

# Commit with message
git commit -m $message

# Push to main branch
git push origin main

Write-Host "✅ All changes pushed to GitHub!" -ForegroundColor Cyan
Pause
