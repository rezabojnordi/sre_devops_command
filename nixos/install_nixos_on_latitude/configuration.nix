{ modulesPath, lib, ... }: # We added 'lib' here to use mkForce
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
  # --- Bootloader Settings (Legacy BIOS) ---
  boot.loader.grub.enable = true;
  # CRITICAL FIX: We use 'lib.mkForce' here.
  # Reason: The 'disko' module automatically sets a boot device. 
  # Without 'mkForce', NixOS sees two devices and fails with "Duplicated devices" error.
  # This command forces NixOS to use only this list.
  boot.loader.grub.devices = lib.mkForce [ "/dev/sda" ]; 
  # Disable EFI because this server uses Legacy BIOS
  boot.loader.grub.efiSupport = false;
  # Look for other operating systems (optional, good for safety)
  boot.loader.grub.useOSProber = true;
  # ----------------------------------------
  # Enable SSH server so we can log in after installation
  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "yes";
  # The public SSH key for the root user
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICmH44yGqC54PK6cEiBaLtq7h63Zd5ob1hRJ86wBwP58 root@NixOS-POC"
  ];
  system.stateVersion = "24.11";
}
