#!/bin/bash

# Tor IP Rotator
# Automatically rotates your Tor IP at set intervals

COOKIE="/run/tor/control.authcookie"
INTERVALO=${1:-300}

cookie_hex=$(xxd -p -c 256 "$COOKIE" 2>/dev/null)

if [ -z "$cookie_hex" ]; then
    echo "Error: could not read Tor cookie from $COOKIE"
    echo "Run 'newgrp debian-tor' or relogin to enable the group."
    exit 1
fi

rotate_ip() {
    exec 3<>/dev/tcp/127.0.0.1/9051
    printf "AUTHENTICATE %s\r\n" "$cookie_hex" >&3
    sleep 0.3
    printf "SIGNAL NEWNYM\r\n" >&3
    sleep 0.3
    exec 3<&-
    exec 3>&-
}

echo "IP rotation started - interval: ${INTERVALO}s"
echo "Press Ctrl+C to stop."

while true; do
    ip_before=$(curl -s --socks5-hostname 127.0.0.1:9050 --max-time 15 https://check.torproject.org/api/ip | grep -oP '"IP":"\K[^"]+')
    echo "$(date '+%H:%M:%S') - Current IP: ${ip_before:-error}"

    rotate_ip

    sleep 5

    ip_after=$(curl -s --socks5-hostname 127.0.0.1:9050 --max-time 15 https://check.torproject.org/api/ip | grep -oP '"IP":"\K[^"]+')
    echo "$(date '+%H:%M:%S') - New IP:   ${ip_after:-error}"

    if [ -n "$ip_before" ] && [ "$ip_before" = "$ip_after" ]; then
        echo "IP didn't change, trying again..."
    fi

    sleep "$INTERVALO"
done