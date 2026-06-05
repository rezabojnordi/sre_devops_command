#!/usr/bin/env bash
set -euo pipefail

# mac_like_zsh_setup.sh
# Ubuntu/Debian installer for a macOS-like Zsh terminal experience.
# It installs Zsh, Oh My Zsh, Powerlevel10k, autosuggestions, syntax highlighting,
# completions, fzf, eza, bat, zoxide, and writes an optimized ~/.zshrc.

if [[ $EUID -eq 0 ]]; then
  TARGET_USER="${SUDO_USER:-root}"
  TARGET_HOME="$(getent passwd "$TARGET_USER" | cut -d: -f6)"
else
  TARGET_USER="$USER"
  TARGET_HOME="$HOME"
fi

if [[ -z "$TARGET_HOME" || ! -d "$TARGET_HOME" ]]; then
  echo "Could not detect target home directory."
  exit 1
fi

run_as_user() {
  if [[ $EUID -eq 0 && "$TARGET_USER" != "root" ]]; then
    sudo -u "$TARGET_USER" HOME="$TARGET_HOME" bash -lc "$*"
  else
    HOME="$TARGET_HOME" bash -lc "$*"
  fi
}

echo "### Installing packages"
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y zsh git curl wget ca-certificates unzip fzf zoxide

# Nice replacements, package names differ by distro/version.
apt-get install -y eza bat fd-find ripgrep 2>/dev/null || true

# Debian/Ubuntu often installs bat as batcat and fd as fdfind.
if command -v batcat >/dev/null 2>&1 && ! command -v bat >/dev/null 2>&1; then
  ln -sf /usr/bin/batcat /usr/local/bin/bat
fi
if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
  ln -sf /usr/bin/fdfind /usr/local/bin/fd
fi

ZSH_DIR="$TARGET_HOME/.oh-my-zsh"
CUSTOM_DIR="$ZSH_DIR/custom"

if [[ ! -d "$ZSH_DIR" ]]; then
  echo "### Installing Oh My Zsh"
  run_as_user "git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git '$ZSH_DIR'"
fi

echo "### Installing theme and plugins"
run_as_user "mkdir -p '$CUSTOM_DIR/themes' '$CUSTOM_DIR/plugins'"

if [[ ! -d "$CUSTOM_DIR/themes/powerlevel10k" ]]; then
  run_as_user "git clone --depth=1 https://github.com/romkatv/powerlevel10k.git '$CUSTOM_DIR/themes/powerlevel10k'"
fi
if [[ ! -d "$CUSTOM_DIR/plugins/zsh-autosuggestions" ]]; then
  run_as_user "git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions '$CUSTOM_DIR/plugins/zsh-autosuggestions'"
fi
if [[ ! -d "$CUSTOM_DIR/plugins/zsh-syntax-highlighting" ]]; then
  run_as_user "git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git '$CUSTOM_DIR/plugins/zsh-syntax-highlighting'"
fi
if [[ ! -d "$CUSTOM_DIR/plugins/zsh-completions" ]]; then
  run_as_user "git clone --depth=1 https://github.com/zsh-users/zsh-completions '$CUSTOM_DIR/plugins/zsh-completions'"
fi

BACKUP="$TARGET_HOME/.zshrc.backup.$(date +%Y%m%d-%H%M%S)"
if [[ -f "$TARGET_HOME/.zshrc" ]]; then
  cp "$TARGET_HOME/.zshrc" "$BACKUP"
  chown "$TARGET_USER:$TARGET_USER" "$BACKUP" 2>/dev/null || true
  echo "### Old ~/.zshrc backed up to $BACKUP"
fi

cat > "$TARGET_HOME/.zshrc" <<'ZSHRC'
# ~/.zshrc - macOS-like optimized Zsh for Linux
# Reload with: source ~/.zshrc

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Oh My Zsh behavior
DISABLE_MAGIC_FUNCTIONS=true
COMPLETION_WAITING_DOTS=true
HIST_STAMPS="yyyy-mm-dd"

