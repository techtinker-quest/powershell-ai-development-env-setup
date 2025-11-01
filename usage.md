# Usage Guide

Congratulations — your AI development environment is ready!  
Here’s how to **use it daily** like a pro.

---

## 🚀 Daily Workflow

```powershell
# 1. Open PowerShell (any folder)
ai                     # Activate environment

# 2. Start coding
code .                 # Open VS Code in current folder
python train.py        # Run scripts
jupyter lab            # Open notebooks
```

---

## 🧭 Key Commands

| Command | Purpose |
|----------|----------|
| `ai` | Activate `ai_project` environment |
| `python script.py` | Run Python files |
| `pip install xyz` | Install extra packages |
| `conda list` | View installed packages |
| `gh auth login` | Connect to GitHub |
| `yolo predict model=yolov8n.pt source=img.jpg` | Run YOLO |

---

## 🧠 VS Code Integration

1. Open any project folder:
   ```powershell
   code .
   ```

2. **First time only** — select the interpreter:  
   `Ctrl + Shift + P` → **"Python: Select Interpreter"** → choose:
   ```
   Python 3.12.x ('ai_project': conda)
   ```

> **Tip:** Add this to `settings.json` for auto-select:
> ```json
> "python.defaultInterpreterPath": "C:\\Users\\%USERNAME%\\miniforge3\\envs\\ai_project\\python.exe"
> ```

---

## 🧪 Example Projects

See [`../examples/`](../examples/) for ready-to-run demos:

| File | Description |
|------|--------------|
| `ocr_scan.py` | Extract text from images |
| `chat_with_pdf.py` | Ask questions about PDFs |
| `yolo_detect.py` | Object detection on images |

Run any example:
```powershell
ai
python examples/ocr_scan.py
```

---

## 🔄 Upgrading Packages

```powershell
ai
pip install --upgrade torch ultralytics transformers
```

Or use `mamba` for conda packages:
```powershell
mamba update -n ai_project --all
```

---

## ♻️ Re-running the Setup Script

It’s **safe to re-run** anytime:
```powershell
.\scripts\setup-ai-env.ps1
```

Then reactivate:
```powershell
ai
```

---

## 📦 Export Your Environment

Save the current environment:
```powershell
ai
conda env export -n ai_project > ai_project.yml
```

Restore later:
```powershell
mamba env create -n ai_project -f ai_project.yml
```

---

## 🆘 Need Help?

- [Troubleshooting](../docs/troubleshooting.md)
- [GitHub Issues](https://github.com/techtinker-quest/powershell-ai-development-env-setup/issues)

---

**You're now ready to build AI on Windows — fast, clean, and powerful.**
