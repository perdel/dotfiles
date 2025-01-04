#!/usr/bin/env bash

# Current Theme
dir="~/.config/waybar/scripts/power-menu/"
theme='style'

# CMDs
uptime="`uptime -p | sed -e 's/up //g'`"
host=`cat /etc/hostname`

# Options
shutdown=' Shutdown'
reboot=' Reboot'
lock=' Lock'
suspend=' Suspend'
logout=' Logout'

# Rofi CMD
rofi_cmd() {
    rofi -dmenu \
        -p "$host" \
        -mesg "Uptime: $uptime" \
        -theme ${dir}/${theme}.rasi
}

# Confirmation CMD
confirm_cmd() {
    rofi -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 250px;}' \
        -theme-str 'mainbox {children: [ "message", "listview" ];}' \
        -theme-str 'listview {columns: 2; lines: 1;}' \
        -theme-str 'element-text {horizontal-align: 0.5;}' \
        -theme-str 'textbox {horizontal-align: 0.5;}' \
        -dmenu \
        -p 'Confirmation' \
        -mesg 'Are you Sure?' \
        -theme ${dir}/${theme}.rasi
}

# Pass variables to rofi dmenu
run_rofi() {
    echo -e "$shutdown\n$reboot\n$logout\n$lock\n$suspend" | rofi_cmd
}

# Execute Command
run_cmd() {
    if [[ $1 == '--shutdown' ]]; then
        systemctl poweroff
    elif [[ $1 == '--reboot' ]]; then
        systemctl reboot
    elif [[ $1 == '--suspend' ]]; then
        amixer set Master mute
        systemctl suspend
    elif [[ $1 == '--logout' ]]; then
    hyprctl dispatch exit 1
    fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $shutdown)
        run_cmd --shutdown
        ;;
    $reboot)
        run_cmd --reboot
        ;;
    $lock)
        if [[ -x '/usr/bin/betterlockscreen' ]]; then
            betterlockscreen -l
        elif [[ -x '/usr/bin/i3lock' ]]; then
            i3lock
        elif [[ -x '/usr/bin/Hyprland' ]]; then
          swaylock
        fi
        ;;
    $suspend)
        run_cmd --suspend
        ;;
    $logout)
        run_cmd --logout
        ;;
esac
