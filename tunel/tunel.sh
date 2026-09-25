#!/bin/bash

# Configuration
REMOTE_HOST="solana_monegram_validator"
SSH_PORT=2020
SOUND_FILE="/usr/share/sounds/alsa/1.m4a"
CHECK_HOST="8.8.8.8"
CHECK_INTERVAL=10
MAX_FAIL_COUNT=20

# State
fail_count=0

# Check internet connectivity
check_internet() {
  ping -c 1 -W 2 "$CHECK_HOST" &>/dev/null
}

# Check if SSH SOCKS proxy is listening locally
check_ssh() {
  nc -z 127.0.0.1 "$SSH_PORT" &>/dev/null
}

# Logging function
log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Play alert sound
play_alert() {
  if command -v paplay &>/dev/null; then
    paplay "$SOUND_FILE" &
  elif command -v aplay &>/dev/null; then
    aplay "$SOUND_FILE" &
  else
    echo -e "\a"
  fi
}

# Start or restart SSH tunnel
start_ssh() {
  log "Restarting SSH tunnel on port $SSH_PORT..."
  pkill -f "ssh -D $SSH_PORT" &>/dev/null
  ssh -D "$SSH_PORT" -fCqN "$REMOTE_HOST"
  if [ $? -eq 0 ]; then
    log "SSH tunnel started successfully."
  else
    log "Failed to start SSH tunnel."
    play_alert
  fi
}

# Main loop
while true; do
  if check_internet; then
    if ! check_ssh; then
      log "Internet OK, but SSH tunnel is down."
      start_ssh
    fi
    fail_count=0  # Reset failure count on success
  else
    ((fail_count++))
    log "Internet down. Failure count: $fail_count"
    if [ "$fail_count" -ge "$MAX_FAIL_COUNT" ]; then
      log "Internet has failed $fail_count times. Triggering alert."
      play_alert
      fail_count=0  # Reset after alert
    fi
  fi
  sleep "$CHECK_INTERVAL"
done
