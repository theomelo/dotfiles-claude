#!/usr/bin/env bash
set -e

# Dotfiles installer - Claude Code setup

echo "==> Installing Claude Code..."

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

echo "==> Claude Code installed successfully!"
echo "Run 'claude' to start using Claude Code."
