#!/bin/bash

# Set pipeline fail on error
# - exit on error
# - undefined variables are errors
# - if any command fails, whole pipeline fails
set -euo pipefail

if ! command -v brew > /dev/null 2>&1; then
    echo "Installing homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

BREW_TRUSTED_TAPS=(
    nikitabobko/tap
)

for tap in "${BREW_TRUSTED_TAPS[@]}"; do
    echo "Trusting tap '$tap'..."
    brew trust "$tap"
done

BREW_FORMULAE=(
    tmux
    neovim
    jq
    maven
    protobuf
    ripgrep
    telnet
    watch
    opencode
)
BREW_CASKS=(
    aerospace
    alacritty
    bruno
)

brew install -y -n "${BREW_FORMULAE[@]}"
brew install -y -n --cask "${BREW_CASKS[@]}"

echo "Done!"
