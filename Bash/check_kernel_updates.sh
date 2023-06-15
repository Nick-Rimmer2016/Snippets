#!/bin/bash

# Check for available updates without installing them
updates=$(sudo yum check-update)

# Check if any kernel-related package requires a reboot
if echo "$updates" | grep -q "kernel" && echo "$updates" | grep -q "reboot"; then
  echo "Kernel update available that requires a reboot."
fi

# Run yum update with security patches
sudo yum update --security -y

# Check if a reboot is required after the update
if [ -f "/var/run/reboot-required" ] || [ -f "/var/run/reboot-required.pkgs" ]; then
  echo "Kernel update required. Please reboot."
fi
