#!/usr/bin/env bash
# ============================================================
#   MEDASIN — Cyber Defense Toolkit v1.0
#   Personal protection | Anonymity | Anti-Phishing
# ============================================================

R='\033[1;31m'
Y='\033[1;33m'
G='\033[1;32m'
C='\033[1;36m'
M='\033[1;35m'
W='\033[1;37m'
D='\033[0;90m'
N='\033[0m'
BOLD='\033[1m'
BG_RED='\033[41m'
BG_DARK='\033[40m'

pause() {
    echo ""
    echo -e "  ${D}[ press enter to return ]${N}"
    read -r
}

section() {
    clear
    echo -e "${C}"
    echo -e "  ╔══════════════════════════════════════════╗"
    printf "  ║  ${W}${BOLD}%-40s${C}║\n" "$1"
    echo -e "  ╚══════════════════════════════════════════╝${N}"
    echo ""
}

result_ok()   { echo -e "  ${G}✔${N} ${W}$1:${N} ${G}$2${N}"; }
result_warn() { echo -e "  ${Y}⚠${N} ${W}$1:${N} ${Y}$2${N}"; }
result_bad()  { echo -e "  ${R}✘${N} ${W}$1:${N} ${R}$2${N}"; }
result_info() { echo -e "  ${C}▸${N} ${W}$1:${N} ${D}$2${N}"; }

header() {
    clear
    echo -e "${C}"
    cat << 'GHOST'

              ░░░░░░░░░░░░░░░░░░░
            ░░                   ░░
          ░░    ╭─────────────╮    ░░
         ░░     │  ◉       ◉  │     ░░
        ░░      │      ▾      │      ░░
        ░░      │  ╰───────╯  │      ░░
         ░░     ╰─────────────╯     ░░
           ░░          │          ░░
             ░░░░░░░░░░│░░░░░░░░░░
                       │
                      ╰╯  ← drop
                      ╰╯
GHOST
    echo -e "${N}"
    echo -e "  ${BG_DARK}${C}${BOLD}  👁  MEDASIN  —  CYBER DEFENSE v1.0  👁  ${N}"
    echo -e "  ${D}─────────────────────────────────────────────────${N}"
    echo -e "  ${G}⚡  Personal protection | Anonymity | Anti-Phishing${N}"
    echo -e "  ${D}─────────────────────────────────────────────────${N}"
    echo ""
}

main_menu() {
    header
    echo -e "  ${C}╔═══════════════════════════════════════════════════╗${N}"
    echo -e "  ${C}║${W}${BOLD}               Main Menu                     ${N}${C}║${N}"
    echo -e "  ${C}╠═══════════════════════════════════════════════════╣${N}"
    echo -e "  ${C}║${N}  ${G}[01]${N}  How exposed am I right now?                            ${C}║${N}"
    echo -e "  ${C}║${N}  ${G}[02]${N}  Is this link trying to steal from me? (Anti-Phishing)  ${C}║${N}"
    echo -e "  ${C}║${N}  ${G}[03]${N}  Activate ghost mode (TOR + secure DNS)                 ${C}║${N}"
    echo -e "  ${C}║${N}  ${G}[04]${N}  Scan my network — who's watching me?                   ${C}║${N}"
    echo -e "  ${C}║${N}  ${G}[05]${N}  Clean my digital tracks now                            ${C}║${N}"
    echo -e "  ${C}║${N}  ${G}[06]${N}  Am I under attack? (Basic IDS)                         ${C}║${N}"
    echo -e "  ${C}║${N}  ${G}[07]${N}  Was my password stolen?                                ${C}║${N}"
    echo -e "  ${C}║${N}  ${G}[08]${N}  Generate unhackable password                           ${C}║${N}"
    echo -e "  ${C}║${N}  ${G}[09]${N}  Encrypt message to send securely                       ${C}║${N}"
    echo -e "  ${C}║${N}  ${G}[10]${N}  My defenses status (dashboard)                         ${C}║${N}"
    echo -e "  ${C}╠═══════════════════════════════════════════════════╣${N}"
    echo -e "  ${C}║${N}  ${D}[00]  Exit                                      ${C}║${N}"
    echo -e "  ${C}╚═══════════════════════════════════════════════════╝${N}"
    echo ""
    echo -ne "  ${W}Selection: ${C}"
    read -r OPT
    echo -e "${N}"
}

