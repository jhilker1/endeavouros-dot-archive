#!/usr/bin/env bash
VOL=$(pacmd list-sinks|grep -A 15 '* index'| awk '/volume: front/{ print $5 }' | sed 's/[%|,]//g' | xargs)

MUTED=$(pacmd list-sinks|grep -A 15 '* index'|awk '/muted:/{ print $2 }')

if [[ $MUTED == "yes" ]] 
then
    printf "%s" "Muted"
else
    printf "%s%%" "$VOL"
fi
