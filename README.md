UbuntuWebServer - Flask Network Scanner

A modern, lightweight network device scanner built with Flask and Python. This dashboard detects all devices on your local network, identifies them by MAC/IP/hostname/vendor, optionally detects OS, and offers admin-editable notes for known devices.

=====================================

✅ Project Goal

Create a web-based dashboard on your Ubuntu server (or Proxmox VM) that:

- Scans the network for connected devices (IP, MAC, hostname, vendor, OS)
- Logs and displays results in a web UI
- Allows tagging/notes for known hosts
- Optionally alerts on new/unknown devices
- Runs continuously with auto-refresh and deep scan automation

=====================================

🛠 Tools & Technologies

Task                | Tool                        
--------------------|-----------------------------
Web Server          | Apache2 (optional) / Flask
Backend             | Python (Flask)
Network Scanning    | nmap, mac-vendor-lookup
Frontend            | HTML/CSS/JS (Bootstrap)
Storage             | SQLite
Scheduling          | cron
Startup Automation  | systemd

=====================================

🧱 Architecture

[Ubuntu Server / Proxmox VM]
         |
   [Flask App - app.py]
         |
 [Nmap Scans + Deep Scan (cron)]
         |
 [SQLite Database + MAC Vendor DB]
         |
 [Bootstrap Web UI w/ Auto Refresh]

=====================================

🧪 Installation Instructions

1. Clone and Setup
------------------
git clone https://github.com/yourusername/UbuntuWebServer.git
cd UbuntuWebServer
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

2. Install Dependencies
-----------------------
sudo apt update
sudo apt install nmap sqlite3 -y

3. Initialize the Database
--------------------------
bash init_db.sh

4. Start the Flask App
----------------------
bash run_flask.sh

Then visit: http://<server-ip>:5000

=====================================

🔁 Sync & Restart from GitHub

bash sync_from_github.sh

This will:
- Pull the latest code
- Ensure sqlite3 is installed
- Initialize the DB if needed
- Restart the Flask app

=====================================

🔂 Automate Deep OS Scan

bash install_cron.sh

This sets up a cron job to run every 30 minutes:
*/30 * * * * /usr/bin/python3 /home/tim2/UbuntuWebServer/deep_scan.py

=====================================

🚀 Enable on Boot (systemd)

sudo cp flaskscanner.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable flaskscanner
sudo systemctl start flaskscanner

=====================================

🧾 Add/Edit Known Hosts

python insert_known_host.py

This will prompt for:
- MAC
- IP
- Hostname
- Vendor
- OS
- Notes

=====================================

📁 Project Layout

File                    | Purpose
------------------------|----------------------------------------------
app.py                  | Flask app, runs network scan
deep_scan.py            | OS detection, cron-based
insert_known_host.py    | CLI insert for known host DB
templates/              | HTML UI (scan_results.html)
known_hosts.db          | SQLite DB for persistent host info
sync_to_github.sh       | Push code from Ubuntu → GitHub
sync_from_github.sh     | Pull updates from GitHub and restart
init_db.sh              | Creates the known_hosts table
flask.log, app_errors.log | Log files

=====================================

🌐 Web UI Features

- Auto-refresh every 15s
- Manual refresh button
- Search/filter box (IP, MAC, Vendor, Hostname)
- Color badges by vendor
- OS info from deep scans
- Notes from DB
- Responsive Bootstrap layout

=====================================

🩺 Troubleshooting

- Ensure nmap is installed: sudo apt install nmap
- If port 5000 fails, run: lsof -i :5000
- Run with debug=True in development
- For Windows compatibility, use WSL or Python 3.10+

=====================================

⚠️ Security Notice

This tool is for use on trusted private networks only.
There is no authentication or encryption by default.
Do not expose to the public internet.

=====================================

📸 Screenshots

(Add a screenshot named dashboard_screenshot.png in /static/)

=====================================

📄 License

MIT License

=====================================

🙋‍♂️ Author

Timothy Johnson II
Hosted PBX Engineer, 123NET
GitHub: https://github.com/tjohnsonII