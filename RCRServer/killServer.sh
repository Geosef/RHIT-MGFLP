#!/bin/bash

list=$(pidof -o %PPID python)

for p in $list
do
   echo "Killing $p..."
   sudo kill -TERM $p
done