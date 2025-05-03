import nmap
import json
import time

OUTPUT_PATH = "/tmp/os_cache.json"

def deep_os_scan():
    nm = nmap.PortScanner()
    nm.scan(hosts="192.168.1.0/24", arguments="-O -T4")  # OS detection
    os_data = {}

    for host in nm.all_hosts():
        os_info = nm[host].get('osmatch', [])
        best_guess = os_info[0]['name'] if os_info else "Unknown"
        os_data[host] = best_guess

    with open(OUTPUT_PATH, "w") as f:
        json.dump({
            "timestamp": time.time(),
            "os_results": os_data
        }, f, indent=2)

if __name__ == "__main__":
    deep_os_scan()
