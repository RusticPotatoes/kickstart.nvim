#!/usr/bin/env bash

set -euo pipefail

echo "Bootstrapping Neovim environment..."

# --- FUNCTIONS ---
install_brew_pkg() {
  if ! brew list "$1" &>/dev/null; then
    echo "Installing $1..."
    brew install "$1"
  else
    echo "$1 already installed"
  fi
}

install_apt_pkg() {
  if ! dpkg -s "$1" &>/dev/null; then
    echo "Installing $1..."
    sudo apt-get install -y "$1"
  else
    echo "$1 already installed"
  fi
}

# --- OS DETECTION ---
if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "Detected macOS"
  command -v brew >/dev/null 2>&1 || {
    echo "Homebrew not found. Install it from https://brew.sh/"
    exit 1
  }

  install_brew_pkg neovim
  install_brew_pkg ripgrep
  install_brew_pkg fd
  install_brew_pkg fzf
  install_brew_pkg tree-sitter
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  echo "Detected Linux"
  sudo apt-get update
  install_apt_pkg neovim
  install_apt_pkg ripgrep
  install_apt_pkg fd-find
  install_apt_pkg fzf
  install_apt_pkg tree-sitter
else
  echo "Unsupported OS: $OSTYPE"
  exit 1
fi

# --- OPTIONAL: Clone your Neovim config ---
read -rp "Clone a Neovim config (like Kickstart)? [y/N] " clone_choice
if [[ "$clone_choice" == "y" || "$clone_choice" == "Y" ]]; then
  git clone https://github.com/nvim-lua/kickstart.nvim ~/.config/nvim
  echo "Kickstart cloned to ~/.config/nvim"
fi

echo "Done. You can now run: nvim"