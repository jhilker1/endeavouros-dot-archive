#!/usr/bin/env bash

EWW=`which eww`
FILE="$HOME/.cache/eww_launch.sb"
CFG="$HOME/.config/eww/rightbar"
SB_NAME="example"

if [[ ! `pidof eww` ]]; then
    eww daemon
    sleep 1
fi

if [[ ! -f "$FILE" ]]; then
    touch "$FILE"
    $EWW open "$SB_NAME"
else
   $EWW close "$SB_NAME"
   rm -rf "$FILE"
fi
