{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/sda";
        content = {
          type = "gpt";
          partitions = {
            # Critical partition for Legacy BIOS booting (Grub core image)
            boot = {
              size = "1M";
              type = "EF02"; 
              priority = 1; 
            };
            
            # ESP partition for Kernel/Bootloader files
            ESP = {
              size = "500M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            
            # ZFS partition taking the rest of the disk
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zroot";
              };
            };
          };
        };
      };
    };
    
    # ZFS Pool Configuration
    zpool = {
      zroot = {
        type = "zpool";
        
        # FIXED: Set this to null to avoid conflict with the 'root' dataset below
        mountpoint = null;
        
        rootFsOptions = {
          compression = "lz4";
          "com.sun:auto-snapshot" = "false";
        };

        datasets = {
          # The actual Root filesystem
          root = {
            type = "zfs_fs";
            mountpoint = "/";
            options.mountpoint = "legacy";
          };
          
          # Optional: Separate Home dataset
          home = {
            type = "zfs_fs";
            mountpoint = "/home";
            options.mountpoint = "legacy";
          };
          
          # Nix store dataset (optimization: turn off access time)
          nix = {
            type = "zfs_fs";
            mountpoint = "/nix";
            options.mountpoint = "legacy";
            options.atime = "off";
          };
        };
      };
    };
  };
}
