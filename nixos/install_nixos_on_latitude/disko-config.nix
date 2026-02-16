{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/sda"; # The hard drive to install on
        content = {
          type = "gpt";
          partitions = {
            # --- BIOS Boot Partition ---
            # This is critical for Legacy BIOS booting on GPT disks.
            # GRUB stores its core code here.
            boot = {
              size = "1M";
              type = "EF02"; 
              priority = 1; 
            };
            # ---------------------------
            
            ESP = {
              size = "500M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };
}
