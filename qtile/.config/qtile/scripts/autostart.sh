#!/usr/bin/env bash
xset b off
xrandr --output eDP1 --mode 1368x768
feh --bg-center ~/.dotfiles/wallpapers/gruvbox/pacman.png
redshift -l $(curl -s "https://location.services.mozilla.com/v1/geolocate?key=geoclue" | jq '.location.lat, .location.lng' | tr '\n' ':' | sed 's/:$//') &
