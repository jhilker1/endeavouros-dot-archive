#!/usr/bin/env bash
xrandr --output eDP1 --mode 1368x768
xset b off
picom -b 
feh --bg-center ~/wallpapers/gruvbox/pacman.png
redshift -l $(curl -s "https://location.services.mozilla.com/v1/geolocate?key=geoclue" | jq -r '"\(.location.lat):\(.location.lng)"') &
emacs --daemon &
emacs --with-profile=doom --daemon &
