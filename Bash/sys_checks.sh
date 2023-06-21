#!/bin/bash

# Define the required volume group size in gigabytes
required_size=7

# Define the endpoint to check using netcat
endpoint="example.com"
port=80

# Get the available physical disk space in gigabytes
available_space=$(vgs --units g --noheadings --nosuffix --options vg_free | awk '{print $1}')

# Check if the available space is greater than or equal to the required size
if (( $(bc <<< "$available_space >= $required_size") )); then
    echo "Disk space is sufficient for a volume group of $required_size GB."
else
    echo "Insufficient disk space. Cannot create a volume group of $required_size GB."
    exit 1
fi

# Check if the audit package is installed
if ! rpm -q audit >/dev/null 2>&1; then
    echo "The audit package is not installed."
    exit 1
fi

# Check if audit is not in immutable mode
if [[ "$(grep '^\s*[^#]*[^ ]\s*/sbin/auditctl.*-e 2' /etc/audit/audit.rules)" != "" ]]; then
    echo "Audit is in immutable mode. Please disable immutable mode to proceed."
    exit 1
fi

# Check if the endpoint is reachable using netcat
if nc -z "$endpoint" "$port" >/dev/null 2>&1; then
    echo "The endpoint $endpoint:$port is reachable."
else
    echo "The endpoint $endpoint:$port is not reachable."
    exit 1
fi
