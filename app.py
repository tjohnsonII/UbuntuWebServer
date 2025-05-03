from flask import Flask
import nmap

app = Flask(__name__)

@app.route("/")
def home():
    nm = nmap.PortScanner()
    nm.scan(hosts='192.168.1.0/24', arguments='-sn')  # Ping scan

    results = []
    for host in nm.all_hosts():
        hostname = nm[host].hostname()
        mac = nm[host]['addresses'].get('mac', 'N/A')
        results.append(f"Host: {host} ({hostname}) | MAC: {mac}")

    return "<br>".join(results)  # Render results in HTML line breaks

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=False, use_reloader=False)
