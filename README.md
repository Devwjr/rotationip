# Tor IP Rotator

Automatically rotates your Tor IP address at set intervals. Useful for maintaining anonymity or bypassing IP-based rate limits.

## Features

- Rotates Tor IP automatically at configurable intervals
- Shows before/after IP addresses for verification
- Runs continuously in the background
- Configurable rotation interval via command-line argument

## Prerequisites

- Tor must be running and configured with a control port
- The control authentication cookie must be available at `/run/tor/control.authcookie`
- Network access to check.torproject.org

## Installation

1. Make the script executable:
   ```bash
   chmod +x tor-rotator.sh
   ```

2. Run the script (default interval is 300 seconds):
   ```bash
   ./tor-rotator.sh
   ```

3. Or specify a custom interval in seconds:
   ```bash
   ./tor-rotator.sh 600  # Rotate every 10 minutes
   ```

## How it works

1. Reads the Tor control cookie for authentication
2. Connects to the Tor control port (9051)
3. Authenticates and sends the NEWNYM signal to request a new circuit
4. Checks and displays your current IP address
5. Waits for the specified interval before repeating

## License

MIT