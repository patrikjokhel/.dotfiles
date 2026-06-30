# .dotfiles

The archive of my dotfiles. Only macOS is supported for now. I don't have the time or will to write it for Linux. Maybe someday.

## Prerequisites

### macOS Setup

- Xcode Command Line Tools:

```sh
xcode-select --install
```

## Git Setup

Generate an SSH key and add it to your GitHub account:

```sh
ssh-keygen -t ed25519 -C "your@email.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub
```

[Add the key to GitHub](https://github.com/settings/keys).

Configure git:

```sh
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
```

## Clone

```sh
git clone git@github.com:patrikjokhel/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

## Setup Script

### macOS Setup

Run everything:

```sh
chmod +x ./setup-mac.sh
./setup-mac.sh
```

Or run individual stages:

| Flag           | Description                             |
| -------------- | --------------------------------------- |
| `--help`       | Show usage help                         |
| `--brew`       | Install Homebrew, formulae, and casks   |
| `--link`       | Symlink configs to `~/.config/` and `~` |
| `--oh-plugins` | Install oh-my-zsh and custom plugins    |

Add `--dry-run` to preview without making changes.

## Post-Setup

- **Powerlevel10k** — run `p10k configure` to customise the prompt, or adjust `~/.p10k.zsh`.
- **Neovim** — open `nvim` and let Lazy.nvim install all plugins, then run `:Lazy sync`.
- **tmux** — start tmux, then press `prefix` + `I` (capital i) to install TPM plugins.
- **Alacritty** — the config uses JetBrainsMono Nerd Font (installed via `--brew`). Verify icons render correctly.
