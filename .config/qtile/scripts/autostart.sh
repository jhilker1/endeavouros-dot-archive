#!/usr/bin/env bash
~/.dotfiles/.screenlayout/netbook-366-768.sh
xset b off
picom -b 
feh --bg-center ~/Pictures/wallpapers/gruvbox/pacman.png
redshift -l $(curl -s "https://location.services.mozilla.com/v1/geolocate?key=geoclue" | jq -r '"\(.location.lat):\(.location.lng)"') &
emacs --daemon &
emacs --with-profile=doom --daemon &
