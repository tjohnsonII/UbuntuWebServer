✅ Project Goal
Create a web-based dashboard on your Ubuntu server running Apache2 that:

Scans the network for connected devices (IP/MAC/vendor info)

Logs and displays device info (hostname, OS if possible)

Optionally, alerts on new/unknown devices

🛠 Tools & Technologies
Task	Recommended Tool
Web Server	Apache2 (already installed)
Backend	Python (Flask or Django) or PHP
Network Scanning	nmap or arp-scan
Frontend	HTML/CSS/JS (Bootstrap for styling)
Storage	SQLite or MySQL (optional for history tracking)
Cron	To schedule regular scans

🧱 Basic Architecture
csharp
Copy
Edit
[Ubuntu Server w/ Apache2]
       |
    [Backend App - Python or PHP]
       |
 [Scan Network using nmap/arp]
       |
 [Parse & Display Results in Web UI]

 🧪 Step-by-Step Starter Plan
1. Install nmap
bash
Copy
Edit
sudo apt update
sudo apt install nmap
2. Write a scan script (e.g., Python)
python
Copy
Edit
import nmap

nm = nmap.PortScanner()
nm.scan(hosts='192.168.1.0/24', arguments='-sn')  # Ping scan

for host in nm.all_hosts():
    print(f"Host: {host} ({nm[host].hostname()}) | MAC: {nm[host]['addresses'].get('mac', 'N/A')}")
3. Display on a Web Page
Option A: Write a Python Flask app that returns HTML

Option B: Use PHP script to execute the scan and output HTML

Sample PHP snippet (basic, not secure for production):

php
Copy
Edit
<?php
$output = shell_exec("nmap -sn 192.168.1.0/24");
echo "<pre>$output</pre>";
?>
Save as /var/www/html/devices.php and access it at http://your-server-ip/devices.php.

4. Automate with cron
Run the scan every 5-10 minutes and cache results to a file or DB.

bash
Copy
Edit
*/5 * * * * /usr/bin/python3 /home/user/scan_script.py > /var/www/html/devices.html
✅ Optional Enhancements
Store data in SQLite or MySQL to track device history

Flag new devices

Use ARP or SNMP for more device details

Add login/authentication to restrict access