plugins=(
  git
  sudo
  command-not-found
  extract
  colored-man-pages
  history-substring-search
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-completions
)

source "$ZSH/oh-my-zsh.sh"

# Powerlevel10k instant prompt. Keep this near the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# macOS-like prompt settings using Powerlevel10k.
# To customize visually later: p10k configure
POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
POWERLEVEL9K_MODE=nerdfont-complete
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_RPROMPT_ON_NEWLINE=false
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX='╭─'
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX='╰─%F{blue}❯%f '
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time background_jobs time)
POWERLEVEL9K_DIR_FOREGROUND=39
POWERLEVEL9K_DIR_SHORTENED_FOREGROUND=39
POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=39
POWERLEVEL9K_VCS_CLEAN_FOREGROUND=76
POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=178
POWERLEVEL9K_STATUS_OK=false
POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=2
POWERLEVEL9K_TIME_FORMAT='%D{%H:%M}'

# History: Mac-like useful persistent history
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt EXTENDED_HISTORY

# Better completion
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' verbose yes
autoload -Uz compinit
compinit

# Keybindings similar to macOS/iTerm comfort
bindkey -e
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[3~' delete-char

# Autosuggestion style
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# Syntax highlighting must be loaded near the end; plugin handles it.

# fzf integration
if command -v fzf >/dev/null 2>&1; then
  source /usr/share/doc/fzf/examples/key-bindings.zsh 2>/dev/null || true
  source /usr/share/doc/fzf/examples/completion.zsh 2>/dev/null || true
fi

# zoxide: smarter cd, use `z foldername`
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# eza/bat modern mac-like defaults
if command -v eza >/dev/null 2>&1; then
  alias ls='eza --icons=auto --group-directories-first'
  alias ll='eza -lah --icons=auto --group-directories-first --git'
  alias la='eza -la --icons=auto --group-directories-first'
  alias tree='eza --tree --icons=auto --group-directories-first'
else
  alias ll='ls -lah --color=auto'
  alias la='ls -la --color=auto'
fi

if command -v bat >/dev/null 2>&1; then
  alias cat='bat --paging=never --style=plain'
fi

# Handy aliases
alias ..='cd ..'
alias ...='cd ../..'
alias c='clear'
alias h='history'
alias grep='grep --color=auto'
alias ip='ip --color=auto'
alias ports='ss -tulpn'
alias myip='curl -4 ifconfig.me; echo'
alias reload='source ~/.zshrc'
alias zshconfig='${EDITOR:-nano} ~/.zshrc'

# Git aliases
alias gs='git status -sb'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate --all -20'

# Docker aliases, harmless if Docker is not installed
alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dcu='docker compose up -d'
alias dcd='docker compose down'
alias dcl='docker compose logs -f --tail=100'

# Linux helpers
alias update='sudo apt update && sudo apt upgrade -y'
alias install='sudo apt install -y'
alias path='echo $PATH | tr ":" "\n"'

# Editor default
export EDITOR='nano'
export VISUAL='nano'

# Less colors for man pages
export LESS_TERMCAP_mb=$'\e[1;31m'
export LESS_TERMCAP_md=$'\e[1;36m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;44;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;32m'

# Optional local overrides
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
ZSHRC

chown "$TARGET_USER:$TARGET_USER" "$TARGET_HOME/.zshrc" 2>/dev/null || true

ZSH_BIN="$(command -v zsh)"
CURRENT_SHELL="$(getent passwd "$TARGET_USER" | cut -d: -f7)"
if [[ "$CURRENT_SHELL" != "$ZSH_BIN" ]]; then
  echo "### Changing default shell to zsh for $TARGET_USER"
  chsh -s "$ZSH_BIN" "$TARGET_USER" || echo "Could not change shell automatically. Run: chsh -s $ZSH_BIN"
fi

echo
 echo "DONE. Close and reopen terminal, or run: exec zsh"
 echo "For the best macOS-like icons, install a Nerd Font on your terminal and select it."
 echo "To customize the prompt later, run: p10k configure"
