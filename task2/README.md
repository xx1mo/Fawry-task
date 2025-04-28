# Network Troubleshooting Task

## Scenario

Your internal web dashboard (hosted on `internal.example.com`) is suddenly unreachable from multiple systems. The service seems up, but users get "host not found" errors. You suspect a DNS or network misconfiguration. Your task is to troubleshoot, verify, and restore connectivity to the internal service.

## Task

### 1. Verify DNS Resolution

**Check current DNS servers:**
```bash
cat /etc/resolv.conf
```

**Test resolution with system DNS:**
```bash
nslookup internal.example.com
dig internal.example.com
```

**Test resolution with Google DNS:**
```bash
nslookup internal.example.com 8.8.8.8
dig @8.8.8.8 internal.example.com
```

### 2. Diagnose Service Reachability

**Get the IP address:**
```bash
IP=$(dig +short internal.example.com | head -n1)
```

**Check if port 80/443 is open:**
```bash
telnet $IP 80
telnet $IP 443
```

**Using modern tools:**
```bash
nc -zv $IP 80
nc -zv $IP 443
```

**Check HTTP response:**
```bash
curl -v http://$IP
curl -vk https://$IP
```

**Verify service is listening locally (if on the server):**
```bash
ss -tulnp | grep ':80\|:443'
netstat -tulnp | grep ':80\|:443'
```

### 3. Possible Causes

#### DNS Layer:
- Incorrect DNS server configuration in `/etc/resolv.conf`
- DNS server outage or unresponsiveness
- Missing or incorrect DNS record for `internal.example.com`
- DNS cache poisoning or incorrect cached entry
- Split DNS configuration mismatch
- DNSSEC validation failure
- DNS firewall blocking queries

#### Network Layer:
- Network connectivity issues between client and DNS server
- Misconfigured firewall blocking DNS (port 53) or HTTP/HTTPS traffic
- Routing issues preventing DNS queries from reaching the server
- VLAN or subnet misconfiguration
- VPN tunnel issues (if accessing remotely)
- MTU size problems causing packet fragmentation

#### Service Layer:
- Web server misconfigured with wrong virtual host
- SSL/TLS certificate issues causing rejection
- Load balancer misconfiguration
- Host-based firewall blocking connections
- Service binding to wrong IP address
- Resource exhaustion preventing new connections

### 4. Proposed Fixes

#### DNS Server Configuration Issue
**Confirm:** Compare resolution between different DNS servers.

**Fix:**
```bash
# Edit resolv.conf (temporary)
sudo nano /etc/resolv.conf
# Add correct nameserver: nameserver 10.0.0.53

# Persistent fix (Debian/Ubuntu)
sudo nano /etc/netplan/50-cloud-init.yaml

# Persistent fix (RHEL/CentOS)
sudo nmcli connection modify eth0 ipv4.dns "10.0.0.53"
sudo nmcli connection up eth0
```

#### Missing DNS Record
**Confirm:** Check with `dig internal.example.com`.

**Fix:** Add the record to your internal DNS server.

#### DNS Cache Issue
**Confirm:** Compare fresh query with cached result.

**Fix:**
```bash
# Flush DNS cache (systemd-resolved)
sudo systemd-resolve --flush-caches

# Flush DNS cache (nscd)
sudo systemctl restart nscd
```

#### Firewall Blocking DNS
**Confirm:** Check firewall rules.
```bash
sudo iptables -L -n -v
sudo nft list ruleset
```

**Fix:**
```bash
# Allow DNS (temporary)
sudo iptables -A INPUT -p udp --dport 53 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 53 -j ACCEPT
```

#### Web Server Virtual Host Misconfiguration
**Confirm:** Check web server logs and configuration.

**Fix:**
```bash
# For Apache
sudo nano /etc/apache2/sites-enabled/internal.example.com.conf

# For Nginx
sudo nano /etc/nginx/conf.d/internal.example.com.conf

# Restart web server
sudo systemctl restart apache2 # or nginx
```

### Bonus Tasks

#### Configure Local /etc/hosts Entry
```bash
echo "192.168.1.100 internal.example.com" | sudo tee -a /etc/hosts

# Verify
ping -c 1 internal.example.com
```

#### Persist DNS Settings with systemd-resolved
```bash
# Edit resolved.conf
sudo nano /etc/systemd/resolved.conf

# Set:
DNS=10.0.0.53 8.8.8.8
Domains=example.com

# Restart service
sudo systemctl restart systemd-resolved

# Verify
systemd-resolve --status
```

#### Persist DNS Settings with NetworkManager
```bash
# For a specific connection
sudo nmcli connection modify "Wired Connection 1" ipv4.dns "10.0.0.53"
sudo nmcli connection up "Wired Connection 1"

# Verify
nmcli device show eth0 | grep DNS

