#!/usr/bin/env bash
NOTIFCOUNT=$(dunstctl count displayed)

if [[ $NOTIFCOUNT == "0" ]] 
then
    printf ""
else
    printf ""
fi
