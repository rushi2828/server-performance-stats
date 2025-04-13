#!/bin/bash

top_output=$(top -bn1)

cpu=$( echo "$top_output" | grep "Cpu(s)" | sed 's/.*, *\([0-9.]*\)%* id.*/\1/' | awk '{print 100 - $1 "%"}')
echo "CPU Usage: $cpu"
