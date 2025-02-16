#!/usr/bin/env bash

# Source the file containing default temperature
default_file=$HOME/.config/waybar/scripts/default_temp.sh
source $default_file

# Check if gammastep is currently running
decrease() {
    if pgrep gammastep >/dev/null; then
        # If gammastep is running, kill it and start with increased temperature
        current_temp=$((default_temp - 250))
        if (( current_temp < 2000 )); then
            notify-send -t 700 "Temp can't subceed 2000K."
        else
            pkill gammastep
            gammastep -O "$current_temp" &
            notify-send -t 700 "Temp $current_temp K"
            # Update default_temp in the separate file
            echo "default_temp=$((current_temp))" > $default_file
        fi
    else
        default_temp=3500
        gammastep -O "$default_temp" &
        notify-send -t 700 "RedGlow Started"
        echo "default_temp=$((default_temp))" > $default_file
    fi
}

increase(){
    # Check if gammastep is currently running
    if pgrep gammastep >/dev/null; then
        # If gammastep is running, kill it and start with increased temperature
        current_temp=$((default_temp + 250))
        if (( current_temp > 4500 )); then
            notify-send -t 700 "Temp can't exceed 4500K."
        else
            pkill gammastep
            gammastep -O "$current_temp" &
            notify-send -t 700 "Temp $current_temp K"
            # Update default_temp in the separate file
            echo "default_temp=$((current_temp))" > $default_file
        fi
    else
        default_temp=3500
        gammastep -O "$default_temp" &
        notify-send -t 700 "RedGlow Started"
        echo "default_temp=$((default_temp))" > $default_file
    fi
}

toggle(){
    if pgrep gammastep >/dev/null; then
        pkill gammastep
        notify-send -t 700 "RedGlow Stoped"
    else
        gammastep -O 3500 &
        notify-send -t 700 "RedGlow ON"
    fi
}

# Execute Command
if [[ $1 == '--decrease' ]]; then
    decrease
elif [[ $1 == '--increase' ]]; then
    increase
elif [[ $1 == '--toggle' ]]; then
    toggle
fi
