from libqtile import bar, widget
from theme.colors import gruvbox as colors
import os
import subprocess

widget_defaults = dict(
    font='Iosevka Nerd Font',
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
    return widget.TextBox(text="\ue0b2",
                          padding=0,
                          fontsize=font_size,
                          background=bg,
                          foreground=fg)

wttr_locs = [
    {"home": "Charlottesville"},
]

mainbar = bar.Bar([
    widget.Sep(linewidth = 0,
               padding = 6,
               background=colors['blue']),
    widget.TextBox(text="",
                   font="Material Icons 12",
                   background=colors['blue']),
    widget.Clock(format="%H:%M - %a, %d %b",
                 background=colors['blue']),
    draw_arrow_right(colors['bg'],colors['blue']),
    widget.GroupBox(disable_drag=True),
    
    draw_arrow_right(colors['purple'],colors['bg']),
    widget.CurrentLayout(background=colors['purple']),
    draw_arrow_right(colors['bg'],colors['purple']),
    widget.Spacer(),
    draw_arrow_left(colors['bg'], colors['orange']),
    widget.Wlan(format="INT: {essid}",
                disconnected_message="INT: Not Connected ",
                background=colors['orange']),
    draw_arrow_left(colors['orange'],colors['purple']),
   widget.Battery(format="BAT: {percent:2.0%}",
                   show_short_text = False,
                   background=colors['purple']),
    #widget.PulseVolume(emoji=True, fontsize=12), 
    draw_arrow_left(colors['purple'],colors['blue']),
    widget.GenPollText(update_interval=None, 
                       func=lambda: subprocess.check_output(os.path.expanduser("~/.dotfiles/qtile/.config/qtile/scripts/printvol.sh")).decode('utf-8'),
                       background=colors['blue']),
    widget.Systray(), 

        ], 30, background=colors['bg'], )
