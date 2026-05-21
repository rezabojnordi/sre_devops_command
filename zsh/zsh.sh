#!/usr/bin/env bash
# =============================================================================
#  setup-devops-zsh.sh — Professional DevOps/SRE Zsh Environment Installer
# =============================================================================
#  Version : 3.0.0
#  Tested  : Ubuntu 20.04/22.04/24.04, Debian 11/12,
#             RHEL/Rocky/Alma 8/9, Fedora 38+, Arch Linux
#
#  Features:
#    - Oh My Zsh + Powerlevel10k
#    - 60+ DevOps/SRE aliases & helper functions
#    - Optional tool installers: kubectl, helm, k9s, terraform, argocd,
#      flux, stern, kubectx/kubens, ansible, velero
#    - fzf-powered fuzzy helpers for k8s, git, docker, processes
#    - Modular ~/.zshrc.d/ config system
#    - Professional tmux config included
#    - Multi-arch: amd64 + arm64
#    - Idempotent: safe to re-run at any time
#    - Dry-run mode, rollback on failure
# =============================================================================

set -euo pipefail

# ─── Script Meta ──────────────────────────────────────────────────────────────
SCRIPT_VERSION="3.0.0"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG_FILE="/tmp/setup-devops-zsh-${TIMESTAMP}.log"

# Redirect all output to log file as well
exec > >(tee -a "$LOG_FILE") 2>&1

# ─── Colors & Symbols ─────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
DIM='\033[2m'
RESET='\033[0m'

OK="  ${GREEN}✔${RESET}"
WARN="${YELLOW}⚠${RESET}"
ERR="  ${RED}✘${RESET}"
INFO="${CYAN}➜${RESET}"
STEP="${BLUE}◆${RESET}"
SKIP="${DIM}○${RESET}"

# ─── Helpers ──────────────────────────────────────────────────────────────────
log()    { echo -e "${INFO} $*"; }
ok()     { echo -e "${OK} $*"; }
warn()   { echo -e "${WARN} $*"; }
err()    { echo -e "${ERR} $*" >&2; }
die()    { err "$*"; exit 1; }
skipped(){ echo -e "${SKIP} ${DIM}Skipped: $*${RESET}"; }
step()   { echo -e "\n${STEP} ${BOLD}$*${RESET}"; }
hr()     { echo -e "${BLUE}$(printf '─%.0s' {1..72})${RESET}"; }
hr2()    { echo -e "${DIM}$(printf '·%.0s' {1..72})${RESET}"; }

# Spinner for long-running tasks
spinner() {
  local pid=$! frames=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏') i=0
  while kill -0 "$pid" 2>/dev/null; do
    printf "\r  ${CYAN}%s${RESET} %s" "${frames[$((i % 10))]}" "$1"
    (( i++ )) || true
    sleep 0.1
  done
  printf "\r"
}

# Check if a command exists
has() { command -v "$1" &>/dev/null; }

# Run as target user
run_as() { sudo -u "$TARGET_USER" env HOME="$USER_HOME" "$@"; }

# ─── Defaults ─────────────────────────────────────────────────────────────────
INSTALL_TOOLS=false
MINIMAL=false
FORCE=false
SKIP_FONTS=false
DRY_RUN=false
NO_TMUX=false
TARGET_USER=""
ARCH=""
OS_ID=""
OS_VER=""
OS_PKG_MGR=""

# Tool selection (used with --tools)
TOOLS_LIST=(kubectl helm k9s terraform argocd flux stern kubectx ansible velero)
SELECTED_TOOLS=()

# ─── Usage ────────────────────────────────────────────────────────────────────
usage() {
  cat <<EOF
${BOLD}Usage:${RESET} sudo $0 [OPTIONS]

${BOLD}Options:${RESET}
  -u, --user NAME         Target user (default: \$SUDO_USER or current user)
  -t, --tools [LIST]      Install DevOps tools. Optionally comma-separated list:
                            kubectl,helm,k9s,terraform,argocd,flux,stern,
                            kubectx,ansible,velero
                          (default: all tools when -t is given without LIST)
  -m, --minimal           Minimal install — core plugins only, no extra tools
  -f, --force             Overwrite existing configs (.zshrc, .p10k.zsh)
  -s, --skip-fonts        Skip Meslo Nerd Font installation
      --no-tmux           Skip tmux config
  -n, --dry-run           Show what would be done, make no changes
  -h, --help              Show this help

${BOLD}Examples:${RESET}
  sudo $0                                    # Standard shell env for \$SUDO_USER
  sudo $0 -u deploy --tools                  # Full install with all tools
  sudo $0 --tools kubectl,helm,k9s           # Specific tools only
  sudo $0 --minimal --skip-fonts             # Lightweight, no fonts
  sudo $0 --dry-run                          # Preview without changes
  sudo $0 -f                                 # Re-install / update everything

${BOLD}Log:${RESET} $LOG_FILE

EOF
  exit 0
}

# ─── Argument Parsing ─────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case "$1" in
    -u|--user)
      TARGET_USER="$2"; shift 2 ;;
    -t|--tools)
      INSTALL_TOOLS=true
      # If next arg looks like a tool list (no leading dash), parse it
      if [[ $# -gt 1 && "$2" != -* && "$2" =~ ^[a-z] ]]; then
        IFS=',' read -ra SELECTED_TOOLS <<< "$2"; shift
      fi
      shift ;;
    -m|--minimal)  MINIMAL=true; shift ;;
    -f|--force)    FORCE=true; shift ;;
    -s|--skip-fonts) SKIP_FONTS=true; shift ;;
    --no-tmux)     NO_TMUX=true; shift ;;
    -n|--dry-run)  DRY_RUN=true; shift ;;
    -h|--help)     usage ;;
    *) die "Unknown option: $1. Use --help for usage." ;;
  esac
done

# If --tools given without list, install all
[[ ${#SELECTED_TOOLS[@]} -eq 0 && "$INSTALL_TOOLS" == "true" ]] && \
  SELECTED_TOOLS=("${TOOLS_LIST[@]}")

# Dry-run guard
dryrun_guard() {
  if [[ "$DRY_RUN" == "true" ]]; then
    echo -e "  ${DIM}[dry-run] would run: $*${RESET}"
    return 0
  fi
  "$@"
}

# ─── Privilege Check ──────────────────────────────────────────────────────────
[[ "$EUID" -ne 0 ]] && die "Please run as root or with sudo."

# ─── Resolve Target User ──────────────────────────────────────────────────────
[[ -z "$TARGET_USER" ]] && TARGET_USER="${SUDO_USER:-$(whoami)}"
[[ -z "$TARGET_USER" ]] && die "Could not determine target user. Use -u <username>."
id "$TARGET_USER" &>/dev/null || die "User '$TARGET_USER' does not exist."

USER_HOME=$(eval echo "~$TARGET_USER")
ZSH_DIR="$USER_HOME/.oh-my-zsh"
ZSH_CUSTOM="$ZSH_DIR/custom"
ZSHRC_D="$USER_HOME/.zshrc.d"

# ─── Architecture Detection ───────────────────────────────────────────────────
detect_arch() {
  case "$(uname -m)" in
    x86_64)  ARCH="amd64" ;;
    aarch64|arm64) ARCH="arm64" ;;
    armv7l)  ARCH="armv7" ;;
    *) warn "Unknown arch $(uname -m), defaulting to amd64"; ARCH="amd64" ;;
  esac
}

# ─── OS Detection ─────────────────────────────────────────────────────────────
detect_os() {
  [[ -f /etc/os-release ]] || die "/etc/os-release not found — cannot detect OS."
  # shellcheck disable=SC1091
  source /etc/os-release
  OS_ID="${ID:-unknown}"
  OS_VER="${VERSION_ID:-unknown}"

  case "$OS_ID" in
    ubuntu|debian|linuxmint|pop)
      OS_PKG_MGR="apt" ;;
    rhel|centos|rocky|almalinux|ol)
      OS_PKG_MGR="dnf" ;;
    fedora)
      OS_PKG_MGR="dnf" ;;
    arch|manjaro|endeavouros)
      OS_PKG_MGR="pacman" ;;
    opensuse*|sles)
      OS_PKG_MGR="zypper" ;;
    *)
      warn "Untested distro '$OS_ID' — will try apt, then dnf."
      has apt-get && OS_PKG_MGR="apt" || OS_PKG_MGR="dnf" ;;
  esac
}

