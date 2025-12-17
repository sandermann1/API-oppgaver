
# setup-python.ps1
# Oppretter venv, aktiverer det, laster ned .gitignore og installerer requests, numpy, pandas

param(
    [string]$EnvName = "venv"
)

function Fail($msg) {
    Write-Host "[FEIL] $msg" -ForegroundColor Red
    exit 1
}

# 1) Sjekk at Python er tilgjengelig
Write-Host "Sjekker Python..." -ForegroundColor Cyan
$pythonCmds = @("python", "py")
$pythonFound = $false
foreach ($cmd in $pythonCmds) {
    try {
        $version = & $cmd --version 2>$null
        if ($LASTEXITCODE -eq 0 -and $version) {
            Write-Host "Fant Python: $version via '$cmd'"
            $pythonExe = $cmd
            $pythonFound = $true
            break
        }
    } catch { }
}
if (-not $pythonFound) { Fail "Python ble ikke funnet i PATH. Installer Python først fra https://python.org/downloads/" }

# 2) Opprett virtuelt miljø
Write-Host "Oppretter virtuelt miljø: $EnvName..." -ForegroundColor Cyan
& $pythonExe -m venv $EnvName
if ($LASTEXITCODE -ne 0) { Fail "Kunne ikke opprette venv." }

# 3) Aktiver miljøet
$activateScript = Join-Path -Path ".\$EnvName\Scripts" -ChildPath "Activate.ps1"
if (-not (Test-Path $activateScript)) { Fail "Aktiveringsscript ikke funnet: $activateScript" }

Write-Host "Aktiverer miljøet..." -ForegroundColor Cyan
& $activateScript

# 4) Oppgrader pip
Write-Host "Oppgraderer pip..." -ForegroundColor Cyan
python -m pip install --upgrade pip
if ($LASTEXITCODE -ne 0) { Fail "Pip-oppgradering feilet." }

# 5) Installer requests, numpy og pandas
Write-Host "Installerer 'requests', 'numpy', 'pandas'..." -ForegroundColor Cyan
python -m pip install requests numpy pandas
if ($LASTEXITCODE -ne 0) { Fail "Installasjon av pakker feilet." }

# 6) Lag requirements.txt
Write-Host "Lager requirements.txt..." -ForegroundColor Cyan
python -m pip freeze | Out-File -Encoding ASCII "requirements.txt"

# 7) Last ned .gitignore (Python)
Write-Host "Laster ned .gitignore (Python)..." -ForegroundColor Cyan
$gitignoreUrl = "https://raw.githubusercontent.com/github/gitignore/main/Python.gitignore"
Invoke-WebRequest -Uri $gitignoreUrl -OutFile ".gitignore"

# 8) Create folders
$FinishedFolderPath = Join-Path -Path . -ChildPath "src/main"
if (-not (Test-Path $FinishedFolderPath)) {
Write-Host "Lager filstruktur" -ForegroundColor Cyan
Write-Host "0/2 ferdig" -ForegroundColor Cyan
$folder = "src"
New-Item -Path . -Name $folder -ItemType Directory -Force

Write-Host "1/2 ferdig" -ForegroundColor Cyan

Write-Host "Lager filstruktur" -ForegroundColor Cyan
$fullPath = Join-Path -Path . -ChildPath "src"
New-Item -Path $fullPath -Name "main" -ItemType Directory -Force
Write-Host "2/2 ferdig" -ForegroundColor Cyan
} else {
Write-Host "Mapper finnes alerede" -ForegroundColor Cyan
}
# 9) Make main.py
$filePathComplete = Join-Path -Path $FinishedFolderPath -ChildPath "main.py"
if (-not (Test-Path $filePathComplete)){
Write-Host "Lager main.py" -ForegroundColor Cyan
$fullPath = Join-Path -Path . -ChildPath "src/main"
$content = @"
import pandas
import numpy
import requests

def main():
    print("Hello, World")

if __name__ == "__main__":
    main()

"@
New-Item -Path $fullPath -Name "main.py" -ItemType File -Force | Set-Content -Value $content
} else {
Write-Host "main finnes alerede" -ForegroundColor Cyan
}

# 10) Make README.md
Write-Host "Lager" -ForegroundColor Cyan
$readMePath = Join-Path -Path . -ChildPath "README.md"
if (-not (Test-Path $readMePath)){
$contentReadMe = @"
# README
> ### *Laget av ???*
---
### Hva er dette


> - - - > - - - > - - - >

### Features

Python


---
### TODO
- [ ] Utsette oppgaver
- [ ] Gjøre ting senere
- [ ] Sove
- [ ] Unngå lekser
- [x] Lage README.md

> - - - > - - -
"@
New-Item -Path . -Name "README.md" -ItemType File -Force | Set-Content -Value $contentReadMe
} else {
Write-Host "README finnes alerede" -ForegroundColor Cyan
}



Write-Host "`n✅ Ferdig! Venv er aktivert, pakker er installert og .gitignore er lastet ned." -ForegroundColor Green
Write-Host "Tips: Miljøet er aktivt i denne sesjonen. Kjør 'deactivate' for å avslutte venv."
