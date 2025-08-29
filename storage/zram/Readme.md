ZRAM Setup for Improved System Performance
This guide explains how to enable ZRAM, a compressed RAM disk, on Linux. ZRAM creates a compressed swap space in your RAM, which can significantly speed up your system by avoiding slow disk I/O when memory is low. This is particularly useful for systems with limited RAM.

## 🚀 Installation
First, update your package list and install the zram-tools package.

```bash
sudo apt update
sudo apt install zram-tools
```
## ⚙️ Configuration
After installation, you can configure ZRAM by editing its default settings file.
```bash
sudo nano /etc/default/zramswap
```

In this file, you can modify two key values:

### ALGO: 
This specifies the compression algorithm. lz4 is the fastest, while zstd offers the best compression ratio. lz4 is generally a great choice for balancing speed and compression.

### PERCENT: 
This determines what percentage of your total RAM will be allocated to ZRAM. The default value, typically 20 or 25, is usually a good starting point.

## ▶️ Activation
After installing and configuring the service, start and enable it to ensure it runs automatically on every system boot.
```bash
sudo systemctl start zramswap.service
sudo systemctl enable zramswap.service
```

## Verification
To verify that ZRAM is active and working correctly, use the zramctl command.
```bash
zramctl
```
