#!/usr/bin/env bash
set -euo pipefail
umask 077

if (( EUID == 0 )); then
  printf 'Run as your regular user. The script calls sudo as needed.\n' >&2
  exit 1
fi

. /etc/os-release
if [[ "${ID:-}" != debian ]]; then
  printf 'This script is intended for Debian.\n' >&2
  exit 1
fi

sudo apt-get update
sudo apt-get install -y zsh git pipx clamav ca-certificates curl gpg

if [[ ! -x "$HOME/.cargo/bin/cargo" ]] && ! command -v cargo >/dev/null; then
  sudo apt-get install -y cargo
fi

if [[ ! -x "$HOME/google-cloud-sdk/bin/gcloud" ]] && ! command -v gcloud >/dev/null; then
  if ! apt-cache show google-cloud-cli >/dev/null 2>&1; then
    curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg |
      gpg --batch --dearmor |
      sudo tee /usr/share/keyrings/cloud.google.gpg >/dev/null

    printf '%s\n' \
      'deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main' |
      sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list >/dev/null

    sudo apt-get update
  fi
  sudo apt-get install -y google-cloud-cli
fi

config_dir="${ZDOTDIR:-$HOME}"
mkdir -p -- "$config_dir"
stage_dir="$(mktemp -d "$config_dir/.zsh-setup.XXXXXXXX")"
trap 'rm -rf -- "$stage_dir"' EXIT

cat > "$stage_dir/.zsh-portable-env.zsh" <<'ZSH'
typeset -U path PATH
path+=("$HOME/.local/bin")
if [[ -r "$HOME/.cargo/env" ]]; then
  source "$HOME/.cargo/env"
fi
export PATH
ZSH

cat > "$stage_dir/.zsh-prompt-style.zsh" <<'ZSH'
autoload -Uz vcs_info add-zsh-hook compinit
setopt prompt_subst

if (( ! $+functions[compdef] )); then
  compinit
fi

for sdk_dir in "$HOME/google-cloud-sdk" /usr/lib/google-cloud-sdk; do
  if [[ -r "$sdk_dir/path.zsh.inc" ]]; then
    source "$sdk_dir/path.zsh.inc"
  fi
  if [[ -r "$sdk_dir/completion.zsh.inc" ]]; then
    source "$sdk_dir/completion.zsh.inc"
    break
  fi
done
unset sdk_dir

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats ' [%b]'
zstyle ':vcs_info:git:*' actionformats ' [%b|%a]'
add-zsh-hook precmd vcs_info

PROMPT=$'%F{cyan}%n@%m%f  %F{blue}%~%f%F{magenta}${vcs_info_msg_0_//\\%/%%}%f\n%F{green}❯%f '
RPROMPT='%(?..%F{red}exit %?%f)'
ZSH

stage_startup() {
  local name="$1" line="$2"
  if [[ -f "$config_dir/$name" ]]; then
    cat -- "$config_dir/$name" > "$stage_dir/$name"
  else
    touch -- "$stage_dir/$name"
  fi
  if ! grep -Fxq -- "$line" "$stage_dir/$name"; then
    printf '\n%s\n' "$line" >> "$stage_dir/$name"
  fi
}

stage_startup .zshenv 'source "${ZDOTDIR:-$HOME}/.zsh-portable-env.zsh"'
stage_startup .zshrc 'source "${ZDOTDIR:-$HOME}/.zsh-prompt-style.zsh"'

files=(.zsh-portable-env.zsh .zsh-prompt-style.zsh .zshenv .zshrc)
for name in "${files[@]}"; do
  zsh -fn "$stage_dir/$name"
done

backup_dir="$(mktemp -d "$HOME/zsh-setup-backup.XXXXXXXX")"
for name in "${files[@]}"; do
  if [[ -e "$config_dir/$name" || -L "$config_dir/$name" ]]; then
    cp -a -- "$config_dir/$name" "$backup_dir/"
  fi
done
printf 'Backup: %s\n' "$backup_dir"

for name in "${files[@]}"; do
  mv -fT -- "$stage_dir/$name" "$config_dir/$name"
done

ZDOTDIR="$config_dir" zsh -lic '
  set -e
  print -r -- "Zsh $ZSH_VERSION"
  for tool in git pipx cargo gcloud clamscan; do
    command -v "$tool"
  done
'

account="$(id -un)"
zsh_path=/usr/bin/zsh
current_shell="$(getent passwd "$account" | cut -d: -f7)"
if [[ "$current_shell" != "$zsh_path" ]]; then
  sudo chsh -s "$zsh_path" "$account"
fi

printf 'Setup complete. Log out and back in to use Zsh as your default shell.\n'
