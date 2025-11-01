### 1. **Create a GitHub Repo**
- Go to [github.com/new](https://github.com/new)
- Name: `powershell-ai-development-env-setup`
- Description: "One-click AI dev environment for Windows"
- Make it public
- Click **"Create repository"**

### 2. **Add the Files**
- In your new repo, click **"Add file"** → **"Create new file"**
- For `CONTRIBUTING.md`:
  - Name: `CONTRIBUTING.md`
  - Paste this raw content (select all below and paste):

# Contributing to AI Development Environment Setup

Thank you for your interest in contributing!  
This project aims to provide a **robust, one-click AI dev environment for Windows** — and we welcome all contributions.

---

## 🧩 Ways to Contribute

| Type | Examples |
|------|-----------|
| 🐛 **Bug Reports** | Installation fails, `conda` not found, VS Code issues |
| 💡 **Feature Requests** | Add TensorFlow, support Python 3.13, auto-update |
| 🧱 **Code Improvements** | Better error handling, faster install, logging |
| 📖 **Documentation** | Improve README, add tutorials, fix typos |
| 🧪 **Examples** | Add `/examples/` projects (OCR, RAG, YOLO) |

---

## 🔧 How to Contribute

### 1. Fork the Repository
Click **"Fork"** on GitHub, then clone your fork:
```bash
git clone https://github.com/<your-username>/powershell-ai-development-env-setup.git
cd powershell-ai-development-env-setup
```

### 2. Create a Branch
```bash
git checkout -b feature/your-feature-name
# or
git checkout -b fix/issue-description
```

### 3. Make Your Changes
- Follow the existing code style.  
- Keep scripts **idempotent** and **safe to re-run**.  
- Test on a **clean Windows VM** if possible.

### 4. Test Thoroughly
```powershell
# Run full setup
.\scripts\setup-ai-env.ps1

# Verify
ai
python -c "import torch, ultralytics; print('Success!')"
```

### 5. Commit & Push
```bash
git add .
git commit -m "feat: add auto-update check"
git push origin feature/your-feature-name
```

### 6. Open a Pull Request
1. Go to your fork on GitHub.  
2. Click **"Contribute" → "Open Pull Request"**.  
3. Fill out the PR template.

---

## 🤝 Code of Conduct
Be respectful, inclusive, and constructive.  
This project follows the [Contributor Covenant](https://www.contributor-covenant.org/).

---

## ❓ Questions?

Open an [Issue](https://github.com/techtinker-quest/powershell-ai-development-env-setup/issues) with:
- Your **OS version**
- Your **PowerShell version** (`$PSVersionTable.PSVersion`)
- The **full error log**

---

**💙 Thank you for making Windows AI development easier for everyone!**
