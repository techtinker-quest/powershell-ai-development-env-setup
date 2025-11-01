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
- 🔗 **VS Code:** Auto-configured with 7 AI-friendly extensions  

| Category       | Tools |
|----------------|-------|
| **Tools**      | Git, VS Code, GitHub CLI |
| **Python**     | Miniforge + Mamba, `ai_project` env (Python 3.12) |
| **Core**       | `numpy`, `pandas`, `scikit-learn`, `matplotlib`, `opencv` |
| **AI/ML**      | PyTorch (GPU/CPU auto), Transformers |
| **Vision/OCR** | `ultralytics`, `paddleocr`, `easyocr` |
| **NLP**        | `spaCy`, `langdetect`, `datasets`, `accelerate` |
| **MLOps**      | `MLflow`, `label-studio` |
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
-Scope Process ensures no permanent policy changes.

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

1. Restart your computer (required for PATH and conda init)
2. Open VS Code → Ctrl+Shift+P → "Python: Select Interpreter" → choose ai_project
3. (Optional) Login to GitHub CLI:
```powershell
gh auth login
```

---

## 🧩 Customization

To skip TensorFlow, keep its section commented in the script

Add or remove packages directly in the relevant section (Core, Vision, NLP, etc.)

For advanced environment tuning, see docs/usage.md

---

## 🧰 Troubleshooting

Always run PowerShell as Administrator

Check for sufficient disk space and a stable internet connection

View detailed logs in the script output

For detailed error messages and known issues, see docs/troubleshooting.md


## 🤝 Contributing

Contributions, bug reports, and feature ideas are welcome!
See CONTRIBUTING.md
 for guidelines.



## 📄 License

Distributed under the MIT License

---
