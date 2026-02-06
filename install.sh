#!/usr/bin/env bash
set -e

# Install Homebrew for Linux if not present
if ! command -v brew &> /dev/null; then
    echo "Homebrew not found. Installing Homebrew for Linux..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for Linux
    if [ -d "/home/linuxbrew/.linuxbrew" ]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        # Persist to .bashrc for future sessions
        echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"' >> /home/coder/.bashrc
    elif [ -d "$HOME/.linuxbrew" ]; then
        eval "$($HOME/.linuxbrew/bin/brew shellenv)"
        # Persist to .bashrc for future sessions
        echo 'eval "$($HOME/.linuxbrew/bin/brew shellenv bash)"' >> "$HOME/.bashrc"
    fi
fi

# Install glab using Homebrew
echo "Installing glab via Homebrew..."
brew install glab

# Install Git AI
echo "Installing Git AI..."
curl -sSL https://usegitai.com/install.sh | bash

# Check if npm is available
if ! command -v npm &> /dev/null; then
    echo "npm not found. Installing Node.js via nvm..."

    # Install nvm if not present
    if [ ! -d "$HOME/.nvm" ]; then
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
    fi

    # Load nvm
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    # Install latest LTS Node.js
    nvm install --lts
    nvm use --lts
fi

# Install Claude Code globally
npm install -g @anthropic-ai/claude-code

# --- Playwright with headless Chromium ---
# /home/coder/ is a persistent volume, so playwright-tools/ and
# .cache/ms-playwright/ survive workspace rebuilds. System packages
# (apt) do not, so we reinstall them idempotently on every run.

# 1. Install system deps for headless Chromium (lost on workspace rebuild)
if ! dpkg -s libgbm1 >/dev/null 2>&1; then
    echo "Installing system dependencies for headless Chromium..."
    if [ -d /home/coder/playwright-tools/node_modules/playwright ]; then
        cd /home/coder/playwright-tools && npx playwright install-deps chromium
    else
        # System deps will be installed after playwright is set up below
        :
    fi
fi

# 2. If playwright-tools dir is missing (fresh workspace), set it up
if [ ! -d /home/coder/playwright-tools/node_modules/playwright ]; then
    echo "Setting up Playwright tools..."
    mkdir -p /home/coder/playwright-tools
    cd /home/coder/playwright-tools
    npm init -y
    npm install playwright
    npx playwright install --with-deps chromium
fi


_exts=(
  anthropic.claude-code
  eamodio.gitlens
)

if command -v cursor &> /dev/null; then
  for _ext in "${_exts[@]}"; do
    cursor --install-extension "$_ext";
  done
else
  echo "cursor CLI not found, skipping extension installation"
fi
