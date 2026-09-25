#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# macOS-like Zsh setup for Ubuntu / Debian
#
# - Clean macOS-style prompt
# - No Nerd Font required
# - No weird file/folder icons
# - Real `cat` command (no bat alias)
# - Oh My Zsh
# - Autosuggestions
# - Syntax highlighting
# - Extra completions
# - fzf
# - zoxide
# - eza if available
# - Non-interactive installation
# ============================================================

export DEBIAN_FRONTEND=noninteractive

if [[ $EUID -eq 0 ]]; then
    TARGET_USER="${SUDO_USER:-root}"
else
    TARGET_USER="$USER"
fi

TARGET_HOME="$(getent passwd "$TARGET_USER" | cut -d: -f6)"

if [[ -z "$TARGET_HOME" || ! -d "$TARGET_HOME" ]]; then
    echo "ERROR: Could not determine home directory for $TARGET_USER"
    exit 1
fi

echo
echo "=============================================="
echo " Installing macOS-like Zsh for: $TARGET_USER"
echo " Home: $TARGET_HOME"
echo "=============================================="
echo

run_as_user() {
    if [[ $EUID -eq 0 && "$TARGET_USER" != "root" ]]; then
        sudo -u "$TARGET_USER" HOME="$TARGET_HOME" bash -c "$1"
    else
        HOME="$TARGET_HOME" bash -c "$1"
    fi
}

# ------------------------------------------------------------
# Packages
# ------------------------------------------------------------

echo ">>> Installing packages..."

apt-get update -y

apt-get install -y \
    zsh \
    git \
    curl \
    wget \
    ca-certificates \
    unzip \
    fzf \
    ripgrep \
    less \
    nano \
    command-not-found

# zoxide
apt-get install -y zoxide 2>/dev/null || true

# eza
apt-get install -y eza 2>/dev/null || true

# bat
apt-get install -y bat 2>/dev/null || true

# fd
apt-get install -y fd-find 2>/dev/null || true

# Ubuntu/Debian compatibility
if command -v batcat >/dev/null 2>&1 && ! command -v bat >/dev/null 2>&1; then
    ln -sf /usr/bin/batcat /usr/local/bin/bat
fi

if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
    ln -sf /usr/bin/fdfind /usr/local/bin/fd
fi

# ------------------------------------------------------------
# Oh My Zsh
# ------------------------------------------------------------

ZSH_DIR="$TARGET_HOME/.oh-my-zsh"
CUSTOM_DIR="$ZSH_DIR/custom"

if [[ ! -d "$ZSH_DIR" ]]; then
    echo ">>> Installing Oh My Zsh..."

    run_as_user "
        git clone --depth=1 \
        https://github.com/ohmyzsh/ohmyzsh.git \
        '$ZSH_DIR'
    "
else
    echo ">>> Oh My Zsh already installed."
fi

mkdir -p "$CUSTOM_DIR/plugins"
chown -R "$TARGET_USER:$TARGET_USER" "$ZSH_DIR" 2>/dev/null || true

# ------------------------------------------------------------
# Plugins
# ------------------------------------------------------------

echo ">>> Installing Zsh plugins..."

if [[ ! -d "$CUSTOM_DIR/plugins/zsh-autosuggestions" ]]; then
    run_as_user "
        git clone --depth=1 \
        https://github.com/zsh-users/zsh-autosuggestions.git \
        '$CUSTOM_DIR/plugins/zsh-autosuggestions'
    "
fi

if [[ ! -d "$CUSTOM_DIR/plugins/zsh-syntax-highlighting" ]]; then
    run_as_user "
        git clone --depth=1 \
        https://github.com/zsh-users/zsh-syntax-highlighting.git \
        '$CUSTOM_DIR/plugins/zsh-syntax-highlighting'
    "
fi

if [[ ! -d "$CUSTOM_DIR/plugins/zsh-completions" ]]; then
    run_as_user "
        git clone --depth=1 \
        https://github.com/zsh-users/zsh-completions.git \
        '$CUSTOM_DIR/plugins/zsh-completions'
    "
fi

# ------------------------------------------------------------
# Backup old config
# ------------------------------------------------------------

if [[ -f "$TARGET_HOME/.zshrc" ]]; then
    BACKUP="$TARGET_HOME/.zshrc.backup.$(date +%Y%m%d-%H%M%S)"
    cp "$TARGET_HOME/.zshrc" "$BACKUP"
    chown "$TARGET_USER:$TARGET_USER" "$BACKUP" 2>/dev/null || true

    echo ">>> Previous .zshrc backed up:"
    echo "    $BACKUP"
fi

# Remove old Powerlevel10k config if present.
# We don't need it for the macOS-like prompt.
rm -f "$TARGET_HOME/.p10k.zsh" 2>/dev/null || true

# ------------------------------------------------------------
# New Zsh config
# ------------------------------------------------------------

echo ">>> Writing ~/.zshrc..."

cat > "$TARGET_HOME/.zshrc" <<'ZSHRC'
# ============================================================
# macOS-like Zsh configuration
# ============================================================

export ZSH="$HOME/.oh-my-zsh"

# Don't use a theme.
# macOS Terminal uses a clean/simple Zsh prompt.
ZSH_THEME=""

# ------------------------------------------------------------
# Oh My Zsh
# ------------------------------------------------------------

DISABLE_AUTO_UPDATE=true
DISABLE_UPDATE_PROMPT=true
DISABLE_MAGIC_FUNCTIONS=true

