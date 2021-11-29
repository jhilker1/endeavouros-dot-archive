from libqtile.config import EzKey as Key
from libqtile.lazy import lazy

mod = "mod4"
terminal = "alacritty"

keys = [
    # Switch between windows
    Key("M-h", lazy.layout.left(), desc="Move focus to left"),
    Key("M-l", lazy.layout.right(), desc="Move focus to right"),
    Key("M-j", lazy.layout.down(), desc="Move focus down"),
    Key("M-k", lazy.layout.up(), desc="Move focus up"),
    Key("M-<space>", lazy.layout.next(), desc="Move window focus to other window"),
        # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key("M-S-h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key("M-S-l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key("M-S-j", lazy.layout.shuffle_down(),
        desc="Move window down"),
    Key("M-S-k", lazy.layout.shuffle_up(), desc="Move window up"),
    Key("M-C-h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key("M-C-l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key("M-C-j", lazy.layout.grow_down(),
        desc="Grow window down"),
    Key("M-C-k", lazy.layout.grow_up(), desc="Grow window up"),
    Key("M-n", lazy.layout.normalize(), desc="Reset all window sizes"),

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key("M-S-<Return>", lazy.layout.toggle_split(), desc="Toggle between split and unsplit sides of stack"),
    Key("M-<Return>", lazy.spawn(terminal), desc="Launch terminal"),

    # Toggle between different layouts as defined below
    Key("M-<Tab>", lazy.next_layout(), desc="Toggle between layouts"),
    Key("M-w", lazy.window.kill(), desc="Kill focused window"),
       Key("M-S-r", lazy.restart(), desc="Restart Qtile"),
    Key("M-C-q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key("M-r", lazy.spawn("rofi -show drun"), desc="Spawn a command using a prompt widget"),
    Key("<XF86AudioRaiseVolume>", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +2%"), "Raise Volume"),
    Key("<XF86AudioLowerVolume>", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -2%"), "Lower Volume"),
    Key("<XF86AudioMute>", lazy.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle")),

]
