#!/bin/bash

cpu=$(top -bn5 | grep "Cpu(s)" | sed 's/.*, *\([0-9.]*\)%* id.*/\1/' | awk '{print 100 - $1 "%"}')
echo $cpu
