import os
import re
import socket
import subprocess
from typing import List  # noqa: F401

from libqtile import layout, bar, widget, hook
from libqtile.lazy import lazy
from libqtile.config import Match, Screen, Group, DropDown, ScratchPad, KeyChord
from libqtile.config import EzKey as Key, EzClick as Click, EzDrag as Drag

from theme import fonts, gruvbox as colors

mod = "mod4"
terminal = "alacritty"
browser = "firefox"

groups = [Group("1", label=" ", layout='monadtall', matches=[
    Match(wm_class=["firefox", "qutebrowser"]),
]),
          Group("2", label="", layout='monadtall', matches=[
              Match(title=["Emacs"])
          ]),
          Group("3", label="", layout='monadtall', matches=[
              Match(title=["Alacritty"])
          ]),
          
          Group("4", label="", layout='monadtall', matches=[
              Match(title=["Discord", "Discord Updater"]),
          ]),
          Group("5", label="", layout='monadtall', matches=[
              Match(title=["Steam"]),
          ]),
          Group("6", label="", layout='monadtall', matches=[
              Match(title=["ncspot"])
          ]),
          Group("7", label="", layout='max', matches=[
              Match(title=["GNU Image Manipulation Program"]),
              Match(wm_class=["feh"])
          #    Match(wm_class=["Godot"]), # Wonderdraft
          ]),
          Group("8", label="", layout='max'),

          Group("9", label="", layout='max')]

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

wttr_locs = [
    {"home": "Charlottesville"},
    {"grandmas": "Saxis"}
]

mainbar = bar.Bar([
    widget.Sep(linewidth=0,
               padding=6),
    widget.GroupBox(disable_drag=True,
                    block_highlight_text_color=colors['fg'],
                    active=colors['fg'],
                    highlight_method='line',
                    highlight_color=colors['bg'],
                    inactive=colors['gray'],
                    this_current_screen_border=colors['blue'],
                    rounded=False,
                    padding = 4,
                    font = fonts['fa'],
                    #fontsize=12
                  ),
    draw_arrow_right(colors['blue'],
                     colors['bg']),
    widget.TextBox(text="",
                   font=fonts['material'],
                   fontsize = 14,
                   background=colors['blue']),
      widget.Clock(format="%H:%M - %a %d %b",
                 background=colors['blue']), 
    draw_arrow_right(colors['purple'],
                     colors['blue']),
    widget.CurrentLayout(background=colors['purple']),
    draw_arrow_right(colors['bg'],
                     colors['purple']),
    widget.Spacer(),
    draw_arrow_left(colors['bg'], 
                    colors['orange']),
    widget.TextBox(text="",
                   background = colors['orange'],
                   font=fonts['material'],
                   fontsize=16),
    widget.Wlan(format="{essid}",
                disconnected_message="Not Connected",
                background=colors['orange']),
    widget.Battery(format="",
                   show_short_text = False,
                   padding = 0,
                   fontsize = 33,
                   background = colors['orange'],
                   foreground = colors['blue'],
                   low_foreground = colors['red']),
    widget.Battery(format="{char}",
                   show_short_text=False,
                   charge_char = "",
                   discharge_char = "",
                   full_char = "",
                   font = fonts['material'],
                   fontsize=16,
                   background = colors['blue'],
                   low_background = colors['red']),

    widget.Battery(format="{percent:2.0%}",
                   show_short_text=False,
                   background = colors['blue'],
                   low_background = colors['red']),
   widget.Battery(format="",
                   show_short_text = False,
                   padding = 0,
                   fontsize = 33,
                   background = colors['blue'],
                   low_background = colors['red'],
                   foreground=colors['purple']),

    widget.TextBox(text="",
                   fontsize=16,
                   background=colors['purple']),

    widget.Bluetooth(hci="/dev_90_7A_58_A6_A0_0A",
                     background=colors['purple']),

    draw_arrow_left(colors['purple'],
                    colors['green']),
    widget.GenPollText(update_interval=None, 
                       func=lambda: subprocess.check_output(os.path.expanduser("~/.dotfiles/qtile/.config/qtile/scripts/volicon.sh")).decode('utf-8'),
                       font=fonts['material'],
                       fontsize=16,
                       background=colors['green']),
    
    widget.GenPollText(update_interval=None, 
                       func=lambda: subprocess.check_output(os.path.expanduser("~/.dotfiles/qtile/.config/qtile/scripts/printvol.sh")).decode('utf-8'),
                       background=colors['green']),
    
    draw_arrow_left(colors['green'],
                     colors['blue']),
    widget.TextBox(text="",
                   font=fonts['material'],
                   background=colors['blue']),
    widget.Backlight(backlight_name = "intel_backlight",
                     background=colors['blue']), 
    
    draw_arrow_left(colors['blue'],
                    colors['red']),
    widget.TextBox(text="",
                   font = fonts["material"],
                   background=colors['red'],
                   fontsize=16),
    widget.ThermalSensor(fgcolor_normal=colors['fg'],
                         fgcolor_high=colors['fg'],
                         fgcolor_crit=colors['fg'],
                         foreground=colors['fg'],
                         background=colors['red']),

    ], 30, background=colors['bg'], )

altbar = bar.Bar([
    
    widget.Sep(linewidth=0,
               padding=6),
    widget.TextBox(text="", 
                   font = fonts['material'],
                   fontsize = 12),
    widget.CheckUpdates(no_update_string="0",
                        colour_have_updates=colors['fg'],
                        colour_no_updates=colors['fg']),
    draw_arrow_right(colors['orange'],
                     colors['bg']),
    widget.CapsNumLockIndicator(background=colors['orange']),
    draw_arrow_right(colors['blue'],
                     colors['orange']),
    widget.Pomodoro(background=colors['blue'],
                    color_active=colors['fg'],
                    color_break=colors['fg'],
                    color_inactive=colors['fg']),
    draw_arrow_right(colors['bg'],
                     colors['blue']),
    widget.Chord(),
    widget.Spacer(),
    
    draw_arrow_left(colors['bg'],
                     colors['purple']),
    widget.GenPollText(update_interval=None, 
                       func=lambda: subprocess.check_output(os.path.expanduser("~/.dotfiles/qtile/.config/qtile/scripts/notifbell.sh")).decode('utf-8'),
                       fontsize=16,
                       background=colors['purple'],
                       foreground=colors['fg']),
    widget.GenPollText(update_interval=None, 
                       func=lambda: subprocess.check_output(os.path.expanduser("~/.dotfiles/qtile/.config/qtile/scripts/notifs.sh")).decode('utf-8'),
                       background=colors['purple'],
                       foreground=colors['fg']),
    
draw_arrow_left(colors['purple'],
                    colors['blue']),
    widget.Wttr(location=wttr_locs[0],
                format="%c %t (%f)",
                background=colors['blue']
                ),
     
    
], 30, background=colors['bg'])

screens = [
    Screen(top = mainbar, bottom = altbar),
]

@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser('~')
    subprocess.call([home + '/.config/qtile/scripts/autostart.sh'])
