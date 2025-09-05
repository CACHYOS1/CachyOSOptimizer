#!/bin/bash

# Function to check if zenity is installed
check_zenity() {
    if ! command -v zenity &> /dev/null; then
        echo "Zenity is not installed. Installing..."
        sudo apt-get install zenity -y || sudo pacman -S zenity --noconfirm
    fi
}

# Function to show GUI menu
show_gui_menu() {
    choice=$(zenity --list \
        --title="CPU Optimizer" \
        --width=400 \
        --height=300 \
        --column="Option" \
        "Show Current Settings" \
        "Set CPU Governor" \
        "Set Custom Frequency" \
        "Show GPU Info" \
        "Exit")
    
    case $choice in
        "Show Current Settings")
            current_settings=$(show_current_settings)
            zenity --info --width=400 --text="$current_settings"
            ;;
        "Set CPU Governor")
            governors=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors)
            governor=$(zenity --list \
                --title="Select CPU Governor" \
                --column="Governor" $governors)
            if [ -n "$governor" ]; then
                set_governor "$governor"
                zenity --info --text="Governor set to: $governor"
            fi
            ;;
        "Set Custom Frequency")
            min_freq=$(zenity --entry \
                --title="Set Minimum Frequency" \
                --text="Enter minimum frequency (kHz):")
            max_freq=$(zenity --entry \
                --title="Set Maximum Frequency" \
                --text="Enter maximum frequency (kHz):")
            if [ -n "$min_freq" ] && [ -n "$max_freq" ]; then
                set_frequency_limits "$min_freq" "$max_freq"
                zenity --info --text="Frequency limits set"
            fi
            ;;
        "Show GPU Info")
            gpu_info=$(show_gpu_info)
            zenity --info --width=400 --text="$gpu_info"
            ;;
        "Exit")
            exit 0
            ;;
    esac
}

# Main script
check_zenity

while true; do
    show_gui_menu
done