# ─── Banner ───────────────────────────────────────────────────────────────────
print_banner() {
  hr
  echo -e "${BOLD}${CYAN}"
  cat <<'BANNER'
  ██████╗ ███████╗██╗   ██╗ ██████╗ ██████╗ ███████╗   ███████╗██╗  ██╗
  ██╔══██╗██╔════╝██║   ██║██╔═══██╗██╔══██╗██╔════╝   ╚══███╔╝██║  ██║
  ██║  ██║█████╗  ██║   ██║██║   ██║██████╔╝███████╗     ███╔╝ ███████║
  ██║  ██║██╔══╝  ╚██╗ ██╔╝██║   ██║██╔═══╝ ╚════██║    ███╔╝  ██╔══██║
  ██████╔╝███████╗ ╚████╔╝ ╚██████╔╝██║     ███████║   ███████╗██║  ██║
  ╚═════╝ ╚══════╝  ╚═══╝   ╚═════╝ ╚═╝     ╚══════╝   ╚══════╝╚═╝  ╚═╝
BANNER
  echo -e "${RESET}"
  printf "  %-20s %s\n" "Version:"     "${BOLD}${SCRIPT_VERSION}${RESET}"
  printf "  %-20s %s\n" "Target user:" "${YELLOW}${TARGET_USER}${RESET}"
  printf "  %-20s %s\n" "Home dir:"    "${YELLOW}${USER_HOME}${RESET}"
  printf "  %-20s %s\n" "OS:"          "${OS_ID} ${OS_VER} (${OS_PKG_MGR})"
  printf "  %-20s %s\n" "Arch:"        "${ARCH}"
  [[ "$DRY_RUN"       == "true" ]] && printf "  %-20s %s\n" "Mode:" "${MAGENTA}DRY RUN — no changes will be made${RESET}"
  [[ "$INSTALL_TOOLS" == "true" ]] && printf "  %-20s %s\n" "Tools:" "${GREEN}${SELECTED_TOOLS[*]}${RESET}"
  [[ "$MINIMAL"       == "true" ]] && printf "  %-20s %s\n" "Plugins:" "${DIM}minimal${RESET}"
  hr
  echo
}

# ─── Rollback Support ─────────────────────────────────────────────────────────
BACKUP_DIR="/tmp/devops-zsh-backup-${TIMESTAMP}"

backup_existing() {
  mkdir -p "$BACKUP_DIR"
  local backed_up=0
  for f in .zshrc .p10k.zsh .zshrc.d .tmux.conf; do
    [[ -e "$USER_HOME/$f" ]] && cp -r "$USER_HOME/$f" "$BACKUP_DIR/" && (( backed_up++ )) || true
  done
  [[ $backed_up -gt 0 ]] && log "Backed up $backed_up existing config(s) to $BACKUP_DIR"
}

rollback() {
  err "Installation failed! Rolling back..."
  for f in .zshrc .p10k.zsh .zshrc.d .tmux.conf; do
    [[ -e "$BACKUP_DIR/$f" ]] && cp -r "$BACKUP_DIR/$f" "$USER_HOME/$f" && warn "Restored $f"
  done
  err "Rollback complete. Log: $LOG_FILE"
  exit 1
}
trap rollback ERR

# ─── Package Install ──────────────────────────────────────────────────────────
pkg_install() {
  [[ "$DRY_RUN" == "true" ]] && { log "[dry-run] Would install packages: $*"; return; }
  case "$OS_PKG_MGR" in
    apt)
      apt-get update -qq
      DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends "$@" \
        2>&1 | grep -E "^(Get:|Setting up|already)" || true ;;
    dnf)
      dnf install -y "$@" 2>&1 | grep -E "^(Installing|already)" || true ;;
    pacman)
      pacman -Sy --noconfirm --needed "$@" ;;
    zypper)
      zypper install -y "$@" ;;
  esac
}

install_packages() {
  step "Installing system packages"

  # Common packages available on all distros (adjust names per pkg manager)
  local common_apt=(zsh git curl wget unzip locales fzf bat tree htop jq tmux ripgrep fd-find net-tools dnsutils fonts-powerline python3-pip)
  local common_dnf=(zsh git curl wget unzip glibc-locale-source fzf bat tree htop jq tmux ripgrep fd-find net-tools bind-utils python3-pip)
  local common_pacman=(zsh git curl wget unzip fzf bat tree htop jq tmux ripgrep fd net-tools bind python-pip)

  case "$OS_PKG_MGR" in
    apt)
      pkg_install "${common_apt[@]}"
      # bat is 'batcat' on Debian/Ubuntu — create symlink
      if has batcat && ! has bat; then
        mkdir -p "$USER_HOME/.local/bin"
        ln -sf "$(command -v batcat)" "$USER_HOME/.local/bin/bat"
        ok "Created bat → batcat symlink"
      fi
      # fd is 'fdfind' on Debian/Ubuntu
      if has fdfind && ! has fd; then
        ln -sf "$(command -v fdfind)" /usr/local/bin/fd 2>/dev/null || true
      fi ;;
    dnf)
      # Enable EPEL for RHEL-based
      if [[ "$OS_ID" =~ rhel|centos|rocky|almalinux|ol ]]; then
        dnf install -y epel-release 2>/dev/null || true
      fi
      pkg_install "${common_dnf[@]}" ;;
    pacman)
      pkg_install "${common_pacman[@]}" ;;
  esac

  # Set locale
  if [[ "$OS_PKG_MGR" == "apt" ]]; then
    locale-gen en_US.UTF-8 > /dev/null 2>&1 || true
    update-locale LANG=en_US.UTF-8 2>/dev/null || true
  fi

  ok "System packages ready"
}

# ─── Nerd Fonts ───────────────────────────────────────────────────────────────
install_fonts() {
  [[ "$SKIP_FONTS" == "true" ]] && { skipped "Fonts (--skip-fonts)"; return; }
  [[ "$DRY_RUN"    == "true" ]] && { log "[dry-run] Would install Meslo Nerd Fonts"; return; }

  step "Installing Meslo Nerd Fonts"

  local FONT_DIR="$USER_HOME/.local/share/fonts"
  mkdir -p "$FONT_DIR"

  local BASE="https://github.com/romkatv/powerlevel10k-media/raw/master"
  local -a VARIANTS=("Regular" "Bold" "Italic" "Bold%20Italic")

  for v in "${VARIANTS[@]}"; do
    local name="MesloLGS NF ${v//%20/ }.ttf"
    local url="${BASE}/MesloLGS%20NF%20${v}.ttf"
    if [[ ! -f "$FONT_DIR/$name" ]]; then
      wget -q "$url" -O "$FONT_DIR/$name" || warn "Failed to download: $name"
    fi
  done

  fc-cache -fv "$FONT_DIR" > /dev/null 2>&1 || true
  chown -R "$TARGET_USER":"$TARGET_USER" "$FONT_DIR"
  ok "Meslo Nerd Fonts installed"
}

# ─── Oh My Zsh ────────────────────────────────────────────────────────────────
install_ohmyzsh() {
  step "Installing Oh My Zsh"

  if [[ -d "$ZSH_DIR" ]]; then
    if [[ "$FORCE" == "true" ]]; then
      [[ "$DRY_RUN" != "true" ]] && rm -rf "$ZSH_DIR"
      warn "Removed existing Oh My Zsh (--force)"
    else
      # Update instead of skip
      if [[ "$DRY_RUN" != "true" ]]; then
        run_as git -C "$ZSH_DIR" pull --quiet origin master 2>/dev/null || true
      fi
      ok "Oh My Zsh updated"
      return
    fi
  fi

  [[ "$DRY_RUN" == "true" ]] && { log "[dry-run] Would install Oh My Zsh"; return; }

  run_as env RUNZSH=no CHSH=no \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    "" --unattended

  ok "Oh My Zsh installed"
}

# ─── Plugin Installer ─────────────────────────────────────────────────────────
clone_plugin() {
  local name="$1" url="$2"
  local dest="$ZSH_CUSTOM/plugins/$name"

  [[ "$DRY_RUN" == "true" ]] && { log "[dry-run] Would install plugin: $name"; return; }

  if [[ -d "$dest" ]]; then
    run_as git -C "$dest" pull --quiet origin HEAD 2>/dev/null || true
    ok "Plugin up-to-date: $name"
  else
    run_as git clone --depth=1 --quiet "$url" "$dest"
    ok "Plugin installed: $name"
  fi
}

install_plugins() {
  step "Installing Zsh plugins"

  # ── Core (always installed) ──────────────────────────────────
  clone_plugin "zsh-autosuggestions"      "https://github.com/zsh-users/zsh-autosuggestions"
  clone_plugin "zsh-syntax-highlighting"  "https://github.com/zsh-users/zsh-syntax-highlighting"
  clone_plugin "zsh-z"                    "https://github.com/agkozak/zsh-z"

  [[ "$MINIMAL" == "true" ]] && return

  # ── Extended ─────────────────────────────────────────────────
  clone_plugin "zsh-completions"              "https://github.com/zsh-users/zsh-completions"
  clone_plugin "zsh-history-substring-search" "https://github.com/zsh-users/zsh-history-substring-search"
  clone_plugin "fast-syntax-highlighting"     "https://github.com/zdharma-continuum/fast-syntax-highlighting"
}

