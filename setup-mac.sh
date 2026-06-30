#!/bin/bash

# Get home directory or default to ~
HOME_DIR="${HOME:-~}"

# Set pipeline fail on error
# - exit on error
# - undefined variables are errors
# - if any command fails, whole pipeline fails
set -euo pipefail


# Stage flags
RUN_HOMEBREW=false
RUN_LINK_CONFIGS=false
RUN_OH_MY_ZSH_PLUGINS=false

# Parse flags
if [ $# -eq 0 ]; then
    RUN_HOMEBREW=true
    RUN_LINK_CONFIGS=true
    RUN_OH_MY_ZSH_PLUGINS=true
else
    while [[ $# -gt 0 ]]; do
	case $1 in
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
		echo "Usage: $0 [--brew] [--link] [--oh-plugins]"
		exit 0
		;;
	    *)
		echo "Unknown flag '$1'"
		exit 1
		;;
	esac
    done
fi

if [ "$RUN_HOMEBREW" == true ]; then
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

fi

if [ "$RUN_LINK_CONFIGS" == true ]; then
    echo "Creating .config directory..."
    mkdir -p "$HOME_DIR/.config"

    CONFIG_LINKS=(
	aerospace
	alacritty
	nvim
    )

    for cfg in "${CONFIG_LINKS[@]}"; do
	echo "Linking in .config directory '$cfg'..."
	# ln -s "./$cfg" "$HOME_DIR/.config/$cfg"
	echo "ln -s './$cfg' '$HOME_DIR/.config/$cfg'"
    done

    HOMEDIR_LINKS=(
	tmux/.tmux.conf
	zsh/.zshrc
	zsh/.p10k.zsh
    )

    for link in "${HOMEDIR_LINKS[@]}"; do
	filename="${link##*/}"
	echo "Linking in home directory '$filename'..."
	# ln -s "./$link" "$HOME_DIR/$link"
	echo "ln -s './$link' '$HOME_DIR/$filename'"
    done


fi

if [[ "$RUN_OH_MY_ZSH_PLUGINS" = true ]]; then
    OH_MY_ZSH_REPO="git@github.com/ohmyzsh/ohmyzsh.git"
    if [ ! -d "$HOME_DIR/.oh-my-zsh" ]; then
        echo "Cloning oh-my-zsh..."
        # git clone "$OH_MY_ZSH_REPO" "$HOME_DIR/.oh-my-zsh"
	echo "git clone '$OH_MY_ZSH_REPO' '$HOME_DIR/.oh-my-zsh'"
    else
        echo "Repository '.oh-my-zsh' already exists at '$HOME_DIR/.oh-my-zsh', skipping clone."
    fi

    echo "Cloning oh-my-zsh custom plugins..."

    mkdir -p "$HOME_DIR/.oh-my-zsh/custom/plugins"

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
            # git clone "$repo" "$target_path"
	    echo "git clone '$repo' '$target_path'"
        else
            echo "Repository '$repo_dir' already exists at '$target_path', skipping clone."
        fi
    done

fi

echo "Done!"
