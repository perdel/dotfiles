#!/bin/sh

cat /sys/class/power_supply/BAT0/power_now | awk '{printf "%.1f", $1*10^-6}'
