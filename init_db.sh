import sqlite3

conn = sqlite3.connect('known_hosts.db')
c = conn.cursor()

c.execute('''
CREATE TABLE IF NOT EXISTS known_hosts (
    mac TEXT PRIMARY KEY,
    ip TEXT,
    hostname TEXT,
    vendor TEXT,
    os TEXT,
    notes TEXT
)
''')

conn.commit()
conn.close()
print("[✓] known_hosts table created or verified.")
