#!/bin/bash

set -euo pipefail

cd "$(dirname "$0")/.."

echo "==> Building test container..."
docker build -t dotfiles-test -f - . <<'DOCKERFILE'
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl \
    git \
    sudo \
    locales \
    zsh \
    && rm -rf /var/lib/apt/lists/*

# Set up locale
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8

# Create test user with sudo access
RUN useradd -m -s /bin/zsh testuser && \
    echo "testuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER testuser
WORKDIR /home/testuser/dotfiles
DOCKERFILE

echo "==> Running setup and validation in container..."
# Authenticate GitHub API calls to avoid anonymous rate limits
GITHUB_TOKEN="${GITHUB_TOKEN:-$(gh auth token 2>/dev/null || true)}"

docker run --rm \
    -v "$PWD:/home/testuser/dotfiles" \
    -e GITHUB_TOKEN \
    -e HOME=/home/testuser \
    dotfiles-test \
    bash -c '
        set -e

        echo "==> Installing mise..."
        curl -fsSL https://mise.run | sh
        export PATH="$HOME/.local/bin:$HOME/.local/share/mise/shims:$PATH"

        echo "==> Running bootstrap..."
        mise trust
        mise bootstrap -y

        echo ""
        echo "==> Validating installation..."
        export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"

        echo "Checking bootstrap status..."
        mise bootstrap status

        echo "Checking brew packages..."
        tree --version

        echo "Checking tools..."
        nvim --version | head -1
        starship --version

        echo "Checking symlinks..."
        ls -la ~/.zshrc ~/.gitconfig ~/.ripgreprc
        ls -la ~/.config/nvim
        ls -la ~/.config/starship.toml ~/.config/mise/config.toml

        echo "Checking zshrc loads without errors..."
        zsh -c "source ~/.zshrc && echo zshrc OK"

        echo ""
        echo "==> All validations passed!"
    '
