<#
=============================================================
 AI DEVELOPMENT ENVIRONMENT SETUP SCRIPT (Windows)
 Author: Sandeep A + Grok (xAI) + ChatGPT
 Target: Python 3.12 + Miniforge + Mamba + VS Code + GitHub
 Version: 2025-11-01 (v1.8)
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

$ErrorActionPreference = "Stop"

$scriptVersion = "2025-11-01 (v1.8)"
Write-Host "`nAI Dev Setup Script v1.8 - $scriptVersion" -ForegroundColor Magenta
Write-Host ("=" * 70) -ForegroundColor DarkGray

$logPath = "$env:USERPROFILE\ai_setup_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"
Start-Transcript -Path $logPath -Append
Write-Host "`n=== AI ENVIRONMENT SETUP STARTED ===" -ForegroundColor Green
Write-Host "Log: $logPath`n"

try { Set-ExecutionPolicy RemoteSigned -Scope Process -Force } catch {}

if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "Running without Administrator privileges. Some installations may fail."
    Write-Host " -> Consider running PowerShell as Administrator.`n"
}

function Stamp { "[" + (Get-Date -Format "HH:mm:ss") + "]" }

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
    Write-Host "`n$(Stamp) STEP 1: Installing Git and VS Code" -ForegroundColor Cyan
    winget install --id Git.Git -e --source winget --silent --accept-package-agreements --accept-source-agreements
    winget install --id Microsoft.VisualStudioCode -e --source winget --silent --accept-package-agreements --accept-source-agreements

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

    Write-Host "`n$(Stamp) STEP 3: Locating Conda/Mamba Executables" -ForegroundColor Cyan
    
    # Find the correct conda/mamba executables
    $condaExe = $null
    $mambaExe = $null
    
    $possibleCondaPaths = @(
        "$miniforgePath\Scripts\conda.exe",
        "$miniforgePath\condabin\conda.bat",
        "$miniforgePath\Library\bin\conda.bat"
    )
    
    foreach ($path in $possibleCondaPaths) {
        if (Test-Path $path) {
            $condaExe = $path
            Write-Host "Found conda at: $condaExe" -ForegroundColor Green
            break
        }
    }
    
    if (-not $condaExe) {
        throw "Could not find conda executable in $miniforgePath"
    }
    
    $possibleMambaPaths = @(
        "$miniforgePath\Scripts\mamba.exe",
        "$miniforgePath\condabin\mamba.bat"
    )
    
    foreach ($path in $possibleMambaPaths) {
        if (Test-Path $path) {
            $mambaExe = $path
            Write-Host "Found mamba at: $mambaExe" -ForegroundColor Green
            break
        }
    }
    
    if (-not $mambaExe) {
        Write-Warning "Mamba not found, will use conda instead"
        $mambaExe = $condaExe
    }

    Write-Host "`n$(Stamp) STEP 4: Initializing Conda for PowerShell" -ForegroundColor Cyan
    
    # Add conda to PATH for current session
    $env:Path = "$miniforgePath\Scripts;$miniforgePath\condabin;$miniforgePath;$env:Path"
    
    # Initialize conda for PowerShell (for future sessions)
    try {
        & $condaExe init powershell 2>&1 | Out-Null
        Write-Host "Conda initialized for PowerShell (effective in new sessions)" -ForegroundColor Green
    } catch {
        Write-Warning "Could not run conda init: $_"
    }

    Write-Host "`n$(Stamp) STEP 5: Updating base environment with Mamba" -ForegroundColor Cyan
    & $mambaExe update -n base -c conda-forge --all -y

    Write-Host "`n$(Stamp) STEP 6: Creating Conda Environment 'ai_project'" -ForegroundColor Cyan
    $envListOutput = & $condaExe env list 2>&1
    if ($envListOutput -match "ai_project") {
        Write-Host "Environment 'ai_project' already exists - skipping creation."
    } else {
        & $mambaExe create -n ai_project python=3.12 -y
        Write-Host "Environment 'ai_project' created."
    }

    Write-Host "`n$(Stamp) STEP 7: Installing Core Libraries" -ForegroundColor Cyan
    $corePkgs = @("numpy","pandas","scikit-learn","matplotlib","seaborn","jupyterlab","ipykernel","nb_conda_kernels","opencv")
    & $mambaExe install -n ai_project -c conda-forge -y $corePkgs
    
    # Install pymupdf via pip (not available in conda-forge with that name)
    & $condaExe run -n ai_project python -m pip install pymupdf

    Write-Host "`n$(Stamp) STEP 8: Installing PyTorch (Auto-detect CUDA)" -ForegroundColor Cyan
    $hasCuda = $false
    if (Get-Command nvidia-smi -ErrorAction SilentlyContinue) { $hasCuda = $true }
    elseif (Test-Path "$env:ProgramFiles\NVIDIA Corporation\NVSMI\nvidia-smi.exe") { $hasCuda = $true }

    $pytorchIndex = "https://download.pytorch.org/whl/cpu"
    if ($hasCuda) {
        Write-Host "CUDA detected -> installing GPU-enabled PyTorch" -ForegroundColor Green
        $pytorchIndex = "https://download.pytorch.org/whl/cu118"

        # Check if cuda-toolkit is installed
        $cudaCheck = & $condaExe list -n ai_project cuda-toolkit 2>&1
        if ($cudaCheck -notmatch "cuda-toolkit") {
            Write-Host "Installing CUDA toolkit for compatibility..."
            & $mambaExe install -n ai_project -c nvidia -y "cuda-toolkit>=11.8"
        }
    } else {
        Write-Host "No CUDA detected -> installing CPU-only PyTorch"
    }

    & $condaExe run -n ai_project python -m pip install --upgrade pip
    & $condaExe run -n ai_project python -m pip install torch torchvision torchaudio --index-url $pytorchIndex

    Write-Host "`n$(Stamp) STEP 9: Installing Vision and OCR Libraries" -ForegroundColor Cyan
    # These require numpy >= 2.0, so install them first to set the numpy version
    & $condaExe run -n ai_project python -m pip install "numpy>=2.0,<3.0"
    & $condaExe run -n ai_project python -m pip install ultralytics==8.* paddleocr==2.* easyocr==1.*

    Write-Host "`n$(Stamp) STEP 10: Installing NLP Libraries" -ForegroundColor Cyan
    & $condaExe run -n ai_project python -m pip install spacy>=3.7 langdetect>=1.0.9 transformers datasets accelerate

    Write-Host "`n$(Stamp) STEP 11: Installing Tracking and Annotation Tools" -ForegroundColor Cyan
    & $condaExe run -n ai_project python -m pip install mlflow>=2.8
    & $condaExe run -n ai_project python -m pip install argilla>=2.0
    Write-Host "Using Argilla for annotation (modern alternative to label-studio)" -ForegroundColor Green

    Write-Host "`n$(Stamp) STEP 12: Installing Developer Tools" -ForegroundColor Cyan
    & $condaExe run -n ai_project python -m pip install black flake8 mypy pytest

    Write-Host "`n$(Stamp) STEP 13: Installing GitHub CLI" -ForegroundColor Cyan
    winget install --id GitHub.cli -e --source winget --silent --accept-package-agreements --accept-source-agreements

    Write-Host "`n$(Stamp) STEP 14: Installing VS Code Extensions" -ForegroundColor Cyan
    if (-not (Get-Command code -ErrorAction SilentlyContinue)) {
        $altBins = @(
            "$env:LOCALAPPDATA\Programs\Microsoft VS Code\bin",
            "$env:ProgramFiles\Microsoft VS Code\bin"
        )
        foreach ($p in $altBins) {
            if (Test-Path $p) { 
                $env:Path += ";$p"
            }
        }
    }

    $cmd = Get-Command code -ErrorAction SilentlyContinue
    if ($cmd) { $codeCmd = $cmd.Source } else { $codeCmd = $null }

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

    Write-Host "`n$(Stamp) STEP 15: Configuring VS Code Settings" -ForegroundColor Cyan
    $pythonPath = & $condaExe run -n ai_project python -c "import sys; print(sys.executable)"
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
        "jupyter.notebookFileRoot"      = "`${workspaceFolder}"
    }
    $merged = Merge-Hashtables $existing $newSettings
    $merged | ConvertTo-Json -Depth 10 | Out-File -FilePath $settingsPath -Encoding utf8 -Force
    Write-Host "VS Code configured for 'ai_project' environment."

    Write-Host "`n$(Stamp) STEP 16: Final Verification" -ForegroundColor Cyan
    & $condaExe --version
    & $condaExe run -n ai_project python --version
    
    # Git might not be in PATH yet in current session
    $gitCmd = Get-Command git -ErrorAction SilentlyContinue
    if ($gitCmd) { 
        git --version 
    } else {
        Write-Host "Git installed (will be available in new PowerShell sessions)" -ForegroundColor Yellow
    }
    
    if ($codeCmd) { & $codeCmd --version }

    Write-Host "`n$(Stamp) STEP 17: Running environment test..." -ForegroundColor Cyan
    $test = & $condaExe run -n ai_project python -c "import torch, sys; print(f'PyTorch: {torch.__version__} | CUDA: {torch.cuda.is_available()}')" 2>$null
    if ($test) {
        Write-Host $test -ForegroundColor Green
    } else {
        Write-Warning "Environment test failed. Check logs."
    }

    Write-Host "`nSETUP COMPLETE" -ForegroundColor Green
    Write-Host ("=" * 70) -ForegroundColor DarkGray
    Write-Host @'
Next steps:
  1. Close this PowerShell window and open a NEW PowerShell window
  2. Run: conda activate ai_project
  3. Open VS Code -> Ctrl+Shift+P -> 'Python: Select Interpreter' -> choose 'ai_project'
  4. (Optional) Run: gh auth login -> connect to GitHub
  5. Create project folder -> code .
  6. Test: python -c "import torch; print(torch.cuda.is_available())"
  7. Enjoy your fully loaded AI environment!
'@

} catch {
    Write-Error "SETUP FAILED: $_"
    Write-Host "Check network, admin rights, or review log: $logPath" -ForegroundColor Red
    exit 1
} finally {
    Stop-Transcript
}
