#!/bin/bash

# Get home directory or default to ~
HOME_DIR="${HOME:-~}"

# Absolute path to the dotfiles directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
echo "SCRIPT_DIR: $SCRIPT_DIR"

# Set pipeline fail on error
# - exit on error
# - undefined variables are errors
# - if any command fails, whole pipeline fails
set -euo pipefail

# Stage flags
DRY_RUN=false
RUN_HOMEBREW=false
RUN_LINK_CONFIGS=false
RUN_OH_MY_ZSH_PLUGINS=false

# Extract --dry-run flag and separate remaining arguments
REMAINING_ARGS=()
for arg in "$@"; do
	if [ "$arg" == "--dry-run" ]; then
		echo "DRY RUN MODE ENABLED"
		DRY_RUN=true
		break
	else
		REMAINING_ARGS+=("$arg")
	fi
done

# Parse flags
if [ ${#REMAINING_ARGS[@]} -eq 0 ]; then
	RUN_HOMEBREW=true
	RUN_LINK_CONFIGS=true
	RUN_OH_MY_ZSH_PLUGINS=true
else
	for arg in "${REMAINING_ARGS[@]}"; do
		case "$arg" in
		--brew)
			RUN_HOMEBREW=true
			shift
			;;
		--link)
			RUN_LINK_CONFIGS=true
			shift
			;;
		--oh-plugins)
			RUN_OH_MY_ZSH_PLUGINS=true
			shift
			;;
		--help)
			echo "Usage: $0 [--brew] [--link] [--oh-plugins] [--dry-run]"
			exit 0
			;;
		*)
			echo "Unknown flag '$1'"
			exit 1
			;;
		esac
	done
fi

# ==============================================================================
# MAINTAINABILITY HELPERS (The "Dry-Run" Abstraction Layer)
# ==============================================================================

# Wrapper for running file-system commands
run_cmd() {
	if [ "$DRY_RUN" == true ]; then
		echo "[DRY-RUN] $*"
	else
		"$@"
	fi
}

# Wrapper for running brew install
run_brew_install() {
	if [ "$DRY_RUN" == true ]; then
		echo "[DRY-RUN] brew install -y $*"
		brew install -n -y "$@"
	else
		brew install -y "$@"
	fi
}

# Wrapper for running git clone
run_git_clone() {
	local repo="$1"
	local target="$2"

	if [ -d "$target" ] && [ "$DRY_RUN" = false ]; then
		echo "Repository already exists at '$target', skipping."
		return
	fi

	if [ "$DRY_RUN" = true ]; then
		echo "[DRY RUN] git clone '$repo' '$target'"
	else
		git clone "$repo" "$target"
	fi
}

if [ "$RUN_HOMEBREW" == true ]; then
	if ! command -v brew >/dev/null 2>&1; then
		echo "Installing homebrew..."
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	fi

	BREW_TRUSTED_TAPS=(
		nikitabobko/tap
	)

	for tap in "${BREW_TRUSTED_TAPS[@]}"; do
		echo "Trusting tap '$tap'..."
		run_cmd brew trust "$tap"
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
		zoxide
		nvm
	)
	BREW_CASKS=(
		font-jetbrains-mono-nerd-font
		aerospace
		alacritty
		bruno
	)

	run_brew_install "${BREW_FORMULAE[@]}"
	run_brew_install --cask "${BREW_CASKS[@]}"

fi

if [ "$RUN_LINK_CONFIGS" == true ]; then
	echo "Creating .config directory..."
	run_cmd mkdir -p "$HOME_DIR/.config"

	CONFIG_LINKS=(
		aerospace
		alacritty
		nvim
	)

	for cfg in "${CONFIG_LINKS[@]}"; do
		echo "Linking in .config directory '$cfg'..."
		run_cmd ln -s "$SCRIPT_DIR/$cfg" "$HOME_DIR/.config/$cfg"
	done

	HOMEDIR_LINKS=(
		tmux/.tmux.conf
		zsh/.zshrc
		zsh/.p10k.zsh
	)

	for link in "${HOMEDIR_LINKS[@]}"; do
		filename="${link##*/}"
		echo "Linking in home directory '$filename'..."
		run_cmd ln -s "$SCRIPT_DIR/$link" "$HOME_DIR/$filename"
	done

fi

if [[ "$RUN_OH_MY_ZSH_PLUGINS" = true ]]; then
	OH_MY_ZSH_REPO="git@github.com/ohmyzsh/ohmyzsh.git"

	if [ ! -d "$HOME_DIR/.oh-my-zsh" ]; then
		echo "Cloning oh-my-zsh..."
		run_git_clone "$OH_MY_ZSH_REPO" "$HOME_DIR/.oh-my-zsh"
	else
		echo "Repository '.oh-my-zsh' already exists at '$HOME_DIR/.oh-my-zsh', skipping clone."
	fi

	echo "Cloning oh-my-zsh custom plugins..."
	run_cmd mkdir -p "$HOME_DIR/.oh-my-zsh/custom/plugins"

	GIT_REPOS=(
		git@github.com/zsh-users/zsh-syntax-highlighting.git
		git@github.com/zsh-users/zsh-autosuggestions
	)

	for repo in "${GIT_REPOS[@]}"; do
		# 1. Get the last part: 'zsh-syntax-highlighting.git'
		repo_dir="${repo##*/}"
		# 2. Strip the trailing '.git': 'zsh-syntax-highlighting'
		repo_dir="${repo_dir%.git}"

		target_path="$HOME_DIR/.oh-my-zsh/custom/plugins/$repo_dir"

		echo "Cloning git repository '$repo' to '$target_path'..."
		if [ ! -d "$target_path" ]; then
			run_git_clone "$repo" "$target_path"
		else
			echo "Repository '$repo_dir' already exists at '$target_path', skipping clone."
		fi
	done

fi

echo "Done!"
