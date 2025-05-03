from flask import Flask, render_template
import nmap
from manuf import manuf

app = Flask(__name__)

# Initialize the MAC vendor parser once
mac_parser = manuf.MacParser()

def scan_network():
    nm = nmap.PortScanner()
    nm.scan(hosts="192.168.1.0/24", arguments="-sn")  # Fast ping scan
    hosts = []

    for host in nm.all_hosts():
        mac = nm[host]['addresses'].get('mac', 'N/A')
        vendor = mac_parser.get_manuf(mac) if mac != "N/A" else "N/A"
        hosts.append({
            'ip': host,
            'hostname': nm[host].hostname(),
            'mac': mac,
            'vendor': vendor
        })

    return hosts

@app.route("/")
def home():
    results = scan_network()
    return render_template("scan_results.html", results=results)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=False, use_reloader=False)
