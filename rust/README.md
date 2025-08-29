sudo apt update
sudo apt install -y curl build-essential
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

source $HOME/.cargo/env

echo 'source $HOME/.cargo/env' >> ~/.zshrc
source ~/.zshrc

or
echo 'source $HOME/.cargo/env' >> ~/.bashrc
source ~/.bashrc

rustc --version


rustup update

