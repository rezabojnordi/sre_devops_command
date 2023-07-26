# ping2 - IP Address Ping Utility

![Ping2 Logo](./img/pinglogo.png)


![alt text](./img/ping2.png)


## Description

`ping2` is a Python-based command-line utility that allows users to perform ping tests on one or multiple IP addresses. It sends ICMP echo requests to the specified IP addresses and displays detailed information about packet loss, round-trip times (RTT), and time-to-live (TTL). The ping results are presented in a well-organized table format, making it easy to analyze the network health of various destinations at a glance.

## Features

- Perform ping tests on one or multiple IP addresses.
- Display packet loss, RTT times, and TTL information for each address.
- Output ping results in a tabular format for easy analysis.

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
- [License](#license)
- [Contributing](#contributing)
- [Issues](#issues)
- [Acknowledgments](#acknowledgments)
- [DpkgPackage](#DebianPackage)

## Installation

1. Clone this repository.

```bash
git clone https://github.com/rezabojnordi/ping2.git
```

### Change directory to the ping2 folder.
```bash
chmod +x ping2.py
```
### Usage
To run the ping2 command, open a terminal and navigate to the ping2 directory. Then use the following syntax:
``` bash
./ping2.py <ip1> <ip2> ...

```
Replace <ip1>, <ip2>, etc., with the IP addresses you want to ping.


### Example
To ping Google's public DNS server (8.8.8.8) and Cloudflare's public DNS server (1.1.1.1), use the following command:
```
./ping2.py 8.8.8.8 1.1.1.1

```

### License
This project is licensed under the MIT License - see the LICENSE file for details.

### Contributing
Contributions are welcome! Please read our Contribution Guidelines for more details.

### Issues
If you encounter any problems or have questions, feel free to open an issue.

### DebianPackage
```
sudo dpkg -i ping2.deb
```

### How to use it

```
ping2 8.8.8.8 1.1.1.1 4.2.2.4 4.4.4
```
