#!/bin/bash

set -euo pipefail

cd "$(dirname "$0")/.."

echo "==> Building test container..."
docker build -t dotfiles-test -f - . <<'DOCKERFILE'
FROM ubuntu:22.04

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
docker run --rm \
    -v "$PWD:/home/testuser/dotfiles" \
    -e HOME=/home/testuser \
    dotfiles-test \
    bash -c '
        set -e

        echo "==> Running setup..."
        ./script/setup

        echo ""
        echo "==> Validating installation..."
        export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

        echo "Checking brew..."
        brew --version

        echo "Checking nvim..."
        nvim --version | head -1

        echo "Checking tmux..."
        tmux -V

        echo "Checking starship..."
        starship --version

        echo "Checking symlinks..."
        ls -la ~/.zshrc ~/.gitconfig ~/.tmux.conf ~/.ripgreprc
        ls -la ~/.config/nvim
        ls -la ~/.config/starship.toml

        echo "Checking zshrc loads without errors..."
        zsh -c "source ~/.zshrc && echo zshrc OK"

        echo ""
        echo "==> All validations passed!"
    '
