<#
=============================================================
 AI DEVELOPMENT ENVIRONMENT SETUP SCRIPT (Windows)
 Author: Sandeep A + Grok (xAI) + ChatGPT
 Target: Python 3.12 + Miniforge + Mamba + VS Code + GitHub
 Version: 2025-11-01 (v1.1)
=============================================================

 Highlights:
  ✅ Fully automated, idempotent, safe re-runs
  ✅ Installs Git, VS Code, Miniforge (with mamba), GitHub CLI
  ✅ Creates isolated conda env: "ai_project" (Python 3.12)
  ✅ Installs core AI/ML packages (Torch, Transformers, Vision, NLP, Tracking)
  ✅ Configures VS Code + extensions + interpreter + Black + linting
  ✅ Auto-detects CUDA + installs cuda-toolkit if needed
  ✅ Full transcript logging + robust error handling
  ✅ JSON-safe VS Code settings merge (handles arrays)
  ✅ Retry logic for GitHub API
  ✅ Process-scoped execution policy
  ✅ VS Code CLI path auto-fix (Local + Program Files)
  ✅ Final environment test
=============================================================
#>

# === STOP ON FIRST ERROR ===
$ErrorActionPreference = "Stop"

# === SCRIPT VERSION BANNER ===
$scriptVersion = "2025-11-01 (v2.3)"
Write-Host "`nAI Dev Setup Script v2.3 - $scriptVersion" -ForegroundColor Magenta
Write-Host ("═" * 70) -ForegroundColor DarkGray

# === START LOGGING ===
$logPath = "$env:USERPROFILE\ai_setup_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"
Start-Transcript -Path $logPath -Append
Write-Host "`n=== AI ENVIRONMENT SETUP STARTED ===" -ForegroundColor Green
Write-Host "Log: $logPath`n"

# === OPTIONAL: ENSURE SCRIPT EXECUTION ALLOWED (Process Scope) ===
try { Set-ExecutionPolicy RemoteSigned -Scope Process -Force } catch {}

# === ADMIN CHECK ===
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "Running without Administrator privileges. Some installations may fail."
    Write-Host " → Consider running PowerShell as Administrator.`n"
}

# === HELPER: Timestamp ===
function Stamp { "[" + (Get-Date -Format "HH:mm:ss") + "]" }

# === HELPER: Deep Merge Hashtables (Handles nested + arrays) ===
function Merge-Hashtables {
    $output = @{}
    foreach ($hashtable in $args) {
        if ($hashtable -is [hashtable]) {
            foreach ($key in $hashtable.Keys) {
                if ($output.ContainsKey($key)) {
                    if ($output[$key] -is [hashtable] -and $hashtable[$key] -is [hashtable]) {
                        $output[$key] = Merge-Hashtables $output[$key] $hashtable[$key]
                    } elseif ($output[$key] -is [array] -and $hashtable[$key] -is [array]) {
                        $output[$key] = $output[$key] + $hashtable[$key] | Select-Object -Unique
                    } else {
                        $output[$key] = $hashtable[$key]
                    }
                } else {
                    $output[$key] = $hashtable[$key]
                }
            }
        }
    }
    return $output
}