# ─── Powerlevel10k ────────────────────────────────────────────────────────────
install_theme() {
  step "Installing Powerlevel10k theme"

  local P10K_DIR="$ZSH_CUSTOM/themes/powerlevel10k"
  [[ "$DRY_RUN" == "true" ]] && { log "[dry-run] Would install Powerlevel10k"; return; }

  if [[ -d "$P10K_DIR" ]]; then
    run_as git -C "$P10K_DIR" pull --quiet origin HEAD 2>/dev/null || true
    ok "Powerlevel10k updated"
  else
    run_as git clone --depth=1 --quiet \
      https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
    ok "Powerlevel10k installed"
  fi
}

# ─── DevOps Tool Installers ───────────────────────────────────────────────────
tool_in_list() { printf '%s\n' "${SELECTED_TOOLS[@]}" | grep -qx "$1"; }

# Helper: download binary, install to /usr/local/bin
install_binary() {
  local name="$1" url="$2"
  log "Downloading ${name}..."
  curl -fsSLo "/tmp/${name}" "$url"
  install -o root -g root -m 0755 "/tmp/${name}" "/usr/local/bin/${name}"
  rm -f "/tmp/${name}"
  ok "${name} installed → $(${name} version 2>/dev/null | head -1 || echo 'ok')"
}

