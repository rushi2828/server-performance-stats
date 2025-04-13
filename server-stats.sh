#!/bin/bash

top_output=$(top -bn1)

cpu=$( echo "$top_output" | grep "Cpu(s)" | sed 's/.*, *\([0-9.]*\)%* id.*/\1/' | awk '{print 100 - $1 "%"}')
echo "CPU Usage: $cpu"


mem=$(awk '/MemTotal/ {total=$2} /MemAvailable/ {avail=$2} END {printf("%.1f%%", (1 - avail/total) * 100)}' /proc/meminfo)
echo "Memory Usage: $mem"