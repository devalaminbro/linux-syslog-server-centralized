```bash
#!/bin/bash

# ============================================================
# Centralized Syslog Server Auto-Installer
# Author: Sheikh Alamin Santo
# Description: Configures Rsyslog for Remote Logging
# ============================================================

# Color Codes
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${GREEN}[+] Starting Syslog Server Configuration...${NC}"

# 1. Install Rsyslog (Usually pre-installed, but ensuring)
echo -e "${GREEN}[+] Installing Rsyslog...${NC}"
apt-get update -y
apt-get install -y rsyslog

# 2. Configure Rsyslog to Listen on UDP 514
echo -e "${GREEN}[+] Configuring UDP Listener...${NC}"

# Backup original config
cp /etc/rsyslog.conf /etc/rsyslog.conf.bak

# Enable UDP Module
sed -i 's/^#module(load="imudp")/module(load="imudp")/' /etc/rsyslog.conf
sed -i 's/^#input(type="imudp" port="514")/input(type="imudp" port="514")/' /etc/rsyslog.conf

# 3. Create Template for Organizing Logs by IP
echo -e "${GREEN}[+] Creating Remote Log Template...${NC}"

cat > /etc/rsyslog.d/remote-logging.conf <<EOF
# Define a template to store logs in /var/log/remotelogs/IP-ADDRESS/date.log
\$template RemoteLogs,"/var/log/remotelogs/%FROMHOST-IP%/%$YEAR%-%$MONTH%-%$DAY%.log"

# Filter: If traffic comes from remote UDP, use the template
*.* ?RemoteLogs
& ~
EOF

# 4. Create Log Directory & Set Permissions
echo -e "${GREEN}[+] Creating Log Directory...${NC}"
mkdir -p /var/log/remotelogs
chown syslog:syslog /var/log/remotelogs
chmod 755 /var/log/remotelogs

# 5. Open Firewall Port
echo -e "${GREEN}[+] Opening Firewall Port 514/UDP...${NC}"
ufw allow 514/udp
ufw reload

# 6. Restart Service
echo -e "${GREEN}[+] Restarting Rsyslog Service...${NC}"
systemctl restart rsyslog
systemctl enable rsyslog

echo -e "${GREEN}=============================================${NC}"
echo -e "${GREEN}   SYSLOG SERVER IS LISTENING! 👂            ${NC}"
echo -e "${GREEN}=============================================${NC}"
echo -e "Logs will be stored in: /var/log/remotelogs/"
echo -e "Configure your MikroTik/Cisco devices to send logs to this Server IP."