install_kubectl() {
  has kubectl && ! [[ "$FORCE" == "true" ]] && { ok "kubectl already installed"; return; }
  local ver; ver=$(curl -fsSL https://dl.k8s.io/release/stable.txt)
  install_binary kubectl "https://dl.k8s.io/release/${ver}/bin/linux/${ARCH}/kubectl"
}

install_helm() {
  has helm && ! [[ "$FORCE" == "true" ]] && { ok "helm already installed"; return; }
  log "Installing Helm..."
  curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash -s -- --no-sudo
  ok "Helm installed → $(helm version --short 2>/dev/null || echo 'ok')"
}

install_k9s() {
  has k9s && ! [[ "$FORCE" == "true" ]] && { ok "k9s already installed"; return; }
  local ver; ver=$(curl -fsSL https://api.github.com/repos/derailed/k9s/releases/latest | grep '"tag_name"' | cut -d'"' -f4)
  local url="https://github.com/derailed/k9s/releases/download/${ver}/k9s_Linux_${ARCH}.tar.gz"
  log "Installing k9s ${ver}..."
  curl -fsSL "$url" | tar -xz -C /tmp k9s
  install -o root -g root -m 0755 /tmp/k9s /usr/local/bin/k9s
  ok "k9s ${ver} installed"
}

install_terraform() {
  has terraform && ! [[ "$FORCE" == "true" ]] && { ok "terraform already installed"; return; }
  local ver; ver=$(curl -fsSL https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r .current_version)
  local url="https://releases.hashicorp.com/terraform/${ver}/terraform_${ver}_linux_${ARCH}.zip"
  log "Installing Terraform ${ver}..."
  curl -fsSLo /tmp/terraform.zip "$url"
  unzip -o /tmp/terraform.zip -d /usr/local/bin/ > /dev/null
  chmod +x /usr/local/bin/terraform
  rm -f /tmp/terraform.zip
  ok "Terraform ${ver} installed"
}

install_argocd() {
  has argocd && ! [[ "$FORCE" == "true" ]] && { ok "argocd already installed"; return; }
  local ver; ver=$(curl -fsSL https://api.github.com/repos/argoproj/argo-cd/releases/latest | grep '"tag_name"' | cut -d'"' -f4)
  install_binary argocd "https://github.com/argoproj/argo-cd/releases/download/${ver}/argocd-linux-${ARCH}"
}

install_flux() {
  has flux && ! [[ "$FORCE" == "true" ]] && { ok "flux already installed"; return; }
  log "Installing Flux CLI..."
  curl -fsSL https://fluxcd.io/install.sh | bash
  ok "Flux installed → $(flux version --client 2>/dev/null | head -1 || echo 'ok')"
}

install_stern() {
  has stern && ! [[ "$FORCE" == "true" ]] && { ok "stern already installed"; return; }
  local ver; ver=$(curl -fsSL https://api.github.com/repos/stern/stern/releases/latest | grep '"tag_name"' | cut -d'"' -f4 | tr -d 'v')
  local url="https://github.com/stern/stern/releases/download/v${ver}/stern_${ver}_linux_${ARCH}.tar.gz"
  log "Installing stern ${ver}..."
  curl -fsSL "$url" | tar -xz -C /tmp stern
  install -o root -g root -m 0755 /tmp/stern /usr/local/bin/stern
  ok "stern ${ver} installed"
}

install_kubectx() {
  local ver; ver=$(curl -fsSL https://api.github.com/repos/ahmetb/kubectx/releases/latest | grep '"tag_name"' | cut -d'"' -f4)
  local base="https://github.com/ahmetb/kubectx/releases/download/${ver}"

  if ! has kubectx || [[ "$FORCE" == "true" ]]; then
    curl -fsSLo /usr/local/bin/kubectx "${base}/kubectx_${ver}_linux_${ARCH}.tar.gz" 2>/dev/null \
      || curl -fsSLo /usr/local/bin/kubectx "${base}/kubectx" 2>/dev/null
    chmod +x /usr/local/bin/kubectx
    ok "kubectx installed"
  else
    ok "kubectx already installed"
  fi

  if ! has kubens || [[ "$FORCE" == "true" ]]; then
    curl -fsSLo /usr/local/bin/kubens "${base}/kubens" 2>/dev/null || true
    chmod +x /usr/local/bin/kubens 2>/dev/null || true
    ok "kubens installed"
  else
    ok "kubens already installed"
  fi
}

install_ansible() {
  has ansible && ! [[ "$FORCE" == "true" ]] && { ok "ansible already installed"; return; }
  log "Installing Ansible via pip..."
  pip3 install --quiet --upgrade ansible
  ok "Ansible installed → $(ansible --version 2>/dev/null | head -1)"
}

install_velero() {
  has velero && ! [[ "$FORCE" == "true" ]] && { ok "velero already installed"; return; }
  local ver; ver=$(curl -fsSL https://api.github.com/repos/vmware-tanzu/velero/releases/latest | grep '"tag_name"' | cut -d'"' -f4)
  local url="https://github.com/vmware-tanzu/velero/releases/download/${ver}/velero-${ver}-linux-${ARCH}.tar.gz"
  log "Installing velero ${ver}..."
  curl -fsSL "$url" | tar -xz -C /tmp
  find /tmp -name "velero" -type f -exec install -o root -g root -m 0755 {} /usr/local/bin/velero \;
  ok "velero ${ver} installed"
}

install_devops_tools() {
  [[ "$INSTALL_TOOLS" != "true" ]] && return
  [[ "$DRY_RUN" == "true" ]] && { log "[dry-run] Would install tools: ${SELECTED_TOOLS[*]}"; return; }

  step "Installing DevOps tools: ${SELECTED_TOOLS[*]}"

  tool_in_list kubectl   && install_kubectl
  tool_in_list helm      && install_helm
  tool_in_list k9s       && install_k9s
  tool_in_list terraform && install_terraform
  tool_in_list argocd    && install_argocd
  tool_in_list flux      && install_flux
  tool_in_list stern     && install_stern
  tool_in_list kubectx   && install_kubectx
  tool_in_list ansible   && install_ansible
  tool_in_list velero    && install_velero

  ok "DevOps tools installation complete"
}

# ─── Modular zshrc.d ──────────────────────────────────────────────────────────
write_zshrc_module() {
  local name="$1" content="$2"
  [[ "$DRY_RUN" == "true" ]] && { log "[dry-run] Would write ~/.zshrc.d/${name}"; return; }
  mkdir -p "$ZSHRC_D"
  echo "$content" > "$ZSHRC_D/$name"
}

# ─── Write Main .zshrc ────────────────────────────────────────────────────────
write_zshrc() {
  step "Writing shell configuration"
  [[ "$DRY_RUN" == "true" ]] && { log "[dry-run] Would write .zshrc and ~/.zshrc.d/ modules"; return; }

  local ZSHRC="$USER_HOME/.zshrc"

  if [[ -f "$ZSHRC" && "$FORCE" != "true" ]]; then
    cp "$ZSHRC" "${ZSHRC}.bak.${TIMESTAMP}"
    warn "Backed up existing .zshrc to .zshrc.bak.${TIMESTAMP}"
  fi

  local PLUGIN_LIST="git docker kubectl sudo zsh-autosuggestions zsh-syntax-highlighting zsh-z"
  [[ "$MINIMAL" == "false" ]] && \
    PLUGIN_LIST="$PLUGIN_LIST zsh-completions zsh-history-substring-search"

  cat > "$ZSHRC" <<ZSHRC_EOF
# ============================================================
#  ~/.zshrc  |  DevOps/SRE Environment  |  v${SCRIPT_VERSION}
#  Generated: $(date)
# ============================================================

export ZSH="\$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

# ── History ──────────────────────────────────────────────────
HISTSIZE=100000
SAVEHIST=100000
HISTFILE="\$HOME/.zsh_history"
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_REDUCE_BLANKS

# ── Shell Options ────────────────────────────────────────────
setopt AUTO_CD
setopt CORRECT
setopt CORRECT_ALL
setopt GLOB_DOTS
setopt NO_BEEP
setopt EXTENDED_GLOB
setopt PUSHD_IGNORE_DUPS
setopt AUTO_PUSHD

# ── Plugins ──────────────────────────────────────────────────
plugins=(${PLUGIN_LIST})

source "\$ZSH/oh-my-zsh.sh"

# ── Completion System ────────────────────────────────────────
autoload -Uz compinit
if [[ -n \${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:descriptions' format '%B%F{blue}── %d ──%f%b'
zstyle ':completion:*:warnings' format '%F{red}No matches for: %d%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors \${(s.:.)LS_COLORS}
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path "\$HOME/.zcompcache"

# Enable kubectl completion if available
command -v kubectl &>/dev/null && source <(kubectl completion zsh)
command -v helm    &>/dev/null && source <(helm completion zsh)
command -v flux    &>/dev/null && source <(flux completion zsh)
command -v argocd  &>/dev/null && source <(argocd completion zsh)

# ── Environment ──────────────────────────────────────────────
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export EDITOR="\${EDITOR:-vim}"
export VISUAL="\$EDITOR"
export PAGER="\${PAGER:-less}"
export LESS="-RFXi"
export PATH="\$HOME/.local/bin:\$HOME/bin:/usr/local/bin:\$PATH"

# ── fzf ──────────────────────────────────────────────────────
[[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]] && \
  source /usr/share/doc/fzf/examples/key-bindings.zsh
[[ -f /usr/share/doc/fzf/examples/completion.zsh ]] && \
  source /usr/share/doc/fzf/examples/completion.zsh
# RHEL/Fedora path
[[ -f /usr/share/fzf/shell/key-bindings.zsh ]] && \
  source /usr/share/fzf/shell/key-bindings.zsh

export FZF_DEFAULT_OPTS="
  --height=50% --layout=reverse --border=rounded
  --color=fg:#cdd6f4,bg:#1e1e2e,hl:#89b4fa
  --color=fg+:#cdd6f4,bg+:#313244,hl+:#89b4fa
  --color=info:#f38ba8,prompt:#cba6f7,pointer:#f5c2e7
  --color=marker:#a6e3a1,spinner:#f5c2e7,header:#94e2d5
  --preview-window=right:60%:wrap
  --bind='ctrl-/:toggle-preview'
  --bind='ctrl-a:select-all'
  --bind='ctrl-d:deselect-all'
"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range=:100 {} 2>/dev/null || cat {}'"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -50'"
export FZF_CTRL_R_OPTS="--sort --exact"

# ── Plugin Config ────────────────────────────────────────────
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=50
ZSH_AUTOSUGGEST_USE_ASYNC=1
bindkey '^ ' autosuggest-accept           # Ctrl+Space to accept suggestion

# History substring search keybindings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# ── Powerlevel10k ────────────────────────────────────────────
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ── Load Modular Configs ─────────────────────────────────────
# Drop extra config files in ~/.zshrc.d/ — they load automatically
if [[ -d "\$HOME/.zshrc.d" ]]; then
  for f in "\$HOME/.zshrc.d"/*.zsh(N); do
    source "\$f"
  done
fi

# ── Local Machine Overrides ──────────────────────────────────
# Not committed to git — put node-specific config here
[[ -f "\$HOME/.zshrc.local" ]] && source "\$HOME/.zshrc.local"
ZSHRC_EOF

  ok ".zshrc written"

  # ── Write modular configs into ~/.zshrc.d/ ────────────────
  mkdir -p "$ZSHRC_D"

  # ── 10-navigation.zsh ─────────────────────────────────────
  write_zshrc_module "10-navigation.zsh" '# Navigation aliases
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias -- -="cd -"
alias mkd="mkdir -pv"
alias lsd="ls -d */ --color=auto"

# ls / eza / exa
if command -v eza &>/dev/null; then
  alias ls="eza --icons --group-directories-first"
  alias ll="eza -alh --icons --group-directories-first --git"
  alias lt="eza --tree --icons --level=3"
  alias la="eza -a --icons"
else
  alias ll="ls -alFh --color=auto"
  alias la="ls -A --color=auto"
  alias l="ls -CF --color=auto"
fi

# bat / cat
if command -v bat &>/dev/null; then
  alias cat="bat --paging=never"
  alias catn="bat -n --paging=never"
  alias cath="bat --style=header --paging=never"
elif command -v batcat &>/dev/null; then
  alias cat="batcat --paging=never"
fi

# ripgrep / grep
if command -v rg &>/dev/null; then
  alias grep="rg"
  alias rgi="rg -i"
  alias rgl="rg -l"
else
  alias grep="grep --color=auto"
fi

# fd / find
command -v fd &>/dev/null && alias find="fd"

# Disk
alias df="df -hT"
alias du1="du -h --max-depth=1 | sort -hr"
alias du2="du -h --max-depth=2 | sort -hr"
alias lsblk="lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINT,LABEL"
alias mounts="mount | column -t"

# Safety nets
alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"
alias rmf="rm -rf"        # Use explicitly when you mean it

# Quick edit configs
alias zshrc="$EDITOR ~/.zshrc"
alias zshlocal="$EDITOR ~/.zshrc.local"
alias p10kconf="$EDITOR ~/.p10k.zsh"

# Misc
alias h="history"
alias hg="history | grep"
alias reload="exec zsh"
alias path="echo $PATH | tr : $\"\n\""
alias now="date +\"%Y-%m-%d %T\""
alias week="date +%V"
alias utc="date -u"
alias weather="curl -s wttr.in"
alias cheat="curl -s cheat.sh/"
'

  # ── 20-system.zsh ─────────────────────────────────────────
  write_zshrc_module "20-system.zsh" '# System monitoring
alias psmem="ps aux --sort=-%mem | head -20"
alias pscpu="ps aux --sort=-%cpu | head -20"
alias ports="ss -tlnp"
alias udports="ss -ulnp"
alias connections="ss -s"
alias ifaces="ip -c addr"
alias routes="ip -c route"
alias arp="ip neigh"
alias syslog="sudo tail -f /var/log/syslog"
alias journal="sudo journalctl -f"
alias jexe="sudo journalctl -xe"
alias jboot="sudo journalctl -b"
alias jtoday="sudo journalctl --since today"
alias dmesgf="dmesg -wH"
alias meminfo="cat /proc/meminfo | grep -E \"(Mem|Swap|Available)\""
alias cpuinfo="lscpu | grep -E \"(Model|CPU\(s\)|Thread|Core|Socket)\""

# fzf process killer
fkill() {
  local pid
  pid=$(ps aux | fzf --prompt="Kill process> " --header="PID USER %CPU %MEM COMMAND" | awk "{print \$2}")
  [[ -n "$pid" ]] && { echo "Killing PID $pid..."; kill -9 "$pid"; }
}

# Service manager
svc() {
  local action="${1:-status}"
  local service
  service=$(systemctl list-units --type=service --no-pager --no-legend | awk "{print \$1}" | fzf --prompt="Service ($action)> ")
  [[ -n "$service" ]] && sudo systemctl "$action" "$service"
}

# Quick benchmark
bench() { time for i in {1..100}; do printf "."; done; echo; }

# Network
myip() {
  echo "  Public  : $(curl -fsSL https://ifconfig.me/ip 2>/dev/null || echo unavailable)"
  echo "  Private : $(ip route get 1.1.1.1 2>/dev/null | awk "/src/ { print \$7 }" || hostname -I | awk "{print \$1}")"
}

portcheck() {
  local host="${1:-localhost}" port="$2"
  [[ -z "$port" ]] && { echo "Usage: portcheck <host> <port>"; return 1; }
  nc -zv "$host" "$port" 2>&1 && echo "✔ $host:$port open" || echo "✘ $host:$port closed"
}

certinfo() {
  [[ -z "$1" ]] && { echo "Usage: certinfo <hostname>"; return 1; }
  echo | openssl s_client -connect "${1}:443" -servername "$1" 2>/dev/null \
    | openssl x509 -noout -text \
    | grep -E "(Subject|Issuer|Not (Before|After)|DNS|IP)"
}

# Extract any archive
extract() {
  [[ ! -f "$1" ]] && { echo "File not found: $1"; return 1; }
  case "$1" in
    *.tar.bz2|*.tbz2) tar xjf "$1"  ;;
    *.tar.gz|*.tgz)   tar xzf "$1"  ;;
    *.tar.xz)          tar xJf "$1"  ;;
    *.tar.zst)         tar --use-compress-program=zstd -xf "$1" ;;
    *.tar)             tar xf "$1"   ;;
    *.bz2)             bunzip2 "$1"  ;;
    *.gz)              gunzip "$1"   ;;
    *.zip)             unzip "$1"    ;;
    *.7z)              7z x "$1"     ;;
    *.xz)              unxz "$1"     ;;
    *.rar)             unrar e "$1"  ;;
    *)                 echo "Unknown archive: $1" ;;
  esac
}

