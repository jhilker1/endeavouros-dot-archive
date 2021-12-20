from libqtile.config import KeyChord
from libqtile.config import EzKey as Key
from libqtile.lazy import lazy
from settings.groups import groups

mod = "mod4"
terminal = "alacritty"
browser = "firefox"

core_binds = [
    Key("M-h", lazy.layout.left(), desc="Move focus to left"),
    Key("M-l", lazy.layout.right(), desc="Move focus to right"),
    Key("M-j", lazy.layout.down(), desc="Move focus down"),
    Key("M-k", lazy.layout.up(), desc="Move focus up"),
    Key("M-<space>", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key("M-S-h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key("M-S-l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key("M-S-j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key("M-S-k", lazy.layout.shuffle_up(), desc="Move window up"),
    Key("M-C-h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key("M-C-l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key("M-C-j", lazy.layout.grow_down(), desc="Grow window down"),
    Key("M-C-k", lazy.layout.grow_up(), desc="Grow window up"),
     Key("M-<equal>", lazy.layout.grow()),
    Key("M-<minus>", lazy.layout.shrink()),
    Key("M-0", lazy.layout.reset()),
    Key("M-S-q", lazy.window.kill(), desc="Kill focused window"),
    Key("M-S-r", lazy.restart(), desc="Restart Qtile"),
    Key("M-S-p", lazy.spawn("rofi -show powermenu -modi powermenu:~/.dotfiles/rofi/.config/rofi/scripts/power.sh -theme-str '#window { height: 55%;} listview { columns: 1;}'"), desc="Manage machine power state"),
    Key("M-f", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen"),
    Key("M-S-f", lazy.window.toggle_floating(), desc="Toggle floating layout"),
    Key("M-<Tab>", lazy.next_layout()),
    Key("<XF86AudioLowerVolume>", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%")),
    Key("<XF86AudioRaiseVolume>", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%")),

    Key("<XF86AudioMute>", lazy.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle")),
]

keys = core_binds.copy()

app_bindings = [
    Key("M-r", lazy.spawn("rofi -show drun")),
    Key("M-<Return>", lazy.spawn(terminal), desc="Launch terminal"),
    Key("M-S-<Return>", lazy.spawn(browser), desc="Open Firefox"),
    ]

for keybind in app_bindings:
    keys.append(keybind)

emacs_apps = KeyChord([mod], "e", [
    Key("e", lazy.spawn("emacsclient -cs 'jmacs' -a 'emacs'"), desc="Spawn emacs client"),
    Key("n", lazy.spawn("emacsclient -cs 'jmacs' -e '(elfeed)'"), desc="Spawn emacs client"),
])

keys.append(emacs_apps)

for group in groups:
    keys.extend([
      Key("M-{}".format(group.name), lazy.group[group.name].toscreen(), desc="Switch to group {}".format(group.name)),
      Key("M-S-{}".format(group.name), lazy.window.togroup(group.name), desc="Move focused window to group {}".format(group.name)) 
    ])
