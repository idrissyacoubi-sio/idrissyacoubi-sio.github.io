$GitPath = "git"
# Vérifie si la commande git fonctionne, sinon utilise le chemin complet
try {
    $null = & $GitPath --version 2>$null
} catch {
    $GitPath = "C:\Program Files\Git\cmd\git.exe"
}

$RepoPath = $PSScriptRoot
Set-Location $RepoPath

Write-Host "=======================================================" -ForegroundColor Cyan
Write-Host " Démarrage de la synchronisation automatique (Auto-Push)" -ForegroundColor Cyan
Write-Host "=======================================================" -ForegroundColor Cyan
Write-Host "Dossier surveillé : $RepoPath"
Write-Host "Le script va vérifier les modifications toutes les 15 secondes."
Write-Host "Laissez cette fenêtre ouverte pendant que vous travaillez."
Write-Host "Appuyez sur Ctrl+C pour arrêter." -ForegroundColor Red
Write-Host "-------------------------------------------------------"

while ($true) {
    Start-Sleep -Seconds 15
    
    $status = & $GitPath status --porcelain
    if ($status) {
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        Write-Host "[$timestamp] Modifications détectées. Enregistrement..." -ForegroundColor Yellow
        
        & $GitPath add .
        & $GitPath commit -m "Auto-commit: $timestamp" | Out-Null
        
        $pushResult = & $GitPath push 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "[$timestamp] ✅ Succès : Modifications envoyées sur GitHub." -ForegroundColor Green
        } else {
            Write-Host "[$timestamp] ❌ Erreur lors du push. Assurez-vous d'avoir une connexion internet." -ForegroundColor Red
            Write-Host $pushResult -ForegroundColor DarkRed
        }
    }
}
