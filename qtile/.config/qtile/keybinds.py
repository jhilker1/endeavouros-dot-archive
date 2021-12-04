from libqtile.config import Key, EzKey
from libqtile.lazy import lazy

mod = "mod4"
terminal = "alacritty"

keys = [
    # Switch between windows
    EzKey("M-h", lazy.layout.left(), desc="Move focus to left"),
    EzKey("M-l", lazy.layout.right(), desc="Move focus to right"),
    EzKey("M-j", lazy.layout.down(), desc="Move focus down"),
    EzKey("M-k", lazy.layout.up(), desc="Move focus up"),
    EzKey("M-<space>", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    EzKey("M-S-h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    EzKey("M-S-l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    EzKey("M-S-j", lazy.layout.shuffle_down(), desc="Move window down"),
    EzKey("M-S-k", lazy.layout.shuffle_up(), desc="Move window up"),
    EzKey("M-C-h", lazy.layout.grow_left(), desc="Grow window to the left"),
    EzKey("M-C-l", lazy.layout.grow_right(), desc="Grow window to the right"),
    EzKey("M-C-j", lazy.layout.grow_down(), desc="Grow window down"),
    EzKey("M-C-k", lazy.layout.grow_up(), desc="Grow window up"),
    EzKey("M-n", lazy.layout.normalize(), desc="Reset all window sizes"),

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    EzKey("M-S-<Return>", lazy.layout.toggle_split(), desc="Toggle between split and unsplit sides of stack"),
    EzKey("M-<Return>", lazy.spawn(terminal), desc="Launch terminal"),

    # Toggle between different layouts as defined below
    EzKey("M-<Tab>", lazy.next_layout(), desc="Toggle between layouts"),

    EzKey("A-<Tab>", lazy.spawn("rofi -show window -p 'Windows'"), desc="Toggle between windows"),
    EzKey("M-S-p", lazy.spawn("rofi -show powermenu -modi powermenu:~/.dotfiles/rofi/.config/rofi/scripts/power.sh -theme-str '#window { height: 55%;} listview { columns: 1;}'"), desc="Manage machine power state"),
    EzKey("M-S-q", lazy.window.kill(), desc="Kill focused window"),
    EzKey("M-S-r", lazy.restart(), desc="Restart Qtile"),
    EzKey("M-S-p", lazy.spawn("rofi -show powermenu -modi powermenu:~/.dotfiles/rofi/.config/rofi/scripts/power.sh -theme-str '#window { height: 55%;} listview { columns: 1;}'"), desc="Manage machine power state"),
    #EzKey("M-a", lazy.spawn("rofi -show combi -sidebar-mode")),
    EzKey("M-r", lazy.spawn("rofi -show drun"), desc="Launch app with Rofi"),
    EzKey("<XF86AudioRaiseVolume>", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +2%"), "Raise Volume"),
    EzKey("<XF86AudioLowerVolume>", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -2%"), "Lower Volume"),
    EzKey("<XF86AudioMute>", lazy.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle")),

]
