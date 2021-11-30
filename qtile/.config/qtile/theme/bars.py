from libqtile import bar, widget
from theme.colors import gruvbox

widget_defaults = dict(
    font='Iosevka Nerd Font',
    fontsize=16,
    padding=3,
    background = gruvbox['bg'],
    foreground = gruvbox['fg']
)
extension_defaults = widget_defaults.copy()

def draw_arrow_right(bg,fg,font_size=24):
    "Creates a textbox widget with a right-pointing arrow."
    return widget.TextBox(text="",
                          padding=0,
                          fontsize=font_size,
                          background=bg,
                          foreground=fg)

def draw_arrow_left(bg,fg,font_size=24):
    "Creates a textbox widget with a right-pointing arrow."
    return widget.TextBox(text="\ue0b2",
                          padding=0,
                          fontsize=font_size,
                          background=bg,
                          foreground=fg)

mainbar = bar.Bar([
    widget.CurrentLayoutIcon(scale=0.5, background=gruvbox['purple']),
    widget.CurrentLayout(background=gruvbox['purple']),
    draw_arrow_right(gruvbox['bg'],gruvbox['purple']),
    widget.GroupBox(disable_drag = True,
                    active=gruvbox['fg']),
    #draw_arrow_right(gruvbox['orange'],gruvbox['bg']),

    #draw_arrow_left(gruvbox['orange'],gruvbox['blue']),
    widget.Clock(format="%H:%M - %a, %d %b", background=gruvbox['blue']),
    widget.BatteryIcon(),
    widget.Battery(),
    widget.TextBox(text=""),
    widget.PulseVolume(fmt="{}"),
], 33, background=gruvbox['bg'])
