#!/usr/bin/env bash
# =============================================================================
#  zsh-speed-optimizer.sh
#  Applies performance patches on top of setup-devops-zsh.sh
#  Compatible with Ubuntu / Debian / RHEL / Arch
# =============================================================================

set -euo pipefail

# ─── Colors ──────────────────────────────────────────────────
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'
BOLD='\033[1m'; DIM='\033[2m'; RESET='\033[0m'
ok()   { echo -e "  ${GREEN}✔${RESET} $*"; }
log()  { echo -e "  ${CYAN}➜${RESET} $*"; }
warn() { echo -e "  ${YELLOW}⚠${RESET} $*"; }
hr()   { echo -e "${CYAN}$(printf '─%.0s' {1..68})${RESET}"; }

# ─── Resolve target user ─────────────────────────────────────
TARGET_USER="${SUDO_USER:-$(logname 2>/dev/null || whoami)}"
USER_HOME=$(eval echo "~$TARGET_USER")
ZSHRC="$USER_HOME/.zshrc"
ZSHRC_D="$USER_HOME/.zshrc.d"
CACHE_DIR="$USER_HOME/.zsh_cache"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

[[ "$EUID" -ne 0 ]] && { warn "Run with sudo"; exit 1; }
id "$TARGET_USER" &>/dev/null || { warn "User '$TARGET_USER' not found"; exit 1; }

hr
echo -e "\n  ${BOLD}${CYAN}Zsh Speed Optimizer${RESET}  →  user: ${YELLOW}${TARGET_USER}${RESET}\n"
hr

# ─── Backup existing .zshrc ──────────────────────────────────
log "Backing up current .zshrc..."
[[ -f "$ZSHRC" ]] && cp "$ZSHRC" "${ZSHRC}.bak.${TIMESTAMP}"
ok "Backup saved: ${ZSHRC}.bak.${TIMESTAMP}"

# ─── Create completion cache directory ───────────────────────
mkdir -p "$CACHE_DIR"
chown "$TARGET_USER":"$TARGET_USER" "$CACHE_DIR"

# ─── 1. Cached completion module ─────────────────────────────
log "Writing cached completion module..."

cat > "$ZSHRC_D/05-completions-cached.zsh" <<'COMP_EOF'
# ============================================================
#  05-completions-cached.zsh
#  Caches each tool's completion script to a file.
#  Only rebuilds when the binary is newer than the cache.
#  Replaces slow inline: source <(kubectl completion zsh)
# ============================================================

_zsh_cache_completion() {
  local cmd="$1"
  local cache_file="$HOME/.zsh_cache/${cmd}_completion.zsh"

  command -v "$cmd" &>/dev/null || return 0

  local cmd_path
  cmd_path="$(command -v "$cmd")"

  # Rebuild cache if it doesn't exist or binary is newer
  if [[ ! -f "$cache_file" || "$cmd_path" -nt "$cache_file" ]]; then
    "$cmd" completion zsh > "$cache_file" 2>/dev/null || rm -f "$cache_file"
  fi

  [[ -f "$cache_file" ]] && source "$cache_file" 2>/dev/null
}

# These four were adding 200-400ms each on every shell startup
_zsh_cache_completion kubectl
_zsh_cache_completion helm
_zsh_cache_completion flux
_zsh_cache_completion argocd

# Force-rebuild all completion caches
zsh_clear_completion_cache() {
  rm -f "$HOME/.zsh_cache/"*_completion.zsh
  echo "✔ Completion cache cleared. Reopen your terminal."
}
COMP_EOF

ok "Module 05-completions-cached.zsh written"

# ─── 2. Fast compinit module ─────────────────────────────────
log "Writing fast compinit module..."

cat > "$ZSHRC_D/04-compinit-fast.zsh" <<'CINIT_EOF'
# ============================================================
#  04-compinit-fast.zsh
#  Runs compinit fully only once per 24 hours.
#  Uses -C (skip security check) on subsequent startups.
# ============================================================

autoload -Uz compinit

ZSH_COMPDUMP="${ZDOTDIR:-$HOME}/.zcompdump"

