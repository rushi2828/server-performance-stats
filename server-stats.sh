#!/bin/bash

# CPU 

top_output=$(top -bn1)

cpu=$( echo "$top_output" | grep "Cpu(s)" | sed 's/.*, *\([0-9.]*\)%* id.*/\1/' | awk '{print 100 - $1 "%"}')
echo "CPU Usage: $cpu"

# Memory
# Read memory from file

read total_memory available_memory <<< $(awk '/MemTotal/ {t=$2} /MemAvailable/ {a=$2} END {print t, a}' /proc/meminfo)

used_memory=$((total_memory - available_memory))
used_memory_percent=$(awk -v u=$used_memory -v t=$total_memory 'BEGIN { printf("%.1f", (u / t) * 100) }')
free_memory_percent=$(awk -v a=$available_memory -v t=$total_memory 'BEGIN { printf("%.1f", (a / t) * 100) }')

# Convert from kB to MB 
total_memory_mb=$(awk -v t=$total_memory 'BEGIN { printf("%.1f", t/1024) }')
used_mb=$(awk -v u=$used_memory 'BEGIN { printf("%.1f", u/1024) }')
available_memory_mb=$(awk -v a=$available_memory 'BEGIN { printf("%.1f", a/1024) }')

echo "Total Memory    : $total_memory_mb MB"
echo "Used Memory     : $used_mb MB ($used_memory_percent%)"
echo "Free/Available  : $available_memory_mb MB ($free_memory_percent%)"


echo "****************************************************************************************************************"

# Disk

df_output=$(df -h /)

size_disk=$(echo "$df_output" | awk 'NR==2 {printf $2}')

# Dont use printf in below line, it doesnt add space
read used_disk available_disk <<< $(echo "$df_output" | awk 'NR==2 {print $3, $4}')

df_output_raw=$(df /)

read size_disk_kb used_disk_kb available_disk_kb <<< $(echo "$df_output_raw" | awk 'NR==2 {print $2, $3, $4}')

used_disk_percent=$(echo "scale=2; $used_disk_kb *100/$size_disk_kb" | bc)
available_disk_percent=$(echo "scale=2; $available_disk_kb *100/$size_disk_kb" | bc)

echo "Disk Size : $size_disk"
echo "Used Disk Space: $used_disk ($used_disk_percent%)"
echo "Available Disk Space: $available_disk ($available_disk_percent)"