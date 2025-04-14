#!/bin/bash

REMOTE_HOST="ger_master2"
SSH_PORT=2020

check_internet() {
  ping -c 1 8.8.8.8 &> /dev/null
  return $?
}

check_ssh() {
  pgrep -f "ssh -D $SSH_PORT -fCqN $REMOTE_HOST" > /dev/null
  return $?
}


while true; do
  if check_internet; then
    if ! check_ssh; then
      echo "Internet is up, but SSH is not running. Starting SSH..."
      ssh -D $SSH_PORT -fCqN $REMOTE_HOST
    fi
  else
    echo "Internet is down. Waiting..."
  fi
  sleep 10
done
