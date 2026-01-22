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

# Install glib using Homebrew
echo "Installing glib via Homebrew..."
brew install glib

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
