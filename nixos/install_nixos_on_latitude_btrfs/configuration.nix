{ modulesPath, lib, pkgs, ... }:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  # --- Bootloader Settings (Legacy BIOS + Btrfs) ---
  boot.loader.grub.enable = true;
  
  # FIX: Use 'lib.mkForce' to strictly define the boot device
  # preventing conflicts with Disko's auto-generation.
  boot.loader.grub.devices = lib.mkForce [ "/dev/sda" ];
  
  boot.loader.grub.efiSupport = false; # Legacy BIOS Mode
  boot.loader.grub.useOSProber = true;
  # -------------------------------------------------

  # SSH Access
  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "yes";

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICmH44yGqC54PK6cEiBaLtq7h63Zd5ob1hRJ86wBwP58 root@NixOS-POC"
  ];

  system.stateVersion = "24.11";
}
