from libqtile.config import Group, DropDown, ScratchPad, Match

groups = [Group("1", label="WEB", layout='monadtall', matches=[
    Match(wm_class=["firefox"])]),
          Group("2", layout='monadtall'),
          Group("3", layout='monadtall'),
          Group("4", layout='monadtall'),
          Group("5", layout='monadtall'),
          Group("6", layout='monadtall'),
          Group("7", layout='monadtall'),
          Group("8", layout='max'),
          Group("9", layout='max')]
