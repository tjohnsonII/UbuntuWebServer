import os
import logging
from flask import Flask, render_template
from mac_vendor_lookup import MacLookup, VendorNotFoundError
import nmap

# Setup logging
logging.basicConfig(filename='app_errors.log', level=logging.WARNING, 
                    format='%(asctime)s [%(levelname)s] %(message)s')

app = Flask(__name__)

# Use local writable cache path
os.environ["MAC_VENDOR_LOOKUP_CACHE"] = "./.cache/mac-vendors.txt"
os.makedirs("./.cache", exist_ok=True)

vendor_lookup = MacLookup()
try:
    vendor_lookup.update_vendors()
except Exception as e:
    logging.warning(f"Failed to update MAC vendor database: {e}")

def scan_network():
    nm = nmap.PortScanner()
    nm.scan(hosts="192.168.1.0/24", arguments="-O")  # Enable OS detection
    hosts = []

    for host in nm.all_hosts():
        mac = nm[host]['addresses'].get('mac', 'N/A')
        try:
            vendor = vendor_lookup.lookup(mac) if mac != "N/A" else "N/A"
        except VendorNotFoundError:
            vendor = "Unknown"

        os_info = nm[host].get('osmatch', [{}])[0].get('name', 'N/A')

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
