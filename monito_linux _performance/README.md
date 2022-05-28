
## top
Linux Top command is a performance monitoring program that is used frequently by many system administrators to monitor Linux performance and it is available under many Linux/Unix-like operating systems.

```
top
```
## VmStat – Virtual Memory Statistics

Linux VmStat command is used to display statistics of virtual memory, kernel threads, disks, system processes, I/O blocks, interrupts, CPU activity, and much more.
vmstat command (also known as virtual memory statistic tool) shows information about processes, memory, disk, and CPU activity in Linux, whereas the iostat command is used to monitor CPU utilization, system input/output statistics for all the disks and partitions.

```
sudo apt-get install sysstat  [On Debian/Ubuntu & Mint]
```

The common usage of vmstat command format is.

```
vmstat
```

### Execute vmstat ‘X’ seconds and (‘Number of times)

In the below example, there are six columns. The significance of the columns are explained on the man page of vmstat in detail. The most important fields are free under memory and si, so under the swap column.

```

vmstat -a

```

* Free – Amount of free/idle memory spaces.
* si – Swapped in every second from disk in KiloBytes.
* so – Swapped out every second to disk in KiloBytes.


With this command, vmstat execute every two seconds and stop automatically after executing six intervals.

```
vmsate 2 6 
```
### Vmstat with Timestamps

```
vmstat -t 1 5
```

### Statistics of Various Counter

vmstat command with -s switch displays summary of various event counters and memory statistics.

```
vmstat -s 

```

### Monitor Linux Disks Statistics
vmstat with -d option display all disks statistics of Linux.
```
vmstat -d
```

### Display Statistics in Megabytes

The vmstat displays memory statistics in kilobytes by default, but you can also display reports with memory sizes in megabytes with the argument -S M. Consider the following example.

```
vmstat -S M 1 5
```
### Display CPU and I/O Statistics of Disks

iostat without arguments displays CPU and I/O statistics of all partitions as shown below.

```
iostat
```

### Shows Linux CPU Statistics

iostat with -c arguments displays only CPU statistics as shown below.

```
iostat -c
```

### Shows Linux Disks I/O Statistics

iostat with -d arguments display only disk I/O statistics of all partitions as shown.

```
iostat -d
```

### Shows I/O Statistics of Specific Device

By default, it displays statistics of all partitions, with -p and device name arguments display only disks I/O statistics for specific device only as shown.

```
iostat -p sda
```

### Display LVM Statistics

```
iostat -N
```
### Check Iostat Version

```
iostat -V
```
### NetHogs – Monitor Per Process Network Bandwidth

NetHogs is an open-source nice small program (similar to Linux top command) that keeps a tab on each process network activity on your system. It also keeps a track of real-time network traffic bandwidth used by each program or application.

# nethogs