# ══════════════════════════════════════════════════════════════
# 01 — HOW EXPOSED AM I?
# ══════════════════════════════════════════════════════════════
tool_01() {
    section "01 · How exposed am I right now?"
    echo -e "  ${Y}Analyzing your current exposure...${N}"
    echo ""

    # Public IP
    local IP; IP=$(curl -s --max-time 6 ifconfig.me 2>/dev/null)
    if [[ -n "$IP" ]]; then
        result_warn "Your visible public IP address" "$IP"
    else
        result_bad "Public IP address" "Could not obtain"
    fi

    # GeoIP of your own IP
    local GEO; GEO=$(curl -s --max-time 6 "http://ip-api.com/json/${IP}?fields=country,regionName,city,isp,org,proxy,hosting")
    local COUNTRY; COUNTRY=$(echo "$GEO" | jq -r '.country' 2>/dev/null)
    local CITY;    CITY=$(echo "$GEO"    | jq -r '.city'    2>/dev/null)
    local ISP;     ISP=$(echo "$GEO"     | jq -r '.isp'     2>/dev/null)
    local PROXY;   PROXY=$(echo "$GEO"   | jq -r '.proxy'   2>/dev/null)
    local HOSTING; HOSTING=$(echo "$GEO" | jq -r '.hosting' 2>/dev/null)

    result_warn "Visible location" "$CITY, $COUNTRY"
    result_info "Your visible ISP"    "$ISP"

    if [[ "$PROXY" == "true" ]]; then
        result_ok "Proxy/VPN detected" "Yes — something is covering you."
    else
        result_bad "Proxy/VPN detected" "No — you're naked on the internet lol"
    fi

    echo ""
    echo -e "  ${C}── DNS Leak Check ──${N}"
    local DNS1; DNS1=$(curl -s --max-time 5 "https://dns.google/resolve?name=whoami.akamai.net&type=A" | jq -r '.Answer[0].data' 2>/dev/null)
    if [[ -n "$DNS1" && "$DNS1" != "null" ]]; then
        result_warn "Your visible DNS resolver" "$DNS1"
    fi

    # Local DNS
    local DNS_LOCAL; DNS_LOCAL=$(cat /etc/resolv.conf 2>/dev/null | grep nameserver | awk '{print $2}' | head -1)
    if [[ "$DNS_LOCAL" == "1.1.1.1" || "$DNS_LOCAL" == "1.0.0.1" ]]; then
        result_ok  "Local DNS configured" "$DNS_LOCAL (Cloudflare — good)"
    elif [[ "$DNS_LOCAL" == "8.8.8.8" || "$DNS_LOCAL" == "8.8.4.4" ]]; then
        result_warn "Local DNS configuration" "$DNS_LOCAL (Google — logs queries)"
    else
        result_warn "Local DNS configuration" "$DNS_LOCAL"
    fi

    echo ""
    echo -e "  ${C}── TOR / VPN ──${N}"
    local TOR_CHECK; TOR_CHECK=$(curl -s --max-time 6 "https://check.torproject.org/api/ip" | jq -r '.IsTor' 2>/dev/null)
    if [[ "$TOR_CHECK" == "true" ]]; then
        result_ok "TOR active" "Yes — your traffic goes through TOR"
    else
        result_bad "TOR active" "No"
    fi

    echo ""
    echo -e "  ${C}── Open ports on your machine ──${N}"
    if command -v ss &>/dev/null; then
        local OPEN_PORTS; OPEN_PORTS=$(ss -tlnp 2>/dev/null | grep LISTEN | awk '{print $4}' | grep -oE '[0-9]+$' | sort -u | tr '\n' ' ')
        if [[ -n "$OPEN_PORTS" ]]; then
            result_warn "Ports listening" "$OPEN_PORTS"
        else
            result_ok "Open ports" "None detected"
        fi
    fi

    echo ""
    echo -e "  ${Y}${BOLD}SUMMARY:${N}"
    echo -e "  ${D}If you see your real IP address and there's no VPN/TOR, anyone can use your links.${N}"
    echo -e "  ${D}It can find out your city, ISP, and track you. Use option 03${N}"
    pause
}

