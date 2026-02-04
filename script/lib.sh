#!/bin/bash
# Shared variables and functions for setup scripts

set -euo pipefail

# OS detection
OS="$(uname -s)"
ARCH="$(uname -m)"

# Homebrew prefix
if [[ "$OS" == "Darwin" ]]; then
  if [[ "$ARCH" == "arm64" ]]; then
    BREW_PREFIX="/opt/homebrew"
  else
    BREW_PREFIX="/usr/local"
  fi
else
  BREW_PREFIX="/home/linuxbrew/.linuxbrew"
fi

# Root of dotfiles repo
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
