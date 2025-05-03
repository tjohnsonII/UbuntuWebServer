from flask import Flask, render_template
import nmap
from manuf import manuf
import os
import json

app = Flask(__name__)

# Initialize the MAC vendor parser once
mac_parser = manuf.MacParser()

def scan_network():
    def load_os_cache():
        try:
            with open("/tmp/os_cache.json") as f:
                data = json.load(f)
                return data.get("os_results", {})
        except Exception:
            return {}
    
    nm = nmap.PortScanner()
    nm.scan(hosts="192.168.1.0/24", arguments="-sn")  # Fast ping scan
    hosts = []
    os_cache = load_os_cache()

    for host in nm.all_hosts():
        mac = nm[host]['addresses'].get('mac', 'N/A')
        vendor = mac_parser.get_manuf(mac) if mac != "N/A" else "N/A"
        os_info = os_cache.get(host, "Unknown")
        hosts.append({
            'ip': host,
            'hostname': nm[host].hostname(),
            'mac': mac,
            'vendor': vendor,
            'os': os_info
        })

    return hosts

@app.route("/")
def home():
    results = scan_network()
    return render_template("scan_results.html", results=results)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=False, use_reloader=False)
