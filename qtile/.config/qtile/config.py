import os
import re
import socket
import subprocess
from typing import List  # noqa: F401
from libqtile import hook
from libqtile.config import EzKey as Key

from theme.colors import gruvbox as colors
from theme.layouts import layouts, floating_layout
from theme.bars import mainbar, widget_defaults

from settings.screens import screens
from settings.keybinds import keys
from settings.groups import groups

@hook.subscribe.startup_once
def start_once():
    home = os.path.expanduser('~')
    subprocess.call([home + '/.config/qtile/scripts/autostart.sh'])