try {
    # === STEP 1: Install Git and VS Code ===
    Write-Host "`n$(Stamp) STEP 1: Installing Git and VS Code" -ForegroundColor Cyan
    winget install --id Git.Git -e --source winget --silent --accept-package-agreements --accept-source-agreements
    winget install --id Microsoft.VisualStudioCode -e --source winget --silent --accept-package-agreements --accept-source-agreements

    # === STEP 2: Install Miniforge ===
    Write-Host "`n$(Stamp) STEP 2: Installing Miniforge (Mamba + conda-forge)" -ForegroundColor Cyan
    $miniforgePath = "$env:USERPROFILE\miniforge3"
    if (-not (Test-Path $miniforgePath)) {
        Write-Host "Fetching latest Miniforge release (with retry)..."
        $url = $null
        for ($i = 1; $i -le 3; $i++) {
            try {
                $release = Invoke-RestMethod -Uri "https://api.github.com/repos/conda-forge/miniforge/releases/latest" -TimeoutSec 30
                $url = ($release.assets | Where-Object { $_.browser_download_url -match 'Miniforge3-Windows-x86_64\.exe$' }).browser_download_url | Select-Object -First 1
                if ($url) { break }
            } catch {
                Write-Host "Attempt $i failed: $_" -ForegroundColor Yellow
                if ($i -eq 3) { throw "Failed to fetch Miniforge release info after 3 attempts." }
                Start-Sleep -Seconds 3
            }
        }
        if (-not $url) { throw "Failed to find Miniforge installer URL." }

        $installer = "$env:TEMP\Miniforge3.exe"
        Write-Host "Downloading Miniforge from: $url"
        Invoke-WebRequest -Uri $url -OutFile $installer -TimeoutSec 300
        Write-Host "Installing Miniforge to: $miniforgePath"
        Start-Process -Wait -FilePath $installer -ArgumentList "/InstallationType=JustMe", "/RegisterPython=0", "/S", "/D=$miniforgePath"
        Remove-Item $installer -Force
        Write-Host "Miniforge installed at $miniforgePath" -ForegroundColor Green
    } else {
        Write-Host "Miniforge already installed at $miniforgePath."
    }

    # === STEP 3: Initialize Conda Shell ===
    Write-Host "`n$(Stamp) STEP 3: Initializing Conda Shell" -ForegroundColor Cyan
    $condaHook = & "$miniforgePath\condabin\conda.bat" "shell.powershell" "hook" 2>$null
    if ($condaHook) {
        try {
            Invoke-Expression $condaHook
            Write-Host "Conda shell hook activated (preferred)." -ForegroundColor Green
        } catch {
            Write-Warning "Failed to activate conda hook: $_"
        }
    } elseif (Test-Path "$miniforgePath\Scripts\activate") {
        & "$miniforgePath\Scripts\activate"
        Write-Host "Conda activated via fallback script (compat mode)." -ForegroundColor Yellow
    } else {
        throw "Failed to initialize Conda shell hook."
    }

    # === STEP 4: Update Base Environment (Fixed: update, not upgrade) ===
    Write-Host "`n$(Stamp) STEP 4: Updating base environment with Mamba" -ForegroundColor Cyan
    mamba update -n base -c conda-forge --all -y

    # === STEP 5: Create AI Project Environment ===
    Write-Host "`n$(Stamp) STEP 5: Creating Conda Environment 'ai_project'" -ForegroundColor Cyan
    $envs = (& "$miniforgePath\condabin\conda.exe" env list --json | ConvertFrom-Json).envs
    if ($envs -notmatch "ai_project") {
        mamba create -n ai_project python=3.12 -y
        Write-Host "Environment 'ai_project' created."
    } else {
        Write-Host "Environment 'ai_project' already exists — skipping creation."
    }

    # === STEP 6: Install Core Packages ===
    Write-Host "`n$(Stamp) STEP 6: Installing Core Libraries" -ForegroundColor Cyan
    $corePkgs = @("numpy","pandas","scikit-learn","matplotlib","seaborn","jupyterlab","ipykernel","nb_conda_kernels","opencv","pymupdf")
    mamba install -n ai_project -c conda-forge -y $corePkgs

    # === STEP 7: Detect GPU and Install PyTorch + CUDA Toolkit ===
    Write-Host "`n$(Stamp) STEP 7: Installing PyTorch (Auto-detect CUDA)" -ForegroundColor Cyan
    $hasCuda = $false
    if (Get-Command nvidia-smi -ErrorAction SilentlyContinue) { $hasCuda = $true }
    elseif (Test-Path "$env:ProgramFiles\NVIDIA Corporation\NVSMI\nvidia-smi.exe") { $hasCuda = $true }

    $pytorchIndex = "https://download.pytorch.org/whl/cpu"
    if ($hasCuda) {
        Write-Host "CUDA detected → installing GPU-enabled PyTorch" -ForegroundColor Green
        $pytorchIndex = "https://download.pytorch.org/whl/cu118"

        # Use conda run for mamba list
        $cudaList = & "$miniforgePath\condabin\conda.exe" run -n ai_project mamba list cuda-toolkit --json | ConvertFrom-Json
        $cudaInstalled = $cudaList.name -contains "cuda-toolkit"
        if (-not $cudaInstalled) {
            Write-Host "Installing CUDA toolkit for compatibility..."
            mamba install -n ai_project -c nvidia -y "cuda-toolkit>=11.8"
        }
    } else {
        Write-Host "No CUDA detected → installing CPU-only PyTorch"
    }

    conda run -n ai_project pip install --upgrade pip
    conda run -n ai_project pip install torch torchvision torchaudio --index-url $pytorchIndex

    # === STEP 8: Vision + OCR ===
    Write-Host "`n$(Stamp) STEP 8: Installing Vision and OCR Libraries" -ForegroundColor Cyan
    conda run -n ai_project pip install ultralytics==8.* paddleocr==2.* easyocr==1.*

    # === STEP 9: NLP ===
    Write-Host "`n$(Stamp) STEP 9: Installing NLP Libraries" -ForegroundColor Cyan
    conda run -n ai_project pip install spacy>=3.7 langdetect>=1.0.9 transformers datasets accelerate

    # === STEP 10: Tracking & Annotation ===
    Write-Host "`n$(Stamp) STEP 10: Installing Tracking and Annotation Tools" -ForegroundColor Cyan
    conda run -n ai_project pip install label-studio>=1.9 mlflow>=2.8

    # === STEP 11: Developer Utilities ===
    Write-Host "`n$(Stamp) STEP 11: Installing Developer Tools" -ForegroundColor Cyan
    conda run -n ai_project pip install black flake8 mypy pytest

    # === STEP 12: GitHub CLI ===
    Write-Host "`n$(Stamp) STEP 12: Installing GitHub CLI" -ForegroundColor Cyan
    winget install --id GitHub.cli -e --source winget --silent --accept-package-agreements --accept-source-agreements

    # === STEP 13: VS Code Extensions ===
    Write-Host "`n$(Stamp) STEP 13: Installing VS Code Extensions" -ForegroundColor Cyan
    if (-not (Get-Command code -ErrorAction SilentlyContinue)) {
        $altBins = @(
            "$env:LOCALAPPDATA\Programs\Microsoft VS Code\bin",
            "$env:ProgramFiles\Microsoft VS Code\bin"
        )
        foreach ($p in $altBins) {
            if (Test-Path $p) { $env:Path += ";$p" }
        }
    }
    $codeCmd = (Get-Command code -ErrorAction SilentlyContinue)?.Source
    if ($codeCmd) {
        $extensions = @(
            "ms-python.python",
            "ms-toolsai.jupyter",
            "ms-python.vscode-pylance",
            "ms-vscode.gitlens",
            "github.vscode-pull-request-github",
            "ms-python.black-formatter",
            "kevinrose.vsc-python-environment-manager"
        )
        foreach ($ext in $extensions) {
            & $codeCmd --install-extension $ext --force
        }
        Write-Host "VS Code extensions installed successfully." -ForegroundColor Green
    } else {
        Write-Warning "VS Code CLI not found. Open VS Code once, then re-run this step."
        Write-Host "Tip: Restart VS Code to ensure 'code' CLI is available in terminal."
    }

    # === STEP 14: Configure VS Code ===
    Write-Host "`n$(Stamp) STEP 14: Configuring VS Code Settings" -ForegroundColor Cyan
    $pythonPath = & "$miniforgePath\condabin\conda.exe" run -n ai_project python -c "import sys; print(sys.executable)"
    $pythonPath = $pythonPath.Trim() -replace "/", "\\"
    $settingsPath = "$env:APPDATA\Code\User\settings.json"
    if (-not (Test-Path (Split-Path $settingsPath))) { New-Item -ItemType Directory -Path (Split-Path $settingsPath) -Force | Out-Null }
    $existing = @{}
    if (Test-Path $settingsPath) {
        try {
            $existing = (Get-Content $settingsPath -Raw | ConvertFrom-Json -AsHashtable)
        } catch {
            Write-Warning "Could not parse existing settings.json. Starting fresh."
        }
    }
    $newSettings = @{
        "python.defaultInterpreterPath" = $pythonPath
        "python.formatting.provider"    = "black"
        "editor.formatOnSave"           = $true
        "python.linting.flake8Enabled"  = $true
        "jupyter.notebookFileRoot"      = "\${workspaceFolder}"
    }
    $merged = Merge-Hashtables $existing $newSettings
    $merged | ConvertTo-Json -Depth 10 | Out-File -FilePath $settingsPath -Encoding utf8 -Force
    Write-Host "VS Code configured for 'ai_project' environment."

    # === STEP 15: Final Verification ===
    Write-Host "`n$(Stamp) STEP 15: Final Verification" -ForegroundColor Cyan
    conda --version
    conda run -n ai_project python --version
    git --version
    if ($codeCmd) { & $codeCmd --version }

    # === STEP 16: Quick Environment Test ===
    Write-Host "`n$(Stamp) STEP 16: Running environment test..." -ForegroundColor Cyan
    $test = conda run -n ai_project python -c "import torch, sys; print(f'PyTorch: {torch.__version__} | CUDA: {torch.cuda.is_available()}')" 2>$null
    if ($test) {
        Write-Host $test -ForegroundColor Green
    } else {
        Write-Warning "Environment test failed. Check logs."
    }

    # === FINAL SUCCESS MESSAGE ===
    Write-Host "`nSETUP COMPLETE" -ForegroundColor Green
    Write-Host ("═" * 70) -ForegroundColor DarkGray
    Write-Host @"
    Next steps:
      1. Restart your computer (to apply PATH + conda init)
      2. Open VS Code -> Ctrl+Shift+P -> 'Python: Select Interpreter' -> choose 'ai_project'
      3. (Optional) Run: gh auth login -> connect to GitHub
      4. Create project folder -> code .
      5. Test: conda run -n ai_project python -c "import torch; print(torch.cuda.is_available())"
      6. Enjoy your fully loaded AI environment!
    "@

} catch {
    Write-Error "SETUP FAILED: $_"
    Write-Host "Check network, admin rights, or review log: $logPath" -ForegroundColor Red
    exit 1
} finally {
    Stop-Transcript
}
