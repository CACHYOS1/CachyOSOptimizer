#!/bin/bash

show_menu() {
    echo "=================================="
    echo " Linux Gaming Optimizer"
    echo "=================================="
    echo "1) Disable Bluetooth"
    echo "2) Set CPU to Performance"
    echo "3) Reduce Swappiness"
    echo "4) Clean Cache and more"
    echo "5) Exit"
    echo -n "Choose an option: "
}

while true; do
    show_menu
    read -r choice
    case "$choice" in
        1)
            echo "Disabling Bluetooth..."
            sudo systemctl stop bluetooth.service
            sudo systemctl disable bluetooth.service
            ;;
        2)
            echo "Setting CPU governor to performance..."
            for governor in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
                echo "performance" | sudo tee "$governor"
            done
            ;;
        3)
            echo "Reducing swappiness..."
            sudo sysctl vm.swappiness=10
            sudo tee -a /etc/sysctl.conf <<EOF
vm.swappiness=10
EOF
            ;;
        4)
           echo "Clearing Cache"
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
            ;;
        5)
            echo "Exiting..."
            break
            ;;
        *)
            echo "Invalid option, try again."
            ;;
    esac
    echo ""
done
