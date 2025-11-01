# 🧠 AI Development Environment Setup (Windows)

**One-click PowerShell script** to bootstrap a **complete AI & Python dev environment** on Windows — in minutes.

Perfect for **data science**, **computer vision**, **NLP**, and **MLOps**.

[![Windows](https://img.shields.io/badge/Windows-0078D6?logo=windows&logoColor=white)](https://microsoft.com/windows)
[![PowerShell](https://img.shields.io/badge/PowerShell-5391FE?logo=powershell&logoColor=white)](https://learn.microsoft.com/powershell/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

---

## 🚀 Features

- 🧩 **One-step automation:** Installs Git, VS Code, GitHub CLI, and essential extensions  
- 🐍 **Python management:** Miniforge + Mamba, isolated `ai_project` env (Python 3.12)  
- ⚙️ **Preloaded packages:** Full scientific + AI stack  
- 🤖 **AI frameworks:** PyTorch (GPU/CPU auto), Transformers, optional TensorFlow  
- 👁️ **Vision & OCR:** `ultralytics`, `paddleocr`, `easyocr`  
- 💬 **NLP tools:** `spaCy`, `langdetect`, `datasets`, `accelerate`  
- 📊 **MLOps:** `MLflow`, `label-studio`  
- 🧹 **Dev tools:** `black`, `flake8`, `mypy`, `pytest`  
- 🔗 **VS Code:** Auto-configured with 7 AI-friendly extensions such as Linting, formatting, interpreter
- ⚙️ **Auto GPU detection:** Installs CUDA-enabled PyTorch if available

| Category       | Tools |
|----------------|-------|
| **Tools**      | Git, VS Code, GitHub CLI |
| **Python**     | Miniforge + Mamba, `ai_project` env (Python 3.12) |
| **Core**       | `numpy`, `pandas`, `scikit-learn`, `matplotlib`, `opencv` |
| **AI/ML**      | PyTorch (GPU/CPU auto), Transformers |
| **Vision/OCR** | `ultralytics`, `paddleocr`, `easyocr` |
| **NLP**        | `spaCy`, `langdetect`, `datasets`, `accelerate` |
| **MLOps**      | `MLflow`, `argilla` |
| **Dev**        | `black`, `flake8`, `mypy`, `pytest` |
| **VS Code**    | Python, Pylance, Jupyter, GitLens, etc. |

---

## 🧱 Requirements

- **Windows 10 or newer**  
- **PowerShell 5.1+** (built-in)  
- **Administrator access** (required for `winget`, Miniforge)  
- **Stable internet**  
- **~5 GB free disk space**

---

## ⚡ Installation Options

### Option 1: One-Click Install (Recommended)

Run this **single command** in **PowerShell (as Administrator)**:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; `
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/techtinker-quest/powershell-ai-development-env-setup/main/scripts/setup-ai-env.ps1" -OutFile "$env:TEMP\setup-ai-env.ps1"; `
& "$env:TEMP\setup-ai-env.ps1"
```
This downloads and runs the script directly from GitHub.
No permanent policy change — -Scope Process is safe and temporary.

### Option 2: Clone with Git (For Developers)
If Git is installed, clone and run locally:

```powershell
git clone https://github.com/techtinker-quest/powershell-ai-development-env-setup.git
cd powershell-ai-development-env-setup
Set-ExecutionPolicy Bypass -Scope Process -Force
.\scripts\setup-ai-env.ps1
```
Run as Administrator

### Option 3: Manual Download & Run
1. Go to:
https://github.com/techtinker-quest/powershell-ai-development-env-setup/blob/main/scripts/setup-ai-env.ps1
2. Click "Raw" → Right-click → "Save As" → setup-ai-env.ps1
3. Open PowerShell as Administrator, navigate to the file:
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
.\setup-ai-env.ps1
```

## Post-Installation
Do this in a new PowerShell window (not the one that ran the script)

### 1. Allow scripts (once per user)
```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
```

### 2. Create/recreate the `ai` shortcut
```powershell
if (-not (Test-Path $PROFILE)) { New-Item -Path $PROFILE -ItemType File -Force | Out-Null }
Add-Content -Path $PROFILE -Value @'
function ai {
    $env:Path = "$env:USERPROFILE\miniforge3\condabin;$env:Path"
    & "$env:USERPROFILE\miniforge3\condabin\conda.bat" activate ai_project 2>$null
    $env:Path = "$env:USERPROFILE\miniforge3\envs\ai_project\Scripts;$env:USERPROFILE\miniforge3\envs\ai_project;$env:USERPROFILE\miniforge3\envs\ai_project\Library\bin;$env:Path"
    Write-Host "AI Environment Activated! (ai_project)" -ForegroundColor Cyan
}
'@ -Force
```

### 3. Reload profile
```powershell
. $PROFILE
```
### 4. Test activation
```powershell
ai
python -c "import torch, ultralytics; print('All good!')"
```

### Expected output:
```text
AI Environment Activated! (ai_project)
All good! YOLO ready.
```

### 5. Final Setup Steps
1. **Restart your computer** (required for PATH and conda init)
2. Open **VS Code** → `Ctrl+Shift+P` → "Python: Select Interpreter" → choose `ai_project`
3. (Optional) Login to GitHub CLI:
```powershell
gh auth login
```

---

## 🧩 Customization
**Skip TensorFlow?** Keep its line commented in the script
**Add packages?** Edit the relevant section (Core, Vision, NLP, etc.)
**Use different** Python version? Change `python=3.12` in script
**Advanced config** → see `docs/usage.md`

---

## 🧰 Troubleshooting - 🐛 Common Issues and Quick Fixes

Always run PowerShell as Administrator

Check for sufficient disk space and a stable internet connection

View detailed logs in the script output

For detailed error messages and known issues, see docs/troubleshooting.md


| Issue | Quick Fix |
| :--- | :--- |
| `conda` not recognized | Close & reopen **PowerShell** → run `ai` |
| `python` not found | Run `ai` **first** |
| Script fails | Check **internet**, run as **Admin**, check **log** in `%USERPROFILE%` |
| VS Code not detecting env | Restart **VS Code** → reselect **interpreter** |


## 🤝 Contributing

Contributions, bug reports, and feature ideas are welcome!
See CONTRIBUTING.md
 for guidelines.



## 📄 License

Distributed under the MIT License

---
