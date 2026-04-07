# medasin
cyber-defense-Toolkit-v1.0

A minimalist personal defense suite focused on privacy, anonymity, and real-time threat detection. Medasin is designed as a terminal-like interface that allows the average user to view their digital exposure, detect phishing attempts, protect their identity, and strengthen their security without advanced technical knowledge

Legit defensive security toolkit for paranoid Linux users. Teaches good hygiene while automating common checks. Not enterprise grade but solid for personal use.

🛡️ Features (10 Tools)
1. Exposure check (IP/DNS leaks/VPN/TOR)
2. Anti-phishing URL scanner
3. Ghost mode (TOR+DNS)
4. Network scan (nmap local)
5. Track cleaner
6. Basic IDS (attack detection)
7. Password breach check (HIBP)
8. Password generator
9. AES-256 encryptor 
10. Security dashboard (0-100% score)

### Kali Setup (2 minutes):
# 1. Save and run
```
chmod +x medasin.sh
./medasin.sh
```
# 2. Install missing tools (Kali has most already)
```
sudo apt update && sudo apt install -y jq tor proxychains nmap whois ufw fail2ban
```
# 3. Kali-specific fixes (add these lines after line 300 in tool_03()):
```
echo "nameserver 127.0.0.53" | sudo tee /etc/resolv.conf  # systemd-resolved
```

Kali Commands to paste when script suggests:
# Instead of "sudo pacman -S tor"
```
sudo apt install tor proxychains nmap jq
```
# TOR Browser (Kali bonus)
```
sudo apt install torbrowser-launcher
```

### Run it now:
```bash
git clone https://github.com/vxnkx/medasin.git && cd medasin && chmod +x medasin.sh && ./medasin.sh
```
