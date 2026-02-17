{ modulesPath, lib, pkgs, ... }:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  # --- Bootloader Configuration (Legacy BIOS + ZFS) ---
  boot.loader.grub.enable = true;
  
  # FORCE: Override any default device settings from Disko to prevent duplicates
  boot.loader.grub.devices = lib.mkForce [ "/dev/sda" ];
  
  boot.loader.grub.efiSupport = false;
  boot.loader.grub.useOSProber = true;
  
  # IMPORTANT: Enable ZFS awareness for Grub
  boot.loader.grub.zfsSupport = true;
  # --------------------------------------------------

  # --- ZFS System Requirements ---
  boot.supportedFilesystems = [ "zfs" ];
  
  # CRITICAL: ZFS requires a unique 8-digit hex ID for the machine
  networking.hostId = "8425e349"; 
  # -------------------------------

  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "yes";

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICmH44yGqC54PK6cEiBaLtq7h63Zd5ob1hRJ86wBwP58 root@NixOS-POC"
  ];

  system.stateVersion = "24.11";
}
