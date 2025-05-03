from flask import Flask, render_template
from mac_vendor_lookup import MacLookup, VendorNotFoundError
import nmap

app = Flask(__name__)
vendor_lookup = MacLookup()
vendor_lookup.update_vendors()  # Download fresh vendor DB

def scan_network():
    nm = nmap.PortScanner()
    nm.scan(hosts="192.168.1.0/24", arguments="-O")  # Enables OS detection
    hosts = []

    for host in nm.all_hosts():
        mac = nm[host]['addresses'].get('mac', 'N/A')
        hostname = nm[host].hostname()
        
        # Attempt vendor lookup
        try:
            vendor = vendor_lookup.lookup(mac) if mac != "N/A" else "N/A"
        except VendorNotFoundError:
            vendor = "Unknown"

        # Try to get OS info
        try:
            osmatch = nm[host]['osmatch']
            os = osmatch[0]['name'] if osmatch else "Unknown"
        except KeyError:
            os = "Unknown"

        hosts.append({
            'ip': host,
            'hostname': hostname,
            'mac': mac,
            'vendor': vendor,
            'os': os
        })

    return hosts

@app.route("/")
def home():
    results = scan_network()
    return render_template("scan_results.html", results=results)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=False, use_reloader=False)
