# 🗂️ Centralized Syslog Server for ISP Compliance

![Linux](https://img.shields.io/badge/OS-Ubuntu%20%7C%20CentOS-orange)
![Service](https://img.shields.io/badge/Service-Rsyslog-blue)
![Compliance](https://img.shields.io/badge/Compliance-Log%20Retention-green)

## 📖 Overview
For Internet Service Providers (ISPs), keeping traffic logs is often a legal requirement. Since MikroTik routers have limited disk space, storing logs locally is impossible.

This repository provides an automated solution to deploy a **Centralized Syslog Server**. It configures `rsyslog` to accept logs from hundreds of network devices (via UDP 514) and organizes them into separate folders based on the device IP.

## 🛠 Features
- 📨 **Central Collection:** Receives logs from MikroTik, Cisco, OLTs, and Linux servers.
- 📂 **Auto-Organization:** Automatically creates a separate log file for each router IP (e.g., `/var/log/remotelogs/192.168.88.1.log`).
- 🔄 **Log Rotation:** Automatically compresses and archives old logs to save disk space.
- 🚦 **Performance:** Tuned to handle high-volume log ingestion.

## ⚙️ How It Works
1.  **Listener:** Opens UDP Port 514 to accept incoming log streams.
2.  **Template:** Uses a dynamic template to parse the sender's IP.
3.  **Storage:** Writes the log entry to the corresponding file on the disk.

## 🚀 Installation Guide

### Step 1: Clone the Repo
```bash
git clone [https://github.com/devalaminbro/linux-syslog-server-centralized.git](https://github.com/devalaminbro/linux-syslog-server-centralized.git)
cd linux-syslog-server-centralized

Step 2: Run the Setup Script
chmod +x setup_syslog.sh
sudo ./setup_syslog.sh

Step 3: Configure MikroTik to Send Logs
Go to your MikroTik Router and run:
/system logging action
add name=syslog remote=192.168.10.50 target=remote  # Replace with Server IP
/system logging
add action=syslog topics=info
add action=syslog topics=warning
add action=syslog topics=critical

⚠️ Disk Space Warning
Logs can grow very fast. Ensure your server has sufficient storage (e.g., 500GB HDD) or mount an external volume to /var/log/remotelogs.

Author: Sheikh Alamin Santo
Cloud Infrastructure Specialist & System Administrator
