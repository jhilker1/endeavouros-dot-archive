#!/usr/bin/env zsh
TOCONFIG=("polybar" "qtile" "i3" "alacritty")
#TOHOME
DOTDIR=$1

if [[ -z $DOTDIR ]]; then
	echo "No config provided. Aborting." && exit 1
else
	echo "DOTDIR IS $DOTDIR"
fi
