#!/usr/bin/env bash
NOTIFCOUNT=$(dunstctl count waiting)

if [[ $NOTIFCOUNT == "0" ]] 
then
    printf ""
else
    printf ""
fi
