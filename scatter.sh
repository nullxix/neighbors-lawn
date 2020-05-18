#!/bin/bash
#delay script up to an hour
DELAY=$((1 + RANDOM % 15))
sleep $DELAY
./fertilize.py
git add -A
git commit -m "WIP"
git push