# mkcd — mkdir + cd
mkcd() { mkdir -pv "$1" && cd "$1"; }

# backup — quick timestamped copy
backup() { cp -r "$1" "${1}.bak.$(date +%Y%m%d_%H%M%S)"; }

# SSH
sshkey() {
  local name="${1:-id_ed25519}" comment="${2:-$USER@$(hostname)}"
  ssh-keygen -t ed25519 -C "$comment" -f "$HOME/.ssh/$name"
  echo; echo "Public key:"; cat "$HOME/.ssh/${name}.pub"
}

# Generate secure password
genpass() { openssl rand -base64 "${1:-32}" | tr -d "=+/" | cut -c1-"${1:-32}"; }
'

  # ── 30-git.zsh ────────────────────────────────────────────
  write_zshrc_module "30-git.zsh" '# Git
alias gs="git status"
alias ga="git add ."
alias gaa="git add --all"
alias gc="git commit -m"
alias gca="git commit --amend"
alias gcan="git commit --amend --no-edit"
alias gp="git push"
alias gpf="git push --force-with-lease"
alias gpu="git push -u origin HEAD"
alias gl="git pull"
alias glr="git pull --rebase"
alias gd="git diff"
alias gds="git diff --staged"
alias gdc="git diff --cached"
alias gb="git branch"
alias gba="git branch -a"
alias gbD="git branch -D"
alias gco="git checkout"
alias gcb="git checkout -b"
alias gm="git merge --no-ff"
alias grb="git rebase"
alias grbi="git rebase -i"
alias gst="git stash"
alias gstp="git stash pop"
alias gstl="git stash list"
alias gstd="git stash drop"
alias gtag="git tag"
alias greset="git reset --hard HEAD"
alias gclean="git clean -fd"
alias glo="git log --oneline --graph --decorate"
alias gloa="git log --oneline --graph --decorate --all"
alias glog="git log --graph --pretty=format:\"%C(yellow)%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(blue)<%an>%Creset\""
alias gwip="git add -A && git commit -m \"WIP: $(date)\""
alias gunwip="git log -1 --pretty=%s | grep -q WIP && git reset HEAD~1"
alias gignore="git update-index --assume-unchanged"
alias gunignore="git update-index --no-assume-unchanged"

# fzf-powered git checkout
gfco() {
  local branch
  branch=$(git branch -a | grep -v HEAD | sed "s/.* //" | sed "s#remotes/[^/]*/##" | sort -u | fzf --prompt="Checkout> ")
  [[ -n "$branch" ]] && git checkout "$branch"
}

# fzf-powered git log browser
gflog() {
  git log --oneline --color=always | fzf \
    --ansi \
    --preview="git show --color=always {1}" \
    --bind="enter:execute(git show {1} | less -R)"
}

# fzf-powered git add
gfadd() {
  local files
  files=$(git status --short | fzf -m --preview="git diff --color=always {2}" | awk "{print \$2}")
  [[ -n "$files" ]] && echo "$files" | xargs git add && git status
}
'

  # ── 40-kubernetes.zsh ─────────────────────────────────────
  write_zshrc_module "40-kubernetes.zsh" '# Kubernetes — core
alias k="kubectl"
alias kga="kubectl get all"
alias kgaa="kubectl get all --all-namespaces"
alias kgp="kubectl get pods"
alias kgpa="kubectl get pods --all-namespaces"
alias kgpw="kubectl get pods -w"
alias kgs="kubectl get services"
alias kgd="kubectl get deployments"
alias kgn="kubectl get nodes"
alias kgns="kubectl get namespaces"
alias kgi="kubectl get ingress"
alias kgcm="kubectl get configmap"
alias kgsec="kubectl get secret"
alias kgpv="kubectl get pv"
alias kgpvc="kubectl get pvc"
alias kghpa="kubectl get hpa"
alias kgcj="kubectl get cronjob"
alias kgj="kubectl get job"
alias kgsa="kubectl get serviceaccount"
alias kgrb="kubectl get rolebinding"
alias kgcrb="kubectl get clusterrolebinding"

alias kdp="kubectl describe pod"
alias kdd="kubectl describe deployment"
alias kds="kubectl describe service"
alias kdn="kubectl describe node"
alias kdi="kubectl describe ingress"
alias kdns="kubectl describe namespace"

alias klog="kubectl logs -f"
alias kloga="kubectl logs -f --all-containers=true"
alias ktail="kubectl logs --tail=200 -f"
alias kex="kubectl exec -it"
alias kap="kubectl apply -f"
alias kapd="kubectl apply --dry-run=client -f"
alias kd="kubectl delete"
alias kdf="kubectl delete -f"
alias kpf="kubectl port-forward"
alias kcp="kubectl cp"
alias kauth="kubectl auth can-i"

alias kroll="kubectl rollout"
alias krs="kubectl rollout status deployment"
alias krr="kubectl rollout restart deployment"
alias krh="kubectl rollout history deployment"
alias krundo="kubectl rollout undo deployment"

alias ktop="kubectl top pods"
alias ktopp="kubectl top pods --sort-by=cpu"
alias ktopm="kubectl top pods --sort-by=memory"
alias ktonn="kubectl top nodes"

alias kwatch="watch -n2 kubectl get pods"
alias kwatchall="watch -n2 kubectl get pods --all-namespaces"

alias kcurrent="kubectl config current-context"
alias kcfg="kubectl config view --minify"
alias kcontexts="kubectl config get-contexts"

# kctx: use kubectx if available, otherwise fzf fallback
kctx() {
  if command -v kubectx &>/dev/null; then
    kubectx "$@"
  else
    local ctx
    ctx=$(kubectl config get-contexts --no-headers -o name | fzf --prompt="Context> ")
    [[ -n "$ctx" ]] && kubectl config use-context "$ctx"
  fi
}

# kns: use kubens if available, otherwise fzf fallback
kns() {
  if command -v kubens &>/dev/null; then
    kubens "$@"
  else
    local ns
    ns=$(kubectl get ns --no-headers -o custom-columns=NAME:.metadata.name | fzf --prompt="Namespace> ")
    [[ -n "$ns" ]] && kubectl config set-context --current --namespace="$ns"
  fi
}

kexec() {
  local pod ns="${KUBE_NAMESPACE:-default}"
  pod=$(kubectl get pods -n "$ns" --no-headers -o custom-columns=NAME:.metadata.name | fzf --prompt="Exec into pod> ")
  [[ -n "$pod" ]] && kubectl exec -it -n "$ns" "$pod" -- "${1:-/bin/sh}"
}

klogs() {
  local pod ns="${KUBE_NAMESPACE:-default}"
  pod=$(kubectl get pods -n "$ns" --no-headers -o custom-columns=NAME:.metadata.name | fzf --prompt="Pod logs> ")
  [[ -n "$pod" ]] && kubectl logs -f -n "$ns" "$pod"
}

# stern multi-pod log tail
klogall() {
  local selector="${1:-app}"
  command -v stern &>/dev/null && stern . || kubectl logs -f -l "$selector=*"
}

# k8s resource editor with fzf
kedit() {
  local resource="${1:-deployment}"
  local name
  name=$(kubectl get "$resource" --no-headers -o custom-columns=NAME:.metadata.name | fzf --prompt="Edit $resource> ")
  [[ -n "$name" ]] && kubectl edit "$resource" "$name"
}

# Quick pod shell — finds first running pod matching pattern
ksh() {
  local pattern="${1:-.}"
  local pod
  pod=$(kubectl get pods --field-selector=status.phase=Running --no-headers -o custom-columns=NAME:.metadata.name \
    | grep "$pattern" | head -1)
  [[ -n "$pod" ]] && kubectl exec -it "$pod" -- /bin/sh || echo "No running pod matching: $pattern"
}

# k8s event watcher
kevents() { kubectl get events --sort-by=.metadata.creationTimestamp "${@}"; }

