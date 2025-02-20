**vim sethup.sh**


```bash
#!/bin/bash

# Update system
echo "Updating system..."
sudo apt update && sudo apt upgrade -y

# Install necessary packages
echo "Installing Zsh, Git, Docker, Kubectl, and dependencies..."
sudo apt install -y zsh git curl wget fonts-powerline bash-completion

# Install Oh My Zsh
echo "Installing Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install zsh-autosuggestions and zsh-syntax-highlighting plugins
echo "Installing zsh-autosuggestions and zsh-syntax-highlighting..."
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

# Change default theme to agnoster
echo "Setting agnoster theme..."
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="agnoster"/' ~/.zshrc

# Enable plugins (git, docker, kubectl, zsh-autosuggestions, zsh-syntax-highlighting)
echo "Enabling useful plugins..."
sed -i 's/plugins=(git)/plugins=(git docker kubectl zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc

# Add custom aliases for development and DevOps
echo "Adding custom aliases for Docker, Kubernetes, Git..."
cat <<EOL >> ~/.zshrc

# Custom aliases
alias dps='docker ps'
alias dlogs='docker logs -f'

# Kubernetes aliases
alias k='kubectl'
alias kgp='kubectl get pods'
alias klogs='kubectl logs'

# Git aliases
alias gst='git status'
alias gco='git checkout'
alias gd='git diff'

# Navigation aliases
alias ..='cd ..'
alias ...='cd ../..'
EOL

# Apply changes to the current session
echo "Applying changes..."
source ~/.zshrc

# Change default shell to zsh
echo "Changing default shell to zsh..."
chsh -s $(which zsh)

# Restart terminal for changes to take effect
echo "Setup complete! Please restart your terminal for all changes to take effect."
```