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

mod = "mod4"
terminal = "alacritty"
browser = "firefox"

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

for group in groups:
    keys.extend([
      Key("M-{}".format(group.name), lazy.group[group.name].toscreen(), desc="Switch to group {}".format(group.name)),
      Key("M-S-{}".format(group.name), lazy.window.togroup(group.name), desc="Move focused window to group {}".format(group.name)) 
    ])

layout_theme = {
    "margin": 10,
    "border_focus": colors['purple'],
    "border_normal": colors['bg'],
    "border_width": 2
}

layouts = [
    layout.MonadTall(**layout_theme),
    layout.Max(**layout_theme),
]

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

widget_defaults = dict(
    font=fonts['text'],
    fontsize=14,
    padding=3,
    background = colors['bg'],
    foreground = colors['fg'],
    theme_path = "/usr/share/icons/Paper/16x16/panel/"
)

extension_defaults = widget_defaults.copy()

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
                   font = fonts['material'],
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

screens = [
    Screen(top = mainbar),
]

@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser('~')
    subprocess.call([home + '/.config/qtile/scripts/autostart.sh'])