# Get decoded secret
ksecret() {
  local name="$1" key="$2"
  [[ -z "$name" ]] && { echo "Usage: ksecret <secret-name> [key]"; return 1; }
  if [[ -n "$key" ]]; then
    kubectl get secret "$name" -o jsonpath="{.data.${key}}" | base64 -d; echo
  else
    kubectl get secret "$name" -o json | jq -r ".data | to_entries[] | \"\(.key): \(.value | @base64d)\""
  fi
}

# Show resource limits/requests for all pods
klimits() {
  kubectl get pods -o json | jq -r "
    .items[] | .metadata.name as \$pod |
    .spec.containers[] |
    [\$pod, .name, (.resources.requests.cpu // \"-\"), (.resources.requests.memory // \"-\"),
     (.resources.limits.cpu // \"-\"), (.resources.limits.memory // \"-\")] |
    @tsv" | column -t -s $"\t" -N "POD,CONTAINER,REQ_CPU,REQ_MEM,LIM_CPU,LIM_MEM"
}
'

  # ── 50-docker.zsh ─────────────────────────────────────────
  write_zshrc_module "50-docker.zsh" '# Docker
alias d="docker"
alias dps="docker ps"
alias dpsa="docker ps -a"
alias dimg="docker images"
alias dimg="docker images --format \"table {{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.CreatedSince}}\""
alias drm="docker rm"
alias drmi="docker rmi"
alias dex="docker exec -it"
alias dlogs="docker logs -f"
alias dstop="docker stop"
alias dstart="docker start"
alias drestart="docker restart"
alias dprune="docker system prune -f"
alias dprunea="docker system prune -af --volumes"
alias dvol="docker volume ls"
alias dnet="docker network ls"
alias dinspect="docker inspect"
alias dstats="docker stats --no-stream --format \"table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}\t{{.BlockIO}}\""
alias dstatsl="docker stats"
alias dbuild="docker build -t"
alias dpull="docker pull"
alias dpush="docker push"
alias drun="docker run --rm -it"
alias denv="docker run --rm -it --env-file .env"

# Docker Compose (supports both v1 and v2)
if docker compose version &>/dev/null 2>&1; then
  alias dc="docker compose"
else
  alias dc="docker-compose"
fi
alias dcu="dc up -d"
alias dcd="dc down"
alias dcb="dc build"
alias dcl="dc logs -f"
alias dcp="dc ps"
alias dcr="dc restart"
alias dcpull="dc pull"
alias dcrun="dc run --rm"
alias dcexec="dc exec"
alias dcstop="dc stop"
alias dcscale="dc up -d --scale"

# fzf helpers
dexec() {
  local ctr
  ctr=$(docker ps --format "{{.Names}}" | fzf --prompt="Exec into container> ")
  [[ -n "$ctr" ]] && docker exec -it "$ctr" "${1:-/bin/sh}"
}

dlogs_fzf() {
  local ctr
  ctr=$(docker ps --format "{{.Names}}" | fzf --prompt="Container logs> ")
  [[ -n "$ctr" ]] && docker logs -f "$ctr"
}

# Show all container IPs
dips() {
  docker ps -q | xargs -I{} docker inspect {} \
    --format "{{.Name}} {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" \
    | column -t
}
'

  # ── 60-terraform.zsh ──────────────────────────────────────
  write_zshrc_module "60-terraform.zsh" '# Terraform / OpenTofu
if command -v tofu &>/dev/null; then
  alias tf="tofu"     # Prefer OpenTofu if installed
else
  alias tf="terraform"
fi

alias tfi="tf init"
alias tfiu="tf init -upgrade"
alias tfp="tf plan"
alias tfpo="tf plan -out=tfplan"
alias tfa="tf apply"
alias tfaa="tf apply -auto-approve"
alias tfaplan="tf apply tfplan"
alias tfd="tf destroy"
alias tfda="tf destroy -auto-approve"
alias tfo="tf output"
alias tfoj="tf output -json"
alias tfs="tf state"
alias tfsl="tf state list"
alias tfss="tf state show"
alias tfsr="tf state rm"
alias tfmv="tf state mv"
alias tfv="tf validate"
alias tff="tf fmt -recursive"
alias tffc="tf fmt -check -recursive"
alias tfw="tf workspace"
alias tfwl="tf workspace list"
alias tfws="tf workspace select"
alias tfwn="tf workspace new"
alias tfwd="tf workspace delete"
alias tfimport="tf import"
alias tftaint="tf taint"
alias tfuntaint="tf untaint"
alias tfgraph="tf graph | dot -Tpng > /tmp/tfgraph.png && xdg-open /tmp/tfgraph.png"
alias tfcost="infracost breakdown --path ."  # requires infracost

# fzf workspace switcher
tfenv() {
  local ws
  ws=$(tf workspace list | tr -d " *" | fzf --prompt="Workspace> ")
  [[ -n "$ws" ]] && tf workspace select "$ws"
}

# Show outputs as table
tfout() { tf output -json | jq -r "to_entries[] | \"\(.key): \(.value.value)\"" 2>/dev/null || tf output; }

# Plan with cost estimate (requires infracost)
tfplan_full() {
  tf validate && tf fmt -check && tf plan -out=tfplan
  command -v infracost &>/dev/null && infracost diff --path . --tf-plan-file tfplan
}
'

  # ── 70-helm.zsh ───────────────────────────────────────────
  write_zshrc_module "70-helm.zsh" '# Helm
alias hi="helm install"
alias hu="helm upgrade --install"
alias huu="helm upgrade --install --atomic --cleanup-on-fail"
alias hl="helm list"
alias hla="helm list --all-namespaces"
alias hla="helm list -A"
alias hs="helm status"
alias hr="helm repo"
alias hrl="helm repo list"
alias hra="helm repo add"
alias hru="helm repo update"
alias hrd="helm repo remove"
alias hd="helm delete"
alias hg="helm get values"
alias hga="helm get all"
alias hgm="helm get manifest"
alias hdr="helm dependency update"
alias hdb="helm dependency build"
alias ht="helm template"
alias hlint="helm lint"
alias htest="helm test"
alias hsearch="helm search repo"
alias hhub="helm search hub"
alias hhistory="helm history"
alias hrollback="helm rollback"

# Render chart and preview
htemplate() {
  local release="${1:-release}" chart="${2:-.}"
  helm template "$release" "$chart" --debug "${@:3}" | bat --language yaml
}

# Diff before upgrade (requires helm-diff plugin)
hdiff() {
  local release="$1" chart="${2:-.}"
  helm diff upgrade "$release" "$chart" "${@:3}"
}
'

  # ── 80-aws-gcp.zsh ────────────────────────────────────────
  write_zshrc_module "80-cloud.zsh" '# AWS
alias awsid="aws sts get-caller-identity | jq ."
alias awsenv="env | grep AWS | sort"
alias awsregion="aws configure get region"
alias awsls="aws s3 ls"
alias awslogs="aws logs tail"
alias awsec2="aws ec2 describe-instances --query \"Reservations[*].Instances[*].[InstanceId,State.Name,InstanceType,PublicIpAddress,Tags[?Key==\`Name\`].Value|[0]]\" --output table"
alias awseks="aws eks list-clusters"
alias awsecr="aws ecr describe-repositories --query \"repositories[*].repositoryName\" --output table"

# Switch AWS profile via fzf
awsprofile() {
  local profile
  profile=$(aws configure list-profiles | fzf --prompt="AWS Profile> ")
  [[ -n "$profile" ]] && export AWS_PROFILE="$profile" && echo "→ AWS_PROFILE=$AWS_PROFILE"
}

# Get ECR login
ecrlogin() {
  local region="${1:-$(aws configure get region)}"
  local account; account=$(aws sts get-caller-identity --query Account --output text)
  aws ecr get-login-password --region "$region" \
    | docker login --username AWS --password-stdin "${account}.dkr.ecr.${region}.amazonaws.com"
}

# GCP
alias gcpctx="gcloud config configurations list"
alias gcpproj="gcloud config get-value project"
alias gcpls="gcloud projects list"
alias gcpkube="gcloud container clusters get-credentials"

gcpswitch() {
  local proj
  proj=$(gcloud projects list --format="value(projectId)" | fzf --prompt="GCP Project> ")
  [[ -n "$proj" ]] && gcloud config set project "$proj"
}
'

  # ── 90-tmux.zsh ───────────────────────────────────────────
  write_zshrc_module "90-tmux.zsh" '# tmux shortcuts
alias ta="tmux attach -t"
alias tl="tmux ls"
alias tn="tmux new-session -s"
alias tk="tmux kill-session -t"
alias td="tmux detach"
alias tks="tmux kill-server"

# Smart tmux attach or create
t() {
  local session="${1:-main}"
  tmux has-session -t "$session" 2>/dev/null \
    && tmux attach -t "$session" \
    || tmux new-session -s "$session"
}

# fzf tmux session switcher
tsw() {
  local session
  session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --prompt="Switch session> ")
  [[ -n "$session" ]] && tmux switch-client -t "$session"
}
'

  ok "~/.zshrc.d/ modules written (10-navigation, 20-system, 30-git, 40-kubernetes, 50-docker, 60-terraform, 70-helm, 80-cloud, 90-tmux)"
}

# ─── Write .p10k.zsh ──────────────────────────────────────────────────────────
write_p10k() {
  step "Writing Powerlevel10k config"

  local P10K="$USER_HOME/.p10k.zsh"
  [[ "$DRY_RUN" == "true" ]] && { log "[dry-run] Would write .p10k.zsh"; return; }

  if [[ -f "$P10K" && "$FORCE" != "true" ]]; then
    warn ".p10k.zsh already exists — skipping (use -f to overwrite)"
    return
  fi

  cat > "$P10K" <<'P10K_EOF'
# ============================================================
#  ~/.p10k.zsh — Powerlevel10k DevOps/SRE Theme
#  Regenerate interactively: p10k configure
# ============================================================

# Left prompt segments
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
  os_icon           # OS icon
  dir               # Current directory
  vcs               # Git status
  kubecontext       # Kubernetes context:namespace
  terraform         # Terraform workspace
  newline           # Line break before cursor
)

# Right prompt segments
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
  status                  # Exit code of last command
  command_execution_time  # Duration of last command
  background_jobs         # Background job count
  aws                     # Active AWS profile
  gcp                     # Active GCP project
  virtualenv              # Python virtual env
  node_version            # Node.js version
  go_version              # Go version
  time                    # Clock
)