plugins=(
    git
    sudo
    extract
    command-not-found
    colored-man-pages
    history-substring-search
    zsh-autosuggestions
    zsh-completions
)

source "$ZSH/oh-my-zsh.sh"

# Syntax highlighting must be loaded last.
if [[ -f "$ZSH/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
    source "$ZSH/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# ============================================================
# macOS-like prompt
# ============================================================

# Example:
#
# reza@server ~/Downloads %
#
# root becomes red automatically.

setopt PROMPT_SUBST

if [[ "$EUID" -eq 0 ]]; then
    PROMPT='%F{red}%n%f@%F{yellow}%m%f %F{cyan}%~%f %# '
else
    PROMPT='%F{green}%n%f@%F{yellow}%m%f %F{cyan}%~%f %# '
fi

RPROMPT=''

# ------------------------------------------------------------
# History
# ------------------------------------------------------------

HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt EXTENDED_HISTORY

# ------------------------------------------------------------
# Completion
# ------------------------------------------------------------

autoload -Uz compinit
compinit

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list \
    'm:{a-zA-Z}={A-Za-z}'

# ------------------------------------------------------------
# Key bindings
# ------------------------------------------------------------

bindkey -e

# Up/down searches command history based on what you've typed.
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Ctrl + arrow
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

# Home / End
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line

# Delete
bindkey '^[[3~' delete-char

# ------------------------------------------------------------
# Autosuggestions
# ------------------------------------------------------------

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# ------------------------------------------------------------
# fzf
# ------------------------------------------------------------

if command -v fzf >/dev/null 2>&1; then

    [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]] && \
        source /usr/share/doc/fzf/examples/key-bindings.zsh

    [[ -f /usr/share/doc/fzf/examples/completion.zsh ]] && \
        source /usr/share/doc/fzf/examples/completion.zsh
fi

# ------------------------------------------------------------
# zoxide
# ------------------------------------------------------------

if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
fi

# ============================================================
# ls
#
# IMPORTANT:
# No --icons here.
#
# This prevents the strange symbols beside files/directories.
# ============================================================

if command -v eza >/dev/null 2>&1; then

    alias ls='eza --group-directories-first'
    alias ll='eza -lah --group-directories-first --git'
    alias la='eza -la --group-directories-first'
    alias l='eza -lh --group-directories-first'
    alias tree='eza --tree --group-directories-first'

else

    alias ls='ls --color=auto'
    alias ll='ls -lah --color=auto'
    alias la='ls -la --color=auto'
    alias l='ls -lh --color=auto'

fi

# ============================================================
# CAT
#
# DO NOT alias cat to bat.
#
# `cat ~/.ssh/id_rsa.pub`
# will now display the entire key normally.
# ============================================================

unalias cat 2>/dev/null || true

# Use bat explicitly when you WANT syntax highlighting:
#
#   bat file.txt
#
# Normal:
#
#   cat file.txt

# ------------------------------------------------------------
# macOS-like convenience aliases
# ------------------------------------------------------------

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias c='clear'

alias h='history'

alias grep='grep --color=auto'

alias ports='ss -tulpn'

alias myip='curl -4 -s ifconfig.me; echo'

alias reload='source ~/.zshrc'

alias zshconfig='nano ~/.zshrc'

# ------------------------------------------------------------
# Git
# ------------------------------------------------------------

alias gs='git status -sb'
alias ga='git add'
alias gc='git commit'
alias gp='git push'

alias gl='git log \
--graph \
--decorate \
--pretty=oneline \
--abbrev-commit \
--all'

# ------------------------------------------------------------
# Docker
# ------------------------------------------------------------

alias dps='docker ps'
alias dcu='docker compose up -d'
alias dcd='docker compose down'
alias dcl='docker compose logs -f --tail=100'

# ------------------------------------------------------------
# Linux
# ------------------------------------------------------------

alias update='sudo apt update && sudo apt upgrade -y'
alias install='sudo apt install -y'

# ------------------------------------------------------------
# Editor
# ------------------------------------------------------------

export EDITOR=nano
export VISUAL=nano

# ------------------------------------------------------------
# Colors
# ------------------------------------------------------------

export CLICOLOR=1

# GNU ls colors
if command -v dircolors >/dev/null 2>&1; then
    eval "$(dircolors -b)"
fi

# ------------------------------------------------------------
# Local custom settings
# ------------------------------------------------------------

[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

ZSHRC

chown "$TARGET_USER:$TARGET_USER" "$TARGET_HOME/.zshrc"

# ------------------------------------------------------------
# Default shell
# ------------------------------------------------------------

ZSH_BIN="$(command -v zsh)"

CURRENT_SHELL="$(getent passwd "$TARGET_USER" | cut -d: -f7)"

if [[ "$CURRENT_SHELL" != "$ZSH_BIN" ]]; then

    echo ">>> Changing default shell to Zsh..."

    chsh -s "$ZSH_BIN" "$TARGET_USER" || true
fi

echo
echo "=============================================="
echo " macOS-like Zsh installation complete"
echo "=============================================="
echo
echo "User : $TARGET_USER"
echo "Shell: $ZSH_BIN"
echo
echo "Starting Zsh..."
echo

if [[ "$EUID" -eq 0 && "$TARGET_USER" != "root" ]]; then
    exec sudo -u "$TARGET_USER" HOME="$TARGET_HOME" "$ZSH_BIN" -l
else
    exec "$ZSH_BIN" -l
fi
