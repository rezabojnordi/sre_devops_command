import sys
import subprocess
import re
from prettytable import PrettyTable

def ping_ip(ip):
    try:
        output = subprocess.check_output(['ping', '-c', '4', ip], universal_newlines=True)
        packet_loss = re.search(r'(\d+)% packet loss', output).group(1)
        rtt_times = re.findall(r'time=([\d.]+) ms', output)
        rtt_statistics = re.search(r'rtt min/avg/max/mdev = (\d+\.\d+)/(\d+\.\d+)/(\d+\.\d+)/(\d+\.\d+)', output)
        ttl_match = re.search(r'TTL=(\d+)', output)
        ttl = ttl_match.group(1) if ttl_match else "N/A"

        if rtt_statistics:
            rtt_min, rtt_avg, rtt_max, rtt_mdev = rtt_statistics.groups()
            ping_status = f"Packet Loss: {packet_loss}%,\nRTT (ms): {', '.join(rtt_times)},\nTTL: {ttl},\n"
            ping_status += f"Packets: {rtt_times[0]}/{len(rtt_times)}, RTT min/avg/max/mdev: {rtt_min}/{rtt_avg}/{rtt_max}/{rtt_mdev} ms"
        else:
            ping_status = "Unknown Error"

        return ping_status

    except subprocess.CalledProcessError:
        return "Unreachable"

    return "Unknown Error"

def main():
    if len(sys.argv) < 2:
        print("Usage: python ping2.py <ip1> <ip2> ...")
        return

    ips = sys.argv[1:]
    table = PrettyTable()
    table.field_names = ["IP Address", "Ping Status"]
    table.align = "l"
    table.padding_width = 2

    for ip in ips:
        ping_result = ping_ip(ip)
        table.add_row([ip, ping_result])

    print(table)

if __name__ == "__main__":
    main()

