# ── Layout ───────────────────────────────────────────────────
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="╭─"
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="╰❯ "
POWERLEVEL9K_RPROMPT_ON_NEWLINE=false
POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=''
POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=''
POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=' '
POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR=' '

# ── OS icon ──────────────────────────────────────────────────
POWERLEVEL9K_OS_ICON_FOREGROUND=220

# ── Directory ────────────────────────────────────────────────
POWERLEVEL9K_DIR_FOREGROUND=75
POWERLEVEL9K_DIR_SHORTENED_FOREGROUND=103
POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=39
POWERLEVEL9K_DIR_ANCHOR_BOLD=true
POWERLEVEL9K_DIR_MAX_LENGTH=5
POWERLEVEL9K_DIR_SHORTEN_STRATEGY=truncate_to_unique
POWERLEVEL9K_DIR_SHORTEN_LENGTH=1

# ── Git ──────────────────────────────────────────────────────
POWERLEVEL9K_VCS_CLEAN_FOREGROUND=76
POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=220
POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=208
POWERLEVEL9K_VCS_CONFLICTED_FOREGROUND=196
POWERLEVEL9K_VCS_LOADING_FOREGROUND=244

POWERLEVEL9K_VCS_BRANCH_ICON='⎇ '
POWERLEVEL9K_VCS_STAGED_ICON='●'
POWERLEVEL9K_VCS_UNSTAGED_ICON='✚'
POWERLEVEL9K_VCS_UNTRACKED_ICON='…'
POWERLEVEL9K_VCS_CONFLICTED_ICON='✖'
POWERLEVEL9K_VCS_CLEAN_ICON=''
POWERLEVEL9K_VCS_INCOMING_CHANGES_ICON='⇣'
POWERLEVEL9K_VCS_OUTGOING_CHANGES_ICON='⇡'
POWERLEVEL9K_VCS_STASH_ICON='$'

POWERLEVEL9K_VCS_MAX_INDEX_SIZE_DIRTY=4096   # Skip dirty check on large repos

# ── Kubernetes ───────────────────────────────────────────────
POWERLEVEL9K_KUBECONTEXT_SHOW_ON_COMMAND='kubectl|helm|k9s|kubens|kubectx|argocd|flux|stern|velero|terraform'
POWERLEVEL9K_KUBECONTEXT_FOREGROUND=75

# Color-code by context name for safety
POWERLEVEL9K_KUBECONTEXT_CLASSES=(
  '*prod*|*production*|*prd*'   PROD
  '*stag*|*staging*|*stg*'      STAGING
  '*dev*|*development*'         DEV
  '*'                           DEFAULT
)
POWERLEVEL9K_KUBECONTEXT_PROD_FOREGROUND=196      # Red — production
POWERLEVEL9K_KUBECONTEXT_STAGING_FOREGROUND=214   # Orange — staging
POWERLEVEL9K_KUBECONTEXT_DEV_FOREGROUND=76        # Green — dev
POWERLEVEL9K_KUBECONTEXT_DEFAULT_FOREGROUND=75    # Blue — other

# Show namespace after context (context/namespace)
POWERLEVEL9K_KUBECONTEXT_SHOW_DEFAULT_NAMESPACE=true

# ── Terraform ────────────────────────────────────────────────
POWERLEVEL9K_TERRAFORM_SHOW_ON_COMMAND='terraform|tf|tofu'
POWERLEVEL9K_TERRAFORM_CLASSES=(
  '*prod*'  PROD
  '*stag*'  STAGING
  '*'       DEFAULT
)
POWERLEVEL9K_TERRAFORM_PROD_FOREGROUND=196
POWERLEVEL9K_TERRAFORM_STAGING_FOREGROUND=214
POWERLEVEL9K_TERRAFORM_DEFAULT_FOREGROUND=135

# ── AWS ──────────────────────────────────────────────────────
POWERLEVEL9K_AWS_SHOW_ON_COMMAND='aws|sam|eb|terraform|tf|tofu'
POWERLEVEL9K_AWS_CLASSES=(
  '*prod*'  PROD
  '*stag*'  STAGING
  '*'       DEFAULT
)
POWERLEVEL9K_AWS_PROD_FOREGROUND=196
POWERLEVEL9K_AWS_STAGING_FOREGROUND=214
POWERLEVEL9K_AWS_DEFAULT_FOREGROUND=220

# ── GCP ──────────────────────────────────────────────────────
POWERLEVEL9K_GCP_SHOW_ON_COMMAND='gcloud|gsutil|bq|terraform|tf'
POWERLEVEL9K_GCP_FOREGROUND=81

# ── Python venv ──────────────────────────────────────────────
POWERLEVEL9K_VIRTUALENV_SHOW_ON_COMMAND='python|python3|pip|pip3|ansible|pytest'
POWERLEVEL9K_VIRTUALENV_FOREGROUND=227

# ── Command execution time ───────────────────────────────────
POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3     # Only show if > 3 seconds
POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=1
POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=248

# ── Exit status ──────────────────────────────────────────────
POWERLEVEL9K_STATUS_OK=false                         # Hide green checkmark
POWERLEVEL9K_STATUS_ERROR_FOREGROUND=196
POWERLEVEL9K_STATUS_ERROR_SIGNAL_FOREGROUND=196

# ── Time ─────────────────────────────────────────────────────
POWERLEVEL9K_TIME_FORMAT='%D{%H:%M:%S}'
POWERLEVEL9K_TIME_FOREGROUND=244

# ── Background jobs ──────────────────────────────────────────
POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE=true
POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND=220

# ── Node / Go versions ───────────────────────────────────────
POWERLEVEL9K_NODE_VERSION_SHOW_ON_COMMAND='node|npm|npx|yarn|pnpm'
POWERLEVEL9K_NODE_VERSION_FOREGROUND=70
POWERLEVEL9K_GO_VERSION_SHOW_ON_COMMAND='go|gofmt|golint'
POWERLEVEL9K_GO_VERSION_FOREGROUND=81

# ── Instant prompt ───────────────────────────────────────────
# Enable instant prompt (near-instant shell startup)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ── Transient prompt ─────────────────────────────────────────
# Replaces previous prompt lines with a compact single-line prompt
POWERLEVEL9K_TRANSIENT_PROMPT=always
P10K_EOF

  ok ".p10k.zsh written"
}

