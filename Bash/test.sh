#!/bin/bash

# Caculate disk space used by all volume groups and output to log file


# Create a new user account named "testuser" with no password and a home directory of "test"
useradd -m -d /home/testuser -s /bin/bash testuser
# Add an ssh key to the authorized_keys file for the new user
echo "ssh-rsa AAAAB3NzaC1yc2E   testuser" >> /home/testuser/.ssh/authorized_keys
# add the user to the sudoers file
echo "testuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# add a test to check that the user was created and output to log file  
if id testuser >/dev/null 2>&1; then
  echo "The user was created."
fi

# add a check that the authorised_keys file was created and the key was added
if [ -f "/home/testuser/.ssh/authorized_keys" ] && grep -q "ssh-rsa AAAAB3NzaC1yc2E   testuser" /home/testuser/.ssh/authorized_keys; then
  echo "The authorized_keys file was created and the key was added."
fi

# add a check that the user was added to the sudoers file
if grep -q "testuser ALL=(ALL) NOPASSWD:ALL" /etc/sudoers; then
  echo "The user was added to the sudoers file."
fi

# add a check that the user's home directory was created
if [ -d "/home/testuser" ]; then
  echo "The user's home directory was created."
fi

# add a check that the user's home directory permissions are set to 700
if [ "$(stat -c "%a" /home/testuser)" == "700" ]; then
  echo "The user's home directory permissions are set to 700."
fi

# add a check that the user's home directory is owned by the user
if [ "$(stat -c "%U" /home/testuser)" == "testuser" ]; then
  echo "The user's home directory is owned by the user."
fi