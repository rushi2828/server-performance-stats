#!/bin/bash

top_output=$(top -bn1)

cpu=$( echo "$top_output" | grep "Cpu(s)" | sed 's/.*, *\([0-9.]*\)%* id.*/\1/' | awk '{print 100 - $1 "%"}')
echo "CPU Usage: $cpu"

read total available <<< $(awk '/MemTotal/ {t=$2} /MemAvailable/ {a=$2} END {print t, a}' /proc/meminfo)

used=$((total - available))
used_percent=$(awk -v u=$used -v t=$total 'BEGIN { printf("%.1f", (u / t) * 100) }')
free_percent=$(awk -v a=$available -v t=$total 'BEGIN { printf("%.1f", (a / t) * 100) }')

# Convert from kB to MB 
total_mb=$(awk -v t=$total 'BEGIN { printf("%.1f", t/1024) }')
used_mb=$(awk -v u=$used 'BEGIN { printf("%.1f", u/1024) }')
available_mb=$(awk -v a=$available 'BEGIN { printf("%.1f", a/1024) }')

echo "Total Memory    : $total_mb MB"
echo "Used Memory     : $used_mb MB ($used_percent%)"
echo "Free/Available  : $available_mb MB ($free_percent%)"