# ─── Tmux Config ──────────────────────────────────────────────────────────────
write_tmux_conf() {
  [[ "$NO_TMUX" == "true" ]]   && { skipped "tmux config (--no-tmux)"; return; }
  [[ "$DRY_RUN" == "true" ]]   && { log "[dry-run] Would write .tmux.conf"; return; }
  ! has tmux                   && { warn "tmux not installed — skipping config"; return; }

  step "Writing tmux configuration"

  local TMUX_CONF="$USER_HOME/.tmux.conf"
  [[ -f "$TMUX_CONF" && "$FORCE" != "true" ]] && { warn ".tmux.conf exists — skipping (use -f)"; return; }

  cat > "$TMUX_CONF" <<'TMUX_EOF'
# ============================================================
#  ~/.tmux.conf — DevOps/SRE tmux Config
# ============================================================

# ── Prefix key: Ctrl+a (screen-style) ───────────────────────
unbind C-b
set-option -g prefix C-a
bind-key C-a send-prefix

# ── Terminal & Colors ────────────────────────────────────────
set -g default-terminal "screen-256color"
set -ga terminal-overrides ",xterm-256color:Tc"
set -g default-shell /bin/zsh

# ── General settings ─────────────────────────────────────────
set -g history-limit 50000
set -g display-time 2000
set -g status-interval 5
set -g focus-events on
set -sg escape-time 0              # No delay for ESC (important for vim)
set -g base-index 1                # Windows start at 1
setw -g pane-base-index 1
set -g renumber-windows on         # Renumber on window close
set -g set-clipboard on
setw -g automatic-rename on        # Auto-rename window to current command

# ── Mouse support ────────────────────────────────────────────
set -g mouse on

# ── Vim keybindings in copy mode ─────────────────────────────
setw -g mode-keys vi
bind-key -T copy-mode-vi 'v' send -X begin-selection
bind-key -T copy-mode-vi 'y' send -X copy-selection-and-cancel
bind-key -T copy-mode-vi 'r' send -X rectangle-toggle
bind P paste-buffer

# ── Window / Pane management ─────────────────────────────────
bind c new-window -c "#{pane_current_path}"
bind | split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"
unbind '"'
unbind %

# Resize panes with Prefix + H/J/K/L
bind -r H resize-pane -L 5
bind -r J resize-pane -D 5
bind -r K resize-pane -U 5
bind -r L resize-pane -R 5

# Navigate panes with Prefix + h/j/k/l (vim-style)
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

# Quick window navigation
bind -r n next-window
bind -r p previous-window
bind Tab last-window

# Reload config
bind r source-file ~/.tmux.conf \; display "Config reloaded!"

# Kill pane/window without confirm prompt
bind x kill-pane
bind X kill-window
bind Q kill-session

# Sync panes (broadcast to all panes in window)
bind S setw synchronize-panes \; display "Pane sync: #{?synchronize-panes,ON,OFF}"

# ── Status bar ───────────────────────────────────────────────
set -g status on
set -g status-position bottom
set -g status-justify left
set -g status-style "fg=#cdd6f4,bg=#1e1e2e"

# Left: session name
set -g status-left-length 40
set -g status-left "#[fg=#89b4fa,bold] ❐ #S #[fg=#313244]│ "

# Right: kubernetes context + AWS + time + hostname
set -g status-right-length 120
set -g status-right "\
#[fg=#a6e3a1]⎇ #(kubectl config current-context 2>/dev/null | cut -d: -f1 | head -c20 || echo '-') \
#[fg=#313244]│ \
#[fg=#f9e2af]☁  #(echo ${AWS_PROFILE:-default}) \
#[fg=#313244]│ \
#[fg=#94e2d5]%H:%M \
#[fg=#313244]│ \
#[fg=#cba6f7] #H"

# Window tabs
set -g window-status-style "fg=#6c7086,bg=#1e1e2e"
set -g window-status-format " #I:#W "
set -g window-status-current-style "fg=#1e1e2e,bg=#89b4fa,bold"
set -g window-status-current-format " #I:#W "
set -g window-status-activity-style "fg=#f38ba8,bg=#1e1e2e"

# Pane borders
set -g pane-border-style "fg=#313244"
set -g pane-active-border-style "fg=#89b4fa"

# Message / command line
set -g message-style "fg=#1e1e2e,bg=#f9e2af,bold"

# ── Plugins (tpm) ────────────────────────────────────────────
# Install tpm: git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# Then: Prefix + I to install plugins
if "test -f ~/.tmux/plugins/tpm/tpm" \
  "run ~/.tmux/plugins/tpm/tpm"
TMUX_EOF

  chown "$TARGET_USER":"$TARGET_USER" "$TMUX_CONF"
  ok ".tmux.conf written (Catppuccin Mocha theme)"
}

# ─── Fix Ownership ────────────────────────────────────────────────────────────
fix_ownership() {
  [[ "$DRY_RUN" == "true" ]] && return
  step "Fixing ownership"
  chown -R "$TARGET_USER":"$TARGET_USER" "$USER_HOME/.oh-my-zsh"  2>/dev/null || true
  chown -R "$TARGET_USER":"$TARGET_USER" "$ZSHRC_D"               2>/dev/null || true
  chown    "$TARGET_USER":"$TARGET_USER" "$USER_HOME/.zshrc"       2>/dev/null || true
  chown    "$TARGET_USER":"$TARGET_USER" "$USER_HOME/.p10k.zsh"   2>/dev/null || true
  chown    "$TARGET_USER":"$TARGET_USER" "$USER_HOME/.tmux.conf"  2>/dev/null || true
  ok "Ownership set to $TARGET_USER"
}

# ─── Set Default Shell ────────────────────────────────────────────────────────
set_default_shell() {
  [[ "$DRY_RUN" == "true" ]] && { log "[dry-run] Would set default shell to zsh"; return; }
  step "Setting default shell to Zsh"

  local ZSH_BIN; ZSH_BIN=$(command -v zsh)
  grep -qx "$ZSH_BIN" /etc/shells || echo "$ZSH_BIN" >> /etc/shells
  chsh -s "$ZSH_BIN" "$TARGET_USER"
  ok "Default shell → $ZSH_BIN"
}

# ─── Summary ──────────────────────────────────────────────────────────────────
print_summary() {
  echo
  hr
  echo -e "\n  ${BOLD}${GREEN}✅  Installation Complete!${RESET}  (log: ${DIM}${LOG_FILE}${RESET})\n"
  hr2

  echo -e "\n  ${BOLD}What was installed:${RESET}"
  echo -e "  • Oh My Zsh + Powerlevel10k"
  echo -e "  • Plugins: autosuggestions, syntax-highlighting, zsh-z"
  [[ "$MINIMAL" == "false" ]] && \
    echo -e "  • Extra plugins: completions, history-search, fast-syntax-highlighting"
  [[ "$INSTALL_TOOLS" == "true" ]] && \
    echo -e "  • Tools: ${SELECTED_TOOLS[*]}"
  [[ "$NO_TMUX" != "true" ]] && echo -e "  • Tmux config (Catppuccin Mocha theme)"
  echo -e "  • Modular config in ~/.zshrc.d/ (10-navigation … 90-tmux)"

  hr2
  echo -e "\n  ${BOLD}Quick reference:${RESET}"

  local cmds=(
    "exec zsh           Reload shell now"
    "p10k configure     Redesign prompt interactively"
    "kctx               Switch k8s context (fzf)"
    "kns                Switch k8s namespace (fzf)"
    "kexec              Exec into a pod (fzf)"
    "klogs              Tail pod logs (fzf)"
    "kedit              Edit any k8s resource (fzf)"
    "ksecret <name>     Decode a k8s secret"
    "klimits            Show pod CPU/memory limits"
    "gfco               Git checkout branch (fzf)"
    "gflog              Browse git log (fzf)"
    "tfenv              Switch Terraform workspace (fzf)"
    "dexec              Exec into Docker container (fzf)"
    "awsprofile         Switch AWS profile (fzf)"
    "fkill              Kill a process (fzf)"
    "svc                Manage systemd service (fzf)"
    "extract <file>     Unpack any archive"
    "portcheck h p      Test TCP port connectivity"
    "certinfo domain    Inspect TLS certificate"
    "myip               Show public + private IP"
    "genpass [len]      Generate secure password"
    "t [session]        Smart tmux attach/create"
  )

  for cmd in "${cmds[@]}"; do
    local name="${cmd%%   *}"
    local desc="${cmd#*   }"
    printf "  ${CYAN}%-30s${RESET} %s\n" "$name" "$desc"
  done

  echo
  echo -e "  ${BOLD}Font:${RESET} Set terminal font to ${YELLOW}MesloLGS NF${RESET} for prompt icons."
  echo -e "  ${BOLD}Extend:${RESET} Drop extra ${YELLOW}.zsh${RESET} files into ${YELLOW}~/.zshrc.d/${RESET} — auto-loaded."
  echo -e "  ${BOLD}Local:${RESET}  Machine-specific config → ${YELLOW}~/.zshrc.local${RESET} (not in git)."
  echo
  hr
}

# ─── Main ─────────────────────────────────────────────────────────────────────
main() {
  detect_arch
  detect_os
  print_banner

  backup_existing

  install_packages
  install_fonts
  install_ohmyzsh
  install_theme
  install_plugins
  install_devops_tools
  write_zshrc
  write_p10k
  write_tmux_conf
  fix_ownership
  set_default_shell

  # Disable rollback trap on success
  trap - ERR

  print_summary
}

main "$@"
