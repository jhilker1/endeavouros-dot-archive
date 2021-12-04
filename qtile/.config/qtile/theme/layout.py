from libqtile import layout
from theme.colors import gruvbox

layout_theme = {
    "margin": 8,
    "border_focus": gruvbox['yellow'],
    "border_normal": gruvbox['bg-dark'],
    "border_width": 2
}

layouts = [
    layout.MonadTall(**layout_theme),
    layout.Max(**layout_theme)
]
