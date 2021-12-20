fpath=($fpath "/home/jhilker/.zfunctions")
autoload -U promptinit; promptinit
autoload colors; colors
autoload -Uz compinit
compinit

prompt spaceship
setopt autocd
setopt vi
vim_ins_mode="%{$fg[red]%}[%F{12}%BINS%B%{$reset_color%}%{$fg[red]%}]%{$reset_color%}"
vim_cmd_mode="%{$fg[red]%}[%{$fg[magenta]%}NML%{$fg[red]%}]%{$reset_color%}"
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

#eval "$(starship init zsh)"


export PATH=~/.local/bin:~/.npm-global:$PATH
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source ~/.aliases
alias ref="source ~/.zshrc"

