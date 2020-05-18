#!/bin/bash
#delay script up to an hour
SHOULDI=$((1 + RANDOM % 3))
if [[ $SHOULDI == 1 ]]
    then
        DELAY=$((1 + RANDOM % 15))
        sleep $DELAY
        ./fertilize.py
        git add -A
        git commit -m "WIP"
        git push
    else
        echo "I really shouldn't"
fi