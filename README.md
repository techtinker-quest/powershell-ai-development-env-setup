# 🧠 AI Development Environment Setup (Windows, PowerShell)

Automated PowerShell script to bootstrap a complete AI & Python development environment on Windows — in minutes.

This standalone setup is designed for data science, computer vision, NLP, and MLOps workflows.  
It installs all essential developer tools, Python libraries, and configuration automatically.

---

## 🚀 Features

- 🧩 **One-step automation:** Installs Git, Visual Studio Code, and common VS Code extensions  
- 🐍 **Python management:** Deploys Miniforge (with Mamba) and creates an isolated `ai_project` Conda environment (Python 3.12)  
- ⚙️ **Preloaded packages:** Core scientific stack (`numpy`, `pandas`, `scikit-learn`, `matplotlib`, `JupyterLab`, `opencv`, etc.)  
- 🤖 **AI frameworks:** PyTorch (default), Transformers, optional TensorFlow  
- 👁️ **Vision & OCR:** `ultralytics`, `paddleocr`, `easyocr`  
- 💬 **NLP tools:** `spaCy`, `langdetect`, `transformers`, `datasets`, `accelerate`  
- 📊 **Experiment tracking & annotation:** `MLflow`, `label-studio`  
- 🧹 **Developer utilities:** `black`, `flake8`, `mypy`, `pytest`  
- 🔗 **GitHub integration:** Installs GitHub CLI and configures VS Code with AI-friendly defaults  

---

## 🧱 Requirements

- Windows 10 or newer  
- PowerShell 5+  
- Administrator access (for installing dependencies)  
- Stable internet connection  

---

## ⚡ Quick Start

1. **Clone this repository:**

   ```powershell
   git clone https://github.com/yourname/ai-dev-setup.git
   cd ai-dev-setup

2. **Run the setup script (as Administrator):**
   ```powershell
   Set-ExecutionPolicy Bypass -Scope Process -Force
   ./scripts/setup-ai-env.ps1

3. **After installation completes:**
   Restart your computer (to refresh PATH and conda init)
   Open VS Code → Ctrl+Shift+P → “Python: Select Interpreter” → choose ai_project
   Optionally run:
   ```powershell
   gh auth login   # Connect GitHub CLI

---

## 🧩 Customization

To skip TensorFlow, keep its section commented in the script

Add or remove packages directly in the relevant section (Core, Vision, NLP, etc.)

For advanced environment tuning, see docs/usage.md

---

## 🧰 Troubleshooting

Always run PowerShell as Administrator

Check for sufficient disk space and a stable internet connection

For detailed error messages and known issues, see docs/troubleshooting.md


## 🤝 Contributing

Contributions, bug reports, and feature ideas are welcome!
See CONTRIBUTING.md
 for guidelines.



## 📄 License

Distributed under the MIT License

---
