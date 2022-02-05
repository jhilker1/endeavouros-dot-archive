fpath=($fpath "/home/jhilker/.zfunctions")
autoload -U promptinit; promptinit
autoload colors; colors
autoload -Uz compinit; compinit
autoload -Uz add-zsh-hook
typeset -U PATH path
setopt autocd

## Vi Mode
bindkey -v
#vim_ins_mode="%{$fg[red]%}[%F{12}%BINS%B%{$reset_color%}%{$fg[red]%}]%{$reset_color%}"
#vim_cmd_mode="%{$fg[red]%}[%{$fg[magenta]%}NML%{$fg[red]%}]%{$reset_color%}"
vim_ins_mode="INS"
vim_cmd_mode="NML"
vim_mode=$vim_ins_mode

function zle-keymap-select {
  vim_mode="${${KEYMAP/vicmd/${vim_cmd_mode}}/(main|viins)/${vim_ins_mode}}"
  zle reset-prompt
  if [ $KEYMAP = vicmd ]; then
    echo -ne '\e[1 q'
  else
    echo -ne '\e[5 q'
  fi
}

zle -N zle-keymap-select

function zle-line-finish {
  vim_mode=$vim_ins_mode
}
zle -N zle-line-finish

## Prompt Settings
SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_PROMPT_SEPARATE_LINE=false
SPACESHIP_CHAR_SYMBOL="$ "
SPACESHIP_DIR_COLOR="yellow"
SPACESHIP_DIR_PREFIX=""
SPACESHIP_DIR_TRUNC="2"
SPACESHIP_DIR_TRUNC_REPO="false"
SPACESHIP_GIT_BRANCH_COLOR="12"

SPACESHIP_VI_MODE_NORMAL="%{$fg[red]%}[%{$fg[magenta]%}NML%{$fg[red]%}]%{$reset_color%}"
SPACESHIP_VI_MODE_INSERT="%{$fg[red]%}[%F{12}%BINS%B%{$reset_color%}%{$fg[red]%}]%{$reset_color%}"
SPACESHIP_CHAR_COLOR_SUCCESS="15"
SPACESHIP_PROMPT_ORDER=(
  vi_mode 
  dir
  git
  char)

#prompt spaceship
eval "$(starship init zsh)"

## Path and Commands
path=("$path[@]" "$HOME/.local/bin" "$HOME/.cargo/bin")
export PATH
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source ~/.aliases
alias ref="source ~/.zshrc"

## plugin sourcing
source $HOME/.zshplugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source $HOME/.zshplugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh 
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python
