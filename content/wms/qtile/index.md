+++
title = "Qtile"
author = ["JACOBSLAPTOP"]
type = "config"
draft = false
+++

This file serves as the documentation and source code for my configuration of Qtile.


## Global Imports {#global-imports}

These must be imported in order for my config to work.

<details>
<div class="details">

<summary class="summary"><span class="underline"><b>Python</b></span></summary>

```python
import os
import re
import socket
import subprocess
from typing import List  # noqa: F401

from libqtile import layout, bar, widget, hook
from libqtile.lazy import lazy
from libqtile.config import Match, Screen, Group, DropDown, ScratchPad, KeyChord
from libqtile.config import EzKey as Key, EzClick as Click, EzDrag as Drag

from qtile_extras import widget

from theme import fonts
from theme import gruvbox as colors
```
</div>
</details>


## A Few Variables {#a-few-variables}

I like to have the Super (or Windows) key as my modkey, alacritty as my terminal, and firefox as my browser.

```python
mod = "mod4"
terminal = "alacritty"
browser = "firefox"
```


## Core Theming {#core-theming}

This basic module describes my theme options for qtile.


### Colors {#colors}


#### Gruvbox {#gruvbox}

I’ve been using gruvbox as my colorscheme for about a year now, and I really like it.

```python
gruvbox = {
    "bg": "#282828",
    "bg-bright": "#32302f",
    "bg-dark": "#1d2021",
    "fg": "#ebdbb2",
    "red": "#cc241d",
    "green": "#98971a",
    "yellow": "#d79921",
    "blue": "#458588",
    "purple": "#b16286",
    "teal": "#689d6a",
    "orange": "#d65d0e",
    "gray": "#504945",
    }
```


#### <span class="org-todo todo TODO">TODO</span> My Scheme {#my-scheme}

I am currently working on my own color scheme, and this is that scheme.

```python
my_scheme = {}
```


### Fonts {#fonts}

I have 2 main font I like to use - Iosevka Nerd Font for my text font, and Material Material for my material.

```python
fonts = {
    "text": "Iosevka Mono Nerd Font",
    "material": "Material Icons",
    "fa": "FontAwesome"
}
```


## Groups {#groups}

Groups are your workspaces in Qtile.

```python

# TODO Fix matching

groups = [Group("1", layout='monadtall'), ## Browser
	  Group("2", layout='monadtall'), ## Emacs/Dev
	  Group("3", layout='monadtall'), ## Terminal

	  Group("4", layout='monadtall'), ## IRC/Discord
	  Group("5", layout='monadtall'), ## Steam/Games
	  Group("6", layout='monadtall'), ## Music
	  Group("7", layout='max'), ## Graphics
	  Group("8", layout='max'),
	  Group("9", layout='max')]
```


## Keybindings {#keybindings}

My keybindings aren't really that special - I try to keep them vim-based, or as close to vim-based as I can. I am organizing them based on a general category - such as my core bindings, other applications, etc.

