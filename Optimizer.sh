#!/bin/bash

# Check if script is run as root
if [ "$EUID" -ne 0 ]; then 
    echo "Please run as root (use sudo)"
    exit 1
fi

echo "Starting cache cleaning process..."

# Clear PageCache, dentries, and inodes
sync; echo 3 > /proc/sys/vm/drop_caches

# Clear system journal logs
journalctl --vacuum-time=3d

# Clear apt cache
apt-get clean
apt-get autoclean

# Clear thumbnail cache
rm -rf ~/.cache/thumbnails/*

# Clear tmp directories
rm -rf /tmp/*
rm -rf /var/tmp/*

# Clear old logs
find /var/log -type f -name "*.log" -exec truncate -s 0 {} \;
find /var/log -type f -name "*.gz" -delete

# Clear systemd journal
journalctl --rotate
journalctl --vacuum-time=3d

echo "Cache cleaning completed!"

# Show current disk usage
df -h
