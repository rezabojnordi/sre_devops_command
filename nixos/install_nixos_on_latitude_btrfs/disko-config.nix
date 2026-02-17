{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/sda";
        content = {
          type = "gpt";
          partitions = {
            # 1. BIOS Boot Partition
            # MANDATORY for booting GRUB on GPT disks in Legacy BIOS mode
            boot = {
              size = "1M";
              type = "EF02"; 
              priority = 1; 
            };
            
            # 2. ESP (Optional but good practice)
            # We keep this for /boot files or future UEFI compatibility
            ESP = {
              size = "500M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            
            # 3. Root Partition (Btrfs)
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ]; # Force overwrite if needed
                
                # Btrfs Subvolumes (Logical separation of data)
                subvolumes = {
                  # The root filesystem
                  "@" = {
                    mountpoint = "/";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  
                  # User home directories
                  "@home" = {
                    mountpoint = "/home";
                    mountOptions = [ "compress=zstd" ];
                  };
                  
                  # Nix store (Heavy read/write, compression helps)
                  "@nix" = {
                    mountpoint = "/nix";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
