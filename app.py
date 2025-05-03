from flask import Flask, render_template
import nmap

app = Flask(__name__)

def scan_network():
    nm = nmap.PortScanner()
    nm.scan(hosts="192.168.1.0/24", arguments="-sn")
    hosts = []

    for host in nm.all_hosts():
        hosts.append({
            'ip': host,
            'hostname': nm[host].hostname(),
            'mac': nm[host]['addresses'].get('mac', 'N/A')
        })

    return hosts

@app.route("/")
def home():
    results = scan_network()
    return render_template("scan_results.html", results=results)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=False, use_reloader=False)
