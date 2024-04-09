## How to install it

```
gpg —edit-card

sudo apt install yubikey-manager

ykman config mode o+f+c

ykman openpgp

ykman openpgp

ykman openpgp

apt install gnupg pcscd scdaemon
```

```
vim .gnupg/scdaemon.conf

disable-ccid
pcsc-driver /usr/lib/x86_64-linux-gnu/libpcsclite.so.1
card-timeout 1

# Always try to use yubikey as the first reader
# even when other smart card readers are connected
# Name of the reader can be found using the pcsc_scan command
# If you have problems with gpg not recognizing the Yubikey
# then make sure that the string here matches exacly pcsc_scan
# command output. Also check journalctl -f for errors.
reader-port Yubico YubiKey

```

```
vim .gnupg/gpg.conf

trust-model tofu+pgp
```

```
sudo systemctl restart pgp-agent.service

sudo gpg --card-status

gpgconf --list-dirs |grep ssh

-output
agent-ssh-socket:/run/user/1000/gnupg/S.gpg-agent.ssh
```

```
vim ~/.bashrc
export SSH_AUTH_SOCK=/run/user/1000/gnupg/S.gpg-agent.ssh

```
```
gpg --edit-card

sudo apt install yubikey-manager
```
