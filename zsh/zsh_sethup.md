

**vim sethup.sh**


```bash
#!/bin/bash
set -e

echo "🚀 شروع نصب Zsh محیط حرفه‌ای DevOps..."

if [ "$EUID" -ne 0 ]; then
  echo "❌ لطفاً به عنوان root یا با sudo اجرا کنید."
  exit 1
fi

USER_NAME=${SUDO_USER:-$(whoami)}
USER_HOME=$(eval echo "~$USER_NAME")
ZSH_CUSTOM="$USER_HOME/.oh-my-zsh/custom"

apt update && apt install -y zsh git curl wget unzip fonts-powerline locales fzf

locale-gen en_US.UTF-8
update-locale LANG=en_US.UTF-8

echo "🔤 نصب فونت Meslo..."
mkdir -p "$USER_HOME/.local/share/fonts"
cd "$USER_HOME/.local/share/fonts"
wget -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
wget -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
wget -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
wget -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
fc-cache -fv > /dev/null

echo "💻 نصب Oh My Zsh..."
export RUNZSH=no
sudo -u "$USER_NAME" sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "🎨 نصب Powerlevel10k..."
sudo -u "$USER_NAME" git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"

echo "🔌 نصب پلاگین‌های DevOps..."
sudo -u "$USER_NAME" git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
sudo -u "$USER_NAME" git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
sudo -u "$USER_NAME" git clone https://github.com/agkozak/zsh-z "$ZSH_CUSTOM/plugins/zsh-z"

echo "🛠️ ساخت فایل zshrc..."
cat << EOF > "$USER_HOME/.zshrc"
export ZSH="\$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git docker kubectl sudo zsh-autosuggestions zsh-syntax-highlighting zsh-z)

source \$ZSH/oh-my-zsh.sh

alias k='kubectl'
alias kga='kubectl get all'
alias klog='kubectl logs -f'
alias ..='cd ..'
alias ...='cd ../..'
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias gp='git push'
alias dcu='docker-compose up -d'
alias dcd='docker-compose down'

source \$ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source \$ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source \$ZSH_CUSTOM/plugins/zsh-z/zsh-z.plugin.zsh

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
EOF

echo "⚙️ ساخت فایل پیکربندی powerlevel10k..."
cat << 'EOF' > "$USER_HOME/.p10k.zsh"
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time background_jobs time)

POWERLEVEL9K_VCS_BRANCH_ICON='🌿 '
POWERLEVEL9K_VCS_STAGED_ICON='●'
POWERLEVEL9K_VCS_UNSTAGED_ICON='✚'
POWERLEVEL9K_VCS_UNTRACKED_ICON='…'
POWERLEVEL9K_VCS_CONFLICTED_ICON='✖'
POWERLEVEL9K_VCS_CLEAN_ICON='✔'

POWERLEVEL9K_OS_ICON_CONTENT_EXPANSION='🐧'
POWERLEVEL9K_TIME_FORMAT='%D{%H:%M:%S}'

POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="╭─"
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="╰▶ "
EOF

chown -R "$USER_NAME":"$USER_NAME" "$USER_HOME"

echo "🌀 تغییر shell پیش‌فرض به zsh..."
chsh -s "$(which zsh)" "$USER_NAME"

echo ""
echo "✅ محیط DevOps Zsh آماده‌ست!"
echo "📦 برای فعال‌سازی، یکبار logout/login یا فقط تایپ کن: zsh"
echo "🎨 ظاهر رو هم می‌تونی با: p10k configure تنظیم کنی"
```
