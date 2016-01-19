#!/bin/bash

list=$(pidof -o %PPID python)

for p in $list
do
   echo "Killing $p..."
   sudo kill -TERM $p
done

sudo python main.py &
