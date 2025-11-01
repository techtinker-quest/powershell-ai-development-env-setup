# PowerShell AI Development Environment Setup

PowerShell automation to prepare a fully-functional Windows environment for machine learning, AI, and Python development — in minutes.

## Features

- Installs latest Git, Visual Studio Code, and VS Code extensions for Python and AI
- Deploys Miniforge (with Mamba) for Python/Conda package management
- Creates isolated `ai_project` Conda environment with Python 3.12
- Installs core scientific/AI libraries: numpy, pandas, scikit-learn, matplotlib, JupyterLab, opencv, torch, transformers, and more
- Sets up OCR/Vision/NLP tools (ultralytics, paddleocr, easyocr, spaCy, etc.)
- Configures ML experiment tracking tools (label-studio, MLflow)
- Developer utilities: black, flake8, mypy, pytest
- Optionally includes TensorFlow support
- Installs/configures GitHub CLI and all relevant VS Code settings

## Requirements

- Windows 10 or newer
- Administrator access (to install system dependencies)
- Working internet connection

## Quick Start

1. **Clone this repository:**
git clone https://github.com/yourname/powershell-ai-development-env-setup.git
cd powershell-ai-development-env-setup


2. **Run the setup script as Administrator in PowerShell:**
Set-ExecutionPolicy Bypass -Scope Process -Force
./scripts/setup-ai-env.ps1


3. **Follow on-screen instructions for post-setup tasks.**

## Customizing

- To skip TensorFlow installation, leave the related lines commented in the script
- You may edit the script to add/remove Python packages as needed
- For non-standard workflows, see [docs/usage.md](docs/usage.md) for advanced options

## Troubleshooting

- Ensure you run PowerShell “As Administrator”
- If installing fails, check for internet connection, disk space, or permissions
- For known issues and solutions, see [docs/troubleshooting.md](docs/troubleshooting.md)

## Contributing

Contributions, bug reports, and suggestions welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

## License

[MIT](LICENSE)