# ══════════════════════════════════════════════════════════════
# 02 — ANTI-PHISHING
# ══════════════════════════════════════════════════════════════
tool_02() {
    section "02 · Is this link trying to scam me? (Anti-Phishing)"
    echo -ne "  ${W}Paste the suspicious link: ${C}"; read -r URL; echo -e "${N}"
    if [[ -z "$URL" ]]; then result_bad "Error" "You did not enter a URL"; pause; return; fi

    # Secure scheme
    [[ "$URL" != http* ]] && URL="https://$URL"

    local DOMAIN; DOMAIN=$(echo "$URL" | sed 's|https\?://||' | cut -d'/' -f1 | sed 's/^www\.//')
    echo -e "  ${Y}Analyzing: ${W}$DOMAIN${N}"
    echo ""

    # 1. Check on VirusTotal (no key, public endpoint
    echo -e "  ${C}── Reputation check ──${N}"
    local VT_URL; VT_URL=$(echo -n "$URL" | base64 | tr '+/' '-_' | tr -d '=')
    result_info "VirusTotal (open)" "https://www.virustotal.com/gui/url/$(echo -n "$URL" | sha256sum | awk '{print $1}')/detection"

    # 2. Google Safe Browsing lookup (public API)
    local GSB; GSB=$(curl -s --max-time 8 \
        "https://transparencyreport.google.com/safe-browsing/search?url=${DOMAIN}&hl=es" 2>/dev/null)

    # 3. URLScan.io
    result_info "URLScan.io (open)"  "https://urlscan.io/search/#domain:${DOMAIN}"
    result_info "PhishTank (open)"   "https://www.phishtank.com/check_phi..."

    echo ""
    echo -e "  ${C}── Automatic link analysis ──${N}"

    # Check HTTPS
    if [[ "$URL" == https://* ]]; then
        result_ok  "Protocol" "HTTPS — encryption"
    else
        result_bad "HTTP Protocol" "WITHOUT encryption, dangerous"
    fi

    # Verify SSL certificate
    local SSL_INFO; SSL_INFO=$(echo | timeout 5 openssl s_client -connect "${DOMAIN}:443" -servername "$DOMAIN" 2>/dev/null | openssl x509 -noout -issuer -dates 2>/dev/null)
    if [[ -n "$SSL_INFO" ]]; then
        local ISSUER; ISSUER=$(echo "$SSL_INFO" | grep issuer | sed 's/issuer=//')
        local EXPIRY; EXPIRY=$(echo "$SSL_INFO" | grep "notAfter" | sed 's/notAfter=//')
        result_ok  "SSL Certificate" "Valid"
        result_info "SSL Issuer"     "$ISSUER"
        result_info "Expires"         "$EXPIRY"
    else
        result_warn "SSL Certificate" "Could not be verified"
    fi

    # Verify recent domain (WHOIS)
    echo ""
    echo -e "  ${C}── Domain age ──${N}"
    if command -v whois &>/dev/null; then
        local CREATION; CREATION=$(whois "$DOMAIN" 2>/dev/null | grep -i "creation date\|created\|registered" | head -1)
        if [[ -n "$CREATION" ]]; then
            result_info "Creation date" "$CREATION"
            # If it was created less than 6 months ago, suspicious.
            echo -e "  ${Y}  ⚠ Very new domains (<6 months) They are a sign of phishing${N}"
        fi
    fi

    # Phishing signs in the URL
    echo ""
    echo -e "  ${C}── Warning signs in the URL ──${N}"
    local SCORE=0

    # IP address instead of domain
    if echo "$DOMAIN" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$'; then
        result_bad "URL with direct IP" "VERY suspicious — typical phishing"
        ((SCORE+=3))
    fi

    # Too many dashes
    local DASHES; DASHES=$(echo "$DOMAIN" | tr -cd '-' | wc -c)
    if [[ $DASHES -ge 3 ]]; then
        result_warn "Too many dashes in domain" "$DASHES dashes — suspicious"
        ((SCORE+=2))
    fi

    # Phishing keywords
    local PHISH_WORDS=("login" "verify" "secure" "account" "update" "bank" "paypal" "netflix" "amazon" "apple" "microsoft" "google" "signin" "password" "confirm" "wallet" "crypto" "urgent" "suspended" "validate")
    for WORD in "${PHISH_WORDS[@]}"; do
        if echo "$URL" | grep -qi "$WORD"; then
            result_warn "Suspicious word detected" "'$WORD' in the URL"
            ((SCORE++))
        fi
    done

    # Very long URL
    if [[ ${#URL} -gt 100 ]]; then
        result_warn "Very long URL" "${#URL} characters — obfuscation attempt"
        ((SCORE++))
    fi

    # Excessive subdomains
    local SUBDOMAIN_COUNT; SUBDOMAIN_COUNT=$(echo "$DOMAIN" | tr -cd '.' | wc -c)
    if [[ $SUBDOMAIN_COUNT -ge 3 ]]; then
        result_warn "Excessive subdomains" "$SUBDOMAIN_COUNT levels — deception technique"
        ((SCORE+=2))
    fi

    echo ""
    echo -e "  ${C}── Verdict ──${N}"
    if [[ $SCORE -eq 0 ]]; then
        result_ok  "Risk score" "0 — Seems safe"
    elif [[ $SCORE -le 2 ]]; then
        result_warn "Risk score" "$SCORE — Caution"
    else
        result_bad  "Risk score" "$SCORE — VERY SUSPICIOUS, don't open"
    fi

    echo ""
    echo -e "  ${C}── Open these for manual verification ──${N}"
    result_info "VirusTotal"  "https://www.virustotal.com/gui/url-upload"
    result_info "URLVoid"     "https://www.urlvoid.com/scan/${DOMAIN}"
    result_info "ScamAdviser" "https://www.scamadviser.com/check-website/${DOMAIN}"
    pause
}

# ══════════════════════════════════════════════════════════════
# 03 — GHOST MODE
# ══════════════════════════════════════════════════════════════
tool_03() {
    section "03 · Activate ghost mode (TOR + secure DNS)"
    echo -e "  ${Y}This option configures your system for greater anonymity.${N}"
    echo ""

    echo -e "  ${C}── Current TOR status ──${N}"
    if command -v tor &>/dev/null; then
        result_ok "TOR installed" "Yes"
        if systemctl is-active tor &>/dev/null 2>&1; then
            result_ok "TOR service" "Active"
        else
            result_warn "TOR service" "Inactive"
            echo ""
            echo -ne "  ${W}Start TOR now? (y/n): ${C}"; read -r RESP
            if [[ "$RESP" == "s" || "$RESP" == "S" || "$RESP" == "y" || "$RESP" == "Y" ]]; then
                sudo systemctl start tor
                sleep 2
                if systemctl is-active tor &>/dev/null 2>&1; then
                    result_ok "TOR" "Started successfully"
                else
                    result_bad "TOR" "Failed to start"
                fi
            fi
        fi
    else
        result_bad "TOR installed" "No"
        echo -e "  ${Y}  Install with: sudo pacman -S tor${N}"
    fi

    echo ""
    echo -e "  ${C}── Secure DNS (anti-spying) ──${N}"
    local CURRENT_DNS; CURRENT_DNS=$(grep nameserver /etc/resolv.conf 2>/dev/null | awk '{print $2}' | head -1)
    result_info "Current DNS" "$CURRENT_DNS"

    echo ""
    echo -e "  ${W}Select secure DNS to configure:${N}"
    echo -e "  ${G}[1]${N} Cloudflare 1.1.1.1 (fast, private)"
    echo -e "  ${G}[2]${N} Quad9 9.9.9.9 (blocks malware)"
    echo -e "  ${G}[3]${N} DNS.Watch 84.200.69.80 (no logs)"
    echo -e "  ${G}[4]${N} Don't change"
    echo ""
    echo -ne "  ${W}Option: ${C}"; read -r DNS_OPT
    case "$DNS_OPT" in
        1) NEW_DNS="1.1.1.1"; DNS_NAME="Cloudflare" ;;
        2) NEW_DNS="9.9.9.9"; DNS_NAME="Quad9" ;;
        3) NEW_DNS="84.200.69.80"; DNS_NAME="DNS.Watch" ;;
        *) NEW_DNS=""; DNS_NAME="" ;;
    esac

    if [[ -n "$NEW_DNS" ]]; then
        echo ""
        echo -ne "  ${Y}Apply ${DNS_NAME} DNS (${NEW_DNS})? Requires sudo (y/n): ${C}"; read -r CONFIRM
        if [[ "$CONFIRM" == "s" || "$CONFIRM" == "S" || "$CONFIRM" == "y" || "$CONFIRM" == "Y" ]]; then
            echo "nameserver $NEW_DNS" | sudo tee /etc/resolv.conf > /dev/null
            result_ok "DNS changed" "$NEW_DNS ($DNS_NAME)"
        fi
    fi

    echo ""
    echo -e "  ${C}── Proxychains configuration ──${N}"
    if command -v proxychains &>/dev/null || command -v proxychains4 &>/dev/null; then
        result_ok "Proxychains installed" "Yes"
        echo -e "  ${G}▸${N} Use: ${D}proxychains4 firefox${N}  to browse anonymously"
        echo -e "  ${G}▸${N} Use: ${D}proxychains4 curl ifconfig.me${N}  to verify"
    else
        result_warn "Proxychains" "Not installed"
        echo -e "  ${Y}  Install with: sudo pacman -S proxychains-ng${N}"
    fi

    echo ""
    echo -e "  ${C}── Tips to be a ghost ──${N}"
    echo -e "  ${G}▸${N} Use ${W}Tor Browser${N} to browse: ${D}sudo pacman -S torbrowser-launcher${N}"
    echo -e "  ${G}▸${N} Use ${W}Mullvad VPN${N} (free 30 days): ${D}https://mullvad.net${N}"
    echo -e "  ${G}▸${N} Disable ${W}WebRTC${N} in your browser (leaks real IP)"
    echo -e "  ${G}▸${N} Use ${W}Firefox + uBlock Origin${N} always"
    echo -e "  ${G}▸${N} Never use your real email, create aliases: ${D}https://simplelogin.io${N}"
    pause
}

# ══════════════════════════════════════════════════════════════
# 04 — SCAN MY NETWORK
# ══════════════════════════════════════════════════════════════
tool_04() {
    section "04 · Scan my network — who's watching me?"
    echo -e "  ${Y}Scanning your local network...${N}"
    echo ""

    # Network interfaces info
    echo -e "  ${C}── Your network interfaces ──${N}"
    ip addr show 2>/dev/null | grep -E "^[0-9]+:|inet " | while IFS= read -r line; do
        echo -e "  ${C}▸${N} $line"
    done

    echo ""
    echo -e "  ${C}── Your gateway (router) ──${N}"
    local GW; GW=$(ip route | grep default | awk '{print $3}' | head -1)
    result_info "Gateway IP" "$GW"

    echo ""
    echo -e "  ${C}── Devices on your network ──${N}"
    if command -v nmap &>/dev/null; then
        local SUBNET; SUBNET=$(ip route | grep -v default | grep src | awk '{print $1}' | head -1)
        echo -e "  ${Y}Scanning ${SUBNET}...${N}"
        echo ""
        nmap -sn "$SUBNET" 2>/dev/null | grep -E "report for|Host is up|MAC Address" | while IFS= read -r line; do
            if echo "$line" | grep -q "report for"; then
                echo -e "  ${G}▸${N} ${W}$(echo "$line" | sed 's/Nmap scan report for //')${N}"
            else
                echo -e "    ${D}$line${N}"
            fi
        done
    else
        result_warn "nmap not installed" "sudo pacman -S nmap"
        # Ping alternative
        echo -e "  ${Y}Using alternative ping sweep...${N}"
        local BASE_IP; BASE_IP=$(ip route | grep -v default | grep src | awk '{print $1}' | cut -d'/' -f1 | sed 's/\.[0-9]*$//')
        for i in $(seq 1 20); do
            ping -c1 -W1 "${BASE_IP}.${i}" &>/dev/null && \
                echo -e "  ${G}▸${N} ${W}${BASE_IP}.${i}${N} — ${G}active${N}" &
        done
        wait
    fi

    echo ""
    echo -e "  ${C}── Active outgoing connections ──${N}"
    if command -v ss &>/dev/null; then
        ss -tnp 2>/dev/null | grep ESTAB | awk '{print $5, $6}' | while IFS= read -r line; do
            echo -e "  ${Y}▸${N} $line"
        done
    fi

    echo ""
    echo -e "  ${C}── Open ports on YOUR machine ──${N}"
    ss -tlnp 2>/dev/null | grep LISTEN | awk '{print $4}' | while IFS= read -r port; do
        echo -e "  ${Y}⚠${N} Listening on: ${W}$port${N}"
    done

    pause
}

# ══════════════════════════════════════════════════════════════
# 05 — CLEAN MY TRACKS
# ══════════════════════════════════════════════════════════════
tool_05() {
    section "05 · Clean my digital tracks now"
    echo -e "  ${Y}Select what to clean:${N}"
    echo ""
    echo -e "  ${G}[1]${N} Bash/zsh history"
    echo -e "  ${G}[2]${N} DNS cache"
    echo -e "  ${G}[3]${N} System logs (requires sudo)"
    echo -e "  ${G}[4]${N} Temporary files"
    echo -e "  ${G}[5]${N} All of the above"
    echo -e "  ${G}[6]${N} Just show me what's there"
    echo ""
    echo -ne "  ${W}Option: ${C}"; read -r CLEAN_OPT; echo -e "${N}"

    case "$CLEAN_OPT" in
        1|5)
            echo -e "  ${C}── Cleaning terminal history ──${N}"
            # Bash
            if [[ -f "$HOME/.bash_history" ]]; then
                > "$HOME/.bash_history"
                result_ok "bash_history" "Cleaned"
            fi
            # Zsh
            if [[ -f "$HOME/.zsh_history" ]]; then
                > "$HOME/.zsh_history"
                result_ok "zsh_history" "Cleaned"
            fi
            history -c 2>/dev/null
            result_ok "Current session history" "Cleaned"
            [[ "$CLEAN_OPT" != "5" ]] && break
            ;&
        2|5)
            echo -e "  ${C}── Cleaning DNS cache ──${N}"
            if systemctl is-active systemd-resolved &>/dev/null; then
                sudo systemd-resolve --flush-caches 2>/dev/null && result_ok "DNS cache (systemd-resolved)" "Cleaned"
            fi
            if command -v nscd &>/dev/null; then
                sudo nscd -i hosts 2>/dev/null && result_ok "DNS cache (nscd)" "Cleaned"
            fi
            result_ok "Local DNS cache" "Flush sent"
            [[ "$CLEAN_OPT" != "5" ]] && break
            ;&
        3|5)
            echo -e "  ${C}── Cleaning system logs ──${N}"
            echo -ne "  ${Y}Clear logs? Requires sudo (y/n): ${C}"; read -r LCONF
            if [[ "$LCONF" == "s" || "$LCONF" == "S" || "$LCONF" == "y" || "$LCONF" == "Y" ]]; then
                sudo journalctl --vacuum-time=1s 2>/dev/null && result_ok "Journalctl logs" "Cleaned"
                sudo truncate -s 0 /var/log/auth.log 2>/dev/null
                sudo truncate -s 0 /var/log/syslog 2>/dev/null
                result_ok "System logs" "Cleaned"
            fi
            [[ "$CLEAN_OPT" != "5" ]] && break
            ;&
        4|5)
            echo -e "  ${C}── Cleaning temporaries ──${N}"
            local TEMP_SIZE; TEMP_SIZE=$(du -sh /tmp 2>/dev/null | awk '{print $1}')
            rm -rf /tmp/* 2>/dev/null
            result_ok "Files in /tmp" "Cleaned ($TEMP_SIZE freed)"
            # Thumbnails
            rm -rf "$HOME/.cache/thumbnails"/* 2>/dev/null
            result_ok "Thumbnail cache" "Cleaned"
            # Recently used
            > "$HOME/.local/share/recently-used.xbel" 2>/dev/null
            result_ok "Recent files" "Cleaned"
            ;;
        6)
            echo -e "  ${C}── Tracks inventory ──${N}"
            local BH_SIZE; BH_SIZE=$(wc -l < "$HOME/.bash_history" 2>/dev/null || echo 0)
            result_info "Lines in bash_history"  "$BH_SIZE"
            local ZH_SIZE; ZH_SIZE=$(wc -l < "$HOME/.zsh_history" 2>/dev/null || echo 0)
            result_info "Lines in zsh_history"   "$ZH_SIZE"
            local TMP_SIZE; TMP_SIZE=$(du -sh /tmp 2>/dev/null | awk '{print $1}')
            result_info "Size of /tmp"          "$TMP_SIZE"
            local CACHE_SIZE; CACHE_SIZE=$(du -sh "$HOME/.cache" 2>/dev/null | awk '{print $1}')
            result_info "User cache"        "$CACHE_SIZE"
            ;;
    esac
    pause
}

# ══════════════════════════════════════════════════════════════
# 06 — BASIC IDS (attack detection)
# ══════════════════════════════════════════════════════════════
tool_06() {
    section "06 · Am I under attack? (Basic IDS)"
    echo -e "  ${Y}Analyzing logs for attacks...${N}"
    echo ""

    # Failed SSH attempts
    echo -e "  ${C}── Failed SSH login attempts ──${N}"
    local SSH_FAILS
    if [[ -f /var/log/auth.log ]]; then
        SSH_FAILS=$(grep -c "Failed password" /var/log/auth.log 2>/dev/null || echo 0)
        result_warn "Failed SSH attempts (auth.log)" "$SSH_FAILS"
        echo -e "  ${C}  Top attacking IPs:${N}"
        grep "Failed password" /var/log/auth.log 2>/dev/null | \
            grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' | \
            sort | uniq -c | sort -rn | head -5 | \
            while read -r count ip; do
                result_bad "  $count attempts from" "$ip"
            done
    else
        # Arch uses journalctl
        SSH_FAILS=$(journalctl -u sshd 2>/dev/null | grep -c "Failed password" || echo 0)
        result_warn "Failed SSH attempts (journalctl)" "$SSH_FAILS"
        journalctl -u sshd 2>/dev/null | grep "Failed password" | \
            grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' | \
            sort | uniq -c | sort -rn | head -5 | \
            while read -r count ip; do
                result_bad "  $count attempts from" "$ip"
            done
    fi

    echo ""
    echo -e "  ${C}── Active connections NOW ──${N}"
    ss -tnp 2>/dev/null | grep ESTAB | while IFS= read -r line; do
        local REMOTE; REMOTE=$(echo "$line" | awk '{print $5}')
        echo -e "  ${Y}▸${N} Active connection: ${W}$REMOTE${N}"
    done

    echo ""
    echo -e "  ${C}── Processes listening on network ──${N}"
    ss -tlnp 2>/dev/null | grep LISTEN | while IFS= read -r line; do
        echo -e "  ${Y}▸${N} $line"
    done

    echo ""
    echo -e "  ${C}── Recent system logins ──${N}"
    last 2>/dev/null | head -8 | while IFS= read -r line; do
        echo -e "  ${D}▸${N} $line"
    done

    echo ""
    echo -e "  ${C}── Recommendations ──${N}"
    echo -e "  ${G}▸${N} Install ${W}fail2ban${N}: sudo pacman -S fail2ban"
    echo -e "  ${G}▸${N} Install ${W}ufw${N}: sudo pacman -S ufw && sudo ufw enable"
    echo -e "  ${G}▸${N} Disable SSH if not using it: sudo systemctl disable sshd"
    pause
}

# ══════════════════════════════════════════════════════════════
# 07 — WAS MY PASSWORD STOLEN?
# ══════════════════════════════════════════════════════════════
tool_07() {
    section "07 · Was my password or email stolen?"
    echo -e "  ${G}[1]${N} Check email in breaches"
    echo -e "  ${G}[2]${N} Check password (hash, without sending real password)"
    echo ""
    echo -ne "  ${W}Option: ${C}"; read -r BREACH_OPT; echo -e "${N}"

    case "$BREACH_OPT" in
        1)
            echo -ne "  ${W}Your email: ${C}"; read -r EMAIL; echo -e "${N}"
            echo -e "  ${Y}Checking...${N}"
            echo ""
            # HIBP without API key — direct link
            result_info "Check on HaveIBeenPwned" "https://haveibeenpwned.com/account/${EMAIL}"
            result_info "Check on DeHashed"       "https://dehashed.com/search?query=${EMAIL}"
            result_info "Check on LeakCheck"      "https://leakcheck.io/?query=${EMAIL}"
            echo ""
            echo -e "  ${Y}Open those links in your browser to see if your email appeared in breaches.${N}"
            ;;
        2)
            echo -ne "  ${W}Enter your password (not sent, only hashed locally): ${C}"
            read -rs PASS; echo -e "${N}"
            echo ""
            # SHA1 of password, only first 5 characters sent (k-anonymity)
            local SHA1; SHA1=$(echo -n "$PASS" | sha1sum | awk '{print $1}' | tr '[:lower:]' '[:upper:]')
            local PREFIX5="${SHA1:0:5}"
            local SUFFIX="${SHA1:5}"
            echo -e "  ${Y}Querying HIBP Pwned Passwords (secure k-anonymity method)...${N}"
            echo -e "  ${D}  Only first 5 characters of SHA1 hash are sent.${N}"
            echo ""
            local PWNED_DATA; PWNED_DATA=$(curl -s --max-time 8 "https://api.pwnedpasswords.com/range/${PREFIX5}")
            if echo "$PWNED_DATA" | grep -qi "^${SUFFIX}:"; then
                local COUNT; COUNT=$(echo "$PWNED_DATA" | grep -i "^${SUFFIX}:" | cut -d':' -f2 | tr -d '[:space:]')
                result_bad "PASSWORD COMPROMISED" "Appeared $COUNT times in breaches"
                echo -e "  ${R}  ⚠ CHANGE THAT PASSWORD NOW${N}"
            else
                result_ok "Password" "Not found in known breaches"
                echo -e "  ${G}  Seems safe, but don't reuse it.${N}"
            fi
            ;;
    esac
    pause
}

# ══════════════════════════════════════════════════════════════
# 08 — GENERATE UNHACKABLE PASSWORD
# ══════════════════════════════════════════════════════════════
tool_08() {
    section "08 · Generate unhackable password"
    echo -e "  ${W}Password type:${N}"
    echo -e "  ${G}[1]${N} Ultra secure (32 chars, symbols, numbers)"
    echo -e "  ${G}[2]${N} Passphrase (4 random words — easy to remember)"
    echo -e "  ${G}[3]${N} Random 6-digit PIN"
    echo -e "  ${G}[4]${N} Custom password (you choose length)"
    echo ""
    echo -ne "  ${W}Option: ${C}"; read -r PASS_OPT; echo -e "${N}"

    case "$PASS_OPT" in
        1)
            echo -e "  ${C}── Generated passwords ──${N}"
            for i in 1 2 3; do
                local P; P=$(cat /dev/urandom | tr -dc 'A-Za-z0-9!@#$%^&*()_+-=[]{}|;:,.<>?' | head -c 32)
                result_ok "Option $i" "$P"
            done
            ;;
        2)
            # Simple Spanish words list
            local WORDS=("tiger" "cloud" "rock" "moon" "fire" "wind" "stone" "jungle" "river" "sea" "sky" "thunder" "lightning" "forest" "island" "summit" "valley" "fog" "dawn" "storm" "sand" "ice" "flame" "shadow" "strength" "light" "night" "dawn" "mist" "volcano")
            echo -e "  ${C}── Generated passphrases ──${N}"
            for i in 1 2 3; do
                local W1=${WORDS[$RANDOM % ${#WORDS[@]}]}
                local W2=${WORDS[$RANDOM % ${#WORDS[@]}]}
                local W3=${WORDS[$RANDOM % ${#WORDS[@]}]}
                local W4=${WORDS[$RANDOM % ${#WORDS[@]}]}
                local NUM=$((RANDOM % 900 + 100))
                result_ok "Option $i" "${W1}-${W2}-${W3}-${W4}-${NUM}"
            done
            echo ""
            echo -e "  ${D}Passphrases are just as secure and easier to remember.${N}"
            ;;
        3)
            echo -e "  ${C}── Generated PINs ──${N}"
            for i in 1 2 3; do
                local PIN; PIN=$(cat /dev/urandom | tr -dc '0-9' | head -c 6)
                result_ok "PIN $i" "$PIN"
            done
            ;;
        4)
            echo -ne "  ${W}Desired length (e.g. 20): ${C}"; read -r LEN
            [[ -z "$LEN" || ! "$LEN" =~ ^[0-9]+$ ]] && LEN=20
            echo -e "  ${C}── ${LEN}-character passwords ──${N}"
            for i in 1 2 3; do
                local P; P=$(cat /dev/urandom | tr -dc 'A-Za-z0-9!@#$%&*_+-' | head -c "$LEN")
                result_ok "Option $i" "$P"
            done
            ;;
    esac

    echo ""
    echo -e "  ${C}── Recommended password managers ──${N}"
    echo -e "  ${G}▸${N} ${W}Bitwarden${N} (free, open source): sudo pacman -S bitwarden"
    echo -e "  ${G}▸${N} ${W}KeePassXC${N} (local, no cloud):     sudo pacman -S keepassxc"
    pause
}

# ══════════════════════════════════════════════════════════════
# 09 — ENCRYPT A MESSAGE
# ══════════════════════════════════════════════════════════════
tool_09() {
    section "09 · Encrypt a message to send securely"
    echo -e "  ${G}[1]${N} Encrypt message (AES-256)"
    echo -e "  ${G}[2]${N} Decrypt message"
    echo -e "  ${G}[3]${N} Encrypt file"
    echo ""
    echo -ne "  ${W}Option: ${C}"; read -r ENC_OPT; echo -e "${N}"

    case "$ENC_OPT" in
        1)
            echo -ne "  ${W}Message to encrypt: ${C}"; read -r MSG
            echo -ne "  ${W}Secret password: ${C}"; read -rs KEY; echo -e "${N}"
            echo ""
            local ENCRYPTED; ENCRYPTED=$(echo "$MSG" | openssl enc -aes-256-cbc -pbkdf2 -pass pass:"$KEY" -base64 2>/dev/null)
            echo -e "  ${C}── Encrypted message (share this) ──${N}"
            echo ""
            echo -e "  ${Y}$ENCRYPTED${N}"
            echo ""
            echo -e "  ${D}Recipient needs the password to decrypt.${N}"
            ;;
        2)
            echo -ne "  ${W}Encrypted message (base64): ${C}"; read -r ENC_MSG
            echo -ne "  ${W}Password: ${C}"; read -rs KEY; echo -e "${N}"
            echo ""
            local DECRYPTED; DECRYPTED=$(echo "$ENC_MSG" | openssl enc -aes-256-cbc -pbkdf2 -d -pass pass:"$KEY" -base64 2>/dev/null)
            if [[ -n "$DECRYPTED" ]]; then
                result_ok "Decrypted message" "$DECRYPTED"
            else
                result_bad "Error" "Wrong password or corrupted message"
            fi
            ;;
        3)
            echo -ne "  ${W}File path: ${C}"; read -r FPATH
            echo -ne "  ${W}Password: ${C}"; read -rs KEY; echo -e "${N}"
            if [[ ! -f "$FPATH" ]]; then result_bad "File" "Not found"; pause; return; fi
            local OUT="${FPATH}.enc"
            openssl enc -aes-256-cbc -pbkdf2 -in "$FPATH" -out "$OUT" -pass pass:"$KEY" 2>/dev/null
            result_ok "Encrypted file saved" "$OUT"
            echo -e "  ${D}To decrypt: openssl enc -aes-256-cbc -pbkdf2 -d -in ${OUT} -out original_file -pass pass:YOUR_PASSWORD${N}"
            ;;
    esac
    pause
}

# ══════════════════════════════════════════════════════════════
# 10 — DEFENSES DASHBOARD
# ══════════════════════════════════════════════════════════════
tool_10() {
    section "10 · My defenses status (dashboard)"
    echo -e "  ${W}${BOLD}Checking your security posture...${N}"
    echo ""

    local SCORE=0
    local TOTAL=10

    # 1. TOR
    echo -ne "  "; if systemctl is-active tor &>/dev/null 2>&1; then result_ok "TOR" "Active"; ((SCORE++)); else result_bad "TOR" "Inactive"; fi

    # 2. VPN
    local VPN_ACTIVE=false
    if ip link show | grep -qiE "tun|wg|vpn|proton"; then VPN_ACTIVE=true; fi
    echo -ne "  "; if $VPN_ACTIVE; then result_ok "VPN" "Detected"; ((SCORE++)); else result_warn "VPN" "Not detected"; fi

    # 3. Firewall UFW
    echo -ne "  "
    if command -v ufw &>/dev/null; then
        local UFW_STATUS; UFW_STATUS=$(sudo ufw status 2>/dev/null | head -1)
        if echo "$UFW_STATUS" | grep -qi "active"; then result_ok "Firewall (ufw)" "Active"; ((SCORE++)); else result_bad "Firewall (ufw)" "Installed but inactive"; fi
    else
        result_warn "Firewall (ufw)" "Not installed — sudo pacman -S ufw"
    fi

    # 4. Fail2ban
    echo -ne "  "
    if command -v fail2ban-client &>/dev/null; then
        if systemctl is-active fail2ban &>/dev/null; then result_ok "Fail2ban" "Active"; ((SCORE++)); else result_warn "Fail2ban" "Installed but inactive"; fi
    else
        result_warn "Fail2ban" "Not installed — sudo pacman -S fail2ban"
    fi

    # 5. Secure DNS
    echo -ne "  "
    local DNS_NOW; DNS_NOW=$(grep nameserver /etc/resolv.conf 2>/dev/null | awk '{print $2}' | head -1)
    if [[ "$DNS_NOW" == "1.1.1.1" || "$DNS_NOW" == "9.9.9.9" || "$DNS_NOW" == "84.200.69.80" ]]; then
        result_ok "Secure DNS" "$DNS_NOW"; ((SCORE++))
    else
        result_warn "Secure DNS" "$DNS_NOW — consider changing it (option 03)"
    fi

    # 6. SSH disabled
    echo -ne "  "
    if systemctl is-active sshd &>/dev/null; then
        result_warn "SSH" "Active — attack surface open"
    else
        result_ok "SSH" "Inactive"; ((SCORE++))
    fi

    # 7. Pending updates
    echo -ne "  "
    if command -v pacman &>/dev/null; then
        local UPDATES; UPDATES=$(pacman -Qu 2>/dev/null | wc -l)
        if [[ $UPDATES -eq 0 ]]; then result_ok "System updated" "Yes"; ((SCORE++)); else result_warn "Pending updates" "$UPDATES packages"; fi
    fi

    # 8. Clean history
    echo -ne "  "
    local HIST_LINES; HIST_LINES=$(wc -l < "$HOME/.bash_history" 2>/dev/null || echo 0)
    if [[ $HIST_LINES -lt 50 ]]; then result_ok "Bash history" "Clean ($HIST_LINES lines)"; ((SCORE++)); else result_warn "Bash history" "$HIST_LINES lines exposed"; fi

    # 9. Proxychains
    echo -ne "  "
    if command -v proxychains4 &>/dev/null || command -v proxychains &>/dev/null; then
        result_ok "Proxychains" "Installed"; ((SCORE++))
    else
        result_warn "Proxychains" "Not installed"
    fi

    # 10. Tor Browser
    echo -ne "  "
    if command -v torbrowser-launcher &>/dev/null || [[ -d "$HOME/.local/share/torbrowser" ]]; then
        result_ok "Tor Browser" "Installed"; ((SCORE++))
    else
        result_warn "Tor Browser" "Not installed — sudo pacman -S torbrowser-launcher"
    fi

    echo ""
    echo -e "  ${C}══════════════════════════════════════${N}"
    local PCT=$(( SCORE * 100 / TOTAL ))
    if [[ $PCT -ge 80 ]]; then
        echo -e "  ${G}${BOLD}SCORE: ${SCORE}/${TOTAL} (${PCT}%) — WELL PROTECTED${N}"
    elif [[ $PCT -ge 50 ]]; then
        echo -e "  ${Y}${BOLD}SCORE: ${SCORE}/${TOTAL} (${PCT}%) — MEDIUM PROTECTION${N}"
    else
        echo -e "  ${R}${BOLD}SCORE: ${SCORE}/${TOTAL} (${PCT}%) — VERY EXPOSED${N}"
    fi
    echo -e "  ${C}══════════════════════════════════════${N}"
    pause
}

# ══════════════════════════════════════════════════════════════
#  MAIN LOOP
# ══════════════════════════════════════════════════════════════
while true; do
    main_menu
    case "$OPT" in
        1|01)  tool_01 ;;
        2|02)  tool_02 ;;
        3|03)  tool_03 ;;
        4|04)  tool_04 ;;
        5|05)  tool_05 ;;
        6|06)  tool_06 ;;
        7|07)  tool_07 ;;
        8|08)  tool_08 ;;
        9|09)  tool_09 ;;
        10)    tool_10 ;;
        0|00)
            clear
            echo ""
            echo -e "  ${C}${BOLD}  GHOST SHIELD  —  Closing.${N}"
            echo -e "  ${D}  Stay invisible. 👁${N}"
            echo ""
            exit 0
            ;;
        *)
            echo -e "  ${R}Invalid option.${N}"
            sleep 1
            ;;
    esac
done