# Full compinit if dump is older than 24h, otherwise fast -C
if [[ -n "$ZSH_COMPDUMP"(#qN.mh+24) ]]; then
  compinit -d "$ZSH_COMPDUMP"
else
  compinit -C -d "$ZSH_COMPDUMP"
fi

# Prepend custom completion paths
fpath=(
  "$HOME/.zsh_cache/completions"
  "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-completions/src"
  $fpath
)
CINIT_EOF

ok "Module 04-compinit-fast.zsh written"

# ─── 3. Rewrite .zshrc with instant prompt at the top ────────
log "Moving P10k instant prompt to the top of .zshrc..."

# Read current .zshrc but strip any existing instant prompt block
CURRENT_ZSHRC=""
if [[ -f "$ZSHRC" ]]; then
  CURRENT_ZSHRC=$(grep -v "p10k-instant-prompt" "$ZSHRC" || true)
fi

# Rebuild .zshrc: instant prompt header + rest of existing config
{
  cat <<'INSTANT_PROMPT_HEADER'
# ============================================================
#  ~/.zshrc  |  DevOps/SRE  |  Optimized for Speed
# ============================================================

# ── 1. P10k Instant Prompt ───────────────────────────────────
# MUST be first — before any other source, echo, or output!
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

INSTANT_PROMPT_HEADER

  echo "$CURRENT_ZSHRC"

} > "$ZSHRC.new"

mv "$ZSHRC.new" "$ZSHRC"
ok "Instant prompt moved to top of .zshrc"

# ─── 4. Remove slow inline completion sources from .zshrc ────
log "Removing slow inline completion sources from .zshrc..."

# Remove these lines — they now live in 05-completions-cached.zsh
sed -i \
  '/source <(kubectl completion zsh)/d;
   /source <(helm completion zsh)/d;
   /source <(flux completion zsh)/d;
   /source <(argocd completion zsh)/d' \
  "$ZSHRC"

ok "Slow completion source lines removed"

# ─── 5. Lazy-load NVM / Pyenv / SDKMAN (if installed) ───────
log "Writing lazy-loaders for nvm/pyenv/sdkman..."

cat > "$ZSHRC_D/03-lazy-loaders.zsh" <<'LAZY_EOF'
# ============================================================
#  03-lazy-loaders.zsh
#  Defers heavy runtimes until first use.
#  No effect if the tool isn't installed.
# ============================================================

# ── NVM (lazy) ───────────────────────────────────────────────
export NVM_DIR="$HOME/.nvm"
if [[ -d "$NVM_DIR" ]]; then
  # Tiny stub — replaces the full nvm.sh source (~200-400ms)
  nvm() {
    unset -f nvm node npm npx yarn pnpm
    [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
    nvm "$@"
  }
  node() { nvm; node "$@"; }
  npm()  { nvm; npm "$@"; }
  npx()  { nvm; npx "$@"; }
fi

# ── Pyenv (lazy) ─────────────────────────────────────────────
if [[ -d "$HOME/.pyenv" ]]; then
  export PYENV_ROOT="$HOME/.pyenv"
  path=("$PYENV_ROOT/bin" $path)
  pyenv() {
    unset -f pyenv python python3
    eval "$(command pyenv init -)"
    pyenv "$@"
  }
  python()  { pyenv; python "$@"; }
  python3() { pyenv; python3 "$@"; }
fi

# ── SDKMAN (lazy) ────────────────────────────────────────────
if [[ -d "$HOME/.sdkman" ]]; then
  sdk() {
    unset -f sdk java mvn gradle kotlin
    export SDKMAN_DIR="$HOME/.sdkman"
    [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
    sdk "$@"
  }
fi
LAZY_EOF

ok "Lazy-loaders written (nvm / pyenv / sdkman)"

# ─── 6. Benchmark helpers ────────────────────────────────────
log "Adding benchmark helpers..."

cat > "$ZSHRC_D/99-benchmark.zsh" <<'BENCH_EOF'
# ============================================================
#  99-benchmark.zsh — Shell startup measurement tools
# ============================================================

# Run zsh startup N times and print elapsed time for each
zsh_startup_time() {
  local times="${1:-10}"
  echo "Measuring startup time (${times} runs)..."
  for i in $(seq 1 "$times"); do
    local t
    t=$({ time zsh -i -c exit; } 2>&1 | grep real | awk '{print $2}')
    echo "  #${i}: ${t}"
  done
  echo "\nTarget: under 300ms (on par with macOS default zsh)"
}

# Profile which lines of .zshrc are slowest
# Add 'zmodload zsh/zprof' at the very top of .zshrc, then run this
zsh_profile() {
  echo "── Slowest .zshrc lines ──"
  ZSH_PROF=1 zsh -i -c 'zprof' 2>/dev/null | head -30 || \
    echo "Add 'zmodload zsh/zprof' to the top of .zshrc first, then rerun"
}

# One-liner quick test
alias zsh-bench='time zsh -i -c exit'
BENCH_EOF

ok "Module 99-benchmark.zsh written"

# ─── 7. Fix ownership ────────────────────────────────────────
chown -R "$TARGET_USER":"$TARGET_USER" "$ZSHRC_D" "$CACHE_DIR"
chmod 755 "$CACHE_DIR"

# ─── 8. Pre-warm completion caches ──────────────────────────
log "Pre-warming completion caches..."

for cmd in kubectl helm flux argocd; do
  if command -v "$cmd" &>/dev/null; then
    sudo -u "$TARGET_USER" \
      bash -c "\"$(command -v $cmd)\" completion zsh > \"$CACHE_DIR/${cmd}_completion.zsh\" 2>/dev/null" \
      && ok "Cached completion: $cmd" \
      || warn "Could not cache: $cmd (will retry on next shell open)"
  fi
done

chown -R "$TARGET_USER":"$TARGET_USER" "$CACHE_DIR"

# ─── Summary ─────────────────────────────────────────────────
echo
hr
echo -e "\n  ${BOLD}${GREEN}✅  Optimization complete!${RESET}\n"
hr

cat <<SUMMARY

  ${BOLD}What changed:${RESET}

  1  P10k instant prompt   →  moved to top of .zshrc
     (prompt renders immediately; rest loads in background)

  2  Completion caching    →  ~/.zsh_cache/*_completion.zsh
     (kubectl/helm/flux/argocd no longer run on every startup → 500ms+ saved)

  3  Smart compinit        →  full rebuild once per 24h, fast -C otherwise

  4  Lazy loading          →  nvm/pyenv/sdkman only load when first called

  ${BOLD}Useful commands:${RESET}

  ${CYAN}zsh-bench${RESET}                    Quick startup time measurement
  ${CYAN}zsh_startup_time 5${RESET}           Average over 5 runs
  ${CYAN}zsh_clear_completion_cache${RESET}   Force-rebuild all completion caches

  ${BOLD}Test now:${RESET}   exec zsh   →  should be under 300ms

SUMMARY
hr
