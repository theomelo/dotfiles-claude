#!/usr/bin/env bash
set -e

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

for _ext in "${_exts[@]}"; do
  cursor --install-extension "$_ext";
done