```python
keys = [
    Key("M-h", lazy.layout.left(), desc="Move focus to left"),
    Key("M-l", lazy.layout.right(), desc="Move focus to right"),
    Key("M-j", lazy.layout.down(), desc="Move focus down"),
    Key("M-k", lazy.layout.up(), desc="Move focus up"),
    Key("M-S-h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key("M-S-l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key("M-S-j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key("M-S-k", lazy.layout.shuffle_up(), desc="Move window up"),
    Key("M-C-h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key("M-C-l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key("M-C-j", lazy.layout.grow_down(), desc="Grow window down"),
    Key("M-C-k", lazy.layout.grow_up(), desc="Grow window up"),
    Key("M-C-<equal>", lazy.layout.grow()),
    Key("M-C-<minus>", lazy.layout.shrink()),
    Key("M-C-0", lazy.layout.reset()),

    Key("M-S-q", lazy.window.kill(), desc="Kill focused window"),
    Key("M-S-r", lazy.restart(), desc="Restart Qtile"),
    Key("M-S-p", lazy.spawn("rofi -show powermenu -theme-str 'window { height: 55%;}' "), desc="Manage machine power state"),
    Key("M-f", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen"),
    Key("M-S-f", lazy.window.toggle_floating(), desc="Toggle floating layout"),

    Key("M-<Tab>", lazy.next_layout()),
    Key("<XF86AudioLowerVolume>", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%")),
    Key("<XF86AudioRaiseVolume>", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%")),
    Key("<XF86AudioMute>", lazy.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle")),

    Key("M-r", lazy.spawn("rofi -show drun")),
    Key("M-s", lazy.spawn("alacritty -t 'ncspot' -e 'ncspot'")),
    Key("M-<Return>", lazy.spawn(terminal), desc="Launch terminal"),
    Key("M-S-<Return>", lazy.spawn(browser), desc="Open Firefox"),

    KeyChord([mod], "e", [
	Key("c", lazy.spawn("emacsclient -cs 'jmacs' -e '(erc)'"), desc="Spawn erc with emacs client"),
	Key("e", lazy.spawn("emacsclient -cs 'jmacs' -a 'emacs'"), desc="Spawn emacs client"),
	Key("n", lazy.spawn("emacsclient -cs 'jmacs' -e '(elfeed)'"), desc="Spawn elfeed with emacs client"),
    ], mode="Emacs Apps"),

    KeyChord([mod, "shift"], "e", [
	Key("d", lazy.spawn("emacsclient -cs 'doom' -a 'emacs --with-profile=doom'"), desc="Spawn Doom Emacs client"),
	Key("j", lazy.spawn("emacsclient -cs 'jmacs' -a 'emacs'"), desc="Spawn Jmacs client"),
    ], mode="Emacs Profiles"),






    Key("C-<grave>", lazy.spawn("dunstctl close")),
]

```


### Group Bindings {#group-bindings}

This sets up the bindings for my groups - it works with KeyChords.

```python
for group in groups:
    keys.extend([
      Key("M-{}".format(group.name), lazy.group[group.name].toscreen(), desc="Switch to group {}".format(group.name)),
      Key("M-S-{}".format(group.name), lazy.window.togroup(group.name), desc="Move focused window to group {}".format(group.name))
    ])

```


## Layouts {#layouts}

I have only a few layouts I’d like to use - a master/stack layout like in XMonad, and then a maximized layout. However, I also like to set up my floating layouts here.


### Theming {#theming}

I like to have a consistant look for my layouts.

```python
layout_theme = {
    "margin": 10,
    "border_focus": colors['purple'],
    "border_normal": colors['bg'],
    "border_width": 2
}
```


### My Main Layouts {#my-main-layouts}

```python
layouts = [
    layout.MonadTall(**layout_theme),
    layout.Max(**layout_theme),
]
```


### Floating Layout {#floating-layout}

```python

floating_layout = layout.Floating(float_rules=[
    # Run the utility of `xprop` to see the wm class and name of an X client.
    *layout.Floating.default_float_rules,
    Match(wm_class='confirmreset'),  # gitk
    Match(wm_class='makebranch'),  # gitk
    Match(wm_class='maketag'),  # gitk
    Match(wm_class='ssh-askpass'),  # ssh-askpass
    Match(title='branchdialog'),  # gitk
    Match(title='pinentry'),  # GPG key password entry
    Match(wm_class='pinentry-gtk-2'),
], **layout_theme)
```


## Bars {#bars}


### Theming {#theming}

```python
widget_defaults = dict(
    font=fonts['text'],
    fontsize=14,
    padding=3,
    background = colors['bg'],
    foreground = colors['fg'],
    theme_path = "/usr/share/icons/Paper/16x16/panel/"
)

extension_defaults = widget_defaults.copy()
```


