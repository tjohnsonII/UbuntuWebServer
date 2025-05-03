import sqlite3
import os

db_path = os.path.expanduser("~/UbuntuWebServer/known_hosts.db")

conn = sqlite3.connect(db_path)
c = conn.cursor()

c.execute("""
CREATE TABLE IF NOT EXISTS known_hosts (
    mac TEXT PRIMARY KEY,
    ip TEXT,
    hostname TEXT,
    vendor TEXT,
    os TEXT,
    notes TEXT
)
""")

conn.commit()
conn.close()

print("[✓] known_hosts.db initialized successfully.")
