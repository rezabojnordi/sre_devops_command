
```
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
```

We can create a project using cargo new.
```bash
cargo new
```

We can build a project using cargo build.
```bash
cargo build
```

We can build and run a project in one step using cargo run.
```bash
cargo run
```
We can build a project without producing a binary to check for errors using cargo check.
```bash
cargo check
```
Install the latest stable version of Rust using 

```bash
rustup
```
