## How to on it
node: you can run this comment on server1 to server2

```
nix --extra-experimental-features "nix-command flakes" \
  run github:nix-community/nixos-anywhere -- \
  --flake .#server2 \
  root@177.54.155.255

```