#### Arrow Functions {#arrow-functions}

```python
def draw_arrow_right(bg,fg,font_size=33):
    "Creates a textbox widget with a right-pointing arrow."
    return widget.TextBox(text="",
			  padding=0,
			  fontsize=font_size,
			  background=bg,
			  foreground=fg)

def draw_arrow_left(bg,fg,font_size=33):
    "Creates a textbox widget with a right-pointing arrow."
    return widget.TextBox(text="",
			  padding=0,
			  fontsize=font_size,
			  background=bg,
			  foreground=fg)
```


### Main Bar {#main-bar}

```python
mainbar = bar.Bar([
    widget.Sep(linewidth=0,
	       padding=6),
    widget.GroupBox(disable_drag=True,
		    block_highlight_text_color=colors['fg'],
		    active=colors['fg'],),
    draw_arrow_right(colors['blue'],
		     colors['bg']),
    widget.TextBox(text="",
		   font=fonts['material'],
		   fontsize = 12,
		   background=colors['blue']),
    widget.Clock(format="%H:%M - %a %d %b",
		 background=colors['blue']),

    draw_arrow_right(colors['purple'],
		     colors['blue']),
    widget.CurrentLayout(background=colors['purple']),
    draw_arrow_right(colors['bg'],
		     colors['purple']),
    #widget.Spacer(),
    widget.WindowName(),
    draw_arrow_left(colors['bg'],
		    colors['orange']),
    widget.WiFiIcon(background=colors['orange'],
		    active_colour = colors['fg'],
		    inactive_colour = colors['gray'],
		    padding=7,
		    foreground=colors['fg']),


    draw_arrow_left(colors['orange'],
		    colors['purple']),
    widget.TextBox(text="",
		   fontsize=16,
		   background=colors['purple']),

    widget.Bluetooth(hci="/dev_90_7A_58_A6_A0_0A",
		     background=colors['purple']),


    draw_arrow_left(colors['purple'],
		    colors['green']),


    widget.GenPollText(update_interval=None,
		       func=lambda: subprocess.check_output(os.path.expanduser("~/.dotfiles/.config/qtile/scripts/volicon.sh")).decode('utf-8'),
		       font=fonts['material'],
		       fontsize=16,
		       background=colors['green']),

    widget.GenPollText(update_interval=None,
		       func=lambda: subprocess.check_output(os.path.expanduser("~/.dotfiles/.config/qtile/scripts/printvol.sh")).decode('utf-8'),
		       background=colors['green']),

], 30)
```


## Screens {#screens}

Screens are your monitors in qtile.

```python
screens = [
    Screen(top = mainbar),
]
```


## Hooks {#hooks}

Hooks are scripts that can be automated in python - an example would be an init script for setting wallpapers, starting a compositor, etc.


### Autostart {#autostart}

This script calls some functions to automatically start.

```python
@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser('~')
    subprocess.call([home + '/.config/qtile/scripts/autostart.sh'])
```


#### Bash Script {#bash-script}

```sh
~/.dotfiles/.screenlayout/netbook-366-768.sh
xset b off
pulseaudio --start
picom -b
feh --bg-center ~/Pictures/wallpapers/gruvbox/pacman.png
redshift -l $(curl -s "https://location.services.mozilla.com/v1/geolocate?key=geoclue" | jq -r '"\(.location.lat):\(.location.lng)"') &
emacs --daemon &
emacs --with-profile=doom --daemon &
```


### Volume {#volume}


#### Percent {#percent}

```sh
VOL=$(pacmd list-sinks|grep -A 15 '* index'| awk '/volume: front/{ print $5 }' | sed 's/[%|,]//g' | xargs)

MUTED=$(pacmd list-sinks|grep -A 15 '* index'|awk '/muted:/{ print $2 }')

if [[ $MUTED == "yes" ]]
then
    printf "Muted"
else
    printf "%s%%" "$VOL"
fi
```