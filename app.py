from flask import Flask, render_template
from manuf import manuf
import nmap
import sqlite3
from datetime import datetime

app = Flask(__name__)
mac_parser = manuf.MacParser()

def get_known_host_info(mac):
    conn = sqlite3.connect("known_hosts.db")
    c = conn.cursor()
    c.execute("SELECT hostname, vendor, os, notes FROM known_hosts WHERE mac = ?", (mac,))
    row = c.fetchone()
    conn.close()
    if row:
        return {'hostname': row[0], 'vendor': row[1], 'os': row[2], 'notes': row[3]}
    return None

def scan_network():
    nm = nmap.PortScanner()
    nm.scan(hosts="192.168.1.0/24", arguments="-sn")
    hosts = []

    for host in nm.all_hosts():
        mac = nm[host]['addresses'].get('mac', 'N/A')
        hostname = nm[host].hostname()
        vendor = mac_parser.get_manuf(mac) if mac != "N/A" else "N/A"
        os_info = "N/A"
        notes = ""

        known = get_known_host_info(mac)
        if known:
            hostname = known['hostname'] or hostname
            vendor = known['vendor'] or vendor
            os_info = known['os'] or os_info
            notes = known['notes'] or ""

        hosts.append({
            'ip': host,
            'hostname': hostname,
            'mac': mac,
            'vendor': vendor,
            'os': os_info,
            'notes': notes
        })

    return hosts

@app.route("/")
def home():
    results = scan_network()
    return render_template("scan_results.html", results=results, last_scanned=datetime.now())

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=False, use_reloader=False)
